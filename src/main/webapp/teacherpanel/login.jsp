<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(120deg, #84fab0 0%, #8fd3f4 100%);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 0;
        }
        .login-container {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
            width: 300px;
        }
        .login-container h2 {
            margin-bottom: 20px;
            font-size: 1.5rem;
            color: #007bff;
            text-align: center;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            font-weight: bold;
            display: block;
        }
        .form-group input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .btn {
            width: 100%;
            padding: 10px;
            background: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .btn:hover {
            background: #0056b3;
        }
        .result {
            margin-top: 20px;
            font-size: 1rem;
        }
    </style>
</head>
<body>
<div class="login-container">
    <h2>Login</h2>
    <form id="loginForm">
        <div class="form-group">
            <label for="username">Username</label>
            <input type="text" id="username" name="username" required>
        </div>
        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" required>
        </div>
        <button type="button" class="btn" id="loginButton">Login</button>
        <div class="result" id="result"></div>
    </form>
</div>

<script>
    const loginEndpoint = "http://localhost:8080/api/v1/lecturer/login";
    const sessionDetailsEndpoint = "http://localhost:8080/api/session/details";

    // Login Function
    async function login() {
        const username = document.getElementById("username").value;
        const password = document.getElementById("password").value;

        try {
            const response = await fetch(loginEndpoint, {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({ username, password }),
                credentials: "include" // Include cookies in the request
            });

            if (response.ok) {
                document.getElementById("result").innerText = "Login successful! Redirecting...";
                setTimeout(() => {
                    window.location.href = "teacherdashboard.jsp"; // Redirect after successful login
                }, 2000);
            } else {
                const error = await response.text();
                document.getElementById("result").innerText = "Login failed: " + error;
            }
        } catch (error) {
            document.getElementById("result").innerText = "Error during login: " + error.message;
        }
    }

    // Attach event listener to login button
    document.getElementById("loginButton").addEventListener("click", login);
</script>
</body>
</html>
