<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.net.*, java.io.*, org.json.*" %>
<jsp:include page="nav.jsp" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Portfolio</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 800px;
            margin: 20px auto;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 20px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            font-weight: bold;
            margin-bottom: 5px;
        }
        .form-group input, .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            text-align: center;
            cursor: pointer;
            border: none;
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
    <h3>Update Portfolio</h3>
    <%
        String portfolioData = null;
        String alertMessage = null;
        String alertType = null;

        try {
            URL url = new URL("http://localhost:8080/api/v1/students/getportfolio");
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
                portfolioData = jsonResponse.toString();
            } else {
                portfolioData = "Failed to fetch portfolio. HTTP Code: " + responseCode;
            }
        } catch (Exception e) {
            portfolioData = "Error: " + e.getMessage();
        }

        String githubUsername = "";
        String description = "";
        String education = "";
        String achievements = "";

        if (portfolioData != null && portfolioData.startsWith("{")) {
            JSONObject portfolio = new JSONObject(portfolioData);
            githubUsername = portfolio.optString("portfolioGithubUsername", "");
            description = portfolio.optString("portfolioDescription", "");
            education = portfolio.optString("portfolioEducation", "");
            achievements = portfolio.optString("portfolioAchievements", "");
        }

        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String newGithubUsername = request.getParameter("githubUsername");
            String newDescription = request.getParameter("description");
            String newEducation = request.getParameter("education");
            String newAchievements = request.getParameter("achievements");

            try {
                URL url = new URL("http://localhost:8080/api/v1/students/portfolio");
                HttpURLConnection connection = (HttpURLConnection) url.openConnection();
                connection.setRequestMethod("PUT");
                connection.setRequestProperty("Content-Type", "application/json");

                String cookies = request.getHeader("Cookie");
                if (cookies != null) {
                    connection.setRequestProperty("Cookie", cookies);
                }

                connection.setDoOutput(true);

                JSONObject payload = new JSONObject();
                payload.put("githubUsername", newGithubUsername);
                payload.put("description", newDescription);
                payload.put("education", newEducation);
                payload.put("achievements", newAchievements);

                try (OutputStream os = connection.getOutputStream()) {
                    os.write(payload.toString().getBytes("UTF-8"));
                }

                int responseCode = connection.getResponseCode();
                if (responseCode == 200) {
                    alertMessage = "Portfolio updated successfully!";
                    alertType = "success";
                } else {
                    alertMessage = "Failed to update portfolio. HTTP Code: " + responseCode;
                    alertType = "danger";
                }
            } catch (Exception e) {
                alertMessage = "Error: " + e.getMessage();
                alertType = "danger";
            }
        }
    %>
    <form method="post" action="updateportfolio.jsp">
        <div class="form-group">
            <label for="githubUsername">GitHub Username</label>
            <input type="text" id="githubUsername" name="githubUsername" value="<%= githubUsername %>" required>
        </div>
        <div class="form-group">
            <label for="description">Portfolio Description</label>
            <textarea id="description" name="description" required><%= description %></textarea>
        </div>
        <div class="form-group">
            <label for="education">Education</label>
            <textarea id="education" name="education" required><%= education %></textarea>
        </div>
        <div class="form-group">
            <label for="achievements">Achievements</label>
            <textarea id="achievements" name="achievements" required><%= achievements %></textarea>
        </div>
        <button type="submit" class="btn">Update Portfolio</button>
    </form>

    <% if (alertMessage != null) { %>
    <div class="alert alert-<%= alertType %>"><%= alertMessage %></div>
    <% } %>
</div>
</body>
</html>