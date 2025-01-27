<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.net.*, java.io.*, org.json.*" %>
<jsp:include page="nav.jsp" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Interviews</title>
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
        .interviews-grid {
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
    <h3>View Interviews</h3>
    <div class="interviews-grid">
        <%
            String interviewsData = null;

            try {
                // Connect to the backend API
                URL url = new URL("http://localhost:8080/api/v1/lecturer/interviews");
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
                    interviewsData = jsonResponse.toString();
                } else {
                    interviewsData = null;
                    request.setAttribute("error", "Failed to fetch interviews. HTTP Code: " + responseCode);
                }
            } catch (Exception e) {
                interviewsData = null;
                request.setAttribute("error", "Error: " + e.getMessage());
            }

            // Parse JSON and display interviews as cards
            if (interviewsData != null) {
                try {
                    JSONArray interviews = new JSONArray(interviewsData);
                    for (int i = 0; i < interviews.length(); i++) {
                        JSONObject interview = interviews.getJSONObject(i);
        %>
        <div class="card">
            <h4>Interviewer: <%= interview.getString("interviewer") %></h4>
            <p><strong>Event ID:</strong> <%= interview.getString("eid") %></p>
            <p><strong>Date:</strong> <%= interview.getString("date") %></p>
            <p><strong>Location:</strong> <%= interview.getString("location") %></p>
            <a href="./assigninterviewstudent.jsp?eid=<%= interview.getString("eid") %>" class="btn">Assign Students</a>
        </div>
        <%
                    }
                } catch (Exception e) {
                    request.setAttribute("error", "Error parsing interviews data: " + e.getMessage());
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