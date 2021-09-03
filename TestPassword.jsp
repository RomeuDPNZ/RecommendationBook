
<%@ include file="Validation.jsp" %>

<%

	Validation v = new Validation();

	String password = "testet19#";

	out.print("<br /><br />String is: "+password);
	out.print("<br />Password Validation is: "+v. isPasswordValid(password));

	password = "recbookpp";

	out.print("<br /><br />String is: "+password);
	out.print("<br />Password Validation is: "+v. isPasswordValid(password));

	password = "19#teste+";

	out.print("<br /><br />String is: "+password);
	out.print("<br />Password Validation is: "+v. isPasswordValid(password));

	password = "qwerty#12345";

	out.print("<br /><br />String is: "+password);
	out.print("<br />Password Validation is: "+v. isPasswordValid(password));

	password = "#1912testes";

	out.print("<br /><br />String is: "+password);
	out.print("<br />Password Validation is: "+v. isPasswordValid(password));

	password = "teste-19#teste-19";

	out.print("<br /><br />String is: "+password);
	out.print("<br />Password Validation is: "+v. isPasswordValid(password));

	password = "recbook19";

	out.print("<br /><br />String is: "+password);
	out.print("<br />Password Validation is: "+v. isPasswordValid(password));

	password = "19#r";

	out.print("<br /><br />String is: "+password);
	out.print("<br />Password Validation is: "+v. isPasswordValid(password));

	password = "194564789#";

	out.print("<br /><br />String is: "+password);
	out.print("<br />Password Validation is: "+v. isPasswordValid(password));

	password = "#rec_12_redt";

	out.print("<br /><br />String is: "+password);
	out.print("<br />Password Validation is: "+v. isPasswordValid(password));

	password = "rec12redt";

	out.print("<br /><br />String is: "+password);
	out.print("<br />Password Validation is: "+v. isPasswordValid(password));

	password = "#rec_1_redt";

	out.print("<br /><br />String is: "+password);
	out.print("<br />Password Validation is: "+v. isPasswordValid(password));

	password = "#recBOOK#19";

	out.print("<br /><br />String is: "+password);
	out.print("<br />Password Validation is: "+v. isPasswordValid(password));

	password = "#recBOOK+19";

	out.print("<br /><br />String is: "+password);
	out.print("<br />Password Validation is: "+v. isPasswordValid(password));

	password = "#recBOOK-19";

	out.print("<br /><br />String is: "+password);
	out.print("<br />Password Validation is: "+v. isPasswordValid(password));

	password = "#recBOOK_19";

	out.print("<br /><br />String is: "+password);
	out.print("<br />Password Validation is: "+v. isPasswordValid(password));

%>
