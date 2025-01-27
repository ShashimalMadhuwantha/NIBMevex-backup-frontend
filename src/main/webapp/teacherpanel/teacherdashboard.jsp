<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.net.*, java.io.*, org.json.*" %>
<jsp:include page="nav.jsp" />
<%
    // Fetch session details from the API
    String sessionDetails = null;
    String role = "Lecturer"; // Placeholder for role, replace with actual session role if available
    try {
        URL url = new URL("http://localhost:8080/api/v1/session/details");
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("GET");
        connection.setRequestProperty("Accept", "application/json");
        connection.setRequestProperty("Cookie", request.getHeader("Cookie")); // Forward session cookies

        int responseCode = connection.getResponseCode();
        if (responseCode == 200) {
            BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
            StringBuilder jsonResponse = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                jsonResponse.append(line);
            }
            reader.close();

            sessionDetails = jsonResponse.toString();
            // Parse JSON for role if needed
            // Example: JSONObject jsonObject = new JSONObject(sessionDetails);
            // role = jsonObject.optString("role", "Lecturer");
        } else {
            sessionDetails = "Failed to fetch session details. HTTP Code: " + responseCode;
        }
    } catch (Exception e) {
        sessionDetails = "Error fetching session details: " + e.getMessage();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - NIBMEVEX</title>
    <style>
        @keyframes fadeIn {
            from {
                opacity: 0;
            }
            to {
                opacity: 1;
            }
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(120deg, #007bff, #6610f2);
            color: #fff;
            animation: fadeIn 1.5s ease-in;
        }

        .main-icon {
            position: fixed;
            top: 80px;
            right: 20px;
            background-color: #ffc107;
            border-radius: 50%;
            width: 70px;
            height: 70px;
            display: flex;
            justify-content: center;
            align-items: center;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2);
            transition: transform 0.3s ease, background-color 0.3s ease;
            cursor: pointer;
            text-decoration: none;
        }

        .main-icon:hover {
            transform: scale(1.1);
            background-color: #e0a800;
        }

        .main-icon i {
            font-size: 2rem;
            color: #343a40;
        }

        .landing {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            text-align: center;
        }

        .landing h1 {
            font-size: 3rem;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
            margin-bottom: 20px;
        }

        .landing p {
            font-size: 1.5rem;
            margin-bottom: 30px;
            color: #f8f9fa;
        }

        .session-details {
            margin-top: 40px;
            text-align: left;
            background: rgba(255, 255, 255, 0.9);
            color: #343a40;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .session-details pre {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            color: #343a40;
            overflow-x: auto;
        }

        footer {
            text-align: center;
            padding: 15px;
            background-color: rgba(0, 0, 0, 0.8);
            color: white;
            position: absolute;
            width: 100%;
            bottom: 0;
        }
    </style>
</head>
<body>
<div class="landing">
    <div>
        <h1>Welcome, <%= role %>!</h1>
        <p>Your gateway to streamlined session management and communication.</p>
    </div>
</div>

<a href="./viewannouncement.jsp" class="main-icon">
    <i>&#128276;</i>
</a>

<div id="session-details" class="container">
    <div class="session-details">
        <h3>Session Details:</h3>
        <pre><%= sessionDetails %></pre>
    </div>
</div>

<footer>
    &copy; 2024 NIBMEVEX. All Rights Reserved.
</footer>
</body>
</html>
