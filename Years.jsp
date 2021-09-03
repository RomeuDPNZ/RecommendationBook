<%!

public class PrintYears {

	public PrintYears() {

	}

	public String getSelect(Integer i, Boolean session) {
		if(session) {
			return "<option value=\""+i+"\" selected=\"selected\">"+i+"</option>";
		} else {
			return "<option value=\""+i+"\">"+i+"</option>";
		}
	}

}

%>

<%

	String from = request.getParameter("from");
	String to = request.getParameter("to");
	String timeline = request.getParameter("timeline");

	if("now".equals(to)) {
		to = new java.text.SimpleDateFormat("yyyy").format(new java.util.Date());
	}

	if("now".equals(from)) {
		from = new java.text.SimpleDateFormat("yyyy").format(new java.util.Date());
	}

	Integer f = Integer.valueOf(from);
	Integer t = Integer.valueOf(to);

	if(!timeline.equals("true")) {
		if("".equals(session.getAttribute("yearS"))) {
			out.print("<option value=\"\"></option>");
		} else {
			out.print("<option value=\"\" selected=\"selected\"></option>");
		}
	} 

	PrintYears py = new PrintYears();

	if(f < t) {
		for(int i=f;i<=t;i++) {
			out.print(py.getSelect(i, String.valueOf(i).equals(session.getAttribute("yearS"))));
		}
	} else if(t < f) {
		for(int i=f;i>=t;i--) {
			out.print(py.getSelect(i, String.valueOf(i).equals(session.getAttribute("yearS"))));
		}
	}

%>