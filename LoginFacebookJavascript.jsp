
<!DOCTYPE html>

<html>

<head>

<title>Facebook Login JavaScript Example</title>

<meta charset="UTF-8">

</head>

<body>

<script>

function statusChangeCallback(response) {
	if(response.status === 'connected') {
		testAPI();
	} else if(response.status === 'not_authorized') {
		
	} else {
		// The person is not logged into Facebook, so we're not sure if they are logged into this app or not.
	}
}

function checkLoginState() {
	FB.getLoginStatus(function(response) {
		statusChangeCallback(response);
	});
}

window.fbAsyncInit = function() {
	FB.init({
		appId : '1054429214574465',
		cookie : true,
		xfbml : true,
		version : 'v2.2'
	});

	FB.getLoginStatus(function(response) {
		statusChangeCallback(response);
	});
};

(function(d, s, id) {
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) return;
    js = d.createElement(s); js.id = id;
    js.src = "//connect.facebook.net/en_US/sdk.js";
    fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));

function testAPI() {
	FB.api('/me', function(response) {
	document.getElementById('status').innerHTML = ''+response.name+' '+response.email+' '+response.gender+' '+response.locale+' '+response.birthday+'';
	});
}

</script>

<fb:login-button scope="public_profile,email,user_birthday" onlogin="checkLoginState();"></fb:login-button>

<div id="status"></div>

</body>

</html>
