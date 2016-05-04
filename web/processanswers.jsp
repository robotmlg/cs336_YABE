<!DOCTYPE html>
<%@ page language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="mindrot.jbcrypt.BCrypt" %>
 
<% 
  Connection forum_conn = null;
  try{
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    forum_conn = DriverManager.getConnection("jdbc:mysql://localhost/yabe","yabe","yabe");
  }
  catch(Exception e){
    System.out.println("Could not connect to SQL server");
    e.printStackTrace();
  }
  
  String answer = request.getParameter("answer");
  String username = (String)session.getAttribute("username");
  Integer question_id = Integer.parseInt(request.getParameter("question_id"));
  
  
  int answer_id = 0;
  Statement id_stmt = forum_conn.createStatement();
  String questionid_query = "SELECT MAX(a.answer_id) FROM answer a";
  ResultSet questionid_rs = id_stmt.executeQuery(questionid_query);
  
  if(questionid_rs.next()){
	  answer_id = questionid_rs.getInt(1) + 1;
  }
  // if the table was empty and we don't have a Max ID, start at 1
  else{
	  answer_id=1;
  }
  
  int y = 0;
  if(request.getParameter("answer") != null){
	  y = id_stmt.executeUpdate("INSERT INTO answer(answer_id,question_id,username,answer) VALUES ('"
				+ answer_id + "','" + question_id + "','" + username + "','" + answer + "');");
  }
  
  if (y < 1) {
      session.setAttribute("alert","Question not valid");
      session.setAttribute("alert_type","danger");
      %><%@ include file="questions.jsp" %><%
  	} else{
      session.setAttribute("alert","Question posted!");
      session.setAttribute("alert_type","success");
      %><%@ include file="answers.jsp" %><%
 	 }
      %>
