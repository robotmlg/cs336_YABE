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
        <style>
        body {
            padding-top: 60px; /* 60px to make the container go all the way to the bottom of the topbar */
            padding-bottom: 40px;
        }
        </style>
        <script src="js/jquery-1.10.2.min.js"></script>
        <script src="js/bootstrap.js"></script>
    </head>
    <body>
        <%@include file="includes/navbar.jsp" %>
        <div class="container">
        <div class="row">
            <div class="col-md-4">
                <form method="post">       
                    <h2>Please register your account</h2>
                    <p>
                      <input type="text" name="username" placeholder="Username" required autofocus />
                      <input type="password" name="password" placeholder="Password" required />
                    </p>
                    <p>
                      <input type="text" name="name" placeholder="Name" required autofocus />
                    </p>
                    <p>
                      <input type="text" name="age" placeholder="Age" required autofocus onkeypress='return event.charCode >= 48 && event.charCode <= 57' />
                    </p>
                    <p>
                      <input type="text" name="address" placeholder="Address" required autofocus />
                    </p>
                    <button class="btn btn-lg btn-primary btn-block" type="submit">Submit</button>
                    <a href="login.jsp" class="button btn btn-lg btn-primary btn-block">Already have an account?</a>
                </form>
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
  }
  else{
  }
%>
            </div>   
        </div>
        <%@include file="includes/footer.jsp" %>
        </div>
    </body>
</html>
