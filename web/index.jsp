<!DOCTYPE html>
<%@ page language="java" %>
<%@ page import="java.sql.*" %>


<html>
    <head>
        <title>YABE Login</title>
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
                <form>       
                    <h2>Please login</h2>
                    <input type="text" name="username" placeholder="Username" required="" autofocus="" />
                    <input type="password" name="password" placeholder="Password" required=""/>      
                    <button class="btn btn-lg btn-primary btn-block" type="submit">Login</button>
                    <a href="register.jsp" class="button btn btn-lg btn-primary btn-block">Create Account</a>
                </form>
<%
  try{
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost","test_user","test_password");
  }

  catch(Exception e){
    e.printStackTrace();
  }

  String username = request.getParameter("username");
  String password = request.getParameter("password");
  if(username != null && password != null){
    // get salt from DB
    PreparedStatement getSalt = conn.createStatement();
    String salt_query = "SELECT password_hash FROM users WHERE username=\'"+username+"\'";
    ResultSet rs = stmt.executeQuery(salt_query);
    
    // append salt to password
    // hash password
    // check hash against DB
    // confirm logged in ...how do we do this?
  }
  else{
    // show missing data text
  }

%>
            </div>   
        </div>
        </div>
    </body>
</html>
