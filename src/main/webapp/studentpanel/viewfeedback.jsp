<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.net.*, java.io.*, org.json.*" %>
<jsp:include page="nav.jsp" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View All Feedback</title>
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
        .error {
            color: red;
            text-align: center;
            margin-top: 20px;
        }
    </style>
</head>
<body>

<div class="container">
    <h3>View All Feedback</h3>

    <%
        String feedbackData = null;

        try {
            // Connect to the backend API
            URL url = new URL("http://localhost:8080/api/v1/student/received");
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
                feedbackData = jsonResponse.toString();
            } else {
                feedbackData = "Failed to fetch feedback. HTTP Code: " + responseCode;
            }
        } catch (Exception e) {
            feedbackData = "Error: " + e.getMessage();
        }

        // Parse JSON and display feedback in a table
        if (feedbackData != null) {
            if (feedbackData.startsWith("[")) {
    %>
    <div class="card">
        <h4>Feedback List</h4>
        <table>
            <thead>
            <tr>
                <th>Feedback ID</th>
                <th>Sender ID</th>
                <th>Receiver ID</th>
                <th>Description</th>
                <th>Event ID</th>
            </tr>
            </thead>
            <tbody>
            <%
                JSONArray feedbackArray = new JSONArray(feedbackData);
                for (int i = 0; i < feedbackArray.length(); i++) {
                    JSONObject feedback = feedbackArray.getJSONObject(i);
            %>
            <tr>
                <td><%= feedback.getString("fid") %></td>
                <td><%= feedback.getString("sender") %></td>
                <td><%= feedback.getString("receiver") %></td>
                <td><%= feedback.getString("description") %></td>
                <td><%= feedback.getString("eid") %></td>
            </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>
    <%
    } else {
    %>
    <div class="error">
        <%= feedbackData %>
    </div>
    <%
            }
        }
    %>
</div>

</body>
</html>
