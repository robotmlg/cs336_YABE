<!DOCTYPE html>
<%@ page import="java.sql.*" %>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>
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
        <title>YABE Customer Rep Page</title>
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
        <h1>YABE Customer Representative Page</h1>
        <!-- check if user is admin -->
        <% if(session.getAttribute("loggedIn") != "true") {%>
        <p> Must be logged in as a customer representative to view this page.<p>
        <% } else {
            
                String username = (String)session.getAttribute("username");
                Statement stmt = conn.createStatement();
                String cr_query = "SELECT COUNT(*) FROM cust_reps WHERE username=\'"+username+"\'";
                ResultSet rs = stmt.executeQuery(cr_query);
                rs.next();

                if(rs.getInt(1) == 0){%>
        <p> Must be logged in as a customer representative to view this page.<p>
              <% }
                else { 

        %>

        </div>
        </div>
        <div class="row">
        <div class="col-sm-6">
        <div class="jumbotron">
        <h3>Delete Auction</h3>
        <form class="form-horizontal" method="post" action="deleteItem.jsp"> 
            <fieldset>
            <div class="form-group">
                <label for="auctionID" class="col-xs-2 control-label">ID</label>
                <div class="col-xs-10">
                <input type="number" name="auctionID" placeholder="Auction ID" class="form-control" required>
                </div>
            </div>
            </fieldset>
            <button type="submit" class="btn btn-lg btn-danger" align="right">Delete</button>
        </form>
        </div>
        </div>
        <div class="col-sm-6">
        <div class="jumbotron">
        <h3>Delete Bid</h3>
        <form class="form-horizontal" method="post" action="deleteItem.jsp"> 
            <fieldset>
            <div class="form-group">
                <label for="bidID" class="col-xs-2 control-label">ID</label>
                <div class="col-xs-10">
                <input type="number" name="bidID" placeholder="Bid ID" class="form-control" required>
                </div>
            </div>
            </fieldset>
            <button type="submit" class="btn btn-lg btn-danger" align="right">Delete</button>
        </form>
        </div>
        </div>
        </div>
        <div class="row">
        <div class="col-lg-12">
        <div class="jumbotron">
        <h3>Customer Rep Messages
            <button type="button" class="btn btn-primary btn-lg" data-toggle="modal" data-target="#composeModal">Compose Message</button>
        </h3>
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
                <label for="from_user" class="col-xs-2 control-label">From</label>
                <div class="col-xs-10">
                <input type="text" name="from_user" value="cust_rep" class="form-control" required readonly>
                </div>
            </div>
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
            String msg_q = "SELECT * FROM messages WHERE to_user=\'cust_rep\' "+
                "OR from_user=\'cust_rep\' ORDER BY send_time DESC";
            rs = stmt.executeQuery(msg_q);

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
        <%
            }

            if(msg_cnt == 0){%>
            <tr><td>No messages!</td></tr>
            <%}
        } %>
        </table>

              <% 
        } %>


        </div>
        </div>
        </div>
        <%@include file="includes/footer.jsp" %>
        </div>
    </body>
</html>
