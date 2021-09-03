
/* ****************************** WidthStaticAt ****************************** */

function WidthStaticAt(atWidth) {

	function setWidth(atWidth) {
		if($(window).width() < atWidth) {
			$("html").css("text-align","center");
			$("body").css("text-align","center");
			$("div.Geral").css("margin","0px auto");
			$("div.Geral").css("width",""+atWidth+"px");
		} else if($(window).width() > atWidth) {
			$("div.Geral").css("margin","0px");
			$("div.Geral").css("width","auto");
		}
	}

	$(document).ready(function(){

		setWidth(atWidth)

		$(window).resize(function() {
			setWidth(atWidth)
		});

	});

}

/* ****************************** DLWidth ****************************** */

function DLWidth() {

	function setDLWidth() {
		$("dl.user").css("width",""+$('dl.user').parent().parent().width()-40+"px");
	}

	$(window).bind("load", function() {

		setDLWidth();

		/* alert($('dl.user').parent().parent().get(0).tagName); */

		$(window).resize(function() {
			setDLWidth();
		});
	});

}

/* ****************************** AboutWidth ****************************** */

function AboutWidth() {

	function setAboutWidth() {
		$("div.AboutPerson").css("width",""+$('div.AboutPerson').parent().parent().width()-40+"px");
	}

	$(window).bind("load", function() {

		setAboutWidth();

		$(window).resize(function() {
			setAboutWidth();
		});
	});

}

/* ****************************** DLWidthMobile ****************************** */

function DLWidthMobile() {

	function setDLWidthMobile() {
		$("dl.user").css("width",""+$('dl.user').parent().parent().width()-40+"px");
	}

	$(window).bind("load", function() {

		setDLWidthMobile();

		/* alert($('dl.user').parent().parent().get(0).tagName); */

		$(window).resize(function() {
			setDLWidthMobile();
		});
	});

}

/* ****************************** AboutWidthMobile ****************************** */

function AboutWidthMobile() {

	function setAboutWidthMobile() {
		$("div.AboutPerson").css("width",""+$('div.AboutPerson').parent().parent().width()-40+"px");
	}

	$(window).bind("load", function() {

		setAboutWidthMobile();

		$(window).resize(function() {
			setAboutWidthMobile();
		});
	});

}

/* ****************************** MultipleSelectCheckbox ****************************** */

$(document).ready(function(){
	$(".MultipleSelectExtendedOutro").hide();
});

$(document).ready(function(){

	function CheckedCheckbox(cb) {

		if(cb.is(":checked")) {

			if(cb.parents(".MultipleSelectExtendedOutro").length == 1) {
				cb.parent().addClass("MultipleSelectExtendedOutro-on");
			} else {
				cb.parent().addClass("multiselect-on");
			}

			cb.parent().next(".MultipleSelectExtendedOutro").slideDown();

		} else {

			if(cb.parents(".MultipleSelectExtendedOutro").length == 1) {
				cb.parent().removeClass("MultipleSelectExtendedOutro-on");
			} else {
				cb.parent().removeClass("multiselect-on");
			}

			cb.parent().next(".MultipleSelectExtendedOutro").slideUp();

		}

	}

	$.each($("input[type=checkbox]:checked"), function() {
		CheckedCheckbox($(this));
	});

	$("input[type=checkbox]").click(function(){
		CheckedCheckbox($(this));
	});

});

/*

$(document).ready(function(){

	$(this).each(function() {
		var checkboxes = $(this).find("input:checkbox");

		checkboxes.each(function() {
			var checkbox = $(this);

			function CheckedCheckbox(cb) {

				if (cb.attr("checked")) {

					if(cb.parents(".MultipleSelectExtendedOutro").length == 1) {
						cb.parent().addClass("MultipleSelectExtendedOutro-on");
					} else {
						cb.parent().addClass("multiselect-on");
					}

					cb.parent().next(".MultipleSelectExtendedOutro").slideDown();

				} else {

					if(cb.parents(".MultipleSelectExtendedOutro").length == 1) {
						cb.parent().removeClass("MultipleSelectExtendedOutro-on");
					} else {
						cb.parent().removeClass("multiselect-on");
					}

					cb.parent().next(".MultipleSelectExtendedOutro").slideUp();

				}

			}
 
			CheckedCheckbox(checkbox);

			checkbox.click(function() {
				CheckedCheckbox(checkbox);
			});
		});
	});
});

*/
