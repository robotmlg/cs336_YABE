<%-- 
    Document   : register
    Created on : Apr 8, 2016, 2:21:52 PM
    Author     : 
--%>

<!DOCTYPE html>
<%@ page language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>


<html>
    <head>
        <title>YABE Registration</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="css/bootstrap.css" rel="stylesheet">
        <script src="js/jquery-1.10.2.min.js"></script>
        <script src="js/bootstrap.js"></script>
    </head>
    <body>
        <div class="container">
        <div class="row">
            <div class="col-md-4">
                <form method="post">       
                    <h2>Please register your account</h2>
                    <input type="text" name="username" placeholder="Username" required autofocus />
                    <input type="password" name="password" placeholder="Password" required />
                    <input type="text" name="name" placeholder="Name" required autofocus />
                    <input type="text" name="age" placeholder="Age" required autofocus onkeypress='return event.charCode >= 48 && event.charCode <= 57' />
                    <input type="text" name="address" placeholder="Address" required autofocus />
                    <button class="btn btn-lg btn-primary btn-block" type="submit" onclick="regscript">Register</button>
                    <a href="index.jsp" class="button btn btn-lg btn-primary btn-block">Already have an account?</a>
                </form>
<%
  Connection conn = null;
  try{
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    conn = DriverManager.getConnection("jdbc:mysql://localhost/YABE","test_user","test_password");
  }

  catch(Exception e){
    System.out.println("Could not connect to SQL server");
    e.printStackTrace();
  }
  
  String name = request.getParameter("name");
  int age = Integer.parseInt(request.getParameter("age"));
  String address = request.getParameter("address");
  String username = request.getParameter("username");
  String password = request.getParameter("password");
  int password_hash = 0;
  int password_salt = 0;
  if(name != null && age >= 13 && address != null && username != null && password != null){
    // get and hash from DB
    Statement stmt = conn.createStatement();
    String ins_query = "INSERT INTO users (username, password_hash, password_salt, age, name, address) VALUES (\'" + username + "\', \'" + password_hash + "\', \'" + password_salt + "\', \'" + age + "\', \'" + name + "\', \'" + address + "\')";
    int res = stmt.executeUpdate(ins_query);
    
    if (res < 1) {
        out.print("<p>Registration failed.</p>");
    } else {
        out.print("<p>Registration successful.</p>");
    }
  }
  else{
  }
%>
            </div>   
        </div>
        </div>
    </body>
</html>
