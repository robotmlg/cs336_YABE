<!DOCTYPE html>
<%@ page language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="mindrot.jbcrypt.BCrypt" %>
 
<% 
  Connection forum_conn = null;
  try{
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    forum_conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/yabe?autoReconnect=true&useSSL=false","yabe","yabe");
  }
  catch(Exception e){
    System.out.println("Could not connect to SQL server");
    e.printStackTrace();
  }
  
  String question = request.getParameter("question");
  String username = (String)session.getAttribute("username");
  
  int question_id = 0;
  Statement id_stmt = forum_conn.createStatement();
  String questionid_query = "SELECT MAX(q.question_id) FROM questions q";
  ResultSet questionid_rs = id_stmt.executeQuery(questionid_query);
  
  if(questionid_rs.next()){
	  question_id = questionid_rs.getInt(1) + 1;
  }
  // if the table was empty and we don't have a Max ID, start at 1
  else{
	  question_id=1;
  }
  
  	int y = 0; 
	y = id_stmt.executeUpdate("INSERT INTO question(question_id,username,question) VALUES ('"
	+ question_id + "','" + username + "','" + question + "');");

  
  	if (y < 1) {
      session.setAttribute("alert","Question not valid");
      session.setAttribute("alert_type","danger");
      %><%@ include file="questions.jsp" %><%
  	} else 
      session.setAttribute("alert","Question posted!");
      session.setAttribute("alert_type","success");
      %><%@ include file="answers.jsp" %><%

  
%>

<html>
    <head>
        <title>Question/Answer</title>
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
        <h1>Frequently Answered Questions!</h1>
        </div>
        </div>
        <%@include file="includes/footer.jsp" %>
        </div>
    </body>
</html>
