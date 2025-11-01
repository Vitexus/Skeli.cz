<%@ include file="includes/header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<main>
  <h2>Profil</h2>
  <section style="background: var(--panel); border: 1px solid var(--panel-border); border-radius: 12px; padding: 16px; box-shadow: 0 6px 18px rgba(0,0,0,0.20);">
    <h3>Avatar</h3>
    <div style="display:flex; gap:12px; align-items:flex-start; flex-wrap:wrap;">
      <div>
        <div id="avatar-preview" style="width:120px; height:120px; border-radius:50%; overflow:hidden; border:1px solid var(--panel-border); background:rgba(0,0,0,0.2);">
          <img id="avatar-preview-img" src="<%= (request.getSession().getAttribute("avatar_url")!=null)?request.getSession().getAttribute("avatar_url").toString():"/img/avatar-default.png" %>" alt="preview" style="width:100%;height:100%;object-fit:cover;display:block;">
        </div>
      </div>
      <div style="flex:1; min-width:280px;">
        <input id="avatar-input" type="file" accept="image/*">
        <div id="cropper-wrap" style="position:relative; margin-top:8px; max-width:420px; border:1px dashed var(--panel-border); border-radius:8px; overflow:hidden; display:none;">
          <img id="cropper-img" style="max-width:100%; display:block;">
          <div id="cropper-overlay" style="position:absolute; inset:0; pointer-events:none; background:radial-gradient(circle at center, rgba(0,0,0,0) 46%, rgba(0,0,0,0.45) 48%, rgba(0,0,0,0.55) 100%);"></div>
        </div>
        <div style="margin-top:8px; display:flex; gap:8px; flex-wrap:wrap;">
          <button id="btn-auto-face" type="button" class="bruno-ace-sc-regular" style="border:1px solid var(--panel-border);border-radius:8px;padding:6px 10px;display:inline-flex;align-items:center;gap:6px;"><i class="fa-solid fa-user"></i> Auto center</button>
          <button id="btn-zoom-in" type="button" class="bruno-ace-sc-regular" style="border:1px solid var(--panel-border);border-radius:8px;padding:6px 10px;">+</button>
          <button id="btn-zoom-out" type="button" class="bruno-ace-sc-regular" style="border:1px solid var(--panel-border);border-radius:8px;padding:6px 10px;">−</button>
          <span style="flex:1"></span>
          <button id="btn-crop-save" type="button" class="bruno-ace-sc-regular" style="border:1px solid var(--panel-border);border-radius:8px;padding:6px 10px;display:inline-flex;align-items:center;gap:6px;background:transparent;"><i class="fa-solid fa-floppy-disk"></i> Uložit</button>
          <button id="btn-cancel" type="button" class="bruno-ace-sc-regular" style="border:1px solid var(--panel-border);border-radius:8px;padding:6px 10px;background:transparent;">Zrušit</button>
        </div>
        <small style="opacity:.8; display:block; margin-top:6px;">Tip: Zoom kolečkem myši, tažení myší pro posun. Výstup 512×512 JPG.</small>
      </div>
    </div>
    <form id="avatar-form" method="post" action="/profile/avatar" enctype="multipart/form-data" style="display:none;">
      <input type="hidden" name="csrf" value="${csrf}">
      <input id="avatar-file-hidden" type="file" name="avatar" accept="image/*">
    </form>
  </section>
  <link href="https://unpkg.com/cropperjs@1.6.2/dist/cropper.min.css" rel="stylesheet">
  <script src="https://unpkg.com/cropperjs@1.6.2/dist/cropper.min.js"></script>
  <script>
    (function(){
      const input = document.getElementById('avatar-input');
      const wrap = document.getElementById('cropper-wrap');
      const img = document.getElementById('cropper-img');
      const btnSave = document.getElementById('btn-crop-save');
      const btnCancel = document.getElementById('btn-cancel');
      const btnFace = document.getElementById('btn-auto-face');
      const btnZoomIn = document.getElementById('btn-zoom-in');
      const btnZoomOut = document.getElementById('btn-zoom-out');
      const preview = document.getElementById('avatar-preview-img');
      const form = document.getElementById('avatar-form');
      const hidden = document.getElementById('avatar-file-hidden');
      let cropper = null;

      function loadFile(f){
        if(!f) return;
        if (f.size > 15*1024*1024) { alert('Soubor je příliš velký. Zvol menší (<= 15 MB)'); return; }
        const url = URL.createObjectURL(f);
        img.src = url; wrap.style.display='block';
        if (cropper) { cropper.destroy(); }
        cropper = new Cropper(img, { aspectRatio: 1, viewMode: 1, dragMode: 'move', autoCropArea: 1, movable: true, zoomOnWheel: true, ready(){ autoFace(); } });
      }

      // File select
      input.addEventListener('change', function(){ loadFile(this.files && this.files[0]); });

      // Drag & Drop
      ['dragenter','dragover'].forEach(ev=>wrap.addEventListener(ev, e=>{ e.preventDefault(); e.stopPropagation(); wrap.style.borderColor='var(--accent)'; }));
      ;['dragleave','drop'].forEach(ev=>wrap.addEventListener(ev, e=>{ e.preventDefault(); e.stopPropagation(); wrap.style.borderColor='var(--panel-border)'; if(ev==='drop'){ const f=e.dataTransfer.files&&e.dataTransfer.files[0]; loadFile(f);} }));

      btnCancel.addEventListener('click', ()=>{ if(cropper){ cropper.destroy(); cropper=null; } wrap.style.display='none'; input.value=''; });
      btnZoomIn.addEventListener('click', ()=>{ if(cropper) cropper.zoom(0.1); });
      btnZoomOut.addEventListener('click', ()=>{ if(cropper) cropper.zoom(-0.1); });
      btnFace.addEventListener('click', ()=>autoFace());

      async function autoFace(){
        if(!cropper) return;
        try{
          if (window.FaceDetector){
            const det = new FaceDetector({ fastMode:true, maxDetectedFaces:1 });
            const faces = await det.detect(img);
            if (faces && faces[0]){
              const f = faces[0].boundingBox; // in CSS pixels of the image element
              const natural = { w: img.naturalWidth, h: img.naturalHeight };
              const display = img.getBoundingClientRect();
              const scaleX = natural.w / display.width;
              const scaleY = natural.h / display.height;
              const cx = (f.x + f.width/2) * scaleX;
              const cy = (f.y + f.height/2) * scaleY;
              const width = Math.min(natural.w, natural.h) * 0.7;
              cropper.setData({ x: Math.max(0, cx - width/2), y: Math.max(0, cy - width/2), width: width, height: width });
              return;
            }
          }
        }catch(_){}
        // fallback: center
        const natural = { w: img.naturalWidth, h: img.naturalHeight };
        const width = Math.min(natural.w, natural.h) * 0.8;
        cropper.setData({ x: (natural.w-width)/2, y: (natural.h-width)/2, width: width, height: width });
      }

      btnSave.addEventListener('click', async ()=>{
        if(!cropper) return;
        const canvas = cropper.getCroppedCanvas({ width: 512, height: 512, imageSmoothingQuality: 'high' });
        if(!canvas) return;
        canvas.toBlob(async (blob)=>{
          const fd = new FormData(form);
          fd.delete('avatar');
          fd.append('avatar', blob, 'avatar.jpg');
          try {
            const res = await fetch(form.action, { method:'POST', body: fd });
            const data = await res.json();
            if (!res.ok || !data.ok){ alert('Uložení selhalo'); return; }
            preview.src = data.url;
            btnCancel.click();
          } catch(e){ alert('Chyba sítě'); }
        }, 'image/jpeg', 0.85);
      });
    })();
  </script>
</main>
<%@ include file="includes/footer.jsp" %>
