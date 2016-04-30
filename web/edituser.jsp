<%@page import="org.mindrot.jbcrypt.BCrypt"%>
<%@page import="java.sql.*"%>
<%
    Connection conn = null;
    try{
        Class.forName("com.mysql.jdbc.Driver").newInstance();
        conn = DriverManager.getConnection("jdbc:mysql://localhost/yabe","yabe","yabe");
    }

    catch(Exception e){
        out.print("<p>Could not connect to SQL server.</p>");
        e.printStackTrace();
    }
  
    String new_name = request.getParameter("name");
    int new_age;
    if (request.getParameter("age") != null) {
        new_age = Integer.parseInt(request.getParameter("age").trim());
    } else {
        new_age = 0;
    }
    String new_address = request.getParameter("address");
    String password = request.getParameter("password");
    String curr_username = (String)session.getAttribute("username");
    String password_hash = BCrypt.hashpw(password,BCrypt.gensalt());
    if(new_name != null || new_age >= 13 || new_address != null || password != null){
        Statement stmt = conn.createStatement();
        String ins_query = "UPDATE users SET ";
        if(new_name.length() > 0){
            if(ins_query.length()>20)
                ins_query+=", ";
            ins_query += "name=\'"+new_name+"\'";
        }
        if(new_address.length() > 0){
            if(ins_query.length()>20)
                ins_query+=", ";
            ins_query += "address=\'"+new_address+"\'";
        }
        if(password.length() > 0){
            if(ins_query.length()>20)
                ins_query+=", ";
            ins_query += "password_hash=\'"+password_hash+"\'";
        }
        if(new_age >= 13){
            if(ins_query.length()>20)
                ins_query+=", ";
            ins_query += "age=\'"+new_age+"\'";
        }
        ins_query+=" WHERE username=\'"+curr_username+"\'";
        System.out.println(ins_query);
        int res = stmt.executeUpdate(ins_query);
    
        if (res < 1) {
            session.setAttribute("alert","Update failed.");
            session.setAttribute("alert_type","danger");
        } else {
            session.setAttribute("alert","Update successful.");
            session.setAttribute("alert_type","success");
        }
    } else {
            session.setAttribute("alert","Invalid user information fields. Please review your information and try again.");
            session.setAttribute("alert_type","danger");
    }
            %><%@ include file="userprofile.jsp" %><%
%>
