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
    <title>Update Batch Status</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 40%;
            margin: 50px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        h1 {
            text-align: center;
            color: #007bff;
        }
        form {
            display: flex;
            flex-direction: column;
        }
        label {
            font-weight: bold;
            margin-bottom: 8px;
        }
        select {
            padding: 8px;
            margin-bottom: 20px;
            border: 1px solid #dee2e6;
            border-radius: 4px;
        }
        .btn {
            padding: 10px 15px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
        }
        .btn:hover {
            background-color: #0056b3;
        }
        .message {
            text-align: center;
            margin-top: 20px;
            font-weight: bold;
        }
        .success {
            color: #28a745;
        }
        .error {
            color: #dc3545;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Update Batch Status</h1>
    <%
        String batchId = request.getParameter("bid");
        String updateMessage = null;
        boolean isSuccess = false;

        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String status = request.getParameter("status");
            String apiUrl = "http://localhost:8080/api/v1/admin/batches/" + batchId + "?status=" + status;

            try {
                URL url = new URL(apiUrl);
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setRequestMethod("PUT");
                conn.setRequestProperty("Accept", "application/json");

                String cookies = request.getHeader("Cookie");
                if (cookies != null) {
                    conn.setRequestProperty("Cookie", cookies);
                }

                int responseCode = conn.getResponseCode();
                if (responseCode == 200) {
                    updateMessage = "Batch status updated successfully!";
                    isSuccess = true;
                } else {
                    updateMessage = "Failed to update batch status. HTTP Code: " + responseCode;
                }

                conn.disconnect();
            } catch (Exception e) {
                updateMessage = "Error: " + e.getMessage();
            }
        }
    %>
    <% if (updateMessage != null) { %>
    <p class="message <%= isSuccess ? "success" : "error" %>"><%= updateMessage %></p>
    <% } %>
    <form method="post">
        <label for="status">Select Status:</label>
        <select id="status" name="status" required>
            <option value="Active">Active</option>
            <option value="Complete">Complete</option>
        </select>
        <button type="submit" class="btn">Update</button>
    </form>
</div>
</body>
</html>
