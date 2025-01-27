<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.net.*, java.io.*, org.json.*" %>
<jsp:include page="nav.jsp" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Send Feedback</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 600px;
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
        .form-group textarea {
            width: 100%;
            height: 100px;
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
    <h3>Send Feedback</h3>
    <form method="post">
        <div class="form-group">
            <label for="description">Feedback Description</label>
            <textarea id="description" name="description" required></textarea>
        </div>
        <button type="submit" class="btn">Send Feedback</button>
    </form>
    <%
        String description = request.getParameter("description");
        String eid = request.getParameter("eid");
        String sid = request.getParameter("sid");

        if (description != null && eid != null && sid != null) {
            String feedbackResponse = null;
            try {
                URL url = new URL("http://localhost:8080/api/v1/lecturer/send");
                HttpURLConnection connection = (HttpURLConnection) url.openConnection();
                connection.setRequestMethod("POST");
                connection.setRequestProperty("Content-Type", "application/json");

                // Include the session cookie
                String cookies = request.getHeader("Cookie");
                if (cookies != null) {
                    connection.setRequestProperty("Cookie", cookies);
                }

                connection.setDoOutput(true);

                // Prepare the payload
                JSONObject payload = new JSONObject();
                payload.put("description", description);
                payload.put("eid", eid);
                payload.put("sid", sid);

                // Send the request
                try (OutputStream os = connection.getOutputStream()) {
                    os.write(payload.toString().getBytes("UTF-8"));
                }

                int responseCode = connection.getResponseCode();
                if (responseCode == 200) {
                    feedbackResponse = "<div class='alert alert-success'>Feedback sent successfully!</div>";
                } else {
                    feedbackResponse = "<div class='alert alert-danger'>Failed to send feedback. HTTP Code: " + responseCode + "</div>";
                }
            } catch (Exception e) {
                feedbackResponse = "<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>";
            }
            request.setAttribute("feedbackResponse", feedbackResponse);
        }
    %>
    <%= request.getAttribute("feedbackResponse") != null ? request.getAttribute("feedbackResponse") : "" %>
</div>
</body>
</html>
