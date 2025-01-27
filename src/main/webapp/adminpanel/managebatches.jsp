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
    <title>Manage Batches</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f8f9fa;
            color: #333;
        }
        h1 {
            text-align: center;
            margin: 20px 0;
            color: #007bff;
        }
        .container {
            width: 95%;
            margin: 0 auto;
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
        tr:nth-child(even) {
            background-color: #f8f9fa;
        }
        tr:hover {
            background-color: #e9ecef;
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
        .error-message {
            color: red;
            font-weight: bold;
            text-align: center;
            margin-top: 20px;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Manage Batches</h1>
    <%
        String apiUrl = "http://localhost:8080/api/v1/admin/batches/all";
        String batchesData = null;

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
                batchesData = jsonResponse.toString();
            } else {
                batchesData = "Failed to fetch batches. HTTP Code: " + responseCode;
            }

            conn.disconnect();
        } catch (Exception e) {
            batchesData = "Error: " + e.getMessage();
        }

        if (batchesData != null && batchesData.startsWith("[")) {
            JSONArray batches = new JSONArray(batchesData);
    %>
    <table>
        <thead>
        <tr>
            <th>Batch ID</th>
            <th>Batch Name</th>
            <th>Course</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (int i = 0; i < batches.length(); i++) {
                JSONObject batch = batches.getJSONObject(i);
        %>
        <tr>
            <td><%= batch.getString("bid") %></td>
            <td><%= batch.getString("name") %></td>
            <td><%= batch.getString("course") %></td>
            <td><%= batch.getString("status") %></td>
            <td>
                <a href="./updatebatchstatus.jsp?bid=<%= batch.getString("bid") %>" class="action-btn update-btn">Update Status</a>
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
    <p class="error-message"><%= batchesData %></p>
    <%
        }
    %>
</div>
</body>
</html>
