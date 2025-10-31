<!-- includes/footer.jsp -->
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<footer>
 <p><br clear="all"></p>
    <p class = "cpy">&copy; 2025 Skeli</p>

    <div style="font-size:1em; text-align:center;">
            <a href="https://www.facebook.com/mcskeli/" target="_blank" style="margin:0 2px; color:inherit; text-decoration:none;">
                <i class="fab fa-facebook" style="color:#4267B2;"></i>
            </a>
            <a href="https://www.instagram.com/skeli.official/" target="_blank" style="margin:0 2px; color:inherit; text-decoration:none;">
                <i class="fab fa-instagram" style="color:#E1306C;"></i>
            </a>
            <a href="https://www.youtube.com/@Skeli" target="_blank" style="margin:0 2px; color:inherit; text-decoration:none;">
                <i class="fab fa-youtube" style="color:#FF0000;"></i>
            </a>
            <a href="https://open.spotify.com/artist/5IouXw8U9uKCTwmncG5bUl?si=93iNOmPtT8u2l163tTkKeQ" target="_blank" style="margin:0 2px; color:inherit; text-decoration:none;">
                <i class="fab fa-spotify" style="color:#1DB954;"></i>
            </a>
        </div>
</footer>
<div class="smoke-veil"></div>

<div id="cookieBar" style="position:fixed; left:20px; right:20px; bottom:20px; background:#111; color:#fff; padding:12px 16px; border-radius:10px; box-shadow:0 10px 30px rgba(0,0,0,.25); display:none;">
  <%= ((java.util.Properties)request.getAttribute("t")).getProperty("cookie.message","This site uses cookies and third-party platforms (YouTube/Spotify).") %> <a href="/privacy.jsp" style="color:#ffd700;"><%= ((java.util.Properties)request.getAttribute("t")).getProperty("cookie.policy","Privacy") %></a> | <a href="/terms.jsp" style="color:#ffd700;"><%= ((java.util.Properties)request.getAttribute("t")).getProperty("cookie.terms","Terms") %></a>
  <div style="float:right;">
    <button id="cookieAccept" style="margin-right:8px;"><%= ((java.util.Properties)request.getAttribute("t")).getProperty("cookie.accept","Accept") %></button>
    <button id="cookieReject"><%= ((java.util.Properties)request.getAttribute("t")).getProperty("cookie.reject","Reject") %></button>
  </div>
</div>
<script>
  (function(){
    const k='cookieConsent'; const v=localStorage.getItem(k);
    if(!v) document.getElementById('cookieBar').style.display='block';
    document.getElementById('cookieAccept').onclick=function(){ localStorage.setItem(k,'true'); document.getElementById('cookieBar').style.display='none'; document.dispatchEvent(new Event('consent-granted')); };
    document.getElementById('cookieReject').onclick=function(){ localStorage.setItem(k,'false'); document.getElementById('cookieBar').style.display='none'; };
  })();
</script>

</body>
</html>
