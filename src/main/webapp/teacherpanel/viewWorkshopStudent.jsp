<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.net.*, java.io.*, org.json.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Workshop Students</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }
        .container {
            padding: 20px;
        }
        .card {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-bottom: 20px;
        }
        .card h4 {
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        table th, table td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
        }
        table th {
            background-color: #007bff;
            color: white;
        }
        table tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        table tr:hover {
            background-color: #f1f1f1;
        }
        .icon {
            cursor: pointer;
            color: #007bff;
            text-decoration: none;
            font-size: 1.2rem;
            padding: 5px 10px;
            border-radius: 50%;
            transition: background-color 0.3s ease;
        }
        .icon:hover {
            background-color: #e9ecef;
        }
    </style>
</head>
<body>
<div class="container">
    <h3>Students in Workshop</h3>
    <%
        String eid = request.getParameter("eid");
        String studentsData = null;

        if (eid != null) {
            try {
                // Connect to the backend API
                URL url = new URL("http://localhost:8080/api/v1/workshop/" + eid + "/students");
                HttpURLConnection connection = (HttpURLConnection) url.openConnection();
                connection.setRequestMethod("GET");
                connection.setRequestProperty("Accept", "application/json");

                // Forward session cookies
                String cookies = request.getHeader("Cookie");
                if (cookies != null) {
                    connection.setRequestProperty("Cookie", cookies);
                }

                int responseCode = connection.getResponseCode();
                if (responseCode == 200) {
                    BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
                    StringBuilder jsonResponse = new StringBuilder();
                    String line;
                    while ((line = reader.readLine()) != null) {
                        jsonResponse.append(line);
                    }
                    reader.close();
                    studentsData = jsonResponse.toString();
                } else {
                    studentsData = "Failed to fetch students. HTTP Code: " + responseCode;
                }
            } catch (Exception e) {
                studentsData = "Error: " + e.getMessage();
            }
        }

        // Parse JSON and display students in a table
        if (studentsData != null && studentsData.startsWith("[")) {
            try {
                JSONArray students = new JSONArray(studentsData);
    %>
    <div class="card">
        <h4>Event ID: <%= eid %></h4>
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Profile</th>
                <th>Feedback</th>
            </tr>
            </thead>
            <tbody>
            <%
                for (int i = 0; i < students.length(); i++) {
                    JSONObject student = students.getJSONObject(i);
                    String id = student.getString("id");
                    String name = student.getString("name");
                    String email = student.getString("email");
            %>
            <tr>
                <td><%= id %></td>
                <td><%= name %></td>
                <td><%= email %></td>
                <td>
                    <a href="viewportfolio.jsp?studentid=<%= id %>" class="icon">&#128100;</a>
                </td>
                <td>
                    <a href="sendFeedback.jsp?eid=<%= eid %>&sid=<%= id %>" class="icon">&#9993;</a>
                </td>
            </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>
    <%
    } catch (JSONException e) {
    %>
    <div style="color: red;">
        Invalid JSON format: <%= e.getMessage() %>
    </div>
    <%
        }
    } else {
    %>
    <div style="color: red;">
        No data available or failed to fetch data.
    </div>
    <%
        }
    %>
</div>
</body>
</html>
