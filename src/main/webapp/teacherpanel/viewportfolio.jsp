<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.net.*, java.io.*, org.json.*" %>
<jsp:include page="nav.jsp" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Portfolio</title>
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
        .profile-header {
            text-align: center;
            margin-bottom: 20px;
        }
        .profile-picture {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            border: 4px solid #007bff;
            margin-bottom: 15px;
        }
        .profile-header h2 {
            margin: 0;
            font-size: 1.8rem;
            color: #007bff;
        }
        .profile-header p {
            margin: 5px 0;
            font-size: 1rem;
            color: #555;
        }
        .profile-content {
            margin-top: 20px;
        }
        .profile-content h3 {
            border-bottom: 2px solid #007bff;
            padding-bottom: 5px;
            margin-bottom: 15px;
            color: #007bff;
        }
        .profile-content p {
            margin: 5px 0;
            font-size: 1rem;
        }
        .profile-content strong {
            color: #333;
        }
    </style>
</head>
<body>
<div class="container">
    <%
        String studentId = request.getParameter("studentid");
        String portfolioData = null;

        if (studentId != null) {
            try {
                // Connect to the backend API
                URL url = new URL("http://localhost:8080/api/v1/students/portfolio/" + studentId);
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
                    portfolioData = jsonResponse.toString();
                } else {
                    portfolioData = "Failed to fetch portfolio. HTTP Code: " + responseCode;
                }
            } catch (Exception e) {
                portfolioData = "Error: " + e.getMessage();
            }
        }

        if (portfolioData != null && portfolioData.startsWith("{")) {
            try {
                JSONObject portfolio = new JSONObject(portfolioData);

                String studentName = portfolio.optString("studentName", "Unknown");
                String studentEmail = portfolio.optString("studentEmail", "Unknown");
                int studentAge = portfolio.optInt("studentAge", 0);
                String portfolioGithubUsername = portfolio.optString("portfolioGithubUsername", "Unknown");
                String portfolioAchievements = portfolio.optString("portfolioAchievements", "None");
                String portfolioDescription = portfolio.optString("portfolioDescription", "No description provided");
                String portfolioEducation = portfolio.optString("portfolioEducation", "No education details");
                String profilePictureUrl = "https://github.com/" + portfolioGithubUsername + ".png";
    %>
    <div class="profile-header">
        <img src="<%= profilePictureUrl %>" alt="Profile Picture" class="profile-picture" onerror="this.src='default-profile.png';">
        <h2><%= studentName %></h2>
        <p><strong>Email:</strong> <%= studentEmail %></p>
        <p><strong>Age:</strong> <%= studentAge %> years</p>
    </div>
    <div class="profile-content">
        <h3>Achievements</h3>
        <p><%= portfolioAchievements %></p>

        <h3>Portfolio Description</h3>
        <p><%= portfolioDescription %></p>

        <h3>Education</h3>
        <p><%= portfolioEducation %></p>
    </div>
    <%
    } catch (Exception e) {
    %>
    <div style="color: red; text-align: center;">Error parsing portfolio data: <%= e.getMessage() %></div>
    <%
        }
    } else {
    %>
    <div style="color: red; text-align: center;">Error: <%= portfolioData %></div>
    <%
        }
    %>
</div>
</body>
</html>
