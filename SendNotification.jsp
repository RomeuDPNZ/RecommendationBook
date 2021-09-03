
<%@ page errorPage="Error.jsp" %>

<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator" %>

<%@ page import="recBook.DB" %>

<%@ include file="SendMail.jsp" %>

<%!

public class SendNotification extends Thread {

	public Long recommender;
	public Long addRec;
	public Integer action;

	public SendNotification(Long recommender, Long addRec, Integer action) {
		this.recommender = recommender;
		this.addRec = addRec;
		this.action = action;
	}

	public void run() {
		try {
			this.Send();
		} catch(Exception e) {
			System.err.println("SendNotificationException: "+e.getMessage());
		}
	}

	public void Send() throws Exception {

		/*
		 * Conecta ao Banco de Dados
		 */

		DB db = new DB();
		db.ConectaDB();

		if(db.conexao == null) {
			System.err.println("DB Connection Error: "+db.conexao);
		}

		/*
		 * Get Nickname
		 */

		String recommenderText = "";

		try {
			PreparedStatement ps = db.conexao.prepareStatement("SELECT nickname as nickname FROM Recommender WHERE id = ?");
			ps.setLong(1, recommender);
			ResultSet result = ps.executeQuery();

			while(result.next()) {
				recommenderText = result.getString("nickname");
			}

		} catch(SQLException e) {

		} finally { }

		/*
		 * Get Action
		 */

		String actionText = "";

		try {
			PreparedStatement ps = db.conexao.prepareStatement("SELECT action as action FROM Actions WHERE id = ?");
			ps.setLong(1, action);
			ResultSet result = ps.executeQuery();

			while(result.next()) {
				actionText = result.getString("action");
			}

		} catch(SQLException e) {

		} finally { }

		/*
		 * Get Action
		 */

		String addRecText = "";
		String page = "Recommended";

		if(actionText.contains("Recommended the Recommender")) {

		page = "Recommender";

		try {
			PreparedStatement ps = db.conexao.prepareStatement("SELECT nickname as nickname FROM Recommender WHERE id = ?");
			ps.setLong(1, addRec);
			ResultSet result = ps.executeQuery();

			while(result.next()) {
				addRecText = result.getString("nickname");
			}

		} catch(SQLException e) {

		} finally { }

		} else {

		try {
			PreparedStatement ps = db.conexao.prepareStatement("SELECT name as name FROM Recommended WHERE id = ?");
			ps.setLong(1, addRec);
			ResultSet result = ps.executeQuery();

			while(result.next()) {
				addRecText = result.getString("name");
			}

		} catch(SQLException e) {

		} finally { }

		}

		/*
		 * Get recommenderEmail
		 */

		String recommenderEmail = "";
	
		try {
			PreparedStatement ps = db.conexao.prepareStatement("SELECT email as email FROM Login WHERE id = ?");
			ps.setLong(1, recommender);
			ResultSet result = ps.executeQuery();

			while(result.next()) {
				recommenderEmail = result.getString("email");
			}

		} catch(SQLException e) {

		} finally { }

		/*
		 * Get Emails
		 */

		List email = new ArrayList();
	
		try {
			PreparedStatement ps = db.conexao.prepareStatement("SELECT email as email FROM Login WHERE id IN (SELECT subscriber FROM Subscription WHERE recommender = ?)");
			ps.setLong(1, recommender);
			ResultSet result = ps.executeQuery();

			while(result.next()) {
				email.add(result.getString("email"));
			}

		} catch(SQLException e) {

		} finally { }

		/*
		 * Desconecta do Banco de Dados
		 */

		if(db.conexao != null) {
			db.DesconectaDB();
		}

		Iterator itr = email.iterator();

		if(email.isEmpty()) {
		
		} else {

			while(itr.hasNext()) {
				String userEmail = (String) itr.next();

				String from = "recommendationbook@gmail.com";
				String to = userEmail;
				String subject = recommenderText+" "+actionText+" "+addRecText;

				String text = "<span style=\"font-family: verdana, sans-serif; font-size: 18px; color: gray;\"><a href=\"http://recommendationbook.com/\"><img style=\"border: none; outline: none;\" width=\"110\" height=\"60\" src=\"http://recommendationbook.com/img/static/LogoTransparencia.png\" alt=\"Recommendation Book\" /></a><br /><br /><a style=\"color: GoldenRod; text-decoration: none;\" href=\"http://recommendationbook.com/Recommender.jsp?id="+recommender+"\">"+recommenderText+"</a> "+actionText+" <a style=\"color: GoldenRod; text-decoration: none;\" href=\"http://recommendationbook.com/"+page+".jsp?id="+addRec+"\">"+addRecText+"</a> on <a style=\"color: GoldenRod; text-decoration: none;\" href=\"http://recommendationbook.com/\">Recommendation Book</a>";

				SendMail sm = new SendMail(to, from, subject, text);

				try {
					sm.Send();
				} catch(Exception e) {
	
				}

			}

		}

	}

}

%>