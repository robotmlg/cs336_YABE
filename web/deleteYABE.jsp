<!DOCTYPE html>
<%@ page language="java" %>
<%@ page import="java.sql.*" %>


<% 
Connection del_conn = null;
try{
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    del_conn = DriverManager.getConnection("jdbc:mysql://localhost/yabe","yabe","yabe");
}

catch(Exception e){
    System.out.println("Could not connect to SQL server");
    e.printStackTrace();
}


if(session.getAttribute("loggedIn") == "true") {

    String username = (String)session.getAttribute("username");
    Statement stmt = del_conn.createStatement();
    String admin_query = "SELECT COUNT(*) FROM admins WHERE username=\'"+username+"\'";
    ResultSet rs = stmt.executeQuery(admin_query);
    rs.next();

    if(rs.getInt(1) > 0){
        // successfully verified admin login, now delete the db
        stmt.executeUpdate("DELETE FROM users WHERE username!=\'"+username+"\'");
        stmt.executeUpdate("TRUNCATE TABLE other");
        stmt.executeUpdate("TRUNCATE TABLE case_hw");
        stmt.executeUpdate("TRUNCATE TABLE gpu");
        stmt.executeUpdate("TRUNCATE TABLE fan");
        stmt.executeUpdate("TRUNCATE TABLE ram");
        stmt.executeUpdate("TRUNCATE TABLE cpu");
        stmt.executeUpdate("TRUNCATE TABLE motherboard");
        stmt.executeUpdate("TRUNCATE TABLE psu");
        stmt.executeUpdate("TRUNCATE TABLE storage");
        stmt.executeUpdate("TRUNCATE TABLE bid");
        stmt.executeUpdate("TRUNCATE TABLE participatesIn");
        stmt.executeUpdate("TRUNCATE TABLE auction");
        stmt.executeUpdate("TRUNCATE TABLE product");
        stmt.executeUpdate("TRUNCATE TABLE cust_reps");
        stmt.executeUpdate("TRUNCATE TABLE messages");
    }
} %>

<%@ include file="admin.jsp"%>


