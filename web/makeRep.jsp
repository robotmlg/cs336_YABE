<!DOCTYPE html>
<%@ page language="java" %>
<%@ page import="java.sql.*" %>


<% 
Connection rep_conn = null;
try{
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    rep_conn = DriverManager.getConnection("jdbc:mysql://localhost/yabe","yabe","yabe");
}

catch(Exception e){
    System.out.println("Could not connect to SQL server");
    e.printStackTrace();
}


if(session.getAttribute("loggedIn") == "true") {

    String username = (String)session.getAttribute("username");
    Statement stmt = rep_conn.createStatement();
    String admin_query = "SELECT COUNT(*) FROM admins WHERE username=\'"+username+"\'";
    ResultSet rs = stmt.executeQuery(admin_query);
    rs.next();

    if(rs.getInt(1) > 0){
        // successfully verified admin login, now make a representative
        if(request.getParameter("username") != null){
            String rep_username = (String)request.getParameter("username");

            String user_query = "SELECT COUNT(*) FROM users WHERE username=\'"+rep_username+"\'";
            rs = stmt.executeQuery(user_query);
            rs.next();

            if(rs.getInt(1) > 0){ // the user exists
                stmt.executeUpdate("INSERT INTO cust_reps (username) VALUES (\'"+rep_username+"\')");
                session.setAttribute("alert","User "+rep_username+" made customer representative.");
                session.setAttribute("alert_type","success");
            }
            else{
                session.setAttribute("alert","Requested username does not exist.");
                session.setAttribute("alert_type","danger");
            }
        }
        else{
            session.setAttribute("alert","Must enter a username.");
            session.setAttribute("alert_type","danger");
        }
    }
} %>

<%@ include file="admin.jsp"%>


