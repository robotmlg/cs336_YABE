<!DOCTYPE html>
<%@ page language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>


<html>
    <head>
        <title>New Auction</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="css/bootstrap.css" rel="stylesheet">
        <style>
        body {
            
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
                <form action="newauction2.jsp" method="post">       
                    <h2>Create A New Auction</h2>
                    <p>
                        <b>Select a product if it already exists (otherwise, select 'New'):</b><br>
                        <select name="products">
                            <%
                                Connection products_conn = null;
                                try{
                                    Class.forName("com.mysql.jdbc.Driver").newInstance();
                                    products_conn = DriverManager.getConnection("jdbc:mysql://localhost/yabe","yabe","yabe");
                                }

                                catch(Exception e){
                                    out.print("<p>Could not connect to SQL server.</p>");
                                    e.printStackTrace();
                                }

                                Statement statement = products_conn.createStatement() ;
                                ResultSet resultset;
                                resultset = statement.executeQuery("SELECT * FROM product p");
                            %>
                            <option value="new">New</option><br>
                            <%  while(resultset.next()){ %>
                                <option value="<%= resultset.getInt("productID") %>">Brand: <%= resultset.getString("brand") %> Model: <%= resultset.getString("model") %></option><br>
                            <% } %>
                        </select>
                    </p>
                    <p>
                        <b>Select a product type:</b><br>
                        <input type="radio" name="producttype" value="motherboard" checked> Motherboard<br>
                        <input type="radio" name="producttype" value="cpu" checked> CPU<br>
                        <input type="radio" name="producttype" value="ram"> RAM<br>
                        <input type="radio" name="producttype" value="gpu" checked> GPU<br>
                        <input type="radio" name="producttype" value="storage" checked> Storage<br>
                        <input type="radio" name="producttype" value="case"> Case<br>
                        <input type="radio" name="producttype" value="psu"> PSU<br>
                        <input type="radio" name="producttype" value="fan"> Fan<br>
                        <input type="radio" name="producttype" value="other"> Other
                    </p>
                    <p>
                        <b>Product information (required for a new product entry):</b><br>
                        Model: 
                        <input type="text" name="brand" maxlength="24" placeholder="Brand" /><br>
                        Brand: 
                        <input type="text" name="model" maxlength="24" placeholder="Model" />
                    </p>
                    <p>
                        <b>General auction information:</b><br>
                        Start date: 
                        <input type="datetime-local" name="startdate" placeholder="Start Date" required autofocus /><br>
                        End date: 
                        <input type="datetime-local" name="enddate" placeholder="End Date" required /><br>
                        Reserve price: 
                        <input type="number" name="reserveprice" value="0" min="0" step="any" required /><br>
                        Bidding start price: 
                        <input type="number" name="startprice" value="0" min="0" step="any" required /><br>
                        Quantity: 
                        <input type="number" name="quantity" value="1" min="1" step="1" required /><br>
                        Condition: 
                        <input type="text" name="condition" placeholder="Condition" required />
                    </p>
                    <button class="btn btn-lg btn-primary btn-block" type="submit">Create Auction</button>
                </form>
            </div>   
        </div>
        <%@include file="includes/footer.jsp" %>
        </div>
    </body>
</html>
