<%@page import="java.sql.*"%>
<%@ page language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Date" %>

<%
    Connection bid_conn = null;
    try{
        Class.forName("com.mysql.jdbc.Driver").newInstance();
        bid_conn = DriverManager.getConnection("jdbc:mysql://localhost/yabe","yabe","yabe");
    }
    catch(Exception e){
        out.print("<p>Could not connect to SQL server.</p>");
        e.printStackTrace();
    }
    
    
    Integer amount = Integer.parseInt(request.getParameter("amount"));
    Integer max_amount = Integer.parseInt(request.getParameter("max_amount"));
    String time = (request.getParameter("time"));
    String username = (String)session.getAttribute("username");
    Integer auctionID = Integer.parseInt(request.getParameter("auctionID"));
    
    Statement new_statement = bid_conn.createStatement() ;
    ResultSet new_resultset;
    int res2;
    new_resultset = null;
    
    
    // give the bid an id
    Integer bidID = 0;
    
    Statement stmt = bid_conn.createStatement();
    String id_query = "SELECT MAX(b.bidID) FROM bid b";
    ResultSet rs = stmt.executeQuery(id_query);
    
    if(rs.next()){
    	bidID = rs.getInt(1) + 1;
    }
    // if the table was empty and we don't have a Max ID, start at 1
    else{
    	bidID=1;
    }
    

    Statement stmt4 = bid_conn.createStatement();
    String getmaxbid_query = "SELECT MAX(b.max_amount) FROM bid b, auction a WHERE a.auctionID = "+auctionID+" and b.auctionID=a.auctionID ";
    ResultSet rs5 = stmt4.executeQuery(getmaxbid_query);
	
    String getnumbids_query ="SELECT a.numBids FROM  auction a WHERE a.auction ID = "+auctionID+"";
    ResultSet rs7 = stmt4.executeQuery(getnumbids_query);
    
    String getauctionmaxbid_query ="SELECT a.maxBid FROM  auction a WHERE a.auction ID = "+auctionID+"";
    ResultSet rs8 = stmt4.executeQuery(getauctionmaxbid_query);
    
    String ins_query = "INSERT INTO bid (bidID, amount, max_amount, time, username, auctionID) VALUES (\'" + bidID + "\', \'" + amount + "\', \'" + max_amount + "\', NOW() , \'" + username + "\', \'" + auctionID + "\')";
    int res = 0;
    try{
        res = stmt.executeUpdate(ins_query);
    }
    catch(Exception e){ res = 0;}
    finally{
    
        if (res < 1) {
            session.setAttribute("alert","Bid failed.");
            session.setAttribute("alert_type","danger");
        } else {
            session.setAttribute("alert","Bid Successful.");
            session.setAttribute("alert_type","success");
        }
    }
    
    
    Integer x = 0;
    int res3 = 0;
    int res6 = 0;
    x = rs7.getInt("numBids");
    
    if(amount > rs8.getInt("maxBid")){
        x = x + 1;
        if(amount > rs5.getInt("max_amount")){
        	String updatemaxbid_query = "INSERT INTO auction (maxBid, numBids) VALUES (\'" + amount + "\', \'" + x + "\')";
        	 
        	try{
				res3 = stmt4.executeUpdate(updatemaxbid_query);
			}
			catch(Exception e){ res3 = 0;}
		    finally{
		    
		        if (res3 < 1) {
		            session.setAttribute("alert","Your Bid did not go through. Try Again!");
		            session.setAttribute("alert_type","danger");
		        } else {
		            session.setAttribute("alert","You are now the current highest bidder!.");
		            session.setAttribute("alert_type","success");
		        }
        	
		    }
        }
        
        if (amount <= rs5.getInt("max_amount")){
        	if(max_amount > rs5.getInt("max_amount")){
    			
    			String updatemaxbid_query = "INSERT INTO auction (maxBid, numBids) VALUES (\'" + max_amount + "\', \'" + x + "\')";
				try{
					res3 = stmt4.executeUpdate(updatemaxbid_query);
				}
				catch(Exception e){ res3 = 0;}
			    finally{
			    
			        if (res3 < 1) {
			            session.setAttribute("alert","Bid did not go through.");
			            session.setAttribute("alert_type","danger");
			        } else {
			            session.setAttribute("alert","You are now the current highest bidder!.");
			            session.setAttribute("alert_type","success");
			        }
			    }
    		}
        	
        	 if(max_amount <= rs5.getInt("max_amount")){
            	bidID = bidID+1;
            	username = rs5.getString("username");
            	String updatemaxbid_query = "INSERT INTO auction (maxBid, numBids) VALUES (\'" + rs5.getInt("max_amount") + "\', \'" + x + "\')";
                String ins_query2 = "INSERT INTO bid (bidID, amount, max_amount, time, username, auctionID) VALUES (\'" + bidID + "\', \'" + rs5.getInt("max_amount") + "\', \'" + rs5.getInt("max_amount") + "\', NOW() , \'" + username + "\', \'" + auctionID + "\')";
                
                try{
					res3 = stmt4.executeUpdate(updatemaxbid_query);
				}
				catch(Exception e){ res3 = 0;}
			    finally{
			    
			        if (res3 < 1) {
			            session.setAttribute("alert","Bid did not go through.");
			            session.setAttribute("alert_type","danger");
			        } else {
			            session.setAttribute("alert","You are now the current highest bidder!.");
			            session.setAttribute("alert_type","success");
			        }
			    }
                
                try{
    				
    				res6 = stmt4.executeUpdate(ins_query2);
    			}
    			catch(Exception e){ res6 = 0;}
    		    finally{
    		    
    		        if (res6 < 1) {
    		            session.setAttribute("alert","Bid did not go through.");
    		            session.setAttribute("alert_type","danger");
    		        } else {
    		            session.setAttribute("alert","Bid Successful!.");
    		            session.setAttribute("alert_type","success");
    		        }
    		    }
        	}
        }
    }
    
    else if(amount <= rs8.getInt("maxBid")){
    	 session.setAttribute("alert","Bid did not go through.");
         session.setAttribute("alert_type","danger");
    }

    %><%@ include file="auction.jsp" %><%
	
%>
