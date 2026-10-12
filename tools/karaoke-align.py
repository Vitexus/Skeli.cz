# Karaoke timings for a clip: when each line (and each word) of the lyrics is sung (js/karaoke.js fills it in gold).
#
# 1. Demucs takes the voice out of the clip (no beat, no bass), so the words are clear.
# 2. The lyrics we already have are laid onto that voice letter by letter (forced alignment with the
#    multilingual MMS model; Czech without accents is close enough to its letters). Unlike listening and
#    writing down what it heard (Whisper, the old way), it never skips a repeated chorus: it knows every line
#    is there and only looks for *where*. Before every line a "*" swallows whatever is not in the text
#    (an intro, ad-libs, a part of another rapper that is not written down).
# A line runs from its first word to its last; every word keeps its own time.
#
# usage:  python tools/karaoke-align.py <clip.mp4> <lyrics.txt> <out.json> [--fallback old.json] [--ffmpeg path]
#                                       [--cache dir] [--cpu]          (--fallback: see the end of main)
# out:    {"lines": 42, "matched": 0.81, "times": [[12.4, 15.9], ...],            one pair per non-empty line
#          "words": [[[12.4, 12.7], [12.8, 13.1], ...], ...]}  one pair per word (split at spaces) of each line
#         "matched" = how sure the model is on average (0-1); lines it is unsure about are printed with "?"
# Needs:  pip install torch==2.6.0 torchaudio==2.6.0 --index-url https://download.pytorch.org/whl/cu124
#         pip install demucs        and ffmpeg (C:\Users\skele\yt\ffmpeg.exe unless --ffmpeg says otherwise)
import json
import os
import re
import subprocess
import sys
import unicodedata

import numpy as np
import torch
import torchaudio
from torchaudio.pipelines import MMS_FA

RATE = 16000


def option(name, default):
    return sys.argv[sys.argv.index(name) + 1] if name in sys.argv else default


def norm(word):
    """Lower case, no accents, only the model's letters: "Kouře," -> "koure"."""
    w = unicodedata.normalize('NFKD', word.lower())
    w = ''.join(c for c in w if not unicodedata.combining(c))
    return re.sub(r"[^a-z']", '', w).strip("'")


def load(clip, ffmpeg, rate, channels):
    raw = subprocess.run([ffmpeg, '-v', 'error', '-i', clip, '-f', 'f32le', '-ac', str(channels), '-ar', str(rate), '-'],
                         stdout=subprocess.PIPE, check=True).stdout
    return torch.from_numpy(np.frombuffer(raw, dtype=np.float32).copy()).reshape(-1, channels).T


def vocals(clip, ffmpeg, cache, device):
    """The voice alone (Demucs htdemucs), mono 16 kHz. Kept in the cache: the clip does not change."""
    os.makedirs(cache, exist_ok=True)
    out = os.path.join(cache, os.path.splitext(os.path.basename(clip))[0] + '.vocals16k.npy')
    if os.path.exists(out):
        return torch.from_numpy(np.load(out))
    from demucs.apply import apply_model
    from demucs.pretrained import get_model
    model = get_model('htdemucs').to(device).eval()
    wav = load(clip, ffmpeg, model.samplerate, 2)
    ref = wav.mean(0)
    mean, std = ref.mean(), ref.std() + 1e-8
    with torch.no_grad():
        stems = apply_model(model, ((wav - mean) / std)[None].to(device), device=device, split=True, overlap=0.25)[0]
    voice = stems[model.sources.index('vocals')].cpu() * std + mean
    voice = torchaudio.functional.resample(voice.mean(0), model.samplerate, RATE)
    np.save(out, voice.numpy())
    return voice


def emissions(model, voice, device, chunk=30.0, context=2.0):
    """How likely each letter is, every 20 ms. The song goes in 30 s pieces with 2 s of context on both
    sides (whole it would not fit the graphics card)."""
    n, step, pad = voice.shape[0], int(chunk * RATE), int(context * RATE)
    parts = []
    with torch.inference_mode():
        for s in range(0, n, step):
            a, b = max(0, s - pad), min(n, s + step + pad)
            em, _ = model(voice[a:b][None].to(device))
            em = em[0].float().cpu()
            per_second = em.shape[0] / ((b - a) / RATE)
            lo = int(round((s - a) / RATE * per_second))
            hi = lo + int(round((min(s + step, n) - s) / RATE * per_second))
            parts.append(em[lo:hi])
    return torch.log_softmax(torch.cat(parts), dim=-1)


def loudness(voice, frames):
    """How loud the voice is in each 20 ms frame, against its usual loudness (1 = a normal sung word)."""
    hop = voice.shape[0] / frames
    win = int(0.1 * RATE)
    power = torch.nn.functional.avg_pool1d((voice ** 2)[None, None], win * 2 + 1, stride=1, padding=win)[0, 0]
    rms = power.sqrt()[(torch.arange(frames) * hop).long().clamp(max=voice.shape[0] - 1)]
    return rms / torch.quantile(rms[rms > 1e-4], 0.7)


def silence(level, frame, quiet=0.06, keep=0.15):
    """True for the frames where nobody sings: the voice under 6 % of its usual loudness (each sung bit
    widened by 0.15 s, so soft starts and ends of words stay in)."""
    sung = level > quiet
    widen = int(keep / frame)
    sung = torch.nn.functional.max_pool1d(sung.float()[None, None], widen * 2 + 1, stride=1, padding=widen)[0, 0] > 0
    return ~sung


def main():
    flags_with_value = {'--ffmpeg', '--cache', '--fallback'}
    args, skip = [], False
    for a in sys.argv[1:]:
        if skip:
            skip = False
        elif a in flags_with_value:
            skip = True
        elif not a.startswith('--'):
            args.append(a)
    clip, lyrics_file, out = args[0], args[1], args[2]
    ffmpeg = option('--ffmpeg', r'C:\Users\skele\yt\ffmpeg.exe')
    cache = option('--cache', os.path.join(os.path.expanduser('~'), '.cache', 'skeli-karaoke'))
    device = 'cpu' if '--cpu' in sys.argv or not torch.cuda.is_available() else 'cuda'

    with open(lyrics_file, encoding='utf-8') as f:
        lines = [l.strip() for l in f.read().replace('\r\n', '\n').split('\n')]
    lines = [l for l in lines if l]
    words, word_line = [], []
    for li, line in enumerate(lines):
        for w in line.split():
            nw = norm(w)
            if nw:
                words.append(nw)
                word_line.append(li)

    voice = vocals(clip, ffmpeg, cache, device)
    model = MMS_FA.get_model(with_star=True).to(device).eval()
    em = emissions(model, voice, device)
    frame = voice.shape[0] / RATE / em.shape[0]
    letters = MMS_FA.get_dict(star='*')
    # where nobody sings only "nothing" (blank) or "not in the text" (*) may go: otherwise the model can park
    # the last lines in the silence after the song when they are sung softly or fewer times than written
    level = loudness(voice, em.shape[0])
    quiet = silence(level, frame)
    allowed = torch.zeros(em.shape[1], dtype=torch.bool)
    allowed[0] = allowed[letters['*']] = True
    em[quiet[:, None] & ~allowed[None, :]] = -50.0

    # the transcript: a "*" before every line (and one at the end) for whatever is not in the text
    groups, owner = [], []           # one group of letters per word; owner = its word, -1 for a star
    for wi, w in enumerate(words):
        if wi == 0 or word_line[wi] != word_line[wi - 1]:
            groups.append([letters['*']])
            owner.append(-1)
        groups.append([letters[c] for c in w if c in letters])
        owner.append(wi)
    groups.append([letters['*']])
    owner.append(-1)
    flat = [t for g in groups for t in g]
    labels, scores = torchaudio.functional.forced_align(em[None], torch.tensor([flat], dtype=torch.int32), blank=0)
    spans = torchaudio.functional.merge_tokens(labels[0], scores[0].exp())   # one span per letter, in order

    word_time, word_sure, k = [None] * len(words), [0.0] * len(words), 0
    for gi, g in enumerate(groups):
        mine = spans[k:k + len(g)]
        k += len(g)
        if owner[gi] >= 0 and mine:
            start = mine[0].start * frame
            # the last letter before a pause tends to stretch over the silence: no word lasts longer than its
            # letters can be sung
            end = min(mine[-1].end * frame, start + 0.6 + 0.13 * len(g))
            word_time[owner[gi]] = [start, end]
            word_sure[owner[gi]] = sum(s.score for s in mine) / len(mine)

    # each line: from its first word to its last
    times = [None] * len(lines)
    for wi, t in enumerate(word_time):
        if t is None:
            continue
        li = word_line[wi]
        times[li] = list(t) if times[li] is None else [min(times[li][0], t[0]), max(times[li][1], t[1])]
    # (a line with no letters the model knows, like "–": between its neighbours)
    for li in range(len(lines)):
        if times[li] is None:
            before = times[li - 1][1] if li > 0 and times[li - 1] else 0.0
            times[li] = [before, before + 0.4]
    # a line never runs into the next one, and never lasts less than a moment
    for li in range(len(times)):
        if li + 1 < len(times):
            times[li][1] = min(times[li][1], times[li + 1][0])
        times[li][1] = max(times[li][1], times[li][0] + 0.4)
        times[li] = [round(times[li][0], 2), round(times[li][1], 2)]

    # every word of every line (split at spaces, as the page shows them); "–", "!!!" share the time of the
    # words around them; everything stays inside its line and in order
    word_times, wi = [], 0
    for li, line in enumerate(lines):
        tokens = line.split()
        known = []
        for tok in tokens:
            if norm(tok):
                known.append(list(word_time[wi]) if word_time[wi] else None)
                wi += 1
            else:
                known.append(None)
        ls, le = times[li]
        x = 0
        while x < len(tokens):
            if known[x] is not None:
                known[x] = [min(max(known[x][0], ls), le), min(max(known[x][1], ls), le)]
                x += 1
                continue
            j = x
            while j < len(tokens) and known[j] is None:
                j += 1
            start = known[x - 1][1] if x > 0 else ls
            end = max(start, known[j][0] if j < len(tokens) else le)
            total = sum(len(tokens[y]) for y in range(x, j)) or 1
            t0 = start
            for y in range(x, j):
                d = (end - start) * len(tokens[y]) / total
                known[y] = [t0, t0 + d]
                t0 += d
            x = j
        prev = ls
        for y in range(len(known)):
            s = max(known[y][0], prev)
            e = max(known[y][1], s + 0.08)
            known[y] = [round(s, 2), round(min(e, max(le, s + 0.08)), 2)]
            prev = known[y][0]
        word_times.append(known)

    # --fallback old.json (earlier timings of the same text, e.g. from Whisper): a line that looks wrong here
    # (starts where nobody sings, lasts under half a second or over 9 s) takes the old one when that starts on
    # the voice; its neighbours go along while they would otherwise come out of order. Sung choruses are where
    # the letter model is weakest.
    fallback = option('--fallback', None)
    if fallback and os.path.exists(fallback):
        with open(fallback, encoding='utf-8') as f:
            old = json.load(f)
        if old.get('lines') == len(lines) and all(len(old['words'][i]) == len(lines[i].split()) for i in range(len(lines))):
            def voiced(t):
                a = int(t / frame)
                return float(level[a:a + int(0.4 / frame)].max()) if a < len(level) else 0.0

            def odd(t):
                return voiced(t[0]) < 0.25 or t[1] - t[0] < 0.5 or t[1] - t[0] > 9

            take = {i for i in range(len(lines)) if odd(times[i]) and not odd(old['times'][i])}
            grew = bool(take)
            while grew:
                grew = False
                for i in sorted(take):
                    for j in (i - 1, i + 1):
                        if 0 <= j < len(lines) and j not in take:
                            a, b = min(i, j), max(i, j)
                            ta = old['times'][a] if a in take else times[a]
                            tb = old['times'][b] if b in take else times[b]
                            if ta[0] >= tb[0] - 0.3:
                                take.add(j)
                                grew = True
            for i in sorted(take):
                times[i], word_times[i] = old['times'][i], old['words'][i]
                print(f'  < line {i + 1}: the old time {times[i][0]:.1f} s')
            for li in range(len(times) - 1):
                times[li][1] = min(times[li][1], times[li + 1][0])

    # how sure: per line (printed when low) and over the song
    sure_line = {}
    for w, s in enumerate(word_sure):
        sure_line.setdefault(word_line[w], []).append(s)
    for li, ss in sorted(sure_line.items()):
        if sum(ss) / len(ss) < 0.12:
            print(f'  ? line {li + 1} at {times[li][0]:.1f} s: {lines[li][:60]}')
    matched = round(float(sum(word_sure) / max(1, len(word_sure))), 2)
    with open(out, 'w', encoding='utf-8') as f:
        json.dump({'lines': len(lines), 'matched': matched, 'times': times, 'words': word_times}, f)
    print(f'{os.path.basename(out)}: {len(lines)} lines, sure {matched:.0%}')


if __name__ == '__main__':
    main()
