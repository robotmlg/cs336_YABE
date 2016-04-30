
    <nav class="navbar navbar-inverse navbar-fixed-top">
  <div class="container">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar-main">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      <a class="navbar-brand" href="/index.jsp">YABE</a>
    </div>

    <div class="collapse navbar-collapse" id="navbar-main">
      <ul class="nav navbar-nav">
        
        
        <!-- to add a page to the navbar, add another <li></li> as shown below -->
        <% if(session.getAttribute("loggedIn") == "true"){%>
        <li><a href="/userprofile.jsp">Hi, <%= session.getAttribute("username") %></a></li>
        <li><a href="/newauction.jsp">Create New Auction</a></li>
        <li><a href="/inbox.jsp">Inbox</a></li>
        <li>
            <a href="#" data-toggle="modal" data-target="#composeModal">Contact Us</a>
        </li>
        <li><a href="/logout.jsp">Logout</a></li>
        <%}else{ %>
        <li><a href="/login.jsp">Login</a></li>
        <%}%>
        
      </ul>
    </div><!--/.collapse .navbar-collapse -->
  </div>
</nav>

        <div class="modal fade" id="composeModal" tabindex="-1" role="dialog" aria-labelledby="composeModalLabel">
        <div class="modal-dialog" role="document">
        <div class="modal-content">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <h4 class="modal-title" id="composeModalLabel">Contact a Customer Representative</h4>
        </div>
        <form class="form-horizontal" method="post" action="sendMessage.jsp">
        <div class="modal-body">
            <fieldset>
            <div class="form-group">
                <label for="from_user" class="col-xs-2 control-label">From</label>
                <div class="col-xs-10">
                <input type="text" name="from_user" value="<%= session.getAttribute("username") %>" class="form-control" required readonly>
                </div>
            </div>
            <div class="form-group">
                <label for="to_user" class="col-xs-2 control-label">To</label>
                <div class="col-xs-10">
                <input type="text" name="to_user" value="cust_rep" class="form-control" required readonly>
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

<a name="top"></a>

<div class="container">
    <div class="row">
        <div class="col-lg-12">
            <% if(session.getAttribute("alert") != null){%>
                <div class="alert alert-<%= session.getAttribute("alert_type")%>" role="alert">
                    <%= session.getAttribute("alert") %>
                </div>
            <%
            session.setAttribute("alert",null);
            }%>
        </div>
    </div>
</div>
