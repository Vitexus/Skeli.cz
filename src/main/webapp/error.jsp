<%@ include file="includes/header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<main style="text-align:center;">
  <h2><%= t.getProperty("error.heading") %></h2>
  <p><%= t.getProperty("error.lost") %> <a href="/index.jsp"><%= t.getProperty("error.homeLink") %></a>.</p>
  <%
    String role = (String) session.getAttribute("role");
    Throwable ex = (Throwable) request.getAttribute("jakarta.servlet.error.exception");
    Integer code = (Integer) request.getAttribute("jakarta.servlet.error.status_code");
    String uri = (String) request.getAttribute("jakarta.servlet.error.request_uri");
    // Error details are shown to admins only - to anyone else they would leak app internals
    if (ex != null) {
      if ("ADMIN".equals(role)) {
  %>
    <details style="text-align:left; max-width:900px; margin:10px auto; background:rgba(0,0,0,0.4); padding:10px; border-radius:8px;">
      <summary style="cursor:pointer; color:#ffd700;"><%= t.getProperty("error.adminDetail") %></summary>
      <pre style="white-space: pre-wrap; overflow-wrap:anywhere;">
status=<%= code %> uri=<%= com.github.skeliit.WebUtils.escapeHtml(uri) %>
<%
        java.io.StringWriter sw = new java.io.StringWriter();
        ex.printStackTrace(new java.io.PrintWriter(sw));
        // Exception messages can contain user input, so escape them
        out.print(com.github.skeliit.WebUtils.escapeHtml(sw.toString()));
%>
      </pre>
    </details>
  <%
      }
    }
  %>
</main>
<%@ include file="includes/footer.jsp" %>
