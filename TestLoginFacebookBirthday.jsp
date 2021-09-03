
<%@ include file="Validation.jsp" %>

<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%

		String birthday = "30-09-1983";

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

			Validation v = new Validation();

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

		out.print(birthdate);

		//out.print(" Year = "+year+" Month = "+month+" Day = "+day);

%>