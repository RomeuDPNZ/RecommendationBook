<!DOCTYPE html>

<html>

<head>

<title>Google+ JavaScript Quickstart</title>

<script src="https://apis.google.com/js/client:platform.js?onload=startApp" async defer></script>
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js" ></script>

<meta name="google-signin-client_id" content="990394207696-44kdrp5siq2f6hld2tqrb3ms5d5q6uqn.apps.googleusercontent.com"></meta>

</head>

<body>

<div id="gConnect"><div id="signin-button"></div></div>

<script type="text/javascript">

var auth2 = {};

var helper = (function() {
	return {
		onSignInCallback: function(authResult) {
			if (authResult.isSignedIn.get()) {
				helper.profile();
			} else if (authResult['error'] || authResult.currentUser.get().getAuthResponse() == null) {

			}
		},
		disconnect: function() {
			auth2.disconnect();
		},
		profile: function(){
			gapi.client.plus.people.get({
				'userId': 'me'
			}).then(function(res) {
				var profile = res.result;
				alert(profile.displayName+" "+profile.emails[0].value+" "+profile.birthday+" "+profile.gender);
			}, function(err) {
				var error = err.result;
				alert(error.message);
			});
		}
	};
})();

var updateSignIn = function() {
	if (auth2.isSignedIn.get()) {
		helper.onSignInCallback(gapi.auth2.getAuthInstance());
	}else{
		helper.onSignInCallback(gapi.auth2.getAuthInstance());
	}
}

function startApp() {
	gapi.load('auth2', function() {
		gapi.client.load('plus','v1').then(function() {
			gapi.signin2.render('signin-button', {
				scope: 'https://www.googleapis.com/auth/plus.login',
				fetch_basic_profile: false });
			gapi.auth2.init({fetch_basic_profile: false,
				scope:'https://www.googleapis.com/auth/plus.login'}).then(
					function (){
						$("#signin-button").click(function() {
							auth2 = gapi.auth2.getAuthInstance();
							auth2.isSignedIn.listen(updateSignIn);
							auth2.then(updateSignIn());
						});
			});
		});
	});
}

</script>

</body>

</html>