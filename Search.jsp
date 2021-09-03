<%
	String searched = "";

	if(session.getAttribute("SearchString") != null) {
		searched = session.getAttribute("SearchString").toString();
	}
%>

<% if(session.getAttribute("GetDevice").toString().contains("Mobi")) { %>
	<div class="Search">
		<form method="get" action="DoSearch.jsp">
			<fieldset>
				<input class="Search" type="text" name="search" style="width: 75%;" value="<%= searched %>" />
				<input class="SearchButton" type="submit" style="width: 20%;" value="Search" />
			</fieldset>
		</form>
	</div>
<% } else { %>
	<div class="Search">
		<form method="get" action="DoSearch.jsp">
			<fieldset>
				<input class="Search" type="text" name="search" size="75" value="<%= searched %>" />
				<input class="SearchButton" type="submit" value="Search" />
			</fieldset>
		</form>
	</div>
<% } %>