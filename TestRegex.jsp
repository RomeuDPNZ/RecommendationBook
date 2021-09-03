
<%@ page import="java.util.regex.*" %>

<%

	String regexLetters = ".*[a-zA-Z]{6,}.*";
	String regexNumbers = ".*[0-9]{2,}.*";
	String regexCharacters = ".*[#+-_]{1,}.*";

	String password = "testet19#";

	out.print("<br /><br />String is: "+password);
	out.print("<br />Regex is: "+Pattern.matches(regexLetters, password));
	out.print("<br />Regex is: "+Pattern.matches(regexNumbers, password));
	out.print("<br />Regex is: "+Pattern.matches(regexCharacters, password));

	password = "recbookpp";

	out.print("<br /><br />String is: "+password);
	out.print("<br />Regex is: "+Pattern.matches(regexLetters, password));
	out.print("<br />Regex is: "+Pattern.matches(regexNumbers, password));
	out.print("<br />Regex is: "+Pattern.matches(regexCharacters, password));

	password = "19#teste+";

	out.print("<br /><br />String is: "+password);
	out.print("<br />Regex is: "+Pattern.matches(regexLetters, password));
	out.print("<br />Regex is: "+Pattern.matches(regexNumbers, password));
	out.print("<br />Regex is: "+Pattern.matches(regexCharacters, password));

	password = "qwerty#12345";

	out.print("<br /><br />String is: "+password);
	out.print("<br />Regex is: "+Pattern.matches(regexLetters, password));
	out.print("<br />Regex is: "+Pattern.matches(regexNumbers, password));
	out.print("<br />Regex is: "+Pattern.matches(regexCharacters, password));

	password = "#1912testes";

	out.print("<br /><br />String is: "+password);
	out.print("<br />Regex is: "+Pattern.matches(regexLetters, password));
	out.print("<br />Regex is: "+Pattern.matches(regexNumbers, password));
	out.print("<br />Regex is: "+Pattern.matches(regexCharacters, password));

	password = "teste-19#teste-19";

	out.print("<br /><br />String is: "+password);
	out.print("<br />Regex is: "+Pattern.matches(regexLetters, password));
	out.print("<br />Regex is: "+Pattern.matches(regexNumbers, password));
	out.print("<br />Regex is: "+Pattern.matches(regexCharacters, password));

%>