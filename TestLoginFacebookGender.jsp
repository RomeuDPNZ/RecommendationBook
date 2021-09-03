
<%

		String gender = "MALE";

		String sex;

		if(gender.toLowerCase().equals("male")) {
			sex = "Male";
		} else if(gender.toLowerCase().equals("female")) {
			sex = "Female";
		} else {
			sex = "Male";
		}

		out.print(sex);

%>