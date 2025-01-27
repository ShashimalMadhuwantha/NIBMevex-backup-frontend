<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Batch</title>
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
        .form-group input, .form-group select {
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
        <h3>Create Batch</h3>
        <form method="post" action="./createBatch.jsp">
            <div class="form-group">
                <label for="bid">Batch ID</label>
                <input type="text" id="bid" name="bid" required>
            </div>
            <div class="form-group">
                <label for="name">Batch Name</label>
                <input type="text" id="name" name="name" required>
            </div>
            <div class="form-group">
                <label for="course">Course</label>
                <input type="text" id="course" name="course" required>
            </div>
            <div class="form-group">
                <label for="status">Status</label>
                <select id="status" name="status" required>
                    <option value="">Select Status</option>
                    <option value="Active">Active</option>
                    <option value="Inactive">Inactive</option>
                </select>
            </div>
            <div class="form-group">
                <label for="date">Start Date</label>
                <input type="date" id="date" name="date" required>
            </div>
            <div class="form-group">
                <label for="endDate">End Date</label>
                <input type="date" id="endDate" name="endDate" required>
            </div>
            <div class="form-group">
                <label for="lecturer">Lecturer ID</label>
                <select id="lecturer" name="lecturer" required>
                    <option value="">Select Lecturer</option>
                    <%
                        String apiUrl = "http://localhost:8080/api/v1/admin/lecturer/all";
                        String lecturerData = null;
                        try {
                            URL url = new URL(apiUrl);
                            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
                            connection.setRequestMethod("GET");
                            connection.setRequestProperty("Accept", "application/json");

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
                                lecturerData = jsonResponse.toString();
                            }
                        } catch (Exception e) {
                            lecturerData = null;
                        }

                        if (lecturerData != null) {
                            JSONArray lecturers = new JSONArray(lecturerData);
                            for (int i = 0; i < lecturers.length(); i++) {
                                JSONObject lecturer = lecturers.getJSONObject(i);
                                String lid = lecturer.getString("lid");
                                String name = lecturer.getString("name");
                    %>
                    <option value="<%= lid %>"><%= lid %> - <%= name %></option>
                    <%
                        }
                    } else {
                    %>
                    <option value="">Error fetching lecturers</option>
                    <%
                        }
                    %>
                </select>
            </div>
            <button type="submit" class="btn">Create Batch</button>
        </form>
        <%
            String bid = request.getParameter("bid");
            String name = request.getParameter("name");
            String course = request.getParameter("course");
            String status = request.getParameter("status");
            String date = request.getParameter("date");
            String endDate = request.getParameter("endDate");
            String lecturer = request.getParameter("lecturer");

            if (bid != null && name != null && course != null && date != null && endDate != null && lecturer != null) {
                try {
                    URL url = new URL("http://localhost:8080/api/v1/admin/batches");
                    HttpURLConnection connection = (HttpURLConnection) url.openConnection();
                    connection.setRequestMethod("POST");
                    connection.setRequestProperty("Content-Type", "application/json");

                    String cookies = request.getHeader("Cookie");
                    if (cookies != null) {
                        connection.setRequestProperty("Cookie", cookies);
                    }

                    connection.setDoOutput(true);

                    JSONObject payload = new JSONObject();
                    payload.put("bid", bid);
                    payload.put("name", name);
                    payload.put("course", course);
                    payload.put("status", status);
                    payload.put("date", date);
                    payload.put("endDate", endDate);
                    payload.put("lecturer", new JSONObject().put("lid", lecturer));

                    OutputStream os = connection.getOutputStream();
                    os.write(payload.toString().getBytes("UTF-8"));
                    os.close();

                    int responseCode = connection.getResponseCode();
                    if (responseCode == 200) {
                        request.setAttribute("message", "<div class='alert alert-success'>Batch created successfully!</div>");
                    } else {
                        request.setAttribute("message", "<div class='alert alert-danger'>Failed to create batch. HTTP Code: " + responseCode + "</div>");
                    }
                } catch (Exception e) {
                    request.setAttribute("message", "<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
                }
            }
        %>
        <%= request.getAttribute("message") != null ? request.getAttribute("message") : "" %>
    </div>
</div>
</body>
</html>
