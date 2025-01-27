<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.net.*, java.io.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Event</title>
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
            margin: 0;
        }
        .form-group {
            margin: 15px 0;
        }
        .form-group label {
            display: block;
            font-weight: bold;
            margin-bottom: 5px;
        }
        .form-group select,
        .btn {
            width: 100%;
            padding: 10px;
            font-size: 1rem;
            margin-top: 10px;
        }
        .btn {
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .btn:hover {
            background-color: #0056b3;
        }
        .btn-delete {
            background-color: #dc3545;
        }
        .btn-delete:hover {
            background-color: #a71d2a;
        }
        .alert {
            margin-top: 20px;
            padding: 15px;
            border-radius: 5px;
            text-align: center;
        }
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
    </style>
</head>
<body>
<div class="container">
    <h3>Manage Event</h3>
    <%
        String eid = request.getParameter("eid");
        if (eid == null || eid.isEmpty()) {
    %>
    <div class="alert alert-danger">
        Event ID is missing. Please go back and select an event.
    </div>
    <% } else { %>
    <div class="card">
        <h4>Event ID: <%= eid %></h4>
        <form method="post" action="manageEvent.jsp">
            <input type="hidden" name="eid" value="<%= eid %>">
            <div class="form-group">
                <label for="status">Update Status</label>
                <select name="status" id="status" required>
                    <option value="upcoming">Upcoming</option>
                    <option value="complete">Complete</option>
                </select>
            </div>
            <button type="submit" class="btn" name="action" value="update">Update Status</button>
        </form>
        <form method="post" action="manageEvent.jsp">
            <input type="hidden" name="eid" value="<%= eid %>">
            <button type="submit" class="btn btn-delete" name="action" value="delete">Delete Event</button>
        </form>
    </div>
    <%
        String action = request.getParameter("action");
        String message = null;

        if ("update".equals(action)) {
            String status = request.getParameter("status");
            try {
                URL url = new URL("http://localhost:8080/api/v1/lecturer/events/" + eid + "/status?status=" + status);
                HttpURLConnection connection = (HttpURLConnection) url.openConnection();
                connection.setRequestMethod("PUT");
                connection.setRequestProperty("Accept", "application/json");

                // Forward session cookies
                String cookies = request.getHeader("Cookie");
                if (cookies != null) {
                    connection.setRequestProperty("Cookie", cookies);
                }

                int responseCode = connection.getResponseCode();
                if (responseCode == 200) {
                    message = "<div class='alert alert-success'>Event status updated successfully to '" + status + "'.</div>";
                } else {
                    message = "<div class='alert alert-danger'>Failed to update event status. HTTP Code: " + responseCode + "</div>";
                }
            } catch (Exception e) {
                message = "<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>";
            }
        } else if ("delete".equals(action)) {
            try {
                URL url = new URL("http://localhost:8080/api/v1/" + eid);
                HttpURLConnection connection = (HttpURLConnection) url.openConnection();
                connection.setRequestMethod("DELETE");
                connection.setRequestProperty("Accept", "application/json");

                // Forward session cookies
                String cookies = request.getHeader("Cookie");
                if (cookies != null) {
                    connection.setRequestProperty("Cookie", cookies);
                }

                int responseCode = connection.getResponseCode();
                if (responseCode == 200) {
                    message = "<div class='alert alert-success'>Event deleted successfully.</div>";
                } else {
                    message = "<div class='alert alert-danger'>Failed to delete event. HTTP Code: " + responseCode + "</div>";
                }
            } catch (Exception e) {
                message = "<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>";
            }
        }

        if (message != null) {
    %>
    <div><%= message %></div>
    <% } } %>
</div>
</body>
</html>
