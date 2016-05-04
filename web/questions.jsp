<!DOCTYPE html>
<%@ page language="java" %>
<%@ page import="java.sql.*" %>
    
<html>
    <head>
        <title>Ask Questions Page</title>
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
        <%
        Connection auction_conn = null;
        try{
          Class.forName("com.mysql.jdbc.Driver").newInstance();
          auction_conn = DriverManager.getConnection("jdbc:mysql://localhost/yabe","yabe","yabe");
        }

        catch(Exception e){
          System.out.println("Could not connect to SQL server");
          e.printStackTrace();
        }
        %>
    <body>
    
        <%@include file="includes/navbar.jsp" %>
        <div class="container">
        <div class="row">
        <% if(session.getAttribute("loggedIn") == "true"){%>
        <div class="col-md-6">
        <div class="jumbotron">
        <h2>Have Questions? Ask them here!</h2>
        
        
        <form action="processquestion.jsp" method="post">       
                   	 	<textarea name="question" placeholder = "Enter Your Question Here!" required autofocus rows="10" cols="40"></textarea>                      
                    <button class="btn btn-lg btn-primary btn-block" type="submit">Submit</button>
                    <a href="answers.jsp" class="button btn btn-lg btn-primary btn-block">Check out frequently asked questions!</a>
        </form>
        </div>
        </div>
        <%}%>
        
        <%
        String username = (String)session.getAttribute("username");
        Statement stmt = auction_conn.createStatement();
        String cr_query = "SELECT COUNT(*) FROM cust_reps WHERE username=\'"+username+"\'";
        ResultSet rs = stmt.executeQuery(cr_query);
        rs.next();
        if(rs.getInt(1) != 0){%>
        <div class="col-md-6">
        <div class="jumbotron">
        <h2>Customer reps: answer question here</h2>
		
		<form action="processanswers.jsp" method="post">       
                     	<input type="number" name="question_id" placeholder="Question ID" required autofocus />     
                        <br/>
                   	 	<textarea name="answers" placeholder = "Enter your answer here!" required autofocus rows="10" cols="40"></textarea>                      
                    <button class="btn btn-lg btn-primary btn-block" type="submit">Submit</button>
        </form>
        </div>
        </div>
        
               <% }%>
               
        
        
        
        </div>
        <%@include file="includes/footer.jsp" %>
        </div>
    </body>
</html>
