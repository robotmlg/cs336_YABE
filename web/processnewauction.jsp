<%@page import="java.sql.*"%>
<%
    Connection conn = null;
    try{
        Class.forName("com.mysql.jdbc.Driver").newInstance();
        conn = DriverManager.getConnection("jdbc:mysql://localhost/yabe","yabe","yabe");
    }

    catch(Exception e){
        out.print("<p>Could not connect to SQL server.</p>");
        e.printStackTrace();
    }
    
    int productID=0;
    String product = request.getParameter("products");
    String producttype = request.getParameter("producttype");
    String brand = request.getParameter("brand");
    String model = request.getParameter("model");
    
    if (product.equalsIgnoreCase("New")) {
        // assign a new productID by incrementing the last one
        Statement stmt = conn.createStatement();
        String id_query = "SELECT MAX(productID) FROM product";
        ResultSet rs = stmt.executeQuery(id_query);

        // if there is a result
        if(rs.next()){
            productID = rs.getInt(1) + 1;
        }
        // if the table was empty and we don't have a Max ID, start at 1
        else{
            productID=1;
        }

        String ins_query = "INSERT INTO product (productID, brand, model) VALUES (\'" + productID + "\', \'" + brand + "\', \'" + model + "\')";
        int res = stmt.executeUpdate(ins_query);
        
        if (res < 1) {
            session.setAttribute("alert","Auction creation failed. Please try again.");
            session.setAttribute("alert_type","danger");
            %><%@ include file="newauction.jsp" %><%
        } else {
            session.setAttribute("alert","Auction creation successful.");
            session.setAttribute("alert_type","success");
            %><%@ include file="auction.jsp" %><%
        }
    } else {
        productID = Integer.parseInt(product);
    }
    
    String extraInfo = request.getParameter("extraInfo");
    
    String startdate = request.getParameter("startdate");
    String enddate = request.getParameter("enddate");
    int reserveprice = Integer.parseInt(request.getParameter("reserveprice"));
    int startprice = Integer.parseInt(request.getParameter("startprice"));
    int quantity = Integer.parseInt(request.getParameter("quantity"));
    String condition = request.getParameter("condition");
    
    Statement stmt = conn.createStatement();
    String ins_query = "";
    int res;
    switch (request.getParameter("producttype")) {
        case "motherboard":
            int pcieSlots = Integer.parseInt(request.getParameter("pcieSlots"));
            int memorySlots = Integer.parseInt(request.getParameter("memorySlots"));
            int maxRAM = Integer.parseInt(request.getParameter("maxRAM"));
            String socketType = request.getParameter("socketType");
            String chipset = request.getParameter("chipset");
            boolean onBoardSound;
            if (request.getParameter("onBoardSound").equalsIgnoreCase("yes")) {
                onBoardSound = true;
            } else {
                onBoardSound = false;
            }
            boolean onBoardVideo;
            if (request.getParameter("onBoardVideo").equalsIgnoreCase("yes")) {
                onBoardVideo = true;
            } else {
                onBoardVideo = false;
            }
            
            stmt = conn.createStatement();
            ins_query = "INSERT INTO motherboard (productID, pcieSlots, memorySlots, maxRAM, socketType, chipset, onBoardSound, onBoardVideo) VALUES (\'" + productID + "\', \'" + pcieSlots + "\', \'" + memorySlots + "\', \'" + maxRAM + "\', \'" + socketType + "\', \'" + chipset + "\', \'" + onBoardSound + "\', \'" + onBoardVideo + "\')";
            res = stmt.executeUpdate(ins_query);

            if (res < 1) {
                session.setAttribute("alert","Auction creation failed. Please try again.");
                session.setAttribute("alert_type","danger");
                %><%@ include file="newauction.jsp" %><%
            } else {
                session.setAttribute("alert","Auction creation successful.");
                session.setAttribute("alert_type","success");
                %><%@ include file="auction.jsp" %><%
            }
            break;
        case "cpu":
            int cores = Integer.parseInt(request.getParameter("cores"));
            double clockSpeed = Double.parseDouble(request.getParameter("clockSpeed"));
            String cpusocketType = request.getParameter("socketType");
            
            stmt = conn.createStatement();
            ins_query = "INSERT INTO cpu (productID, cores, clockSpeed, socketType) VALUES (\'" + productID + "\', \'" + cores + "\', \'" + clockSpeed + "\', \'" + cpusocketType + "\')";
            res = stmt.executeUpdate(ins_query);

            if (res < 1) {
                session.setAttribute("alert","Auction creation failed. Please try again.");
                session.setAttribute("alert_type","danger");
                %><%@ include file="newauction.jsp" %><%
            } else {
                session.setAttribute("alert","Auction creation successful.");
                session.setAttribute("alert_type","success");
                %><%@ include file="auction.jsp" %><%
            }
            break;
        case "ram":
            int capacity = Integer.parseInt(request.getParameter("capacity"));
            String memoryType = request.getParameter("memoryType");
            int ramclockSpeed = Integer.parseInt(request.getParameter("clockSpeed"));
            
            stmt = conn.createStatement();
            ins_query = "INSERT INTO ram (productID, capacity, memoryType, ramclockSpeed) VALUES (\'" + productID + "\', \'" + capacity + "\', \'" + memoryType + "\', \'" + ramclockSpeed + "\')";
            res = stmt.executeUpdate(ins_query);

            if (res < 1) {
                session.setAttribute("alert","Auction creation failed. Please try again.");
                session.setAttribute("alert_type","danger");
                %><%@ include file="newauction.jsp" %><%
            } else {
                session.setAttribute("alert","Auction creation successful.");
                session.setAttribute("alert_type","success");
                %><%@ include file="auction.jsp" %><%
            }
            break;
        case "gpu":
            double coreClockSpeed = Double.parseDouble(request.getParameter("coreClockSpeed"));
            int numCores = Integer.parseInt(request.getParameter("numCores"));
            int memoryCapacity = Integer.parseInt(request.getParameter("memoryCapacity"));
            int memoryClockSpeed = Integer.parseInt(request.getParameter("memoryClockSpeed"));
            String gpumemoryType = request.getParameter("memoryType");
            int numHDMI = Integer.parseInt(request.getParameter("numHDMI"));
            int numDVI = Integer.parseInt(request.getParameter("numDVI"));
            int numDP = Integer.parseInt(request.getParameter("numDP"));
            int powerRequirement = Integer.parseInt(request.getParameter("powerRequirement"));
            
            stmt = conn.createStatement();
            ins_query = "INSERT INTO gpu (productID, coreClockSpeed, numCores, memoryCapacity, memoryClockSpeed, memoryType, numHDMI, numDVI, numDP, powerRequirement) VALUES (\'" + productID + "\', \'" + coreClockSpeed + "\', \'" + numCores + "\', \'" + memoryCapacity + "\', \'" + memoryClockSpeed + "\', \'" + gpumemoryType + "\', \'" + numHDMI + "\', \'" + numDVI + "\', \'" + numDP + "\', \'" + powerRequirement + "\')";
            res = stmt.executeUpdate(ins_query);

            if (res < 1) {
                session.setAttribute("alert","Auction creation failed. Please try again.");
                session.setAttribute("alert_type","danger");
                %><%@ include file="newauction.jsp" %><%
            } else {
                session.setAttribute("alert","Auction creation successful.");
                session.setAttribute("alert_type","success");
                %><%@ include file="auction.jsp" %><%
            }
            break;
        case "storage":
            double capacityInGB = Double.parseDouble(request.getParameter("capacityInGB"));
            String storageType = request.getParameter("storageType");
            
            stmt = conn.createStatement();
            ins_query = "INSERT INTO storage (productID, capacityInGB, storageType) VALUES (\'" + productID + "\', \'" + capacityInGB + "\', \'" + storageType + "\')";
            res = stmt.executeUpdate(ins_query);

            if (res < 1) {
                session.setAttribute("alert","Auction creation failed. Please try again.");
                session.setAttribute("alert_type","danger");
                %><%@ include file="newauction.jsp" %><%
            } else {
                session.setAttribute("alert","Auction creation successful.");
                session.setAttribute("alert_type","success");
                %><%@ include file="auction.jsp" %><%
            }
            break;
        case "case":
            String dimensions = request.getParameter("dimensions");
            int numCaseFans = Integer.parseInt(request.getParameter("numCaseFans"));
            boolean isLITT;
            if (request.getParameter("isLITT").equalsIgnoreCase("yes")) {
                isLITT = true;
            } else {
                isLITT = false;
            }
            
            stmt = conn.createStatement();
            ins_query = "INSERT INTO case_hw (productID, dimension, numCaseFans, isLITT) VALUES (\'" + productID + "\', \'" + dimensions + "\', \'" + numCaseFans + "\', \'" + isLITT + "\')";
            res = stmt.executeUpdate(ins_query);

            if (res < 1) {
                session.setAttribute("alert","Auction creation failed. Please try again.");
                session.setAttribute("alert_type","danger");
                %><%@ include file="newauction.jsp" %><%
            } else {
                session.setAttribute("alert","Auction creation successful.");
                session.setAttribute("alert_type","success");
                %><%@ include file="auction.jsp" %><%
            }
            break;
        case "psu":
            int power = Integer.parseInt(request.getParameter("power"));
            boolean modular;
            if (request.getParameter("modular").equalsIgnoreCase("yes")) {
                modular = true;
            } else {
                modular = false;
            }
            
            stmt = conn.createStatement();
            ins_query = "INSERT INTO psu (productID, power, modular) VALUES (\'" + productID + "\', \'" + power + "\', \'" + modular + "\')";
            res = stmt.executeUpdate(ins_query);

            if (res < 1) {
                session.setAttribute("alert","Auction creation failed. Please try again.");
                session.setAttribute("alert_type","danger");
                %><%@ include file="newauction.jsp" %><%
            } else {
                session.setAttribute("alert","Auction creation successful.");
                session.setAttribute("alert_type","success");
                %><%@ include file="auction.jsp" %><%
            }
            break;
        case "fan":
            String fandimensions = request.getParameter("dimensions");
            int flowrate = Integer.parseInt(request.getParameter("flowrate"));
            int maxRPM = Integer.parseInt(request.getParameter("maxRPM"));

            stmt = conn.createStatement();
            ins_query = "INSERT INTO fan (productID, dimensions, flowrate, maxRPM) VALUES (\'" + productID + "\', \'" + fandimensions + "\', \'" + flowrate + "\', \'" + maxRPM + "\')";
            res = stmt.executeUpdate(ins_query);

            if (res < 1) {
                session.setAttribute("alert","Auction creation failed. Please try again.");
                session.setAttribute("alert_type","danger");
                %><%@ include file="newauction.jsp" %><%
            } else {
                session.setAttribute("alert","Auction creation successful.");
                session.setAttribute("alert_type","success");
                %><%@ include file="auction.jsp" %><%
            }
            break;
        case "other":
            stmt = conn.createStatement();
            ins_query = "INSERT INTO other (productID) VALUES (\'" + productID + "\')";
            res = stmt.executeUpdate(ins_query);

            if (res < 1) {
                session.setAttribute("alert","Auction creation failed. Please try again.");
                session.setAttribute("alert_type","danger");
                %><%@ include file="newauction.jsp" %><%
            } else {
                session.setAttribute("alert","Auction creation successful.");
                session.setAttribute("alert_type","success");
                %><%@ include file="auction.jsp" %><%
            }
            break;
    }
%>
