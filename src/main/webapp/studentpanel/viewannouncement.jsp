<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.net.*, java.io.*, org.json.*" %>
<jsp:include page="nav.jsp" />
<%
    // Fetch announcements from the API
    String announcements = null;
    try {
        URL url = new URL("http://localhost:8080/api/v1/students/announcements");
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("GET");
        connection.setRequestProperty("Accept", "application/json");
        connection.setRequestProperty("Cookie", request.getHeader("Cookie")); // Forward session cookies

        int responseCode = connection.getResponseCode();
        if (responseCode == 200) {
            BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
            StringBuilder jsonResponse = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                jsonResponse.append(line);
            }
            reader.close();

            announcements = jsonResponse.toString();
        } else {
            announcements = "Failed to fetch announcements. HTTP Code: " + responseCode;
        }
    } catch (Exception e) {
        announcements = "Error fetching announcements: " + e.getMessage();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Announcements</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 800px;
            margin: 40px auto;
            padding: 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        h1 {
            text-align: center;
            color: #007bff;
            margin-bottom: 30px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
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

        .error {
            color: red;
            text-align: center;
            margin: 20px 0;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Announcements</h1>
    <%
        if (announcements != null && !announcements.startsWith("Error") && !announcements.startsWith("Failed")) {
            JSONArray announcementsArray = new JSONArray(announcements);
    %>
    <table>
        <thead>
        <tr>
            <th>Event ID</th>
            <th>Description</th>
            <th>Batch ID</th>
            <th>Date</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (int i = 0; i < announcementsArray.length(); i++) {
                JSONObject announcement = announcementsArray.getJSONObject(i);
                String eid = announcement.optString("eid", "Unknown");
                String description = announcement.optString("description", "No Description");
                String bid = announcement.optString("bid", "N/A");
                String date = announcement.optString("date", "Unknown");
        %>
        <tr>
            <td><%= eid %></td>
            <td><%= description %></td>
            <td><%= bid %></td>
            <td><%= date %></td>
        </tr>
        <%
            }
        %>
        </tbody>
    </table>
    <%
    } else {
    %>
    <div class="error"><%= announcements %></div>
    <%
        }
    %>
</div>
</body>
</html>
