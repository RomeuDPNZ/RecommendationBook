<%@ page import="java.util.regex.*" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.Vector" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.Recommended" %>
<%@ page import="recBook.RecommendedDAO" %>
<%@ page import="recBook.DoesIdExists" %>

<%@ page import="java.sql.SQLException" %>

<%@ page import="java.net.URL" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.net.URLConnection" %>

<!DOCTYPE html>

<html lang="en-US">

<head>
 
<title>Recommendation Book</title>
 
<meta name="keywords" content="" />
<meta name="description" content="" />
 
<style type="text/css">
<!--
   @import url("RecommendationBookCSS.css");
-->
</style>
<link rel="stylesheet" type="text/css" media="screen" href="RecommendationBookCSS.css" />
 
<script type="text/javascript"> 
<!--

//-->
</script>

</head>

<body>

<div class="Geral">

<%!

public class Words {

	private String wordNew;
	private String wordOld;

	public Words() {
	}

	public String getWordNew() {
		return this.wordNew;
	}

	public void setWordNew(String wordNew) {
		this.wordNew = wordNew;
	}

	public String getWordOld() {
		return this.wordOld;
	}

	public void setWordOld(String wordOld) {
		this.wordOld = wordOld;
	}

}

%>

<%

	String about = "                            \n\n\nhttps://stackoverflow.com/questions stackoverflow teste #14# teste www.stackoverflow.com/questions?email=romeuprado@hotmail.coma-zA-Z0-9-+&@#/%?=~_|!:,.; mailto:a-zA-Z0-9._%-+romeuprado@a-zA-Z0-9-.hotmail.com romeuprado@hotmail.com #123 teste 456# teste #12345# teste http://www.stackoverflow.com/questions # teste ## teste ### teste stackoverflow.com/questions #11# teste #1# http://stackoverflow.com/questions #Pro+Trek #Metal http://recommendationbook.com/Recommended.jsp?id=131\n\n\n                           45.01\n\nhttps://youtu.be/vNPIFm7Gsf0 (My English Review)\nhttps://youtu.be/pNt_G1o_iSI (Meu Review Em Português)";

	// Invalid escape sequence (valid ones are  \b  \t  \n  \f  \r  \"  \'  \\ )
	// http://docs.oracle.com/javase/specs/jls/se7/html/jls-3.html#jls-3.10.6

	// Melhor até agora
	// about = about.replaceAll("(((((http|https|ftp|mailto:)(://))?)+)((www.)?)([\\-a-zA-Z0-9+&@#/%?=~_|!:,.;]+[.][a-zA-Z0-9\\-+&@#/%?=~_|!:,.;]+))", "<a href=\"//$9\" target=\"_blank\">$1</a>");

	// Esses também funcionam
	// about = about.replaceAll("^(((((http|https|ftp)(://))?)+)((www.)?)((?<!mailto:)(?<!@)[a-zA-Z0-9\\-]+[.][a-zA-Z0-9\\-+&@#/%?=~_|!:,.;]+))$", "<a href=\"//$9\" target=\"_blank\">$1</a>");
	// about = about.replaceAll("^(((mailto:)?)([a-zA-Z0-9._%\\-+]+[@][a-zA-Z0-9\\-.]+))$", "<a href=\"mailto:$4\" target=\"_blank\">$1</a>");
	// about = about.replaceAll("^((#){1}([a-zA-Z0-9+]+))$", "<a href=\"http://recommendationbook.com/DoSearch.jsp?search=$3\" target=\"_blank\">$1</a>");
	// about = about.replaceAll("^([\\t\\n\\s])$", "Matched");

	out.print("<br />"+about);

	about = about.trim();

	char[] aboutArray = about.toCharArray();

	Integer beginIndex = 0;
	Integer endIndex = 0;

	Vector<String> vector = new Vector<String>();

	for(char s : aboutArray) {

		++endIndex;
		
		String letter = String.valueOf(s);

		if(Pattern.matches("^([\\t\\s\\f\\r])$", letter)) {
			String word = about.substring(beginIndex, endIndex-1);
			vector.add(word);
			vector.add(letter);
			beginIndex = endIndex;
		}

	}

	vector.add(about.substring(beginIndex, endIndex));

	Iterator i = vector.iterator();

	String aboutOutro = "";

	String regexURL = "^(((((http|https|ftp)(://))?)+)((www.)?)((?<!mailto:)(?<!@)[a-zA-Z0-9\\-]+[.][a-z]+[a-zA-Z0-9\\-+&@#/%?=~_|!:,.;]+))$";
	String regexEmail = "^(((mailto:)?)([a-zA-Z0-9._%\\-+]+[@][a-zA-Z0-9\\-.]+))$";
	String regexSearch = "^((#){1}([a-zA-Z0-9+]+))$";

	while(i.hasNext()) {
		String word = (String) i.next();

		if(Pattern.matches(regexURL, word)) {
			word = word.replaceAll(regexURL, "<a href=\"//$9\" target=\"_blank\">$1</a>");	
		} else if(Pattern.matches(regexEmail, word)) {
			word = word.replaceAll(regexEmail, "<a href=\"mailto:$4\" target=\"_blank\">$1</a>");	
		} else if(Pattern.matches(regexSearch, word)) {
			word = word.replaceAll(regexSearch, "<a href=\"http://recommendationbook.com/DoSearch.jsp?search=$3\" target=\"_blank\">$1</a>");	
		} 

		aboutOutro = aboutOutro + word;
	}

	about = aboutOutro;
	aboutArray = about.toCharArray();

	Boolean tralha = false;
	String id = "";

	/*
	 * Conecta ao Banco de Dados
	 */

	DB db = new DB();
	db.ConectaDB();
	db.Atualiza("USE RecommendationBook");

	if(db.conexao == null) {
		System.err.println("DB Connection Error: "+db.conexao);
	}

	String output = "";
	Recommended recommended = new Recommended();
	RecommendedDAO recommendedDAO = new RecommendedDAO(db);
	DoesIdExists doesIdExists = new DoesIdExists();

	for(char s : aboutArray) {
		
		String letter = String.valueOf(s);

		if(tralha) {
			if(Pattern.matches("^([0-9]+)$", letter)) {
				id += letter;
			} else if(letter.equals("#") && !id.equals("")) {

				try {

					if(doesIdExists.check("Recommended", (Long.valueOf(id)))) {
						recommended = recommendedDAO.select(Long.valueOf(id));
						output = "<a href=\"Recommended.jsp?id="+id+"\">"+recommended.getName()+"</a>";
					} else {
						output = "<span class=\"error\">Id "+id+" Not Found</span>";
					}

				} catch(SQLException e) {
					System.err.println("SQLException: "+e.getMessage());

					/*
					 * Desconecta do Banco de Dados
					 */

					if(db.conexao != null) {
						db.DesconectaDB();
					}
				} finally { }

				out.print("<br />"+id);

				about = about.replace("#"+id+"#", output);
				id = "";
			} else {
				tralha = false;
				id="";
			}
		}

		if(letter.equals("#")) {
			tralha = true;
		}

	}


	/*
	 * Desconecta do Banco de Dados
	 */

	if(db.conexao != null) {
		db.DesconectaDB();
	}

	out.print("<br />"+about);

%>

</div>

</body>
 
</html>
