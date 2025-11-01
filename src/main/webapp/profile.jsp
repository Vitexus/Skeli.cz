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
        <div id="cropper-wrap" style="margin-top:8px; max-width:420px; border:1px dashed var(--panel-border); border-radius:8px; overflow:hidden; display:none;">
          <img id="cropper-img" style="max-width:100%; display:block;">
        </div>
        <div style="margin-top:8px; display:flex; gap:8px;">
          <button id="btn-crop-save" type="button">Oříznout a uložit</button>
          <button id="btn-cancel" type="button">Zrušit</button>
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
      const preview = document.getElementById('avatar-preview-img');
      const form = document.getElementById('avatar-form');
      const hidden = document.getElementById('avatar-file-hidden');
      let cropper = null;
      input.addEventListener('change', function(){
        const f = this.files && this.files[0]; if(!f) return;
        if (f.size > 15*1024*1024) { alert('Soubor je příliš velký. Zvol menší (<= 15 MB)'); return; }
        const url = URL.createObjectURL(f);
        img.src = url; wrap.style.display='block';
        if (cropper) { cropper.destroy(); }
        cropper = new Cropper(img, { aspectRatio: 1, viewMode: 1, dragMode: 'move', autoCropArea: 1, movable: true, zoomOnWheel: true });
      });
      btnCancel.addEventListener('click', ()=>{ if(cropper){ cropper.destroy(); cropper=null; } wrap.style.display='none'; input.value=''; });
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
        }, 'image/jpeg', 0.9);
      });
    })();
  </script>
</main>
<%@ include file="includes/footer.jsp" %>
