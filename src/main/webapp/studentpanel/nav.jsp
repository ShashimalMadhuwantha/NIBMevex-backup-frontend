<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Navigation</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .navbar {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .navbar a {
            color: white;
            text-decoration: none;
            margin: 0 15px;
            font-size: 1rem;
            transition: color 0.3s;
        }
        .navbar a:hover {
            color: #d4d4d4;
        }
        .navbar .brand {
            font-size: 1.5rem;
            font-weight: bold;
        }
        .navbar .nav-links {
            display: flex;
            align-items: center;
        }
    </style>
</head>
<body>
<div class="navbar">
    <div class="brand">Student Panel</div>
    <div class="nav-links">
        <a href="./studentdashboard.jsp">Home</a>
        <a href="./viewOptions.jsp">Events</a>
        <a href="./profileOptions.jsp">Profiles</a>
        <a href="./logout.jsp">LogOut</a>
    </div>
</div>
</body>
</html>
