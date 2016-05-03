<!DOCTYPE html>
<%@ page language="java" %>
<%@ page import="java.sql.*" %>


<html>
    <head>
        <title>Bid History</title>
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
                <h1>Below are the bids for this auction:</h1>
            </div>
            <div class="col-md-4">






            </div>   
        </div>
        <%@include file="includes/footer.jsp" %>
        </div>
    </body>
</html>
