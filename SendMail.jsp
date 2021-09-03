<%@ page import="java.util.Date" %>
<%@ page import="java.util.Properties" %>
<%@ page import="javax.mail.Message" %>
<%@ page import="javax.mail.MessagingException" %>
<%@ page import="javax.mail.Session" %>
<%@ page import="javax.mail.Transport" %>
<%@ page import="javax.mail.internet.AddressException" %>
<%@ page import="javax.mail.internet.InternetAddress" %>
<%@ page import="javax.mail.internet.MimeMessage" %>

<%!

public class SendMail {

	public String to;
	public String from;
	public String subject;
	public String message;

	public SendMail(String to, String from, String subject, String message) {
		this.to = to;
		this.from = from;
		this.subject = subject;
		this.message = message;
	}

	public void Send() throws Exception {

		Properties props = System.getProperties();  
 
		props.put("mail.smtp.host","smtp.gmail.com");   
		props.put("mail.smtp.auth", "true");   
		props.put("mail.debug", "true");   
		props.put("mail.smtp.debug", "true");   
		props.put("mail.mime.charset", "ISO-8859-1");   
		props.put("mail.smtp.port", "465");   
		props.put ("mail.smtp.starttls.enable", "true");   
		props.put ("mail.smtp.socketFactory.port", "465");   
		props.put ("mail.smtp.socketFactory.fallback", "false");   
		props.put ("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");  
        
		Session session = Session.getDefaultInstance(props);
                 
		InternetAddress destinatario = new InternetAddress(to);  
		InternetAddress remetente = new InternetAddress(from);  
  
		Message msg = new MimeMessage(session);  
		//msg.setSentDate(new java.util.Date());
		msg.setFrom(remetente);  
		msg.setRecipient(Message.RecipientType.TO, destinatario);  
		msg.setSubject(subject);  
		msg.setContent(message.toString(), "text/HTML");  
		msg.saveChanges();

		Transport transport = session.getTransport("smtp");  
		transport.connect("smtp.gmail.com","recommendationbook", "***********");    
		transport.sendMessage(msg, msg.getAllRecipients());  
		transport.close();  

	}

}

%>
