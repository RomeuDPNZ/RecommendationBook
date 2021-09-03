
<%
	Cookie[] cookies = request.getCookies();

	Boolean isRecommenderLogged = false;
	Long recommenderIdLogged = 0l;

	for(Cookie cookie:cookies) {
 		if(cookie.getName().equals("IsRecommenderLogged")) {
			if(cookie.getValue().equals("Yes")) {
				isRecommenderLogged = true;
			}
		}
	}

	for(Cookie cookie:cookies) {
 		if(cookie.getName().equals("RecommenderId")) {
			if(isRecommenderLogged) {
				recommenderIdLogged = Long.valueOf((String) cookie.getValue());
			}
		}
	}

	session.setAttribute("RecommenderIdLogged", ""+recommenderIdLogged+"");
%>

<% if(!recommenderIdLogged.equals(1l)) { %>

	<jsp:forward page="/Error.jsp?id=7" />

<% } else { %>

<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>

<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>

<%@ page import="java.text.SimpleDateFormat" %>

<%@ page import="recBook.DB" %>

<%!

public class Errors {

	private Long id;
	private String message;
	private String stackTrace;
	private Date createdOn;

	public Errors() {
	}

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getMessage() {
		return this.message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public String getStackTrace() {
		return this.stackTrace;
	}

	public void setStackTrace(String stackTrace) {
		this.stackTrace = stackTrace;
	}

	public Date getCreatedOn() {
		return this.createdOn;
	}

	public void setCreatedOn(Date createdOn) {
		this.createdOn = createdOn;
	}

	public String getCreatedOnToMySQL() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		return sdf.format(this.getCreatedOn()).toString();
	}

	public void setCreatedOnFromMySQL(String createdOn) throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		this.setCreatedOn(sdf.parse(createdOn));
	}

}

%>

<%

	/*
	 * Conecta ao Banco de Dados
	 */

	DB db = new DB();
	db.ConectaDB();

	if(db.conexao == null) {
		System.err.println("DB Connection Error: "+db.conexao);
	}

	List list = new ArrayList();

	try {

		PreparedStatement ps = db.conexao.prepareStatement("SELECT * FROM Errors");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			Errors errors = new Errors();

			errors.setId(result.getLong("id"));
			errors.setMessage(result.getString("message"));
			errors.setStackTrace(result.getString("stacktrace"));
			errors.setCreatedOnFromMySQL(result.getString("createdOn"));

			list.add(errors);
		}

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally {

		/*
		 * Desconecta do Banco de Dados
		 */

		if(db.conexao != null) {
			db.DesconectaDB();
		}
	}

%>

<!DOCTYPE html>

<html lang="en-US">

<head>
 
<title>Recommendation Book</title>
 
<meta name="keywords" content="" />
<meta name="description" content="" />
 
<style type="text/css">

div.ShowErrors {
	padding: 1em;
	border: 1px solid red;
	margin-bottom: 1em;
}

div.NoErrors {
	text-align: center;
	border: 1px solid green;
	padding: 5em;
	margin-bottom: 1em;
}

</style>
<link rel="stylesheet" type="text/css" media="screen" href="RecommendationBookCSS.css" />

<script src="js/jquery-1.10.2.js"></script>
<script src="js/jquery-ui.js"></script>
<script type="text/javascript"> 
<!--

$(document).ready(function(){

	$("input[name=Delete]").click(function(event) {

		var id = $(this).attr("id");
		var url = "DeleteErrors.jsp";

		var posting = $.post(url, {id: id});

		posting.done(function(data) {
		});

		$(this).parent().remove();

	});

	$("input[name=DeleteAllErrors]").click(function(event) {

		var url = "DeleteAllErrors.jsp";

		var posting = $.post(url);

		posting.done(function(data) {
		});

		$(this).parent().remove();

	});

});

//-->
</script>

</head>

<body>

<div class="Geral">
	<jsp:include page="CabecalhoMenu.jsp" flush="true" />
	<jsp:include page="Search.jsp" flush="true" />
	<div class="Corpo">

	<div class="Errors">

<%

	Iterator itr = list.iterator();

	if(list.isEmpty()) {
		out.println("<div class=\"NoErrors\">No Errors Found!</div>");
	} else {

	out.println("<input type=\"button\" name=\"DeleteAllErrors\" value=\"Delete All Errors\" /><br /><br />");

	while(itr.hasNext()) {
		Errors error = (Errors) itr.next();
		out.print("<div class=\"ShowErrors\">Id = "+error.getId()+"<br />Message = "+error.getMessage()+"<br />StackTrace = "+error.getStackTrace()+"<br />Date = "+error.getCreatedOnToMySQL()+"<br /><br /><input type=\"button\" name=\"Delete\" value=\"Delete\" id=\""+error.getId()+"\" /></div>");
	}

	}

%>

	</div>

	</div>
	<jsp:include page="Rodape.jsp" flush="true" />
</div>

</body>
 
</html>

<% } %>
