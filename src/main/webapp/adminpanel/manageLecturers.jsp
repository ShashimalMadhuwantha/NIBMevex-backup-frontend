<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.net.*, java.io.*, org.json.*" %>
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
    <title>Manage Lecturers</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f8f9fa;
        }
        .container {
            width: 95%;
            margin: 20px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        table, th, td {
            border: 1px solid #dee2e6;
        }
        th, td {
            padding: 12px;
            text-align: left;
        }
        th {
            background-color: #007bff;
            color: #fff;
        }
        .action-btn {
            padding: 8px 12px;
            text-decoration: none;
            border-radius: 4px;
            font-weight: bold;
            text-align: center;
            display: inline-block;
        }
        .update-btn {
            background-color: #28a745;
            color: white;
        }
        .update-btn:hover {
            background-color: #218838;
        }
        .delete-btn {
            background-color: #dc3545;
            color: white;
        }
        .delete-btn:hover {
            background-color: #c82333;
        }
        .error-message {
            color: red;
            font-weight: bold;
            text-align: center;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Manage Lecturers</h1>
    <%
        String apiUrl = "http://localhost:8080/api/v1/admin/lecturer/all";
        String lecturersData = null;

        try {
            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Accept", "application/json");

            String cookies = request.getHeader("Cookie");
            if (cookies != null) {
                conn.setRequestProperty("Cookie", cookies);
            }

            int responseCode = conn.getResponseCode();
            if (responseCode == 200) {
                BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                StringBuilder jsonResponse = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    jsonResponse.append(line);
                }
                reader.close();
                lecturersData = jsonResponse.toString();
            } else {
                lecturersData = "Failed to fetch lecturers. HTTP Code: " + responseCode;
            }

            conn.disconnect();
        } catch (Exception e) {
            lecturersData = "Error: " + e.getMessage();
        }

        if (lecturersData != null && lecturersData.startsWith("[")) {
            JSONArray lecturers = new JSONArray(lecturersData);
    %>
    <table>
        <thead>
        <tr>
            <th>LID</th>
            <th>Username</th>
            <th>Name</th>
            <th>Email</th>
            <th>Contact</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (int i = 0; i < lecturers.length(); i++) {
                JSONObject lecturer = lecturers.getJSONObject(i);
        %>
        <tr>
            <td><%= lecturer.getString("lid") %></td>
            <td><%= lecturer.getString("username") %></td>
            <td><%= lecturer.getString("name") %></td>
            <td><%= lecturer.getString("email") %></td>
            <td><%= lecturer.getString("contact") %></td>
            <td>
                <a href="./updateLecturer.jsp?lid=<%= lecturer.getString("lid") %>&username=<%= lecturer.getString("username") %>&name=<%= lecturer.getString("name") %>&email=<%= lecturer.getString("email") %>&contact=<%= lecturer.getString("contact") %>" class="action-btn update-btn">Update</a>
                <a href="./deleteLecturer.jsp?lid=<%= lecturer.getString("lid") %>" class="action-btn delete-btn">Delete</a>
            </td>
        </tr>
        <%
            }
        %>
        </tbody>
    </table>
    <%
    } else {
    %>
    <p class="error-message"><%= lecturersData %></p>
    <%
        }
    %>
</div>
</body>
</html>