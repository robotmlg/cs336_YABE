
<%
  Connection login_conn = null;
  try{
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    login_conn = DriverManager.getConnection("jdbc:mysql://localhost/yabe","yabe","yabe");
  }

  catch(Exception e){
    System.out.println("Could not connect to SQL server");
    e.printStackTrace();
  }

  String login_username = request.getParameter("username");
  String password = request.getParameter("password");
  if(login_username != null && password != null){
    // get and hash from DB
    Statement login_stmt = login_conn.createStatement();
    String pw_query = "SELECT password_hash FROM users WHERE username=\'"+login_username+"\'";
    ResultSet login_rs = login_stmt.executeQuery(pw_query);

    // check if we found a DB result
    if(login_rs.next()){
      String db_hash = login_rs.getString("password_hash");
      // check password
      if(BCrypt.checkpw(password,db_hash)){
        session.setAttribute("username",login_username);
        session.setAttribute("loggedIn","true");
        session.setAttribute("alert","User "+login_username+" successfully logged in.");
        session.setAttribute("alert_type","success");
        %>
        <%@ include file="index.jsp"%>
        <%
      }
      else{
            session.setAttribute("alert","User "+login_username+" could not be logged in.");
            session.setAttribute("alert_type","danger");
        %>
        <%@ include file="login.jsp"%>
        <%
      }
    }
    else{
        session.setAttribute("alert","User "+login_username+" could not be logged in.");
        session.setAttribute("alert_type","danger");
        %>
        <%@ include file="login.jsp"%>
        <%
    }
    
  }
  else{
  }
%>
