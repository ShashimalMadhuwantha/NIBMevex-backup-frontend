<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.net.*, java.io.*, org.json.*" %>
<jsp:include page="nav.jsp" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Profile</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #e9ecef;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 700px;
            margin: 20px auto;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 20px;
            text-align: center;
        }
        .profile-header {
            margin-bottom: 20px;
            position: relative;
        }
        .edit-button {
            position: absolute;
            top: 10px;
            right: 10px;
        }
        .edit-button a {
            text-decoration: none;
            background-color: #007bff;
            color: white;
            padding: 5px 10px;
            border-radius: 5px;
            font-size: 0.9rem;
            transition: background-color 0.3s ease;
        }
        .edit-button a:hover {
            background-color: #0056b3;
        }
        .profile-picture {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            border: 4px solid #007bff;
            margin-bottom: 15px;
        }
        .profile-details {
            text-align: left;
            margin-top: 20px;
        }
        .profile-details h3 {
            border-bottom: 2px solid #007bff;
            padding-bottom: 5px;
            margin-bottom: 15px;
            color: #007bff;
        }
        .profile-details p {
            margin: 10px 0;
            font-size: 1rem;
        }
        .badge {
            display: inline-block;
            padding: 10px 20px;
            background-color: #28a745;
            color: white;
            border-radius: 5px;
            margin-top: 10px;
            font-size: 1rem;
        }
    </style>
</head>
<body>
<div class="container">
    <%
        String profileData = null;

        try {
            URL url = new URL("http://localhost:8080/api/v1/student/profile");
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
                profileData = jsonResponse.toString();
            } else {
                profileData = "Failed to fetch profile. HTTP Code: " + responseCode;
            }
        } catch (Exception e) {
            profileData = "Error: " + e.getMessage();
        }

        if (profileData != null && profileData.startsWith("{")) {
            JSONObject profile = new JSONObject(profileData);
            String sid = profile.optString("sid", "Unknown");
            String name = profile.optString("name", "Unknown");
            String email = profile.optString("email", "Unknown");
            String username = profile.optString("username", "Unknown");
            int age = profile.optInt("age", 0);
            String profilePic = profile.optString("profilePic", "null");
            String badgeId = profile.getJSONObject("badge").optString("bid", "");
            String badgeName = profile.getJSONObject("badge").optString("name", "No Badge");

            if (profilePic == null || profilePic.equalsIgnoreCase("null") || profilePic.isEmpty()) {
                profilePic = "https://ui-avatars.com/api/?name=" + name.replace(" ", "+") + "&background=random&color=fff";
            }
    %>
    <div class="profile-header">
        <img src="<%= profilePic %>" alt="Profile Picture" class="profile-picture">
        <h2><%= name %></h2>
        <div class="edit-button">
            <a href="editprofile.jsp?name=<%= name %>&email=<%= email %>&username=<%= username %>&age=<%= age %>&profilePic=<%= profilePic %>&badgeId=<%= badgeId %>">Edit Profile</a>
        </div>
    </div>
    <div class="profile-details">
        <h3>Details</h3>
        <p><strong>Email:</strong> <%= email %></p>
        <p><strong>Username:</strong> <%= username %></p>
        <p><strong>Age:</strong> <%= age %> years</p>
        <span class="badge">Badge: <%= badgeName %></span>
    </div>
    <%
    } else {
    %>
    <div style="color: red; text-align: center;">Error: <%= profileData %></div>
    <%
        }
    %>
</div>
</body>
</html>
