<!DOCTYPE html>
<%@ page language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>


<html>
    <head>
        <title>YABE Registration</title>
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
            <div class="col-md-4">
                <form action="processregistration.jsp" method="post">       
                    <h2>Please register your account</h2>
                    <p>
                      <input type="text" name="username" placeholder="Username" required autofocus />
                      <input type="password" name="password" placeholder="Password" required />
                    </p>
                    <p>
                      <input type="text" name="name" placeholder="Name" required />
                    </p>
                    <p>
                      <input type="number" name="age" value="1" min="1" step="1" required />
                    </p>
                    <p>
                      <input type="text" name="address" placeholder="Address" required />
                    </p>
                    <button class="btn btn-lg btn-primary btn-block" type="submit">Submit</button>
                    <a href="login.jsp" class="button btn btn-lg btn-primary btn-block">Already have an account?</a>
                </form>
            </div>   
        </div>
        <%@include file="includes/footer.jsp" %>
        </div>
    </body>
</html>
