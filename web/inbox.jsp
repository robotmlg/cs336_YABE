<!DOCTYPE html>
<%@ page language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Date" %>

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

%>

<html>
    <head>
        <title>YABE Messages</title>
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
        <h1>YABE Messages
        <!-- check if user is logged in -->
        <% if(session.getAttribute("loggedIn") != "true") {%>
            </h1>
            <p> Must be logged in to view this page.<p>
        <% } else { %>
        <button type="button" class="btn btn-primary btn-lg" data-toggle="modal" data-target="#composeModal">Compose Message</button></h1>
        <div class="modal fade" id="composeModal" tabindex="-1" role="dialog" aria-labelledby="composeModalLabel">
        <div class="modal-dialog" role="document">
        <div class="modal-content">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <h4 class="modal-title" id="composeModalLabel">Compose Message</h4>
        </div>
        <form class="form-horizontal" method="post" action="sendMessage.jsp">
        <div class="modal-body">
            <fieldset>
            <div class="form-group">
                <label for="to_user" class="col-xs-2 control-label">To</label>
                <div class="col-xs-10">
                <input type="text" name="to_user" placeholder="To" class="form-control" required>
                </div>
            </div>
            <div class="form-group">
                <label for="subject" class="col-xs-2 control-label">Subject</label>
                <div class="col-xs-10">
                <input type="text" name="subject" placeholder="Subject" class="form-control" required>
                </div>
            </div>
            <div class="form-group">
                <label for="body" class="col-xs-2 control-label">Body</label>
                <div class="col-xs-10">
                <textarea type="text" name="body" placeholder="Message" class="form-control" rows="10" required></textarea>
                </div>
            </div>
            </fieldset>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
            <button type="submit" class="btn btn-success">Send</button>
        </form>
        </div>
        </div>
        </div>
        </div>
        <%
            String username = (String)session.getAttribute("username");

            String msg_q = "SELECT * FROM messages WHERE to_user=\'"+username+
                "\' OR from_user=\'"+username+"\' ORDER BY send_time DESC";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(msg_q);

            int msg_cnt = 0;
        %>
        <table class="table">
        <tr><th>From</th><th>To</th><th>Sent</th><th>Subject</th></tr>
        <%
            while(rs.next()){
                ++msg_cnt;
                int msg_id = rs.getInt("message_id");
                String from = rs.getString("from_user");
                String to = rs.getString("to_user");
                String sub = rs.getString("subject");
                String body = rs.getString("body");
                Date date = rs.getTimestamp("send_time");
        %>
        <tr>
            <td><%= from %></td>
            <td><%= to %></td>
            <td><%= date.toString() %></td>
            <td><a href="#" data-toggle="modal" data-target="#msg<%= msg_id %>Modal"><%= sub %></a></td>
        </tr>
        <div class="modal fade" id="msg<%= msg_id %>Modal" tabindex="-1" role="dialog" aria-labelledby="msg<%= msg_id %>ModalLabel">
        <div class="modal-dialog" role="document">
        <div class="modal-content">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <h4 class="modal-title" id="msg<%= msg_id %>ModalLabel"><%= sub %></h4>
            <h5>From: <%= from %></h5>
            <h5>To: <%= to %></h5>
            <h5>Sent: <%= date.toString() %></h5>
        </div>
        <div class="modal-body">
        <p><%= body %></p>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
        </div>
        </div>
        </div>
        </div>
        <%
            }

            if(msg_cnt == 0){%>
            <tr><td>No messages!</td></tr>
            <%}
        } %>
        </table>


        </div>
        </div>
        <%@include file="includes/footer.jsp" %>
        </div>
    </body>
</html>
