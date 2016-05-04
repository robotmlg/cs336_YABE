<!DOCTYPE html>
<%@ page language="java" %>
<%@ page import="java.sql.*" %>
 
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
  String proc_username = (String)session.getAttribute("username");
  
  int question_id = 0;
  Statement id_stmt = forum_conn.createStatement();
  String questionid_query = "SELECT MAX(q.question_id) FROM question q";
  ResultSet questionid_rs = id_stmt.executeQuery(questionid_query);
  
  if(questionid_rs.next()){
	  question_id = questionid_rs.getInt(1) + 1;
  }
  // if the table was empty and we don't have a Max ID, start at 1
  else{
	  question_id=1;
  }
  
  	int y = 0; 
	y = id_stmt.executeUpdate("INSERT INTO question (question_id,username,question) VALUES ('"
	+ question_id + "','" + proc_username + "','" + question + "');");

  
  	if (y < 1) {
      session.setAttribute("alert","Question not valid");
      session.setAttribute("alert_type","danger");
      %><%@ include file="questions.jsp" %><%
  	} else 
      session.setAttribute("alert","Question posted!");
      session.setAttribute("alert_type","success");
      %><%@ include file="answers.jsp" %><%

  
%>

