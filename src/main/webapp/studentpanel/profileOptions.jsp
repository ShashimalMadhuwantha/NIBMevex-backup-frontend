<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="nav.jsp" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile Options</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            color: #343a40;
        }

        .container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 20px;
        }

        h1 {
            text-align: center;
            color: #007bff;
            margin-bottom: 30px;
        }

        .options {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            justify-content: center;
        }

        .option-card {
            background-color: #ffffff;
            border: 2px solid #007bff;
            border-radius: 10px;
            box-shadow: 0 8px 15px rgba(0, 0, 0, 0.1);
            width: 280px;
            text-align: center;
            padding: 20px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            cursor: pointer;
        }

        .option-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 12px 20px rgba(0, 0, 0, 0.2);
        }

        .option-card h2 {
            font-size: 1.5rem;
            color: #007bff;
            margin-bottom: 10px;
        }

        .option-card p {
            font-size: 1rem;
            color: #6c757d;
            margin-bottom: 20px;
        }

        .option-card a {
            text-decoration: none;
            display: inline-block;
            padding: 12px 25px;
            border-radius: 5px;
            background-color: #007bff;
            color: #ffffff;
            font-weight: bold;
            transition: background 0.3s ease;
        }

        .option-card a:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>What Would You Like to View?</h1>
    <div class="options">
        <div class="option-card">
            <h2>Career Portfolio</h2>
            <p>Explore your career portfolio including achievements, skills, and work history.</p>
            <a href="./viewportfolio.jsp">View Career Portfolio</a>
        </div>
        <div class="option-card">
            <h2>Personal Profile</h2>
            <p>Update or view your personal profile details like contact and basic information.</p>
            <a href="./viewprofile.jsp">View Personal Profile</a>
        </div>
    </div>
</div>
</body>
</html>
