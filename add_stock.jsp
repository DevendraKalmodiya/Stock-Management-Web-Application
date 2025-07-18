<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
    String message = "";

    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String itemName = request.getParameter("item_name");
        String quantityStr = request.getParameter("quantity");

        if (itemName != null && quantityStr != null && !itemName.isEmpty() && !quantityStr.isEmpty()) {
            try {
                int quantity = Integer.parseInt(quantityStr);

                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/QuickStock", "root", "@Devendra1");

                PreparedStatement ps = conn.prepareStatement("INSERT INTO stock (item_name, quantity, username) VALUES (?, ?, ?)");
                ps.setString(1, itemName);
                ps.setInt(2, quantity);
                ps.setString(3, username);
                ps.executeUpdate();

                message = "Stock added successfully.";

                ps.close();
                conn.close();
            } catch (NumberFormatException e) {
                message = "Quantity must be a number.";
            } catch (Exception e) {
                message = "Error: " + e.getMessage();
            }
        } else {
            message = "Please fill all fields.";
        }
    }
%>

<html>
<head>
    <title>Add Stock - QuickStock</title>
    <style>
        body { font-family: Arial; background: #f8f9fa; padding: 20px; }
        .container { max-width: 500px; margin: auto; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        input, button { width: 100%; padding: 10px; margin: 10px 0; border-radius: 5px; border: 1px solid #ccc; }
        button { background: #007bff; color: white; border: none; cursor: pointer; }
        .msg { color: green; margin-top: 10px; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Add Stock</h2>
        <form method="post">
            <input type="text" name="item_name" placeholder="Item Name" required />
            <input type="number" name="quantity" placeholder="Quantity" required />
            <button type="submit">Add</button>
        </form>
        <div class="msg"><%= message %></div>
        <p><a href="user_home.jsp">Back to Home</a></p>
    </div>
</body>
</html>
