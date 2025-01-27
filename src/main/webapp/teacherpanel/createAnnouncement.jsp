<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.net.*, java.io.*, org.json.*" %>
<jsp:include page="nav.jsp" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Announcement</title>
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
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            font-weight: bold;
            margin-bottom: 5px;
        }
        .form-group input, .form-group select, .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            font-size: 1rem;
            border: none;
            border-radius: 4px;
            background-color: #007bff;
            color: white;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .btn:hover {
            background-color: #0056b3;
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
    <div class="card">
        <h3>Create Announcement</h3>
        <form method="post" action="./createAnnouncement.jsp">
            <div class="form-group">
                <label for="name">Announcement Name</label>
                <input type="text" id="name" name="name" required>
            </div>
            <!-- Status set as upcoming by default -->
            <input type="hidden" id="status" name="status" value="upcoming">
            <div class="form-group">
                <label for="description">Description</label>
                <textarea id="description" name="description" rows="4" required></textarea>
            </div>
            <div class="form-group">
                <label for="bid">Batch ID</label>
                <select id="bid" name="bid" required>
                    <%
                        try {
                            URL url = new URL("http://localhost:8080/api/v1/lecturer/badges");
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

                                JSONArray badges = new JSONArray(jsonResponse.toString());
                                for (int i = 0; i < badges.length(); i++) {
                                    JSONObject badge = badges.getJSONObject(i);
                                    String bid = badge.getString("bid");
                    %>
                    <option value="<%= bid %>"><%= bid %></option>
                    <%
                                }
                            }
                        } catch (Exception e) {
                            request.setAttribute("error", "Error fetching badges: " + e.getMessage());
                        }
                    %>
                </select>
            </div>
            <button type="submit" class="btn">Create Announcement</button>
        </form>
        <%
            String name = request.getParameter("name");
            String status = "upcoming"; // Default status
            String description = request.getParameter("description");
            String bid = request.getParameter("bid");

            if (name != null && description != null && bid != null) {
                try {
                    URL url = new URL("http://localhost:8080/api/v1/lecturer/announcements");
                    HttpURLConnection connection = (HttpURLConnection) url.openConnection();
                    connection.setRequestMethod("POST");
                    connection.setRequestProperty("Content-Type", "application/json");

                    // Include the session cookie
                    String cookies = request.getHeader("Cookie");
                    if (cookies != null) {
                        connection.setRequestProperty("Cookie", cookies);
                    }

                    connection.setDoOutput(true);

                    // Prepare the payload
                    JSONObject payload = new JSONObject();
                    payload.put("name", name);
                    payload.put("status", status); // Default to "upcoming"
                    payload.put("description", description);
                    payload.put("bid", bid);

                    // Send the request
                    OutputStream os = connection.getOutputStream();
                    os.write(payload.toString().getBytes("UTF-8"));
                    os.close();

                    int responseCode = connection.getResponseCode();
                    if (responseCode == 200) {
                        request.setAttribute("message", "<div class='alert alert-success'>Announcement created successfully!</div>");
                    } else if (responseCode == 403) {
                        request.setAttribute("message", "<div class='alert alert-danger'>Access Denied: Only lecturers can create announcements.</div>");
                    } else {
                        request.setAttribute("message", "<div class='alert alert-danger'>Failed to create announcement. HTTP Code: " + responseCode + "</div>");
                    }
                } catch (Exception e) {
                    request.setAttribute("message", "<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
                }
            }
        %>
        <%= request.getAttribute("message") != null ? request.getAttribute("message") : "" %>
        <% if (request.getAttribute("error") != null) { %>
        <div style="color: red; margin-top: 20px;">
            <%= request.getAttribute("error") %>
        </div>
        <% } %>
    </div>
</div>
</body>
</html>
