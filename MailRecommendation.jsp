
<%@ include file="Validation.jsp" %>

<%@ page import="recBook.DoesIdExists" %>

<% if(request.getParameter("id") == null || request.getParameter("action") == null) { %>

	<span class="red">Error: Parameter Id Or Action == null</span>

<% } else if(!new Validation().isIdValid(request.getParameter("id"))) { %>

	<span class="red">Error: Id Has To Be a Number</span>

<% } else if(!new DoesIdExists().check("Recommended", (Long.valueOf(request.getParameter("id"))))) { %>

	<span class="red">Error: Id Does Not Exists</span>

<% } else { %>

<%
	Cookie[] cookies = request.getCookies();

	Boolean isRecommenderLogged = false;
	Long recommenderIdLogged = 0l;

	if(cookies != null) {

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

	}

%>

<script type="text/javascript"> 
<!--

$(document).ready(function(){

var rules = { 'name': { required: true, maxlength: '50', regex: "^[a-zA-Z0-9\\s]+$" }, 'email': { required: true, maxlength: '100', regex: "^([a-zA-Z0-9_.-]+)@([a-zA-Z0-9_.-]+)$" } };

var messages = {
	'name': { required: "Name Field Cannot Be Empty!", maxlength: "Name Field Cannot Be Bigger Than 50 Characters!", regex: "Choose a Valid Nickname With a-z A-Z 0-9 Characters!" }, 
	'email': { required: "E-mail Field Cannot Be Empty!", maxlength: "E-mail Field Cannot Be Bigger Than 100 Characters!", regex: "Type a Valid E-mail!" }
};

<% if(isRecommenderLogged) { %>

$("#FriendRecommendationForm").validate({rules: rules, messages: messages,
	submitHandler: function (form) {
		$("#spanMailRecommendation").html("<div id=\"Spinner\" class=\"Spinner\"><img width=\"100\" height=\"100\" src=\"./img/static/ajax-loader-GoldenRod.gif\" alt=\"\" /></div>");
		var email = $("input[name='email']").val();
		var posting = $.post("/SendMailRecommendation", {recommender: <%= recommenderIdLogged %>, action: <%= request.getParameter("action") %>, email: email, addRec: <%= request.getParameter("id") %>});
		posting.done(function(data) {
			$("#spanMailRecommendation").empty().append(data);
			$("#spanMailRecommendation").append("<br />Send to Another Friend <%= session.getAttribute("RecommenderLoggedNickname") %>!");
			$("input[name='email']").val("");
		});
	}	
});

<% } else { %>

$("#FriendRecommendationForm").validate({rules: rules, messages: messages,
	submitHandler: function (form) {
		$("#spanMailRecommendation").html("<div id=\"Spinner\" class=\"Spinner\"><img width=\"100\" height=\"100\" src=\"./img/static/ajax-loader-GoldenRod.gif\" alt=\"\" /></div>"); 
		var email = $("input[name='email']").val();
		var name = $("input[name='name']").val();
		var posting = $.post("/SendMailRecommendationNonLogged", {recommender: name, action: <%= request.getParameter("action") %>, email: email, addRec: <%= request.getParameter("id") %>});
		posting.done(function(data) {
			$("#spanMailRecommendation").empty().append(data);
			$("#spanMailRecommendation").append("<br />Send to Another Friend "+name+"!");
			$("input[name='email']").val("");
		});
	}	
});

<% } %>

});

//-->
</script>

<form method="post" id="FriendRecommendationForm" action="" enctype="multipart/form-data">
<table id="FriendRecommendationTable" style="border-spacing: 0px;">
<tbody>

<% if((isRecommenderLogged) && (session.getAttribute("RecommenderLoggedNickname")) != null) { %>

<tr><td class="tdLeft SpaceForFields">Recommend as <span class="Nickname"><jsp:include page="RecommenderLogged.jsp" flush="true" /></span> To</td></tr>

<% } else { %>

<tr><td class="tdLeft SpaceForFields"><span class="Bold">Your Name</span></td></tr>
<tr><td class="tdLeft"><input type="text" style="width: 100%;" class="required" name="name" value="" /></td></tr>

<% } %>

<tr><td class="tdLeft SpaceForFields"><span class="Bold">Your Friend E-mail</span></td></tr>
<tr><td class="tdLeft"><input type="email" style="width: 100%;" class="required" name="email" value="" /></td></tr>

<tr><td class="tdLeft SpaceForFields"><input style="width: 100%;" type="submit" value="Send Recommendation" /></td></tr>

<tr><td class="tdLeft SpaceForFields"><span id="spanMailRecommendation"></span></td></tr>

</tbody>
</table>
</form>

<% } %>