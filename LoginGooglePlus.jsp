
<% if((request.getParameter("name") == null) || (request.getParameter("email") == null) || (request.getParameter("birthday") == null) || (request.getParameter("gender") == null)) { %>

	<jsp:forward page="/Login.jsp" />

<% } else { %>

<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%@ include file="Validation.jsp" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.DoesRecommenderExists" %>
<%@ page import="recBook.Login" %>
<%@ page import="recBook.LoginDAO" %>
<%@ page import="recBook.Recommender" %>
<%@ page import="recBook.RecommenderDAO" %>
<%@ page import="recBook.EmailDAO" %>
<%@ page import="recBook.ErrorServlet" %>
<%@ page import="recBook.Cryptography" %>
<%@ page import="recBook.PasswordGenerator" %>

<%@ page import="java.util.Date" %>
<%@ page import="java.util.Locale" %>

<%@ page import="java.text.SimpleDateFormat" %>

<%@ include file="SendMail.jsp" %>

<%

	String name = "";
	String email = "";
	String birthday = "";
	String genderFB = "";

	name = (String) request.getParameter("name");
	email = (String) request.getParameter("email");
	birthday = (String) request.getParameter("birthday");
	genderFB = (String) request.getParameter("gender");

	Long recommenderId = 0l;

	Boolean selectRecommenderId = false;
	Boolean redirectRecommender = false;

	Long emailFound = new EmailDAO().isEmailAlreadyRegistered(email);

	/*
	 * Conecta ao Banco de Dados
	 */

	DB db = new DB();
	db.ConectaDB();

	if(db.conexao == null) {
		System.err.println("DB Connection Error: "+db.conexao);
	}

	if(emailFound >= 1) {

		selectRecommenderId = true;
		redirectRecommender = true;

	} else {

		/*
		 * Construct Nickname From Name
		 */

		String nickname = name;

		String standardNickname = "Recommender";

		nickname = nickname.replaceAll("[^\\w_]", "");

		if(nickname.length() > 50) {
			nickname = nickname.substring(0, 50);
		}

		Long wasFound = 0l;

		Long lastId = 0l;
		Long lastIdOutro = 0l;

		/*
		 * Select
		 */

		try {
			PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) as lastId FROM Recommender");
			ResultSet result = ps.executeQuery();

			while(result.next()) {
				lastId = result.getLong("lastId");
				lastIdOutro = lastId;
			}

		} catch(SQLException e) {
			System.err.println("SQLException: "+e.getMessage());

			String uri = request.getRequestURI();
			String pageName = uri.substring(uri.lastIndexOf("/")+1);

			if(e.getMessage() != null) {
				throw new SQLException(e.getMessage()+" Page: "+pageName);
			}
		} finally {

		}

		if(!nickname.equals("")) {
			wasFound = new DoesRecommenderExists().check(nickname);
		} else {
			nickname = standardNickname;

			++lastId;

			do {
				nickname = nickname+""+lastId;
				wasFound = new DoesRecommenderExists().check(nickname);
				++lastId;
			} while(wasFound >= 1);
		}

		String nicknameOutro = nickname;

		if(wasFound >= 1) {

			++lastId;

			while(wasFound >= 1) {
				nickname = nicknameOutro+""+lastId;
				if(nickname.length() > 50) {
					Integer len = (""+lastId+"").length();
					nickname = nicknameOutro.substring(0, 50-len)+""+lastId;
				}
				wasFound = new DoesRecommenderExists().check(nickname);
				++lastId;
			}

		}

		Validation v = new Validation();

		if(v.isNicknameValid(nickname) == false) {

			nickname = standardNickname;

			lastId = lastIdOutro;

			++lastId;

			do {
				nickname = nickname+""+lastId;
				wasFound = new DoesRecommenderExists().check(nickname);
				++lastId;
			} while(wasFound >= 1);
		}

		/*
		 * Construct birthdate From birthday
		 */

		String birthdate = "";

		String day = "";
		String month = "";
		String year = "";

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String today = sdf.format(new Date()).toString();

		if(birthday.length() == 10) {

			day = birthday.substring(0,2);
			month = birthday.substring(3,5);
			year = birthday.substring(6,10);

			if(v.isDateValid(year, month, day) == false) {

				birthdate = today;

			} else {

				birthdate = year+"-"+month+"-"+day;
			}

			if(Integer.valueOf(month) > 12) {

				birthdate = today;

			}

		} else {

			birthdate = today;
		}

		/*
		 * Construct sex From genderFB
		 */

		String gender = genderFB;

		String sex = "";

		if(gender.toLowerCase().equals("male")) {
			sex = "Male";
		} else if(gender.toLowerCase().equals("female")) {
			sex = "Female";
		} else {
			sex = "Male";
		}

		/*
		 * Generate Password
		 */

		PasswordGenerator pg = new PasswordGenerator();

		String password = pg.getPassword();

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
		 * Insert New Recommender
		 */

		Login login = new Login();

		login.setEmail(email);
		login.setPassword(pcBytes);
		login.setRoleFromMySQL("Recommender");

		LoginDAO loginDAO = new LoginDAO(db);

		/*
		* INSERT - DELETE
		*/

		Long loginLong = 0l;

		try {

			db.conexao.setAutoCommit(false);

			loginLong = loginDAO.insert(login);

			Recommender recommender = new Recommender();

			recommender.setLogin(loginLong);
			recommender.setRecommendations(0l);
			recommender.setPageViews(0l);
			recommender.setNickName(nickname);
			recommender.setSexFromMySQL(sex);
			recommender.setCountry(1);
			recommender.setBirthDateFromMySQL(birthdate);
			recommender.setShowSex(true);
			recommender.setShowCountry(true);
			recommender.setShowBirth(true);
			recommender.setOfficialWebsite("");
			recommender.setAbout("");

			RecommenderDAO recommenderDAO = new RecommenderDAO(db);

			recommenderId = recommenderDAO.insert(recommender);

			db.conexao.commit();

		} catch(SQLException e) {
			db.conexao.rollback();
			System.err.println("Transaction Is Being Rolled Back: "+e.getMessage());

			String uri = request.getRequestURI();
			String pageName = uri.substring(uri.lastIndexOf("/")+1);

			if(e.getMessage() != null) {
				throw new SQLException(e.getMessage()+" Page: "+pageName);
			}
		} finally {

		}

			/*
			 * Envia Mensagem de Boas Vindas
			 */

			String from = "recommendationbook@gmail.com";
			String subject = "Welcome to Recommendation Book - Here is your Password";
			String text = "Welcome to Recommendation Book<br /><br />Here is Your Password in Case You Want to Login with the Conventional Recommendation Book login.<br /><br />Password: "+password+"";

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


		selectRecommenderId = true;
		redirectRecommender = true;

	}

	if(selectRecommenderId == true) {

		Login login = new Login();
		EmailDAO emailDAO = new EmailDAO();

		/*
		* Select
		*/

		try {

			login = emailDAO.select(email);

		} catch(SQLException e) {
			System.err.println("SQLException: "+e.getMessage());

			String uri = request.getRequestURI();
			String pageName = uri.substring(uri.lastIndexOf("/")+1);

			if(e.getMessage() != null) {
				throw new SQLException(e.getMessage()+" Page: "+pageName);
			}
		} finally {}

		/*
		 * Select
		 */

		try {
			PreparedStatement ps = db.conexao.prepareStatement("SELECT id FROM Recommender WHERE login = ?");
			ps.setLong(1, login.getId());
			ResultSet result = ps.executeQuery();

			while(result.next()) {
				recommenderId = result.getLong("id");
			}

		} catch(SQLException e) {
			System.err.println("SQLException: "+e.getMessage());

			String uri = request.getRequestURI();
			String pageName = uri.substring(uri.lastIndexOf("/")+1);

			if(e.getMessage() != null) {
				throw new SQLException(e.getMessage()+" Page: "+pageName);
			}
		} finally { }

	}

	/*
	 * Desconecta do Banco de Dados
	 */

	if(db.conexao != null) {
		db.DesconectaDB();
	}

	if(redirectRecommender == true) {

		/*
		session.setAttribute("isRecommenderLogged", "Yes");
		session.setAttribute("RecommenderId", ""+recommenderId.toString()+"");

		Cookie isRecommenderLogged = new Cookie("IsRecommenderLogged", "Yes");
		isRecommenderLogged.setMaxAge(365*24*60*60);
		response.addCookie(isRecommenderLogged);

		Cookie recommenderIdCookie = new Cookie("RecommenderId", ""+recommenderId.toString()+"");
		recommenderIdCookie.setMaxAge(365*24*60*60);
		response.addCookie(recommenderIdCookie);
		*/

		out.print(""+recommenderId.toString()+"");

	}	

%>

<% } %>
