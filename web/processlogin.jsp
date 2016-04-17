
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

  String username = request.getParameter("username");
  String password = request.getParameter("password");
  if(username != null && password != null){
    // get and hash from DB
    Statement stmt = conn.createStatement();
    String pw_query = "SELECT password_hash FROM users WHERE username=\'"+username+"\'";
    ResultSet rs = stmt.executeQuery(pw_query);

    // check if we found a DB result
    if(rs.next()){
      String db_hash = rs.getString("password_hash");
      // check password
      if(BCrypt.checkpw(password,db_hash)){
        session.setAttribute("username",username);
        session.setAttribute("loggedIn","true");
        %>
        <%@ include file="index.jsp"%>
        <%
      }
      else{
        out.print("<p>Incorrect password.</p>");
      }
    }
    else{
      out.print("<p>Username not found.</p>");
    }
    
  }
  else{
  }
%>
