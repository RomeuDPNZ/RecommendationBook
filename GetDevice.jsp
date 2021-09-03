
<%
	String device = "Desktop";

	if(request.getHeader("User-Agent") != null) {

		device = ""+request.getHeader("User-Agent").toString()+"";

	}

	// device = "Mobile";

	session.setAttribute("GetDevice", device);
%>