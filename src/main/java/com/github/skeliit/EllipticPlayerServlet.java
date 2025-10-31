package com.github.skeliit;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.net.*;
import java.nio.charset.StandardCharsets;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.JsonNode;

@WebServlet(name = "EllipticPlayerServlet", urlPatterns = {"/elliptic"})
public class EllipticPlayerServlet extends HttpServlet {
    private Connection getConn() throws SQLException {
        String url = "jdbc:mariadb://127.0.0.1:3306/skeliweb?useUnicode=true&characterEncoding=utf8mb4";
        return DriverManager.getConnection(url, "Skeli", "skeli");
    }

    private String fetchYtTitle(String ytId) {
        try {
            String oembed = "https://www.youtube.com/oembed?format=json&url="+
                    URLEncoder.encode("https://www.youtube.com/watch?v="+ytId, StandardCharsets.UTF_8);
            URL u = new URL(oembed);
            HttpURLConnection c = (HttpURLConnection) u.openConnection();
            c.setRequestMethod("GET");
            c.setConnectTimeout(2000); c.setReadTimeout(2000);
            try (java.io.InputStream in = c.getInputStream()) {
                ObjectMapper m = new ObjectMapper();
                JsonNode n = m.readTree(in);
                return n.path("title").asText(null);
            }
        } catch (Exception ignore) { }
        return null;
    }

    static class Vid { String id; String title; String year; }

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html; charset=UTF-8");
        List<Vid> vids = new ArrayList<>();
        String sql = "SELECT v.youtube_id, COALESCE(v.title, s.name, v.youtube_id) AS title, s.year " +
                     "FROM videos v LEFT JOIN songs s ON s.id=v.song_id " +
                     "ORDER BY COALESCE(v.title, s.name, v.youtube_id) ASC";
        try (Connection c = getConn(); PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Vid v = new Vid(); v.id = rs.getString(1); v.title = rs.getString(2); v.year = rs.getString(3);
                if (v.title == null || v.title.isBlank()) {
                    String t = fetchYtTitle(v.id);
                    if (t != null && !t.isBlank()) {
                        v.title = t;
                        try (PreparedStatement up = c.prepareStatement("UPDATE videos SET title=? WHERE youtube_id=?")) {
                            up.setString(1, t); up.setString(2, v.id); up.executeUpdate();
                        } catch (SQLException ignore) {}
                    }
                }
                vids.add(v);
            }
        } catch (SQLException e) { /* silent -> render empty */ }

        PrintWriter out = resp.getWriter();
        out.println("<div class='player' id='el-player' style='position:relative;border:1px solid var(--panel-border);border-radius:12px;background:rgba(0,0,0,0.7);overflow:hidden;box-shadow:0 20px 50px rgba(0,0,0,.35);margin-bottom:24px;'>");
        out.println("  <div class='stage' style='position:relative;padding-top:28.125%;width:60%;min-width:360px;margin:0 auto;'><iframe id='el-frame' style='position:absolute;inset:0;width:100%;height:100%;border:0;' allow='autoplay; encrypted-media; picture-in-picture' allowfullscreen></iframe></div>");
        out.println("</div>");
        out.println("<div class='carousel' style='position:relative;height:240px;margin-top:24px;user-select:none;'>");
        out.println("  <div class='track' id='el-track' style='position:absolute;inset:0;perspective:1000px;'></div>");
        out.println("  <div class='nav' style='position:absolute;inset:0;display:flex;align-items:center;justify-content:space-between;pointer-events:none;'>"+
                "<button id='el-prev' style='pointer-events:auto;background:rgba(255,255,255,.08);color:#fff;border:1px solid var(--panel-border);border-radius:50%;width:40px;height:40px;'>◀</button>"+
                "<button id='el-next' style='pointer-events:auto;background:rgba(255,255,255,.08);color:#fff;border:1px solid var(--panel-border);border-radius:50%;width:40px;height:40px;'>▶</button>"+
                "</div>");
        out.println("</div>");

        // Data -> JS
        out.println("<script>");
        out.println("(function(){");
        out.println("const vids = [];");
        for (Vid v: vids) {
            String escTitle = v.title == null ? "" : v.title.replace("\\", "\\\\").replace("\"","\\\"");
            out.printf("vids.push({yt:\"%s\", title:\"%s\"});%n", v.id, escTitle);
        }
        out.println("const frame=document.getElementById('el-frame'); let current=0; let thumbs=[]; let playing=false;\n"+
                "function ytCmd(cmd){ try{ frame.contentWindow.postMessage(JSON.stringify({event:'command',func:cmd,args:''}),'*'); }catch(_){} }\n"+
                "function play(i){ current=i; const v=vids[i]; frame.src='https://www.youtube.com/embed/'+v.yt+'?autoplay=1&enablejsapi=1'; playing=true; try{ localStorage.setItem('gp_id', v.yt); localStorage.setItem('gp_title', v.title);}catch(e){} if(window.playVideo) try{ window.playVideo(v.yt, v.title);}catch(e){} layout(); }\n"+
                "function layout(){ const N=vids.length,R1=360,R2=36; thumbs.forEach((el,i)=>{ let t=(i-current+N)%N; if(t>N/2)t-=N; const ang=(t/(N/2))*Math.PI/2; const x=Math.cos(ang)*R1; const y=Math.sin(ang)*R2; const s=0.55+0.45*Math.cos(ang); const z=Math.cos(ang); el.style.transform=`translate3d(${x}px,${y}px,0) scale(${s})`; el.style.opacity=0.35+0.65*Math.pow(s,1.5); el.style.zIndex=1000+Math.round(z*100); el.classList.toggle('active',t===0);}); }\n"+
                "const track=document.getElementById('el-track'); function render(){ track.innerHTML=''; thumbs=vids.map((v,i)=>{ const el=document.createElement('div'); el.className='el-thumb'; el.style.cssText='position:absolute;top:55%;left:50%;width:260px;height:146px;margin:-73px 0 0 -130px;border-radius:12px;overflow:hidden;box-shadow:0 12px 30px rgba(0,0,0,.35);border:1px solid var(--panel-border);background:#000;transform-origin:center;transition:transform .32s ease,opacity .32s ease,filter .32s ease;cursor:pointer;'; el.innerHTML=`<img data-src='https://img.youtube.com/vi/${v.yt}/hqdefault.jpg' loading='lazy' style='width:100%;height:100%;object-fit:cover;display:block;' alt='${v.title}'><div style='position:absolute;left:8px;right:8px;bottom:6px;font-size:13px;background:linear-gradient(transparent, rgba(0,0,0,.7));padding:36px 6px 6px;color:#fff;text-shadow:0 1px 2px rgba(0,0,0,.5);border-radius:10px;'>${v.title}</div>`; el.addEventListener('click',()=>play(i)); track.appendChild(el); return el;}); layout(); if(vids.length) play(0); else frame.src='https://www.youtube.com/embed/dQw4w9WgXcQ?enablejsapi=1'; document.querySelectorAll('#el-track img[data-src]').forEach(img=>{ img.src = img.dataset.src; img.removeAttribute('data-src'); }); } render();\n"+
                "let sx=0, drag=false; track.addEventListener('pointerdown',e=>{drag=true;sx=e.clientX;track.setPointerCapture(e.pointerId)}); track.addEventListener('pointerup',e=>{drag=false;track.releasePointerCapture(e.pointerId)}); track.addEventListener('pointercancel',()=>drag=false); track.addEventListener('pointermove',e=>{ if(!drag)return; const dx=e.clientX-sx; if(Math.abs(dx)>40){ current=(current+(dx<0?1:vids.length-1))%vids.length; sx=e.clientX; play(current);} });\n"+
                "function prev(){ current=(current+vids.length-1)%vids.length; play(current);} function next(){ current=(current+1)%vids.length; play(current);} document.getElementById('el-prev').onclick=()=>prev(); document.getElementById('el-next').onclick=()=>next(); document.addEventListener('keydown',e=>{ if(e.key==='ArrowLeft') prev(); else if(e.key==='ArrowRight') next();});\n");
        out.println("})();");
        out.println("</script>");
    }
}
