
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
        <li><a>Hi, <%= session.getAttribute("username") %></a></li>
        <li><a href="/newauction.jsp">Create New Auction</a></li>
        <li><a href="/inbox.jsp">Inbox</a></li>
        <li><a href="/logout.jsp">Logout</a></li>
        <%}else{ %>
        <li><a href="/login.jsp">Login</a></li>
        <%}%>
        
      </ul>
    </div><!--/.collapse .navbar-collapse -->
  </div>
</nav>

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
