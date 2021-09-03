<option value="" <% if("".equals(session.getAttribute("sexS"))) { out.print("selected=\"selected\""); } %>></option>	
<option value="Male" <% if("Male".equals(session.getAttribute("sexS"))) { out.print("selected=\"selected\""); } %>>Male</option>
<option value="Female" <% if("Female".equals(session.getAttribute("sexS"))) { out.print("selected=\"selected\""); } %>>Female</option>