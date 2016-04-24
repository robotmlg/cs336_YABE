<!DOCTYPE html>
<%@ page language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>


<% 
  Connection conn = null;
  try{
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    conn = DriverManager.getConnection("jdbc:mysql://localhost/yabe","yabe","yabe");
  }

  catch(Exception e){
    System.out.println("Could not connect to SQL server");
    e.printStackTrace();
  }

%>

<html>
    <head>
        <title>YABE</title>
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
        <div class="col-lg-12">
        <h1>YABE Admin Page</h1>
        <!-- check if user is admin -->
        <% if(session.getAttribute("loggedIn") != "true") {%>
        <p> Must be logged in as an administrator to view this page.<p>
        <% } else {
            
                String username = (String)session.getAttribute("username");
                Statement stmt = conn.createStatement();
                String admin_query = "SELECT COUNT(*) FROM admins WHERE username=\'"+username+"\'";
                ResultSet rs = stmt.executeQuery(admin_query);
                rs.next();

                if(rs.getInt(1) == 0){%>
        <p> Must be logged in as an administrator to view this page.<p>
              <% }
                else { %>
        <p> Welcome!<p>
              <% }
        } %>


        </div>
        </div>
        <%@include file="includes/footer.jsp" %>
        </div>
    </body>
</html>
