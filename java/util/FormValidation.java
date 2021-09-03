
package recBook;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

import java.util.regex.Pattern;
import java.util.regex.Matcher;

import net.tanesha.recaptcha.ReCaptchaImpl;
import net.tanesha.recaptcha.ReCaptchaResponse;

/* javac -cp .;%CATALINA_HOME%\lib\servlet-api.jar;%CATALINA_HOME%\webapps\ImageUpload-ApacheCommons\WEB-INF\lib\recaptcha4j-0.0.7.jar FormValidation.java */

public class FormValidation extends HttpServlet {

	HttpSession session;
	String remoteAddr;

	public FormValidation(HttpServletRequest request) {
		session = request.getSession(true);
		remoteAddr = request.getRemoteAddr();
	}

	public Boolean isEmpty(String field, String setAttribute) {
		Boolean containError = false;

		if((field == null) || (field.equals(""))) {
			session.setAttribute(setAttribute, "true");
			containError = true;
		} else {
			session.setAttribute(setAttribute, "");
		}

		return containError;
	}

	public Boolean isBiggerThanNCharacters(String field, Integer max, String setAttribute) {
		Boolean containError = false;

		if(field.matches(".{0,"+max+"}") == false) {
			session.setAttribute(setAttribute, "true");
			containError = true;
		} else {
			session.setAttribute(setAttribute, "");
		}

		return containError;
	}

	public Boolean isTextAreaBiggerThanNCharacters(String field, Integer max, String setAttribute) {
		Boolean containError = false;

		Pattern p = Pattern.compile(".{0,"+max+"}", Pattern.DOTALL);
		Matcher m = p.matcher(field);

		if(m.matches() == false) {
			session.setAttribute(setAttribute, "true");
			containError = true;
		} else {
			session.setAttribute(setAttribute, "");
		}

		return containError;
	}

	public Boolean hasTextAreaMoreThanNLineBreaks(String field, Integer max, String setAttribute) {
		Boolean containError = false;

		if((field.split("\n")).length > max) {
			session.setAttribute(setAttribute, "true");
			containError = true;
		} else {
			session.setAttribute(setAttribute, "");
		}

		return containError;
	}

	public Boolean isFileEmpty(Long size, String setAttribute) {
		Boolean containError = false;

		if(size <= 0l) {
			session.setAttribute(setAttribute, "true");
			containError = true;
		} else {
			session.setAttribute(setAttribute, "");
		}

		return containError;
	}

	public Boolean isFileBiggerThanNBytes(Long size, Long max, String setAttribute) {
		Boolean containError = false;

		if(size > max) {
			session.setAttribute(setAttribute, "true");
			containError = true;
		} else {
			session.setAttribute(setAttribute, "");
		}

		return containError;
	}

	public Boolean isFileExtensionNotAccepted(String extension, String setAttribute) {
		Boolean containError = false;

		if(extension.matches("jpg") == false) {
			session.setAttribute(setAttribute, "true");
			containError = true;
		} else {
			session.setAttribute(setAttribute, "");
		}

		return containError;
	}

	public Boolean isCaptchaWrong(String challenge, String uresponse, String setAttribute) {
		Boolean containError = false;

		ReCaptchaImpl reCaptcha = new ReCaptchaImpl();
		reCaptcha.setPrivateKey("6LdQqvwSAAAAABKN8ktbyXwzsOsXzFHHCucctMcY");

		ReCaptchaResponse reCaptchaResponse = reCaptcha.checkAnswer(remoteAddr, challenge, uresponse);

		if(!(reCaptchaResponse.isValid())) {
			session.setAttribute(setAttribute, "true");
			containError = true;
		} else {
			session.setAttribute(setAttribute, "");
		}

		return containError;
	}

}