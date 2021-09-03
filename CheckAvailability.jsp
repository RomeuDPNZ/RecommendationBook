<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>

<%@ page import="recBook.DoesRecommenderExists" %>

<%

	String search = request.getParameter("s");

	Long wasFound = new DoesRecommenderExists().check(search);

	if(wasFound >= 1) {
		out.print("<span class=\"red\">Already Taken!</span>");
	} else {
		out.print("<span class=\"green\">Available!</span>");
	}

%>