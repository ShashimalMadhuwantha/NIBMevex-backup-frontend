<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.net.*, java.io.*" %>
<jsp:include page="nav.jsp" />
<%
    // Access the session and retrieve the userID
    String sessionId = (String) session.getAttribute("userID");
    if (sessionId == null || sessionId.isEmpty()) {
        response.sendRedirect("./logout.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Delete Lecturer</title>
    <style>
        .message {
            max-width: 600px;
            margin: 20px auto;
            padding: 20px;
            text-align: center;
            font-size: 1.2em;
        }
        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
    </style>
</head>
<body>
<h1>Delete Lecturer</h1>
<%
    String lid = request.getParameter("lid");
    if (lid == null) {
%>
<p class="message error">Lecturer ID is missing!</p>
<% } else {
    String apiUrl = "http://localhost:8080/api/v1/admin/lecturer/remove/" + lid;
    try {
        URL url = new URL(apiUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("DELETE");

        String cookies = request.getHeader("Cookie");
        if (cookies != null) {
            conn.setRequestProperty("Cookie", cookies);
        }

        int responseCode = conn.getResponseCode();
        if (responseCode == 200) {
%>
<p class="message success">Lecturer deleted successfully! <a href="./manageLecturers.jsp">Return to Manage Lecturers</a></p>
<%
} else {
%>
<p class="message error">Failed to delete lecturer. HTTP Code: <%= responseCode %></p>
<%
    }
    conn.disconnect();
} catch (Exception e) {
%>
<p class="message error">Error: <%= e.getMessage() %></p>
<%
        }
    }
%>
</body>
</html>
