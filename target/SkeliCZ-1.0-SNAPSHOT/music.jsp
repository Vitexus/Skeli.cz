<%@ include file="includes/header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

   <div class="smoke" >
        <ul>
            <li>S</li>
            <li>K</li>
            <li>E</li>
            <li>L</li>
            <li>I</li>
        </ul>

    </div>

<%
    String[] videoLinks = {
        "YQt6qBZ2f4g",
        "pZx0xa6MpbE",
        "DUyWTpG57NY",
        "euIYhNMeq8A",
        "8y60i79nVJc",
        "2vWZfiMnQ3Y",
        "sVOz2GRE3Cg",
        "AMEQfe9hWlg",
        "S3BFk-qmXAY",
        "8jcSUU-Xgvs"
    };
    request.setAttribute("videoLinks", videoLinks);
%>

<main>
    <h2>Moje Hudba!</h2>
    <div class="carousel">
        <c:forEach var="id" items="${videoLinks}">
            <div>
                <iframe width="560" height="315" src="https://www.youtube.com/embed/${id}" frameborder="0" allowfullscreen></iframe>
            </div>
        </c:forEach>
    </div>
</main>
<script>
$(document).ready(function(){
  $('.carousel').slick({
    dots: true,
    infinite: true,
    speed: 500,
    slidesToShow: 1,
    slidesToScroll: 1
  });
});
</script>
<%@ include file="includes/footer.jsp" %>