<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.net.*, java.io.*, org.json.*" %>
<jsp:include page="nav.jsp" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View All Events</title>
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
        .events-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
        }
        .card {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 20px;
            width: calc(33.333% - 20px);
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
            text-align: center;
        }
        .btn:hover {
            background-color: #0056b3;
        }
        @media (max-width: 768px) {
            .card {
                width: calc(50% - 20px);
            }
        }
        @media (max-width: 480px) {
            .card {
                width: 100%;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <h3>View All Events</h3>
    <div class="events-grid">
        <%
            String eventsData = null;

            try {
                // Connect to the backend API
                URL url = new URL("http://localhost:8080/api/v1/event/all");
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
                    eventsData = jsonResponse.toString();
                } else {
                    eventsData = null;
                    request.setAttribute("error", "Failed to fetch events. HTTP Code: " + responseCode);
                }
            } catch (Exception e) {
                eventsData = null;
                request.setAttribute("error", "Error: " + e.getMessage());
            }

            // Parse JSON and display events as cards
            if (eventsData != null) {
                try {
                    JSONArray events = new JSONArray(eventsData);
                    for (int i = 0; i < events.length(); i++) {
                        JSONObject event = events.getJSONObject(i);
        %>
        <div class="card">
            <h4>Event Name: <%= event.getString("name") %></h4>
            <p><strong>Event ID:</strong> <%= event.getString("eid") %></p>
            <p><strong>Date:</strong> <%= event.getString("date") %></p>
            <p><strong>Status:</strong> <%= event.getString("status") %></p>
            <p><strong>Lecturer ID:</strong> <%= event.getString("lid") %></p>
            <a href="manageEvent.jsp?eid=<%= event.getString("eid") %>" class="btn">Manage</a>
        </div>
        <%
                    }
                } catch (Exception e) {
                    request.setAttribute("error", "Error parsing events data: " + e.getMessage());
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
