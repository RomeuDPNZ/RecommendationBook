
<!DOCTYPE html>

<html lang="en-US">

<head>
 
<title>Recommendation Book</title>
 
<meta name="keywords" content="Recommending on Recommendation Book" />
<meta name="description" content="Recommending on Recommendation Book" />

<link rel="icon" href="./img/static/RBIcon.ico" type="image/x-icon">

<link href='http://fonts.googleapis.com/css?family=Roboto:500' rel='stylesheet' type='text/css'>

<style type="text/css">
<!--
   @import url("RecommendationBookCSS.css");

.ui-effects-transfer { border: 2px dotted gray; }

-->
</style>
<link rel="stylesheet" type="text/css" media="screen" href="RecommendationBookCSS.css" />
 
<script src="js/jquery-1.10.2.js"></script>
<script src="js/jquery-ui.js"></script>
<script src="js/RecommendationBookJS.js"></script>
<script type="text/javascript" src="js/ImagePreview.js"></script>
<script type="text/javascript" src="js/TextAreaCounter.js"></script>

<script type="text/javascript" src="js/jquery.validate.js"></script>
<script type="text/javascript" src="js/jquery.validate.min.js"></script>
<script type="text/javascript" src="js/additional-methods.js"></script>
<script type="text/javascript" src="js/additional-methods.min.js"></script>

<script type="text/javascript" src="js/ValidateMethods.js"></script>

<script type="text/javascript"> 
<!--

$(document).ready(function(){

	$("#PreviewImage").change(function(){
		if(!isMSIE()) {
			readURL(this, "DivImagePreview", "ImagePreview");
		}
	});

	TextAreaCounter("#TAAbout", "div.TextAreaCounter", 20000);

var rules = {
	'image': { required: false, extension: "jpg|png|gif|bmp", imageCantBeBiggerThanNBytes: '10000000' }
};

var messages = {
	'image': { extension: "Only .jpg File Extensions Are Accepted" }
};

	$("#AddRecommended").validate({rules:rules, messages:messages});

});

//-->
</script>

</head>

<body>

<div class="Geral">
	<jsp:include page="MiniMenu.jsp" flush="true" />
	<div class="Corpo">
		<form method="post" id="AddRecommended" action="TestImageValidation.jsp" enctype="multipart/form-data">
				<div id="InputHiddens"></div>
				<table class="listras" style="border-spacing: 0px;">
				<thead>
				<tr>
				<td colspan="3">
<h1 class="Action">You Are Now Testing the Image Redution of Quality and Converion of Type...</h1><br />
				</td>
				</tr>
				</thead>
				<tbody>

				<tr>
					<td class="tdRight">Image</td>
					<td class="tdLeft"><input type="file" class="required" name="image" accept="image/*" id="PreviewImage" /><div id="DivImagePreview"></div></td>
					<td><span class="Nickname">Image Cannot Be Bigger Than 50Kb and Only .jpg File Extensions Are Accepted</span></td>
				</tr>
<% if("true".equals(session.getAttribute("ImageIsBiggerThan50KBytes")) || "true".equals(session.getAttribute("ImageExtensionIsNotAccepted"))) { %>
				<tr>
					<td></td>
					<td>
<span class="error"><% if("true".equals(session.getAttribute("ImageIsBiggerThan50KBytes"))) { out.print("Image Cannot be Bigger Than 50Kb!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("ImageExtensionIsNotAccepted"))) { out.print("Only .jpg File Extensions Are Accepted!"); } %></span>
					</td>
					<td></td>
				</tr>
<% } %>

				<tr><td class="tdRight"></td><td class="tdLeft"><input type="submit" value="Add To Recommendation Book" /></td><td></td></tr>
				</tbody>
				</table>
		</form>
	</div>
	<jsp:include page="Rodape.jsp" flush="true" />
</div>

</body>
 
</html>
