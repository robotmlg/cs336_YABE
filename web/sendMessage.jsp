<%@ page import="java.sql.*" %>
<%
    Connection send_conn = null;
    try{
        Class.forName("com.mysql.jdbc.Driver").newInstance();
        send_conn = DriverManager.getConnection("jdbc:mysql://localhost/yabe","yabe","yabe");
    }

    catch(Exception e){
        out.print("<p>Could not connect to SQL server.</p>");
        e.printStackTrace();
    }

    int messageID = 0;
    String send_subject = request.getParameter("subject");
    String send_to_user = request.getParameter("to_user");
    String send_body    = request.getParameter("body");
    String send_from_user = (String)session.getAttribute("username");

    // get a messageID
    Statement send_stmt = send_conn.createStatement();
    String id_q = "SELECT MAX(message_id) FROM messages";
    ResultSet id_rs = send_stmt.executeQuery(id_q);
    if(id_rs.next()){
        messageID = id_rs.getInt(1)+1;
    }
    else{
        messageID = 1;
    }

    String send_u="INSERT INTO messages (message_id, to_user, from_user, send_time, subject, body) VALUES ("+messageID+",\'"+send_to_user+"\',\'"+send_from_user+"\',NOW(),\'"+send_subject+"\',\'"+send_body+"\')";

    int res = send_stmt.executeUpdate(send_u);

    if(res < 1){
        session.setAttribute("alert","Message failed to send. Try again.");
        session.setAttribute("alert_type","danger");
    }
    else{
        session.setAttribute("alert","Message successfully sent to "+send_to_user+".");
        session.setAttribute("alert_type","success");
    }
%>
<%@ include file="inbox.jsp" %>
