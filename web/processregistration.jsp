<%@page import="org.mindrot.jbcrypt.BCrypt"%>
<%@page import="java.sql.*"%>
<%
    Connection conn = null;
    try{
        Class.forName("com.mysql.jdbc.Driver").newInstance();
        conn = DriverManager.getConnection("jdbc:mysql://localhost/yabe","yabe","yabe");
    }

    catch(Exception e){
        out.print("<p>Could not connect to SQL server.</p>");
        e.printStackTrace();
    }
  
    String name = request.getParameter("name");
    int age;
    if (request.getParameter("age") != null) {
        age = Integer.parseInt(request.getParameter("age").trim());
    } else {
        age = 0;
    }
    String address = request.getParameter("address");
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String password_hash = BCrypt.hashpw(password,BCrypt.gensalt());
    if(name != null && age >= 13 && address != null && username != null && password != null){
        Statement stmt = conn.createStatement();
        String ins_query = "INSERT INTO users (username, password_hash, age, name, address) VALUES (\'" + username + "\', \'" + password_hash + "\', \'" + age + "\', \'" + name + "\', \'" + address + "\')";
        int res = stmt.executeUpdate(ins_query);
    
        if (res < 1) {
            out.print("<p>Registration failed.</p>");
        } else {
            out.print("<p>Registration successful.</p>");
        }
    } else {
        out.print("<p>Invalid registration fields. Please review your information and try again</p>");
    }
%>
