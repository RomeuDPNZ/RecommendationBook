<%
	Cookie[] cookies = request.getCookies();

	Boolean isRecommenderLogged = false;

	if(cookies != null) {

	for(Cookie cookie:cookies) {
 		if(cookie.getName().equals("IsRecommenderLogged")) {
			if(cookie.getValue().equals("Yes")) {
				isRecommenderLogged = true;
			}
		}
	}

	}

%>
	<div class="Cabecalho">
		<div class="ConteudoCabecalhoE">
			<a href="index.jsp"><img width="200" height="100" src="./img/static/LogoTransparencia.png" alt="Recommendation Book" /></a>
		</div>
		<div class="ConteudoCabecalhoC">
			<h1 class="slogan">Recommend your World</h1>
		</div>
		<div class="ConteudoCabecalhoD" style="width: 30%;">
			<div style="width: calc(100% - 0px); word-wrap: break-word;"><jsp:include page="RecommenderLogged.jsp" flush="true" /></div>
		</div>
	</div>
	<div class="Menu">
		<ul class="Menu">
<% if(isRecommenderLogged.equals(false)) { %>
			<li class="Menu"><a class="Menu" href="Login.jsp">Login</a></li>
			<li class="Menu"><a class="Menu" href="AddRecommender.jsp">Register</a></li>
<% } %>
			<li class="Menu"><a class="Menu" href="AddRecommended.jsp">Recommend Something</a></li>
			<li class="Menu"><a class="Menu" href="About.jsp">What's the Recommendation Book?</a></li>
			<li class="Menu"><a class="Menu" href="Contact.jsp">Contact</a></li>
		</ul>
	</div>