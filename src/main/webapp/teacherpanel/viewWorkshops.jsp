<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.net.*, java.io.*, org.json.*" %>
<jsp:include page="nav.jsp" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Workshops</title>
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
        .workshops-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
        }
        .card {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 20px;
            width: calc(33.333% - 20px); /* Three cards per row with a gap of 20px */
            box-sizing: border-box;
        }
        .card h4 {
            margin: 0 0 10px 0;
        }
        .card p {
            margin: 5px 0;
        }
        .btn {
            display: inline-block;
            padding: 10px 15px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            margin-top: 10px;
            font-size: 0.9rem;
        }
        .btn:hover {
            background-color: #0056b3;
        }
        @media (max-width: 768px) {
            .card {
                width: calc(50% - 20px); /* Two cards per row for smaller screens */
            }
        }
        @media (max-width: 480px) {
            .card {
                width: 100%; /* One card per row for very small screens */
            }
        }
    </style>
</head>
<body>
<div class="container">
    <h3>View Workshops</h3>
    <div class="workshops-grid">
        <%
            String workshopsData = null;

            try {
                // Connect to the backend API
                URL url = new URL("http://localhost:8080/api/v1/lecturer/workshops");
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
                    workshopsData = jsonResponse.toString();
                } else {
                    workshopsData = null;
                    request.setAttribute("error", "Failed to fetch workshops. HTTP Code: " + responseCode);
                }
            } catch (Exception e) {
                workshopsData = null;
                request.setAttribute("error", "Error: " + e.getMessage());
            }

            // Parse JSON and display workshops as cards
            if (workshopsData != null) {
                try {
                    JSONArray workshops = new JSONArray(workshopsData);
                    for (int i = 0; i < workshops.length(); i++) {
                        JSONObject workshop = workshops.getJSONObject(i);
        %>
        <div class="card">
            <h4>Event Name: <%= workshop.getString("name") %></h4>
            <p><strong>Event ID:</strong> <%= workshop.getString("eid") %></p>
            <p><strong>Date:</strong> <%= workshop.getString("date") %></p>
            <p><strong>Status:</strong> <%= workshop.getString("status") %></p>
            <p><strong>Location:</strong> <%= workshop.getString("location") %></p>
            <p><strong>Topic:</strong> <%= workshop.getString("topic") %></p>
            <p><strong>Speaker:</strong> <%= workshop.getString("speaker") %></p>
            <p><strong>Duration:</strong> <%= workshop.getString("duration") %></p>
            <p><strong>Batch ID:</strong> <%= workshop.getString("bid") %></p>
            <a href="viewWorkshopStudent.jsp?eid=<%= workshop.getString("eid") %>" class="btn">View Students</a>
        </div>
        <%
                    }
                } catch (Exception e) {
                    request.setAttribute("error", "Error parsing workshops data: " + e.getMessage());
                }
            }
        %>
        <% if (request.getAttribute("error") != null) { %>
        <div style="color: red; margin-top: 20px;">
            <%= request.getAttribute("error") %>
        </div>
        <% } %>
    </div>
</div>
</body>
</html>
