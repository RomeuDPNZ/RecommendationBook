
<!DOCTYPE html>

<html lang="en-US">

<head>
 
<title>Recommendation Book</title>
 
<meta name="keywords" content="" />
<meta name="description" content="" />

<link rel="icon" href="./img/static/RBIcon.ico" type="image/x-icon">

<link href='http://fonts.googleapis.com/css?family=Roboto:500' rel='stylesheet' type='text/css'>

<style type="text/css">

</style>
<link rel="stylesheet" type="text/css" media="screen" href="RecommendationBookCSS.css" />

<script src="js/jquery-1.10.2.js"></script>
<script type="text/javascript"> 
<!--

$(document).ready(function () {

	$("a.Recommended").on('mouseenter', function () {

		var id = $(this).attr("id");

		if($("div#"+id+"").is(":empty")) {

			$("div#"+id+"").load("getImage.jsp?img="+id+"");

		} else {

			$("div#"+id+"").show();
		}

	}).on('mouseleave', function () {

		var id = $(this).attr("id");

		$("div#"+id+"").hide();

	});;

});

//-->
</script>

</head>

<body>

<div class="Geral">
<jsp:include page="CabecalhoMenu.jsp" flush="true" />
<jsp:include page="Search.jsp" flush="true" />

	<div class="Corpo">
		<div class="Column">
			<fieldset>
				<legend>Persons</legend>
				<table cellspacing="5" cellpadding="0" width="100%">
				<tbody align="center" valign="middle">

<tr><td class="LightGrayBorder"><a class="Recommended" id="Recommended2" href="Recommended.jsp?id=2">Arnold Schwarzenegger</a> - <span class="green">3 recs</span><div id="Recommended2"></div></td></tr>

				</tbody>
				</table>
			</fieldset>
			<fieldset>
				<legend>Movies</legend>
				<table cellspacing="5" cellpadding="0" width="100%">
				<tbody align="center" valign="middle">

<tr><td class="LightGrayBorder"><a class="Recommended" id="Recommended56" href="Recommended.jsp?id=56">Predator</a> - <span class="green">3 recs</span><div id="Recommended56"></div></td></tr>
<tr><td class="LightGrayBorder"><a class="Recommended" id="Recommended25" href="Recommended.jsp?id=56">Predator</a> - <span class="green">3 recs</span><div id="Recommended25"></div></td></tr>
<tr><td class="LightGrayBorder"><a class="Recommended" id="Recommended35" href="Recommended.jsp?id=56">Predator</a> - <span class="green">3 recs</span><div id="Recommended35"></div></td></tr>
<tr><td class="LightGrayBorder"><a class="Recommended" id="Recommended40" href="Recommended.jsp?id=56">Predator</a> - <span class="green">3 recs</span><div id="Recommended40"></div></td></tr>
<tr><td class="LightGrayBorder"><a class="Recommended" id="Recommended70" href="Recommended.jsp?id=56">Predator</a> - <span class="green">3 recs</span><div id="Recommended70"></div></td></tr>
<tr><td class="LightGrayBorder"><a class="Recommended" id="Recommended80" href="Recommended.jsp?id=56">Predator</a> - <span class="green">3 recs</span><div id="Recommended80"></div></td></tr>

				</tbody>
				</table>
			</fieldset>
			<fieldset>
				<legend>Songs</legend>
				<table cellspacing="5" cellpadding="0" width="100%">
				<tbody align="center" valign="middle">
				<tr><th rowspan="2"><a href="Recommended.jsp?id=12"><img src="./img/user/Recommended12.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=12">Paranoid</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">1</span></td></tr>
<tr><th rowspan="2"><a href="Recommended.jsp?id=99"><img src="./img/user/Recommended99.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=99">Into the Stadiums</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">1</span></td></tr>
<tr><td colspan="2" class="LightGrayBorder"><a href="MostRecommended.jsp?type=Song">See The 1000 Most Recommended Songs</a></td></tr>

				</tbody>
				</table>
			</fieldset>
			<fieldset>
				<legend>Companies</legend>
				<table cellspacing="5" cellpadding="0" width="100%">
				<tbody align="center" valign="middle">
				<a href="AddRecommender.jsp">Nothing yet! Be the first to add a Company!</a>

				</tbody>
				</table>
			</fieldset>
			<fieldset>
				<legend>Foods</legend>
				<table cellspacing="5" cellpadding="0" width="100%">
				<tbody align="center" valign="middle">
				<tr><th rowspan="2"><a href="Recommended.jsp?id=6"><img src="./img/user/Recommended6.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=6">Hot Dog</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">1</span></td></tr>
<tr><th rowspan="2"><a href="Recommended.jsp?id=7"><img src="./img/user/Recommended7.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=7">Coffee</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">1</span></td></tr>
<tr><td colspan="2" class="LightGrayBorder"><a href="MostRecommended.jsp?type=Food">See The 1000 Most Recommended Foods</a></td></tr>

				</tbody>
				</table>
			</fieldset>
			<fieldset>
				<legend>Guns</legend>
				<table cellspacing="5" cellpadding="0" width="100%">
				<tbody align="center" valign="middle">
				<tr><th rowspan="2"><a href="Recommended.jsp?id=85"><img src="./img/user/Recommended85.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=85">Glock 43</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">1</span></td></tr>
<tr><th rowspan="2"><a href="Recommended.jsp?id=87"><img src="./img/user/Recommended87.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=87">FN P90</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">1</span></td></tr>
<tr><th rowspan="2"><a href="Recommended.jsp?id=92"><img src="./img/user/Recommended92.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=92">HK UMP</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">1</span></td></tr>
<tr><td colspan="2" class="LightGrayBorder"><a href="MostRecommended.jsp?type=Gun">See The 1000 Most Recommended Guns</a></td></tr>

				</tbody>
				</table>
			</fieldset>
			<fieldset>
				<legend>Motorcycles</legend>
				<table cellspacing="5" cellpadding="0" width="100%">
				<tbody align="center" valign="middle">
				<tr><th rowspan="2"><a href="Recommended.jsp?id=17"><img src="./img/user/Recommended17.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=17">XJ 600N</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">5</span></td></tr>
<tr><th rowspan="2"><a href="Recommended.jsp?id=30"><img src="./img/user/NoImageAvailable.png" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=30">Harley Davidson</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">1</span></td></tr>
<tr><th rowspan="2"><a href="Recommended.jsp?id=31"><img src="./img/user/NoImageAvailable.png" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=31">Harley Davidson Sporter Hugger</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">1</span></td></tr>
<tr><td colspan="2" class="LightGrayBorder"><a href="MostRecommended.jsp?type=Motorcycle">See The 1000 Most Recommended Motorcycles</a></td></tr>

				</tbody>
				</table>
			</fieldset>
		</div>
		<div class="Column">
			<fieldset>
				<legend>Groups</legend>
				<table cellspacing="5" cellpadding="0" width="100%">
				<tbody align="center" valign="middle">
				<tr><th rowspan="2"><a href="Recommended.jsp?id=1"><img src="./img/user/Recommended1.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=1">Coen Brothers</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">3</span></td></tr>
<tr><th rowspan="2"><a href="Recommended.jsp?id=34"><img src="./img/user/Recommended34.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=34">Burgundy News Team</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">2</span></td></tr>
<tr><th rowspan="2"><a href="Recommended.jsp?id=65"><img src="./img/user/Recommended65.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=65">The Doomgoryum Guys</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">1</span></td></tr>
<tr><td colspan="2" class="LightGrayBorder"><a href="MostRecommended.jsp?type=Group">See The 1000 Most Recommended Groups</a></td></tr>

				</tbody>
				</table>
			</fieldset>
			<fieldset>
				<legend>Bands</legend>
				<table cellspacing="5" cellpadding="0" width="100%">
				<tbody align="center" valign="middle">
				<tr><th rowspan="2"><a href="Recommended.jsp?id=4"><img src="./img/user/Recommended4.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=4">Bullet</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">1</span></td></tr>
<tr><th rowspan="2"><a href="Recommended.jsp?id=22"><img src="./img/user/Recommended22.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=22">Goddess of Desire</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">1</span></td></tr>
<tr><th rowspan="2"><a href="Recommended.jsp?id=23"><img src="./img/user/Recommended23.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=23">Manowar</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">1</span></td></tr>
<tr><td colspan="2" class="LightGrayBorder"><a href="MostRecommended.jsp?type=Band">See The 1000 Most Recommended Bands</a></td></tr>

				</tbody>
				</table>
			</fieldset>
			<fieldset>
				<legend>Projects</legend>
				<table cellspacing="5" cellpadding="0" width="100%">
				<tbody align="center" valign="middle">
				<tr><th rowspan="2"><a href="Recommended.jsp?id=15"><img src="./img/user/Recommended15.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=15">The Vertical Farm</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">1</span></td></tr>
<tr><td colspan="2" class="LightGrayBorder"><a href="MostRecommended.jsp?type=Project">See The 1000 Most Recommended Projects</a></td></tr>

				</tbody>
				</table>
			</fieldset>
			<fieldset>
				<legend>Products</legend>
				<table cellspacing="5" cellpadding="0" width="100%">
				<tbody align="center" valign="middle">
				<tr><th rowspan="2"><a href="Recommended.jsp?id=21"><img src="./img/user/Recommended21.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=21">Dolce Gusto Piccolo</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">1</span></td></tr>
<tr><th rowspan="2"><a href="Recommended.jsp?id=27"><img src="./img/user/Recommended27.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=27">Olight M18 Striker</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">1</span></td></tr>
<tr><th rowspan="2"><a href="Recommended.jsp?id=61"><img src="./img/user/Recommended61.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=61">Leatherman Super Tool 300</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">1</span></td></tr>
<tr><th rowspan="2"><a href="Recommended.jsp?id=69"><img src="./img/user/Recommended69.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=69">Leatherman Style PS</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">1</span></td></tr>
<tr><th rowspan="2"><a href="Recommended.jsp?id=81"><img src="./img/user/Recommended81.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=81">Google Chromecast</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">1</span></td></tr>
<tr><th rowspan="2"><a href="Recommended.jsp?id=97"><img src="./img/user/Recommended97.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=97">Cold Steel Vietnam Tomahawk</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">1</span></td></tr>
<tr><td colspan="2" class="LightGrayBorder"><a href="MostRecommended.jsp?type=Product">See The 1000 Most Recommended Products</a></td></tr>

				</tbody>
				</table>
			</fieldset>
			<fieldset>
				<legend>Games</legend>
				<table cellspacing="5" cellpadding="0" width="100%">
				<tbody align="center" valign="middle">
				<tr><th rowspan="2"><a href="Recommended.jsp?id=5"><img src="./img/user/Recommended5.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=5">Rock And Roll Racing</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">2</span></td></tr>
<tr><th rowspan="2"><a href="Recommended.jsp?id=18"><img src="./img/user/Recommended18.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=18">FAR CRY 3</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">1</span></td></tr>
<tr><td colspan="2" class="LightGrayBorder"><a href="MostRecommended.jsp?type=Game">See The 1000 Most Recommended Games</a></td></tr>

				</tbody>
				</table>
			</fieldset>
			<fieldset>
				<legend>Knives</legend>
				<table cellspacing="5" cellpadding="0" width="100%">
				<tbody align="center" valign="middle">
				<tr><th rowspan="2"><a href="Recommended.jsp?id=100"><img src="./img/user/Recommended100.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=100">Spyderco Perrin PPT Black</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">1</span></td></tr>
<tr><th rowspan="2"><a href="Recommended.jsp?id=77"><img src="./img/user/Recommended77.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=77">Cold Steel Urban Edge Double Serrated Edge</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">1</span></td></tr>
<tr><th rowspan="2"><a href="Recommended.jsp?id=76"><img src="./img/user/Recommended76.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=76">Cold Steel Rajah III Serrated Edge</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">1</span></td></tr>
<tr><th rowspan="2"><a href="Recommended.jsp?id=75"><img src="./img/user/Recommended75.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=75">Cold Steel Rajah II</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">1</span></td></tr>
<tr><th rowspan="2"><a href="Recommended.jsp?id=74"><img src="./img/user/Recommended74.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=74">Cold Steel FGX Push Blade I</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">1</span></td></tr>
<tr><th rowspan="2"><a href="Recommended.jsp?id=73"><img src="./img/user/Recommended73.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=73">Cold Steel Double Agent II Plain Edge</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">1</span></td></tr>
<tr><th rowspan="2"><a href="Recommended.jsp?id=62"><img src="./img/user/Recommended62.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=62">Cold Steel Espada Large</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">1</span></td></tr>
<tr><th rowspan="2"><a href="Recommended.jsp?id=28"><img src="./img/user/Recommended28.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=28">Spyderco Tatanka</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">1</span></td></tr>
<tr><th rowspan="2"><a href="Recommended.jsp?id=25"><img src="./img/user/Recommended25.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=25">Zero Tolerance 770CF</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">1</span></td></tr>
<tr><th rowspan="2"><a href="Recommended.jsp?id=16"><img src="./img/user/Recommended16.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=16">Hardcore Hardware Australia MFK03G</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">1</span></td></tr>
<tr><td colspan="2" class="LightGrayBorder"><a href="MostRecommended.jsp?type=Knife">See The 1000 Most Recommended Knives</a></td></tr>

				</tbody>
				</table>
			</fieldset>
		</div>
		<div class="Column">
			<fieldset>
				<legend>Books</legend>
				<table cellspacing="5" cellpadding="0" width="100%">
				<tbody align="center" valign="middle">
				<tr><th rowspan="2"><a href="Recommended.jsp?id=98"><img src="./img/user/Recommended98.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=98">Deitel C Plus Plus How to Program 5th Edition</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">1</span></td></tr>
<tr><th rowspan="2"><a href="Recommended.jsp?id=11"><img src="./img/user/Recommended11.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=11">Confessions of an Economic Hitman</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">0</span></td></tr>
<tr><td colspan="2" class="LightGrayBorder"><a href="MostRecommended.jsp?type=Book">See The 1000 Most Recommended Books</a></td></tr>

				</tbody>
				</table>
			</fieldset>
			<fieldset>
				<legend>Albums</legend>
				<table cellspacing="5" cellpadding="0" width="100%">
				<tbody align="center" valign="middle">
				<tr><th rowspan="2"><a href="Recommended.jsp?id=24"><img src="./img/user/Recommended24.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=24">Bloodsport Soundtrack</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">2</span></td></tr>
<tr><th rowspan="2"><a href="Recommended.jsp?id=84"><img src="./img/user/Recommended84.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=84">Squawk</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">2</span></td></tr>
<tr><th rowspan="2"><a href="Recommended.jsp?id=59"><img src="./img/user/Recommended59.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=59">1984</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">2</span></td></tr>
<tr><th rowspan="2"><a href="Recommended.jsp?id=13"><img src="./img/user/Recommended13.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=13">Powerslave</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">1</span></td></tr>
<tr><th rowspan="2"><a href="Recommended.jsp?id=60"><img src="./img/user/Recommended60.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=60">Witch Hunter</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">1</span></td></tr>
<tr><th rowspan="2"><a href="Recommended.jsp?id=40"><img src="./img/user/Recommended40.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=40">Whitesnake 1987</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">1</span></td></tr>
<tr><th rowspan="2"><a href="Recommended.jsp?id=38"><img src="./img/user/Recommended38.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=38">Chasing the Dream</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">1</span></td></tr>
<tr><th rowspan="2"><a href="Recommended.jsp?id=37"><img src="./img/user/Recommended37.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=37">Head of the Pack</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">1</span></td></tr>
<tr><th rowspan="2"><a href="Recommended.jsp?id=36"><img src="./img/user/Recommended36.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=36">Twilight of the Gods</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">1</span></td></tr>
<tr><th rowspan="2"><a href="Recommended.jsp?id=93"><img src="./img/user/Recommended93.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=93">Graveyard Classics</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">1</span></td></tr>
<tr><td colspan="2" class="LightGrayBorder"><a href="MostRecommended.jsp?type=Album">See The 1000 Most Recommended Albums</a></td></tr>

				</tbody>
				</table>
			</fieldset>
			<fieldset>
				<legend>Websites</legend>
				<table cellspacing="5" cellpadding="0" width="100%">
				<tbody align="center" valign="middle">
				<a href="AddRecommender.jsp">Nothing yet! Be the first to add a Website!</a>

				</tbody>
				</table>
			</fieldset>
			<fieldset>
				<legend>Places</legend>
				<table cellspacing="5" cellpadding="0" width="100%">
				<tbody align="center" valign="middle">
				<tr><th rowspan="2"><a href="Recommended.jsp?id=54"><img src="./img/user/Recommended54.jpg" width="100px" height="100px" /></a><td class="LightGrayBorder"><a href="Recommended.jsp?id=54">United States of America</a></td></th></tr><tr><td class="LightGrayBorder"><span class="green">1</span></td></tr>
<tr><td colspan="2" class="LightGrayBorder"><a href="MostRecommended.jsp?type=Place">See The 1000 Most Recommended Places</a></td></tr>

				</tbody>
				</table>
			</fieldset>
			<fieldset>
				<legend>Recommenders</legend>
				<table cellspacing="5" cellpadding="0" width="100%">
				<tbody align="center" valign="middle">
				

<tr><td class="LightGrayBorder"><a class="Recommended" id="Recommender4" href="Recommender.jsp?id=4">Cod_junior</a>- <span class="green">4 recs</span><div id="Recommender4"></div></td></tr>

<tr><td class="LightGrayBorder"><a class="Recommended" id="Recommender1" href="Recommender.jsp?id=1">PowerMadHeadBanger</a> - <span class="green">3 recs</span><div id="Recommender1"></div></td></tr>

				</tbody>
				</table>
			</fieldset>
			<fieldset>
				<legend>Cars</legend>
				<table cellspacing="5" cellpadding="0" width="100%">
				<tbody align="center" valign="middle">
				<a href="AddRecommender.jsp">Nothing yet! Be the first to add a Car!</a>

				</tbody>
				</table>
			</fieldset>
		</div>
	</div>
<jsp:include page="Rodape.jsp" flush="true" />
</div>

</body>
 
</html>
