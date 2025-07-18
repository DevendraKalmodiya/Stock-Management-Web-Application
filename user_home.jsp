<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String message = "";
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>

<html>
<head>
    <title>QuickStock - User Home</title>
    <style>
        body { font-family: Arial; background: #f5f5f5; padding: 20px; }
        .container { max-width: 800px; margin: auto; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 6px rgba(0,0,0,0.2); }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 10px; border: 1px solid #ccc; text-align: center; }
        th { background: #007bff; color: white; }
        a.button { display: inline-block; padding: 10px 20px; margin-top: 10px; background: #28a745; color: white; text-decoration: none; border-radius: 5px; }
        .logout { float: right; background: #dc3545; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Welcome, <%= username %></h2>
        <a href="add_stock.jsp" class="button">Add Stock</a>
        <a href="logout.jsp" class="button logout">Logout</a>

        <h3>Your Stock</h3>
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/QuickStock", "root", "@Devendra1");

                ps = conn.prepareStatement("SELECT item_name, quantity FROM stock WHERE username = ?");
                ps.setString(1, username);
                rs = ps.executeQuery();
        %>
        <table>
            <tr>
                <th>Item Name</th>
                <th>Quantity</th>
            </tr>
            <%
                while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getString("item_name") %></td>
                <td><%= rs.getInt("quantity") %></td>
            </tr>
            <% } %>
        </table>
        <%
            } catch (Exception e) {
                out.println("Error: " + e.getMessage());
            } finally {
                try { if (rs != null) rs.close(); } catch (Exception e) {}
                try { if (ps != null) ps.close(); } catch (Exception e) {}
                try { if (conn != null) conn.close(); } catch (Exception e) {}
            }
        %>
    </div>
</body>
</html>
