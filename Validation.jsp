<%@ page import="java.util.regex.*" %>

<%!

public class Validation {

	public Validation() {

	}

	public boolean isNicknameValid(String name) {
		CharSequence cs = name;

		Pattern p = Pattern.compile("^[\\w]{1,50}$");
		Matcher m = p.matcher(cs);

		return m.matches();
	}

	public boolean isNameValid(String name) {
		CharSequence cs = name;

		Pattern p = Pattern.compile("^[a-zA-Z0-9\\s]+$");
		Matcher m = p.matcher(cs);

		return m.matches();
	}

	public boolean isDescriptionValid(String description) {
		CharSequence cs = description;

		Pattern p = Pattern.compile("^[a-zA-Z0-9\\s]+$");
		Matcher m = p.matcher(cs);

		return m.matches();
	}

	public boolean isSubjectValid(String subject) {
		CharSequence cs = subject;

		Pattern p = Pattern.compile("^[a-zA-Z0-9\\s]+$");
		Matcher m = p.matcher(cs);

		return m.matches();
	}

	public boolean isDateValid(String years, String months, String days) {
		boolean result = true;

		if((!(years.equals(""))) && (!(months.equals(""))) && (!(days.equals("")))) {

		Integer year = Integer.valueOf(years);
		Integer month = Integer.valueOf(months);
		Integer day = Integer.valueOf(days);

		switch(month) {
			case 1:
			case 3:
			case 5:
			case 7:
			case 8:
			case 10:
			case 12:
				break;
			case 4:
			case 6:
			case 9:
			case 11:
				if(day > 30) {
					result = false;
				}
				break;
			case 2:
				if(((year % 4 == 0) && !(year % 100 == 0)) || (year % 400 == 0)) {
					if(day > 29) {
						result = false;
					}
				} else {
					if(day > 28) {
						result = false;
					}
				}
				break;
			default:
				break;
		}

		} else {
			result = false;
		}

		return result;
	}

	public boolean isWebsiteValid(String website) {
		boolean result = false;

		result = Pattern.matches("^([a-zA-Z0-9_.-]{1,100})$", website);

		return result;
	}

	public boolean isEmailValid(String email) {
		boolean result = false;

		result = Pattern.matches("^([a-zA-Z0-9_.-]+)@([a-z0-9_.-]+)$", email);

		return result;
	}

	public boolean isIdValid(String id) {
		boolean result = false;

		result = Pattern.matches("^([0-9]+)$", id);

		return result;
	}

	public boolean isCodeValid(String code) {
		boolean result = false;

		result = Pattern.matches("^([A-Z0-9]+)$", code);

		return result;
	}

	public boolean hasHTMLInjection(String text) {
		boolean result = false;

		if(text.contains("<") || text.contains(">")) {
			result = true;
		}

		return result;
	}

	public boolean isPasswordValid(String password) {
		boolean result = false;

		Integer letters = 0;
		Integer numbers = 0;
		Integer punctuations = 0;
		Integer prohibited = 0;

		char[] passwordArray = password.toCharArray();

		for(char s : passwordArray) {
		
			String character = String.valueOf(s);

			if(Pattern.matches("^[a-zA-Z]$", character)) {
				++letters;
			} else if(Pattern.matches("^[0-9]$", character)) {
				++numbers;
			} else if(Pattern.matches("^[#+-_]$", character)) {
				++punctuations;
			} else {
				++prohibited;
			}

		}

		if((letters >= 6) && (numbers >= 2) && (punctuations >= 1) && (prohibited.equals(0)) && (password.length() >= 9) && (password.length() <= 50)) {
			result = true;
		}

		return result;
	}

}

%>