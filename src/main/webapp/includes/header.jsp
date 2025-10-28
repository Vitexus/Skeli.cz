<!DOCTYPE html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html lang="cs-cz">

<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, viewport-fit=cover">
    <title>Moje první webová stranka</title>
    <meta name="description" content="Osobní portfolio programátora skeliho" />
    <meta name="keywords" content="portfolio,Programator,Skeli,SK-IT" />
    <meta name="author" content="Skeli" />
    <link rel="shortcut icon" href="obrazky/skeliico.ico" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Alumni+Sans+Pinstripe:ital@0;1&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Bruno+Ace+SC&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Comforter+Brush&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <!-- Slick Carousel CSS -->
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css"/>
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick-theme.css"/>
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- Slick Carousel JS -->
    <script src="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"></script>

<style>
.comforter-brush-regular {
  font-family: "Comforter Brush", cursive;
  font-weight: 800;
  font-style: normal;
}

.bruno-ace-sc-regular {
  font-family: "Bruno Ace SC", sans-serif;
  font-weight: 400;
  font-style: normal;
}

.carousel iframe {
    display: block;
    margin: 0 auto;
}

.cpy {
    font-family: 'Alumni Sans Pinstripe', Arial, sans-serif;
    font-size: 1em;
    color: gold;
    font-weight: bold;
}
p {
    font-family: 'Inter', 'Alumni Sans Pinstripe', Arial, sans-serif;
    font-size: 1.05em;
    color: #111;
    font-weight: 400;
    line-height: 1.6;
}

html, body {
    height: 100%;
}
body {
    font-family: 'Inter', 'Segoe UI', Arial, sans-serif;
    background: #121212 url('img/IMG_0090.JPG') center center/cover no-repeat fixed;
    margin: 0;
    padding: 0;
    display: flex;
    flex-direction: column;
    min-height: 100vh;
}

header {
    width: 100%;
    color: gold;
    padding: 120px 0 40px 0px;
    text-align: center;
    border-radius: 0;
    margin: 0;
    position: relative;
    /* průhlednost směrem dolů */
    background: linear-gradient(
        to bottom,
        rgba(34,34,34,0.9) 0%,   /* nahoře jen lehce průhledné */
        rgba(255,255,255,0) 100%    /* dole úplně průhledné */
    );
}

nav a {
    color: white;
    text-decoration: none;
    margin: 0 10px;
    font-weight: bold;
}

nav a:hover {
    text-decoration: underline;
}

main {
    flex: 1 0 auto;
    max-width: 900px;
    margin: 40px auto;
    background: rgba(255,255,255,0.49);
    padding: 30px;
    border-radius: 10px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.25);
}

footer {
    background: linear-gradient(
        to top,
        rgba(34,34,34,0.9) 0%,
        rgba(255,255,255,0) 100%
    );
    color: white;
    text-align: center;
    padding: 80px 0;
    position: static;
    width: 100%;
    border-radius: 3px 3px 0px 0px;
    margin-top: auto; /* push to bottom when content short */
}

body {
    margin:0;
    padding:0;
    background-color:#333;
    font-family:verdana;
}

.smoke {
    position:absolute;
    top:50%;
    left:50%;
    transform:translate(-50%,-50%);
}

.smoke ul {
    margin:0;
    padding:0;
    display:flex;

}

.smoke ul li {
    list-style:none;
    font-weight:bold;
    letter-spacing:10px;
    filter:blur(1px);
    color:#fff;
    font-size:6em;
    display: inline-block;
    animation: smoke 2s linear infinite;
}

@keyframes smoke {
    0% {
        transform: rotate(0deg) translateY(0px);
        opacity: 1;
        filter:blur(1px);
    }
    100% {
      transform: rotate(45deg) translateY(-200px);
        opacity: 0;
        filter:blur(20px);
    }
}

.smoke ul li:nth-child(1){
    animation-delay:0s
}
.smoke ul li:nth-child(2){
    animation-delay:.4s
}
.smoke ul li:nth-child(3){
    animation-delay:.8s
}
.smoke ul li:nth-child(4){
    animation-delay:1.2s
}
.smoke ul li:nth-child(5){
    animation-delay:1.6s
}
ul li a {
    font-family: "Bruno Ace SC", sans-serif;
    font-weight: bold;
    color: #222;
    text-decoration: none;
    transition: color 0.2s, text-shadow 0.2s;
}

ul li a:hover {
    color: gold;
    text-shadow: 0 0 8px #ffd700;
    text-decoration: underline;
}



</style>
<header>


   <h1 class="comforter-brush-regular">SKELOSQUAD</h1>
   <nav class="bruno-ace-sc-regular">
        <a href="index.jsp">Domů</a> |
        <a href="about.jsp">O nás</a> |
        <a href="music.jsp">Hudba</a> |
        <a href="texty.jsp">Texty</a>
    </nav>
    <div style="position:absolute; top:10px; right:14px; font-size:0.95em;">
        <% String currentUser = (String) session.getAttribute("username"); String currentRole = (String) session.getAttribute("role"); %>
        <% if (currentUser == null) { %>
            <a href="login.jsp" style="color:white;">Přihlásit</a> |
            <a href="register.jsp" style="color:white;">Registrovat</a>
        <% } else { %>
            <span>👤 <%= currentUser %><% if ("ADMIN".equals(currentRole)) { %> (admin)<% } %></span> |
            <a href="logout" style="color:white;">Odhlásit</a>
        <% } %>
    </div>
</header>
