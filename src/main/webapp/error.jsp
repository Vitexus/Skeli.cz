<%@ include file="includes/header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<main style="text-align:center;">
  <h2>Oops!</h2>
  <p>Ztratil ses v beatu? Zpět na <a href="index.jsp">Domů</a>.</p>
  <%
    String role = (String) session.getAttribute("role");
    Throwable ex = (Throwable) request.getAttribute("jakarta.servlet.error.exception");
    Integer code = (Integer) request.getAttribute("jakarta.servlet.error.status_code");
    String uri = (String) request.getAttribute("jakarta.servlet.error.request_uri");
    if (ex != null) {
  %>
  <!-- DEBUG: status=<%= code %> uri=<%= uri %> ex=<%= ex.getClass().getName() %>: <%= ex.getMessage() %> root=<%= (ex.getCause()!=null? ex.getCause().getClass().getName()+": "+ex.getCause().getMessage() : "-") %> -->
  <%
      if ("ADMIN".equals(role)) {
  %>
    <details style="text-align:left; max-width:900px; margin:10px auto; background:rgba(0,0,0,0.4); padding:10px; border-radius:8px;">
      <summary style="cursor:pointer; color:#ffd700;">Detail chyby (jen ADMIN)</summary>
      <pre style="white-space: pre-wrap; overflow-wrap:anywhere;">
<%
        java.io.StringWriter sw = new java.io.StringWriter();
        ex.printStackTrace(new java.io.PrintWriter(sw));
        out.print(sw.toString());
%>
      </pre>
    </details>
  <%
      }
    }
  %>
</main>
<%@ include file="includes/footer.jsp" %>
