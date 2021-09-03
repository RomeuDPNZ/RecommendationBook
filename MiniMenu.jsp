	<div class="Cabecalho Mini">
		<div class="ConteudoCabecalhoE">
			<!-- width="100" height="50" for 12px font -->
			<a href="index.jsp"><img width="110" height="60" src="./img/static/LogoTransparencia.png" alt="Recommendation Book" /></a>
		</div>
		<div class="ConteudoCabecalhoE" style="padding-top: 0.5em; padding-left: 1em;">
		<form method="get" action="DoSearch.jsp">
				<input class="SearchMini" type="text" size="30" name="search" value="" />
				<input class="SearchMini" type="submit" value="Search" />
		</form>
		</div>
		<div class="ConteudoCabecalhoD">
			<jsp:include page="RecommenderLogged.jsp" flush="true" />
		</div>
	</div>