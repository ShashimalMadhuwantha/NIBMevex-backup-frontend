<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.*, java.net.*, org.json.JSONObject" %>
<%
    try {
        // Define the API endpoint
        URL url = new URL("http://localhost:8080/api/v1/session/details");

        // Open the connection
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("GET");
        connection.setRequestProperty("Accept", "application/json");

        // Forward session cookies from the request
        String cookies = request.getHeader("Cookie");
        if (cookies != null) {
            connection.setRequestProperty("Cookie", cookies);
        }

        // Check the response code
        int responseCode = connection.getResponseCode();
        if (responseCode == 200) {
            // Read the response
            BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
            StringBuilder responseBuilder = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                responseBuilder.append(line);
            }
            reader.close();

            // Parse the JSON response
            JSONObject sessionJson = new JSONObject(responseBuilder.toString());
            String id = sessionJson.optString("id", null);

            // Validate the ID
            if (id != null && !id.matches(".*[A-Za-z].*")) {
                // Set the ID in the session
                session.setAttribute("userID", id);

                // Redirect to the admin dashboard
                response.sendRedirect("adminpanel/admindashboard.jsp");
            } else {
                response.sendRedirect("logout.jsp");
            }
        } else {
            response.sendRedirect("logout.jsp");
        }
    } catch (Exception e) {
        response.sendRedirect("logout.jsp");
    }
%>
