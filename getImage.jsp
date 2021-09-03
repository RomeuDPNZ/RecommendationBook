<%@ page import="java.util.regex.*" %>

<%@ page import="recBook.IsImageRecorded" %>

<%

	String img = request.getParameter("img").toString();

	Pattern p = Pattern.compile("^(Recommended|Recommender)([0-9]+)$");
	Matcher m = p.matcher(img);

	String imagemNome = img+".jpg";
	String imagemOutro = "NoImageAvailable.png";

	if(m.matches()) {

		if(new IsImageRecorded().Exists(request, "\\img\\user\\", imagemNome)) {

			imagemOutro = imagemNome;

		}

	} else {

		imagemOutro = "NoImageAvailable.png";

	}

%>

<!DOCTYPE html>

<html lang="en-US">

<head>
 
<title>Recommendation Book</title>
 
<meta name="keywords" content="" />
<meta name="description" content="" />

<style type="text/css">

</style>
<link rel="stylesheet" type="text/css" media="screen" href="RecommendationBookCSS.css" />

<script type="text/javascript"> 
<!--

//-->
</script>

</head>

<body>

<div class="getImage"><fieldset><img src="./img/user/<%= imagemOutro %>" width="200" height="200" /></fieldset></div>

</body>
 
</html>
