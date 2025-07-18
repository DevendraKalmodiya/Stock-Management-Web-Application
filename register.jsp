<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
    String message = "";

    if("POST".equalsIgnoreCase(request.getMethod())) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if(username != null && password != null && !username.isEmpty() && !password.isEmpty()) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/QuickStock", "root", "@Devendra1");

                PreparedStatement check = conn.prepareStatement("SELECT * FROM users WHERE username = ?");
                check.setString(1, username);
                ResultSet rs = check.executeQuery();

                if(rs.next()) {
                    message = "Username already exists!";
                } else {
                    PreparedStatement ps = conn.prepareStatement("INSERT INTO users (username, password) VALUES (?, ?)");
                    ps.setString(1, username);
                    ps.setString(2, password);
                    ps.executeUpdate();
                    message = "Registered successfully. <a href='login.jsp'>Login now</a>.";
                }

                rs.close();
                check.close();
                conn.close();
            } catch(Exception e) {
                message = "Error: " + e.getMessage();
            }
        } else {
            message = "Please fill all fields.";
        }
    }
%>

<html>
<head>
    <title>Register - QuickStock</title>
     <link rel="stylesheet" href="registerStyle.css">
    <style>
        body { font-family: Arial; background: #eef; padding: 20px; }
        .form-box { background: white; padding: 20px; max-width: 400px; margin: auto; border-radius: 10px; box-shadow: 0 2px 6px rgba(0,0,0,0.2); }
        input { width: 100%; padding: 10px; margin: 10px 0; border-radius: 5px; border: 1px solid #ccc; }
        button { padding: 10px 20px; background: #28a745; color: white; border: none; border-radius: 5px; cursor: pointer; }
        .message { margin-top: 10px; color: #d00; }
    </style>
</head>
<body>
    <div class="form-box">
        <h2>Register</h2>
        <form method="post">
            <input type="text" name="username" placeholder="Username" required />
            <input type="password" name="password" placeholder="Password" required />
            <button type="submit">Register</button>
        </form>
        <div class="message"><%= message %></div>
        <p>Already have an account? <a href="login.jsp">Login</a></p>
    </div>
</body>
</html>
