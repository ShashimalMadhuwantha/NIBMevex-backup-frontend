<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.net.*, java.io.*, org.json.*" %>
<jsp:include page="nav.jsp" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Profile</title>
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
        .form-group input {
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
    <h3>Update Profile</h3>
    <%
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = ""; // Password is not passed in URL for security reasons
        String profilePic = request.getParameter("profilePic");
        int age = Integer.parseInt(request.getParameter("age"));
        String badge = request.getParameter("badgeId");

        String alertMessage = null;
        String alertType = null;

        if ("POST".equalsIgnoreCase(request.getMethod())) {
            name = request.getParameter("name");
            email = request.getParameter("email");
            username = request.getParameter("username");
            password = request.getParameter("password");
            profilePic = request.getParameter("profilePic");
            age = Integer.parseInt(request.getParameter("age"));
            badge = request.getParameter("badge");

            try {
                URL url = new URL("http://localhost:8080/api/v1/students/profile");
                HttpURLConnection connection = (HttpURLConnection) url.openConnection();
                connection.setRequestMethod("PUT");
                connection.setRequestProperty("Content-Type", "application/json");

                String cookies = request.getHeader("Cookie");
                if (cookies != null) {
                    connection.setRequestProperty("Cookie", cookies);
                }

                connection.setDoOutput(true);

                JSONObject payload = new JSONObject();
                payload.put("name", name);
                payload.put("email", email);
                payload.put("username", username);
                payload.put("password", password);
                payload.put("profilePic", profilePic.equals("null") ? JSONObject.NULL : profilePic);
                payload.put("age", age);
                JSONObject badgeObj = new JSONObject();
                badgeObj.put("bid", badge);
                payload.put("badge", badgeObj);

                try (OutputStream os = connection.getOutputStream()) {
                    os.write(payload.toString().getBytes("UTF-8"));
                }

                int responseCode = connection.getResponseCode();
                if (responseCode == 200) {
                    alertMessage = "Profile updated successfully!";
                    alertType = "success";
                } else {
                    alertMessage = "Failed to update profile. HTTP Code: " + responseCode;
                    alertType = "danger";
                }
            } catch (Exception e) {
                alertMessage = "Error: " + e.getMessage();
                alertType = "danger";
            }
        }
    %>
    <form method="post" action="editprofile.jsp">
        <div class="form-group">
            <label for="name">Name</label>
            <input type="text" id="name" name="name" value="<%= name %>" required>
        </div>
        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" id="email" name="email" value="<%= email %>" required>
        </div>
        <div class="form-group">
            <label for="username">Username</label>
            <input type="text" id="username" name="username" value="<%= username %>" required>
        </div>
        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" value="<%= password %>" required>
        </div>
        <div class="form-group">
            <label for="profilePic">Profile Picture</label>
            <input type="text" id="profilePic" name="profilePic" value="<%= profilePic %>">
        </div>
        <div class="form-group">
            <label for="age">Age</label>
            <input type="number" id="age" name="age" value="<%= age %>" required>
        </div>
        <div class="form-group">
            <label for="badge">Badge ID</label>
            <input type="text" id="badge" name="badge" value="<%= badge %>" required>
        </div>
        <button type="submit" class="btn">Update Profile</button>
    </form>

    <% if (alertMessage != null) { %>
    <div class="alert alert-<%= alertType %>"><%= alertMessage %></div>
    <% } %>
</div>
</body>
</html>
