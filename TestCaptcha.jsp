<!DOCTYPE html>

<html lang="en-US">

<head>
 
<title>Recommendation Book</title>
 
<meta name="keywords" content="" />
<meta name="description" content="" />
 
<style type="text/css">
<!--
   @import url("RecommendationBookCSS.css");
-->
</style>
<link rel="stylesheet" type="text/css" media="screen" href="RecommendationBookCSS.css" />
 
<script src='https://www.google.com/recaptcha/api.js'></script>

<script type="text/javascript"> 
<!--

//-->
</script>

</head>

<body>

<div class="Geral">

		<form method="post" action="TestCaptchaValidation.jsp" enctype="multipart/form-data">
				<table class="listras" style="border-spacing: 0px;">
				<thead>
				<tr>
				<td colspan="3">
<h1 class="Action">You Are Now Testing Captcha...</h1><br />
<span class="Action Bold">Fields in Bold Are Required</span>
				</td>
				</tr>
				</thead>
				<tbody>

				<tr><td class="tdRight"><span class="Bold">Enter Captcha</span></td>
				<td class="tdLeft">
					<div class="g-recaptcha" data-sitekey="6LdQqvwSAAAAAMNiEciF2_Sp1xndgsleTvtiz7jV"></div>
				</td>
				<td></td>
				</tr>
<% if("true".equals(session.getAttribute("CaptchaIsWrong")))  { %>
				<tr>
					<td></td><td><span class="error">Incorrect Captcha! Enter Captcha Again!</span></td><td></td>
				</tr>
<% } %>

				<tr><td class="tdRight"></td><td class="tdLeft"><input type="submit" value="Test Captcha" /></td><td></td></tr>

				</tbody>
				</table>
		</form>
	</div>

</div>

</body>
 
</html>
