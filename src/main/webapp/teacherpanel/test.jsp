<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.net.*, java.io.*, org.json.*" %>
<jsp:include page="nav.jsp" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assign Students to Interview</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }
        .container {
            padding: 20px;
        }
        .card {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-bottom: 20px;
        }
        .card h4 {
            margin-bottom: 20px;
        }
        .btn {
            padding: 10px 15px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            margin-top: 10px;
            font-size: 1rem;
        }
        .btn:hover {
            background-color: #0056b3;
        }
        .error {
            color: red;
            text-align: center;
            margin-top: 20px;
        }
        .success {
            color: green;
            text-align: center;
            margin-top: 20px;
        }
    </style>
</head>
<body>

<div class="container">
    <h3>Assign Students to Interview</h3>

    <%
        String eid = request.getParameter("eid");
        String studentIds = request.getParameter("studentIds");

        // Log the parameters for debugging
        System.out.println("Received eid: " + eid);
        System.out.println("Received studentIds: " + studentIds);
    %>

    <div class="card">
        <h4>Submit Data for Assignment</h4>
        <form id="assignForm">
            <div>
                <label for="eid">Event ID:</label>
                <input type="text" id="eid" name="eid" value="<%= eid %>" required>
            </div>
            <div>
                <label for="studentIds">Student IDs (Comma Separated):</label>
                <input type="text" id="studentIds" name="studentIds" value="<%= studentIds %>" required>
            </div>

            <button class="btn" type="submit">Assign Students</button>
        </form>
    </div>

    <div id="message" class="error"></div> <!-- For error messages -->
    <div id="successMessage" class="success"></div> <!-- For success messages -->
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('assignForm');

        form.addEventListener('submit', async function(e) {
            e.preventDefault(); // Prevent form submission

            // Get values from the form
            const eid = document.getElementById('eid').value;
            const studentIdsString = document.getElementById('studentIds').value;

            // Split the student IDs into an array
            const studentIds = studentIdsString.split(',').map(id => id.trim());

            if (studentIds.length === 0) {
                document.getElementById('message').textContent = "Please enter at least one student ID.";
                return;
            }

            // Create the payload to send
            const payload = {
                eid: eid,
                studentIds: studentIds
            };

            try {
                // Send the POST request
                const response = await fetch('http://localhost:8080/lecturer/assign/interviews', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify(payload),
                    credentials: 'include' // Ensure cookies are sent with the request
                });

                const contentType = response.headers.get("Content-Type");
                let responseBody = await response.text(); // Get response as text

                if (contentType && contentType.includes("application/json")) {
                    // If the response is JSON, parse it
                    responseBody = JSON.parse(responseBody);
                }

                // Handle the response
                if (response.ok) {
                    alert("Students assigned successfully!");
                    document.getElementById('message').textContent = ''; // Clear error message
                    document.getElementById('successMessage').textContent = 'Students assigned successfully!';
                } else {
                    // If it's not JSON, treat it as a plain text error message
                    alert("Error assigning students: " + (responseBody.message || responseBody || "Unknown error"));
                    document.getElementById('message').textContent = responseBody.message || responseBody;
                    document.getElementById('successMessage').textContent = ''; // Clear success message
                }
            } catch (error) {
                alert("Error while assigning students: " + error.message);
                document.getElementById('message').textContent = error.message;
            }
        });
    });
</script>

</body>
</html>
