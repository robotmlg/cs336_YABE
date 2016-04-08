<!DOCTYPE html>
<%@ page language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>


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
                <form method="post">       
                    <h2>Please login</h2>
                    <input type="text" name="username" placeholder="Username" required="" autofocus="" />
                    <input type="password" name="password" placeholder="Password" required=""/>      
                    <button class="btn btn-lg btn-primary btn-block" type="submit">Login</button>
                    <a href="register.jsp" class="button btn btn-lg btn-primary btn-block">Create Account</a>
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

  String username = request.getParameter("username");
  String password = request.getParameter("password");
  if(username != null && password != null){
    // get and hash from DB
    Statement stmt = conn.createStatement();
    String pw_query = "SELECT password_hash FROM users WHERE username=\'"+username+"\'";
    ResultSet rs = stmt.executeQuery(pw_query);
    String db_hash = null;

    try{
      db_hash = rs.getString("password_hash");
    }
    catch(SQLException se){
      if(username != null)
        out.print("<p>Username not found in database.</p>");
    }

    // check password
    if(db_hash != null){
      if(BCrypt.checkpw(password,db_hash)){
        out.print("<p>Login successful.</p>");
        // send some token for later auth? ...TBD
      }
      else{
        out.print("<p>Incorrect password.</p>");
      }
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
