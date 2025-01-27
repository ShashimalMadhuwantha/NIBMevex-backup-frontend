<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.net.*, java.io.*, org.json.*" %>
<jsp:include page="nav.jsp" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assign Students to Interview</title>
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
        .btn {
            padding: 10px 15px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            margin-top: 10px;
            font-size: 1rem;
        }
        .btn:hover {
            background-color: #0056b3;
        }
        .error {
            color: red;
            text-align: center;
            margin-top: 20px;
        }
        .success {
            color: green;
            text-align: center;
            margin-top: 20px;
        }
    </style>
</head>
<body>

<div class="container">
    <h3>Assign Students to Interview</h3>

    <%
        String eid = request.getParameter("eid");
        String badgeData = null;
        String selectedBadgeId = request.getParameter("badgeSelect");
        String studentsData = null;
        String message = null;

        // Fetch badges to populate dropdown
        try {
            URL url = new URL("http://localhost:8080/api/v1/lecturer/badges");
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
                badgeData = jsonResponse.toString();
            } else {
                badgeData = null;
                request.setAttribute("error", "Failed to fetch badges. HTTP Code: " + responseCode);
            }
        } catch (Exception e) {
            badgeData = null;
            request.setAttribute("error", "Error: " + e.getMessage());
        }

        // Fetch students for selected badge
        if (selectedBadgeId != null && !selectedBadgeId.isEmpty()) {
            try {
                URL url = new URL("http://localhost:8080/api/v1/lecturer/students/" + selectedBadgeId);
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
                    studentsData = jsonResponse.toString();
                } else {
                    studentsData = null;
                    request.setAttribute("error", "Failed to fetch students. HTTP Code: " + responseCode);
                }
            } catch (Exception e) {
                studentsData = null;
                request.setAttribute("error", "Error: " + e.getMessage());
            }
        }

        // Process the form when it's submitted
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String[] selectedStudentIds = request.getParameterValues("studentIds");
            if (selectedStudentIds != null && selectedStudentIds.length > 0) {
                // Prepare JSON to send in POST request
                try {
                    URL url = new URL("http://localhost:8080/api/v1/lecturer/assign/interviews");
                    HttpURLConnection connection = (HttpURLConnection) url.openConnection();
                    connection.setRequestMethod("POST");
                    connection.setRequestProperty("Content-Type", "application/json");

                    // Build the JSON payload
                    String jsonInputString = "{ \"eid\": \"" + eid + "\", \"studentIds\": [\"" + String.join("\",\"", selectedStudentIds) + "\"] }";
                    connection.setDoOutput(true);
                    connection.getOutputStream().write(jsonInputString.getBytes("UTF-8"));

                    int responseCode = connection.getResponseCode();
                    StringBuilder responseBuilder = new StringBuilder();
                    if (responseCode == 200) {
                        BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
                        String line;
                        while ((line = in.readLine()) != null) {
                            responseBuilder.append(line);
                        }
                        in.close();

                        // Check the server's response for success or failure
                        JSONObject jsonResponse = new JSONObject(responseBuilder.toString());
                        if (jsonResponse.getBoolean("success")) {
                            message = "Students assigned successfully!";
                        } else {
                            message = "Error assigning students: " + jsonResponse.optString("message", "Unknown error.");
                        }
                    } else {
                        message = "Error assigning students. HTTP Code: " + responseCode;
                    }
                } catch (Exception e) {
                    message = "Error: " + e.getMessage();
                }
            } else {
                message = "Please select at least one student.";
            }
        }

        // Parse badge data and show student selection form
        if (badgeData != null) {
            try {
                JSONArray badges = new JSONArray(badgeData);
    %>
    <div class="card">
        <h4>Select Badge for Students</h4>
        <form id="assignForm" method="POST" action="">
            <label for="badgeSelect">Select Batch (Badge ID): </label>
            <select id="badgeSelect" name="badgeSelect" onchange="this.form.submit()">
                <option value="">Select Batch</option>
                <%
                    for (int i = 0; i < badges.length(); i++) {
                        JSONObject badge = badges.getJSONObject(i);
                        String selected = (selectedBadgeId != null && selectedBadgeId.equals(badge.getString("bid"))) ? "selected" : "";
                %>
                <option value="<%= badge.getString("bid") %>" <%= selected %>><%= badge.getString("bid") %></option>
                <%
                    }
                %>
            </select>
        </form>
    </div>

    <div id="studentsList" class="card">
        <h4>Students List</h4>
        <p>Select the students to assign them to the interview.</p>
        <form id="assignStudentsForm" method="POST" action="">
            <input type="hidden" name="eid" value="<%= eid %>">
            <table id="studentsTable">
                <thead>
                <tr>
                    <th>Select</th>
                    <th>Student Name</th>
                    <th>Student ID</th>
                </tr>
                </thead>
                <tbody>
                <%
                    if (studentsData != null) {
                        JSONArray students = new JSONArray(studentsData);
                        for (int i = 0; i < students.length(); i++) {
                            JSONObject student = students.getJSONObject(i);
                %>
                <tr>
                    <td><input type="checkbox" name="studentIds" value="<%= student.getString("sid") %>"></td>
                    <td><%= student.getString("name") %></td>
                    <td><%= student.getString("sid") %></td>
                </tr>
                <%
                        }
                    }
                %>
                </tbody>
            </table>
            <button class="btn" type="submit">Assign Students</button>
        </form>
    </div>
    <%
            } catch (Exception e) {
                request.setAttribute("error", "Error parsing badge data: " + e.getMessage());
            }
        }

        if (message != null) {
            if (message.contains("success")) {
    %>
    <div class="success">
        <%= message %>
    </div>
    <%
    } else {
    %>
    <div class="error">
        <%= message %>
    </div>
    <%
            }
        }
    %>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('assignStudentsForm');

        form.addEventListener('submit', async function(e) {
            e.preventDefault();

            const selectedStudentIds = [];
            const checkboxes = document.querySelectorAll("input[name='studentIds']:checked");

            checkboxes.forEach((checkbox) => {
                selectedStudentIds.push(checkbox.value);
            });

            if (selectedStudentIds.length === 0) {
                alert('Please select at least one student.');
                return;
            }

            const eid = document.querySelector('input[name="eid"]').value;
            const payload = {
                eid: eid,
                studentIds: selectedStudentIds
            };

            try {
                const response = await fetch('http://localhost:8080/api/v1/lecturer/assign/interviews', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify(payload),
                    credentials: 'include'
                });

                const contentType = response.headers.get("Content-Type");
                let responseBody = await response.text();

                if (contentType && contentType.includes("application/json")) {
                    responseBody = JSON.parse(responseBody);
                }

                if (response.ok) {
                    alert("Students assigned successfully!");
                } else {
                    alert("Error assigning students: " + (responseBody.message || responseBody || "Unknown error"));
                }
            } catch (error) {
                alert("Error while assigning students: " + error.message);
                console.error("Error during assignment:", error);
            }
        });
    });
</script>

</body>
</html>
