<!DOCTYPE html>
<%@ page language="java" %>
<%@ page import="java.sql.*" %>


<% 
Connection del_conn = null;
try{
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    del_conn = DriverManager.getConnection("jdbc:mysql://localhost/yabe","yabe","yabe");
}

catch(Exception e){
    System.out.println("Could not connect to SQL server");
    e.printStackTrace();
}

int res=0;


if(session.getAttribute("loggedIn") == "true") {

    String username = (String)session.getAttribute("username");
    Statement stmt = del_conn.createStatement();
    String rep_query = "SELECT COUNT(*) FROM cust_reps WHERE username=\'"+username+"\'";
    ResultSet rs = stmt.executeQuery(rep_query);
    rs.next();

    if(rs.getInt(1) > 0){
        // successfully verified cust_rep login, now delete the item
        String auctionID = request.getParameter("auctionID");
        String bidID = request.getParameter("bidID");

        if(auctionID != null){
            int aID = Integer.parseInt(auctionID);
            res=stmt.executeUpdate("DELETE FROM auction WHERE auctionID="+aID);

            if(res>0){
                session.setAttribute("alert","Sucessfully deleted auction "+aID);
                session.setAttribute("alert_type","success");
            }
            else{
                session.setAttribute("alert","Failed to delete auction "+aID);
                session.setAttribute("alert_type","danger");
            }
        }
        else if(bidID != null){
            int bID = Integer.parseInt(bidID);
            res=stmt.executeUpdate("DELETE FROM bid WHERE auctionID="+bID);

            if(res>0){
                session.setAttribute("alert","Sucessfully deleted bid "+bID);
                session.setAttribute("alert_type","success");
            }
            else{
                session.setAttribute("alert","Failed to delete bid "+bID);
                session.setAttribute("alert_type","danger");
            }
        }
        else{
        }

            
    }
} %>

<%@ include file="custrep.jsp"%>


