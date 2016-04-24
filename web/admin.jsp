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
        <title>YABE Admin Page</title>
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
                else { 

                    if(session.getAttribute("alert") != null){%>
        <div class="alert alert-<%= session.getAttribute("alert_type")%>" role="alert"><%= session.getAttribute("alert") %></div>
                    <%
                    session.setAttribute("alert",null);
                    }
        %>

        <div class="jumbotron">
        <h2>Generate Reports</h2>
        </div>

        <div class="jumbotron">
        <h2>Create Customer Representatives</h2>
        <p>Enter a username to make that account a customer representative</p>
        <form action="makeRep.jsp" method="put">
            <input type="text" name="username" placeholder="Username" required />
            <button type="submit" class="btn btn-primary btn-lg">Create rep</button>
        </form>
        </div>

        <div class="jumbotron">
        <h2>Delete YABE</h2>
        <p>Press this button to erase the YABE database (except for your admin
        account) 
        </p>
        <button type="button" class="btn btn-danger btn-lg" data-toggle="modal" data-target="#deleteModal">Delete DB</button>
        <div class="modal fade" id="deleteModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
        <div class="modal-content">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <h4 class="modal-title" id="myModalLabel">Are you sure you want to delete all info from the database?</h4>
        </div>
        <div class="modal-footer">
            <form action="deleteYABE.jsp">
            <button type="button" class="btn btn-primary" data-dismiss="modal">No, go back</button>
            <button type="submit" class="btn btn-danger">Yes, nuke it</button>
            </form>
        </div>
        </div>
        </div>
        </div>
        </div>
              <% }
        } %>


        </div>
        </div>
        <%@include file="includes/footer.jsp" %>
        </div>
    </body>
</html>
