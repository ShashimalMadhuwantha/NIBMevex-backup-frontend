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
    <title>Manage Events</title>
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
        .status-filter {
            margin-bottom: 20px;
        }
        .status-filter select {
            padding: 5px;
            font-size: 1rem;
        }
        .card-container {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            justify-content: space-between;
        }
        .card {
            background-color: #fff;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 15px;
            width: 30%;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .card h3 {
            margin-top: 0;
            color: #007bff;
        }
        .card p {
            margin: 8px 0;
            color: #555;
        }
        .card .event-status {
            font-weight: bold;
            color: #28a745; /* Green for upcoming events */
        }
        .card .event-status.complete {
            color: #dc3545; /* Red for complete events */
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
    <h1>Manage Events</h1>

    <!-- Filter by Status -->
    <div class="status-filter">
        <form method="GET" action="adminevent.jsp">
            <label for="status">Filter by Status: </label>
            <select name="status" id="status" onchange="this.form.submit()">
                <option value="all" <%= "all".equals(request.getParameter("status")) ? "selected" : "" %>>All</option>
                <option value="complete" <%= "complete".equals(request.getParameter("status")) ? "selected" : "" %>>Complete</option>
                <option value="upcoming" <%= "upcoming".equals(request.getParameter("status")) ? "selected" : "" %>>Upcoming</option>
            </select>
        </form>
    </div>

    <%
        String status = request.getParameter("status");
        if (status == null || status.equals("all")) {
            status = "all"; // Default to "all" to show both complete and upcoming events
        }

        String apiUrl = "http://localhost:8080/api/v1/admin/events";
        if (!status.equals("all")) {
            apiUrl += "?status=" + status;  // Add status filter if it's not "all"
        }

        String eventsData = null;

        try {
            // Open connection to the API endpoint
            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Accept", "application/json");

            // Add cookies if needed
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
                eventsData = jsonResponse.toString();
            } else {
                eventsData = "Failed to fetch events. HTTP Code: " + responseCode;
            }

            conn.disconnect();
        } catch (Exception e) {
            eventsData = "Error: " + e.getMessage();
        }

        if (eventsData != null && eventsData.startsWith("[")) {
            JSONArray events = new JSONArray(eventsData);
    %>
    <div class="card-container">
        <%
            // Iterate over the events and display them as cards
            for (int i = 0; i < events.length(); i++) {
                JSONObject event = events.getJSONObject(i);
                String eventStatus = event.getString("status");
                String statusClass = eventStatus.equals("complete") ? "complete" : "upcoming";
        %>
        <div class="card">
            <h3><%= event.getString("name") %></h3>
            <p><strong>Event ID:</strong> <%= event.getString("eid") %></p>
            <p><strong>Date:</strong> <%= event.getString("date") %></p>
            <p><strong>Status:</strong> <span class="event-status <%= statusClass %>"><%= event.getString("status") %></span></p>
            <p><strong>Location ID:</strong> <%= event.getString("lid") %></p>
        </div>
        <%
            }
        %>
    </div>
    <%
    } else {
    %>
    <p class="error-message"><%= eventsData %></p>
    <%
        }
    %>
</div>
</body>
</html>
