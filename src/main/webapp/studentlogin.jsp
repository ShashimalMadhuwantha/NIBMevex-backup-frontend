<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Login</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(120deg, #a18cd1 0%, #fbc2eb 100%);
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
            color: #5a5a5a;
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
            background: #5a5a5a;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .btn:hover {
            background: #3e3e3e;
        }
        .result {
            margin-top: 20px;
            font-size: 1rem;
        }
    </style>
</head>
<body>
<div class="login-container">
    <h2>Student Login</h2>
    <form id="studentLoginForm">
        <div class="form-group">
            <label for="username">Username</label>
            <input type="text" id="username" name="username" required>
        </div>
        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" required>
        </div>
        <button type="button" class="btn" id="studentLoginButton">Login</button>
        <div class="result" id="result"></div>
    </form>
</div>

<script>
    const studentLoginEndpoint = "http://localhost:8080/api/v1/student/login";

    // Student Login Function
    async function studentLogin() {
        const username = document.getElementById("username").value;
        const password = document.getElementById("password").value;

        try {
            const response = await fetch(studentLoginEndpoint, {
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
                    window.location.href = "studentpanel/studentdashboard.jsp"; // Redirect after successful login
                }, 2000);
            } else {
                const error = await response.text();
                document.getElementById("result").innerText = "Login failed: " + error;
            }
        } catch (error) {
            document.getElementById("result").innerText = "Error during login: " + error.message;
        }
    }

    // Attach event listener to student login button
    document.getElementById("studentLoginButton").addEventListener("click", studentLogin);
</script>
</body>
</html>
