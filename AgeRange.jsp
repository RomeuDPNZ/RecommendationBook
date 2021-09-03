<%!

public class Ages {

	public Ages() {

	}

	public String getSelect(Integer i) {
		return "<option value=\""+i+"\">"+i+"</option>";
	}

}

%>

<%

	String from = request.getParameter("from");
	String to = request.getParameter("to");

	Integer f = Integer.valueOf(from);
	Integer t = Integer.valueOf(to);

	Ages ages = new Ages();

	out.print("<option value=\"\"></option>");

	if(f < t) {
		for(int i=f;i<=t;i++) {
			out.print(ages.getSelect(i));
		}
	} else if(t < f) {
		for(int i=f;i>=t;i--) {
			out.print(ages.getSelect(i));
		}
	}

%>