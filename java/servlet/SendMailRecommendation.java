
package recBook;

import java.sql.SQLException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import recBook.DB;

import recBook.SendMail;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class SendMailRecommendation extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request,response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		String friendEmail = (String) request.getParameter("email");
		Long recommender = Long.valueOf(request.getParameter("recommender"));
		Long addRec = Long.valueOf(request.getParameter("addRec"));
		Integer action = Integer.valueOf(request.getParameter("action"));

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
		 * Desconecta do Banco de Dados
		 */

		if(db.conexao != null) {
			db.DesconectaDB();
		}

		String from = "recommendationbook@gmail.com";
		String to = friendEmail;
		String subject = recommenderText+" "+actionText+" "+addRecText+" Especially to You on Recommendation Book";

		String text = "<span style=\"font-family: verdana, sans-serif; font-size: 18px; color: gray;\"><a href=\"http://recommendationbook.com/\"><img style=\"border: none; outline: none;\" width=\"110\" height=\"60\" src=\"http://recommendationbook.com/img/static/LogoTransparencia.png\" alt=\"Recommendation Book\" /></a><br /><br /><a style=\"color: GoldenRod; text-decoration: none;\" href=\"http://recommendationbook.com/Recommender.jsp?id="+recommender+"\">"+recommenderText+"</a> "+actionText+" <a style=\"color: GoldenRod; text-decoration: none;\" href=\"http://recommendationbook.com/"+page+".jsp?id="+addRec+"\">"+addRecText+"</a> Especially to You on <a style=\"color: GoldenRod; text-decoration: none;\" href=\"http://recommendationbook.com/\">Recommendation Book</a>";

		SendMail sm = new SendMail(to, from, subject, text);

		try {
			sm.Send();
		} catch(Exception e) {
	
		}

		PrintWriter out = response.getWriter();
		out.println("Recommendation Sent With Success!");
		out.close();

	}

}