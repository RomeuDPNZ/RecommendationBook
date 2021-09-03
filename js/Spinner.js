
	function CentralizeDiv() {
		$("div.Spinner").css("top",""+((($(window).height())/2)-(($("div.Spinner").height())/2)+$(window).scrollTop())+"px");
		$("div.Spinner").css("left",""+(($(window).width())/2)-(($("div.Spinner").width())/2)+"px");
	}
