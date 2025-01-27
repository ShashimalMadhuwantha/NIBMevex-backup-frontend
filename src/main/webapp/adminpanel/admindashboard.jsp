<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.json.*" %>
<%@ include file="nav.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0px;
        }

        .container {
            max-width: 900px;
            margin: 0 auto;
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        h1 {
            text-align: center;
            color: #007bff;
            margin-bottom: 20px;
        }

        canvas {
            margin-top: 20px;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Admin Dashboard</h1>
    <canvas id="adminChart" width="400" height="200"></canvas>
    <%
        // API endpoint for the backend
        String backendUrl = "http://13.60.79.77:8081/api/v1/admin/state"; // Replace <backend-ip> with your BE IP
        JSONObject adminData = null;
        try {
            URL url = new URL(backendUrl);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");
            connection.setRequestProperty("Accept", "application/json");

            // Include cookies for cross-origin requests
            String cookies = request.getHeader("Cookie");
            if (cookies != null) {
                connection.setRequestProperty("Cookie", cookies);
            }

            int responseCode = connection.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
                StringBuilder jsonResponse = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    jsonResponse.append(line);
                }
                reader.close();
                adminData = new JSONObject(jsonResponse.toString());
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Failed to fetch data. HTTP Code: " + responseCode);
                return;
            }
            connection.disconnect();
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Error fetching data: " + e.getMessage());
            return;
        }
    %>
    <script>
        const adminData = <%= adminData != null ? adminData.toString() : "{}" %>;

        if (Object.keys(adminData).length > 0) {
            const ctx = document.getElementById('adminChart').getContext('2d');
            const chartData = {
                labels: ['Admins', 'Lecturers', 'Students', 'Events', 'Workshops', 'Announcements', 'Interviews', 'Feedback'],
                datasets: [{
                    label: 'Count',
                    data: [
                        adminData.totalAdmins || 0,
                        adminData.totalLecturers || 0,
                        adminData.totalStudents || 0,
                        adminData.totalEvents || 0,
                        adminData.totalWorkshops || 0,
                        adminData.totalAnnouncements || 0,
                        adminData.totalInterviews || 0,
                        adminData.totalFeedback || 0
                    ],
                    backgroundColor: [
                        '#007bff', '#28a745', '#ffc107', '#17a2b8',
                        '#fd7e14', '#6c757d', '#dc3545', '#6610f2'
                    ],
                    borderColor: [
                        '#0056b3', '#1e7e34', '#d39e00', '#117a8b',
                        '#e36209', '#545b62', '#c82333', '#520dc2'
                    ],
                    borderWidth: 1
                }]
            };

            new Chart(ctx, {
                type: 'bar',
                data: chartData,
                options: {
                    responsive: true,
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    },
                    plugins: {
                        legend: {
                            position: 'top'
                        }
                    }
                }
            });
        } else {
            document.querySelector('.container').innerHTML +=
                '<p style="color: red; text-align: center;">Error loading chart data. Please try again later.</p>';
        }
    </script>
</div>
</body>
</html>