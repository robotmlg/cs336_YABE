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
                <form action="processnewauction.jsp" method="post">       
                    <h2>New Auction: Additional Information</h2>
                    <p>
                        <b>General product information:</b><br>
                        Product ID: 
                        <input type="text" name="products" value="<%= request.getParameter("products") %>" /><br>
                        <%
                            if (request.getParameter("products").equalsIgnoreCase("new")) {
                                    String brand = request.getParameter("brand");
                                    String model = request.getParameter("model"); %>
                                    Product brand: 
                                    <input type="text" name="brand" value="<%= brand %>" /><br>
                                    Product model: 
                                    <input type="text" name="model" value="<%= model %>" />
                        <%
                            } else {
                                Connection conn = null;
                                try{
                                    Class.forName("com.mysql.jdbc.Driver").newInstance();
                                    conn = DriverManager.getConnection("jdbc:mysql://localhost/yabe","yabe","yabe");
                                }

                                catch(Exception e){
                                    out.print("<p>Could not connect to SQL server.</p>");
                                    e.printStackTrace();
                                }

                                Statement statement = conn.createStatement() ;
                                ResultSet resultset;
                                resultset = statement.executeQuery("SELECT * FROM product p WHERE p.productID = " + request.getParameter("products"));
                                resultset.first();
                                String brand = resultset.getString("brand");
                                String model = resultset.getString("model"); %>
                                Product brand: 
                                <input type="text" name="brand" value="<%= brand %>" /><br>
                                Product model: 
                                <input type="text" name="model" value="<%= model %>" />
                        <%
                            }
                        %>
                    </p>
                    <p>
                        Product type: 
                        <input type="text" name="producttype" value="<%= request.getParameter("producttype") %>" />
                    </p>
                    <p>
                        <b>Product specific information:</b><br>
                        <%
                            String prodtype = request.getParameter("producttype");
                            if (prodtype.equalsIgnoreCase("motherboard")) { %>
                                Number of PCIe Slots?<br>
                                <input type="number" name="pcieSlots" value="0" min="0" step="1" required autofocus /><br>
                                Number of RAM memory slots?<br>
                                <input type="number" name="memorySlots" value="0" min="0" step="1" required /><br>
                                Maximum RAM capacity (GBs)?<br>
                                <input type="number" name="maxRAM" value="0" min="0" step="1" required /><br>
                                Socket type?<br>
                                <input type="text" name="socketType" maxlength="16" placeholder="Socket Type" required /><br>
                                Chipset?<br>
                                <input type="text" name="chipset" maxlength="16" placeholder="Chipset" required /><br>
                                Does the motherboard have on-board sound?<br>
                                <input type="radio" name="onBoardSound" value="yes" checked> Yes<br>
                                <input type="radio" name="onBoardSound" value="no" > No<br>
                                Does the motherboard have on-board video?<br>
                                <input type="radio" name="onBoardVideo" value="yes" checked> Yes<br>
                                <input type="radio" name="onBoardVideo" value="no" > No<br>
                        <%  } else if (prodtype.equalsIgnoreCase("cpu")) { %>
                                    Number of cores?<br>
                                    <input type="number" name="cores" value="1" min="1" step="1" required autofocus /><br>
                                    Clock speed (GHz)?<br>
                                    <input type="number" name="clockSpeed" value="1" min="1" max="10.00" step=".01" required /><br>
                                    Socket type?<br>
                                    <input type="text" name="socketType" maxlength="16" placeholder="Socket Type" required /><br>
                        <%  } else if (prodtype.equalsIgnoreCase("ram")) { %>
                                    Capacity (GB)?<br>
                                    <input type="number" name="capacity" value="1" min="1" step="1" required autofocus /><br>
                                    Memory type (DDR-X)?<br>
                                    <input type="text" name="memoryType" maxlength="4" placeholder="DDR(#)" required /><br>
                                    Clock speed?<br>
                                    <input type="number" name="clockSpeed" value="1666" min="1" step="1" required /><br>
                        <%  } else if (prodtype.equalsIgnoreCase("gpu")) { %>
                                    Core clock speed (GHz)?<br>
                                    <input type="number" name="coreClockSpeed" value="1.00" min="0" max="10.00" step=".01" required autofocus /><br>
                                    Number of cores?<br>
                                    <input type="number" name="numCores" value="1" min="1" step="1" required /><br>
                                    Memory (GBs)?<br>
                                    <input type="number" name="memoryCapacity" value="1" min="0" step="1" required /><br>
                                    Memory clock speed (MHz)?<br>
                                    <input type="number" name="numHDMI" value="1000" min="1" max="9999" step="1" required /><br>
                                    Memory type (DDR-X)?<br>
                                    <input type="text" name="memoryType" maxlength="4" placeholder="DDR(#)" required /><br>
                                    Number of HDMI Ports?<br>
                                    <input type="number" name="numHDMI" value="0" min="0" step="1" required /><br>
                                    Number of DVI Ports?<br>
                                    <input type="number" name="numDVI" value="0" min="0" step="1" required /><br>
                                    Number of Display Ports?<br>
                                    <input type="number" name="numDP" value="0" min="0" step="1" required /><br>
                                    Power requirement (W)?<br>
                                    <input type="number" name="powerRequirement" value="500" min="1" step="1" required /><br>
                        <%  } else if (prodtype.equalsIgnoreCase("storage")) { %>
                                    Capacity (GB)?<br>
                                    <input type="number" name="capacityInGB" value="1" min=".001" max="999999.999" step=".001" required autofocus /><br>
                                    Storage type (HDD or SSD)?<br>
                                    <input type="text" name="storageType" maxlength="3" placeholder="Storage Type" required /><br>
                        <%  } else if (prodtype.equalsIgnoreCase("case")) { %>
                                    Dimensions?<br>
                                    <input type="text" name="dimensions" maxlength="15" placeholder="Dimensions (##.#x##.#x##.#)" required autofocus /><br>
                                    Number of case fans?<br>
                                    <input type="number" name="numCaseFans" value="0" min="0" step="1" required /><br>
                                    Does the case have built in lighting?<br>
                                    <input type="radio" name="isLITT" value="yes" checked> Yes<br>
                                    <input type="radio" name="isLITT" value="no" > No<br>
                        <%  } else if (prodtype.equalsIgnoreCase("psu")) { %>
                                    Power output?<br>
                                    <input type="number" name="power" value="100" min="100" step="1" required autofocus /><br>
                                    Is this PSU modular?<br>
                                    <input type="radio" name="modular" value="yes" checked> Yes<br>
                                    <input type="radio" name="modular" value="no" > No<br>
                        <%  } else if (prodtype.equalsIgnoreCase("fan")) { %>
                                    Dimensions?<br>
                                    <input type="text" name="dimensions" maxlength="15" placeholder="Dimensions (##.#x##.#x##.#)" required autofocus /><br>
                                    Flow rate?<br>
                                    <input type="number" name="flowrate" value="0" min="0" step="1" required /><br>
                                    Maximum RPM?<br>
                                    <input type="number" name="maxRPM" value="60" min="60" step="1" required /><br>
                        <%  } else if (prodtype.equalsIgnoreCase("other")) { %>
                                    
                        <%  } %>
                        Is there any additional information you would like to provide? If so, please add it below.<br>
                        <input type="text" name="extraInfo" placeholder="Extra Information" />
                    </p>
                    <p>
                        <b>General Auction Information:</b><br>
                        Start date: 
                        <input type="datetime-local" name="startdate" value="<%= request.getParameter("startdate") %>" /><br>
                        End date: 
                        <input type="datetime-local" name="enddate" value="<%= request.getParameter("enddate") %>" /><br>
                        Reserve price: 
                        <input type="number" name="reserveprice" value="<%= request.getParameter("reserveprice") %>" /><br>
                        Bidding start price: 
                        <input type="number" name="startprice" value="<%= request.getParameter("startprice") %>" /><br>
                        Quantity being sold: 
                        <input type="number" name="quantity" value="<%= request.getParameter("quantity") %>" /><br>
                        Condition: 
                        <input type="text" name="condition" value="<%= request.getParameter("condition") %>" />
                    </p>
                    <button class="btn btn-lg btn-primary btn-block" type="submit">Create Auction</button>
                </form>
            </div>   
        </div>
        <%@include file="includes/footer.jsp" %>
        </div>
    </body>
</html>
