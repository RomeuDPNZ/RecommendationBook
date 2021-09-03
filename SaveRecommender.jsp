
<%@ page errorPage="Error.jsp" %>  

<%@ page import="recBook.PageViewsDAOOutro" %>

<%

	try {

		new PageViewsDAOOutro().incrementPageViews("SaveRecommender");

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

%>

<%@ page import="java.sql.SQLException" %>

<%@ page import="java.text.SimpleDateFormat" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.AwaitingConfirmation" %>
<%@ page import="recBook.AwaitingConfirmationDAO" %>

<%@ include file="SendMail.jsp" %>
<%@ page import="recBook.Cryptography" %>
<%@ page import="recBook.RandomGenerator" %>

<%
	String nickName = (String) session.getAttribute("nickNameS");
	String sex = (String) session.getAttribute("sexS");
	String country = (String) session.getAttribute("countryS");
	String year = (String) session.getAttribute("yearS");
	String month = (String) session.getAttribute("monthS");
	String day = (String) session.getAttribute("dayS");
	String officialWebsite = (String) session.getAttribute("officialWebsiteS");
	String about = (String) session.getAttribute("aboutS");
	String extensao = (String) session.getAttribute("imageExtension");
	byte[] imagem = (byte[]) session.getAttribute("image");
	String email = (String) session.getAttribute("emailS");
	String password = (String) session.getAttribute("passwordS");

	/*
	 * Criptografa Password
	 */

	byte[] pcBytes = {};

	try {

		Cryptography c = new Cryptography(password);

		pcBytes = c.Encrypt(password);

	} catch(Exception e) {
		System.err.println("CryptographyException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	}

	/*
	 * Gera Codigo de Confirmacao
	 */

	RandomGenerator rlg = new RandomGenerator();
	String codigoDeConfirmacao = rlg.getLettersAndNumbers();

	AwaitingConfirmation ac = new AwaitingConfirmation();

	ac.setEmail(email);
	ac.setPassword(pcBytes);
	ac.setRoleFromMySQL("Recommender");
	ac.setCode(codigoDeConfirmacao);
	ac.setNickName(nickName);
	ac.setSexFromMySQL(sex);
	ac.setCountry(Integer.valueOf(country));
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	ac.setBirthDate(sdf.parse(year+"-"+month+"-"+day));
	ac.setOfficialWebsite(officialWebsite);
	ac.setAbout(about);
	ac.setExtensionImage(extensao);
	ac.setImage(imagem);

	/*
	 * Conecta ao Banco de Dados
	 */

	DB db = new DB();
	db.ConectaDB();

	if(db.conexao == null) {
		System.err.println("DB Connection Error: "+db.conexao);
	}

	AwaitingConfirmationDAO acDAO = new AwaitingConfirmationDAO(db);

	/*
	* INSERT
	*/

	Long acId = 0l;

	try {

		acId = acDAO.insert(ac);

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally {

		/*
		 * Desconecta do Banco de Dados
		 */

		if(db.conexao != null) {
			db.DesconectaDB();
		}

	}

	session.setAttribute("nickNameS", "");
	session.setAttribute("sexS", "");
	session.setAttribute("countryS", "");
	session.setAttribute("yearS", "");
	session.setAttribute("monthS", "");
	session.setAttribute("dayS", "");
	session.setAttribute("officialWebsiteS", "");
	session.setAttribute("aboutS", "");
	session.setAttribute("emailS", "");
	session.setAttribute("remailS", "");
	session.setAttribute("passwordS", "");
	session.setAttribute("image", "");
	session.setAttribute("imageExtension", "");
	session.setAttribute("imageTamanho", "");

	/*
	 * Envia Email com Codigo de Confirmacao
	 */

	String url = request.getRequestURL().toString();

	if(url.contains("localhost:8080")) {
		url = "http://localhost:8080/";
	} else if(url.contains("localhost:8989")) {
		url = "http://localhost:8989/";
	} else {
		url = "http://recommendationbook.com";
	}

	String from = "recommendationbook@gmail.com";
	String subject = "Recommendation Book Registration Confirmation";
	String c = codigoDeConfirmacao;
	String id = acId.toString();
	String text = "<a href=\""+url+"/MailConfirmation.jsp?code="+c+"&id="+id+"\">"+url+"/MailConfirmation.jsp?code="+c+"&id="+id+"</a>";

	SendMail sm = new SendMail(email, from, subject, text);

	try {
		sm.Send();
	} catch(Exception e) {
		System.err.println("EmailException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new Exception(e.getMessage()+" Page: "+pageName);
		}
	}

	response.sendRedirect("MessageToRecommender.jsp?id=1");
%>