
function FormOneToMany(load, manyDiv, manyInput, manyAdd, manyCancel, oneDiv, oneSelect, oneAdd, oneCancel, oneToManyAdd, oneToManyReset, oneToManyContent, addButton, resetButton, instructions, output) {

	var lastSelectJobsCalled = "";
	var groupBeingUpdated = "none";

	$("#"+oneDiv+"").hide();
	$("#"+manyDiv+"").hide();

	$("#"+oneToManyAdd+"").click(function() {

		$("#"+oneDiv+"").css("top",""+((($(window).height())/2)-(($("#"+oneDiv+"").height())/2)+$(window).scrollTop())+"px");
		$("#"+oneDiv+"").css("left",""+(($(window).width())/2)-(($("#"+oneDiv+"").width())/2)+"px");

		$("#"+oneDiv+"").show().effect("highlight", {}, 500);
	});

	function AppendMovieCrewPerson(optionValue) {

		$("#"+oneToManyContent+"").append("<div class=\"MovieCrewPerson\" id=\""+output+""+optionValue+"\">"+$("select[name="+oneSelect+"] option[value=\""+optionValue+"\"]").text()+"<img class=\"ImageDeleteMovieCrewPerson\" id=\"ImageDelete"+output+""+optionValue+"\" src=\"./img/static/Delete.png\" alt=\"\" /><input type=\"hidden\" name=\""+output+""+optionValue+"\" value=\"M"+optionValue+"\" \/><div class=\"MovieCrewPersonJobs\" id=\""+output+"Jobs"+optionValue+"\"><\/div><br \/><br \/><input type=\"button\" id=\"Select"+output+"Jobs"+optionValue+"\" name=\""+optionValue+"\" value=\""+addButton+"\" \/><input type=\"button\" id=\"Reset"+output+"Jobs"+optionValue+"\" name=\""+optionValue+"\" value=\""+resetButton+"\" \/><br \/><span class=\"Instruction\">"+instructions+"<\/span><\/div>");

		$("#Reset"+output+"Jobs"+optionValue+"").click(function() {
			if(confirm("Reset All?")) {
				$("#"+output+"Jobs"+$(this).attr("name")+"").empty();
			}
		});

		$("#Select"+output+"Jobs"+optionValue+"").click(function() {

			lastSelectJobsCalled = $(this).attr("name");

			if(($("#"+output+"GroupOfJobs"+lastSelectJobsCalled+"").length > 0) == false) {

			$("#"+manyDiv+"").css("top",""+((($(window).height())/2)-(($("#"+manyDiv+"").height())/2)+$(window).scrollTop())+"px");
			$("#"+manyDiv+"").css("left",""+(($(window).width())/2)-(($("#"+manyDiv+"").width())/2)+"px");

			$("#"+manyDiv+"").show().effect("highlight", {}, 500);

			} else {
				alert("The Jobs were Already Added. Now You can Only Update or Delete The Jobs Already Added.");
			}

			groupBeingUpdated = "none";

		});

		$("#ImageDelete"+output+""+optionValue+"").click(function() {

			$(this).parent().fadeOut(300, function(){
				$(this).remove();
			});

			$("select[name="+oneSelect+"] option[value=\""+optionValue+"\"]").prop("disabled", false);
		});

		$("select[name="+oneSelect+"]  option[value=\""+optionValue+"\"]").prop("disabled", true);
		$("select[name="+oneSelect+"] option:not([disabled]):first-child").attr("selected", "selected");

	}

	function AppendMovieCrewPersonJobs() {

		var groupOfJobs = ""+output+"GroupOfJobs"+lastSelectJobsCalled+"";

		if(groupBeingUpdated == "none") {

			$("#"+output+"Jobs"+lastSelectJobsCalled+"").append("<div class=\"GroupOfJobs\" id=\""+groupOfJobs+"\"><img class=\"ImageDeleteMovieCrewPerson\" id=\"ImageDelete"+output+""+groupOfJobs+"\" src=\"./img/static/Delete.png\" alt=\"\" /><img class=\"ImageUpdateMovieCrewPerson\" id=\"ImageUpdate"+output+""+groupOfJobs+"\" name=\""+lastSelectJobsCalled+"\" src=\"./img/static/Update.png\" alt=\"\" /><\/div>");

		} else {

			$("#"+groupOfJobs+"").empty();

			$("#"+groupOfJobs+"").append("<img class=\"ImageDeleteMovieCrewPerson\" id=\"ImageDelete"+output+""+groupOfJobs+"\" src=\"./img/static/Delete.png\" alt=\"\" /><img class=\"ImageUpdateMovieCrewPerson\" id=\"ImageUpdate"+output+""+groupOfJobs+"\" name=\""+lastSelectJobsCalled+"\" src=\"./img/static/Update.png\" alt=\"\" />");

		}

		$("#ImageDelete"+output+""+groupOfJobs+"").click(function() {
			$(this).parent().fadeOut(300, function(){
				$(this).remove();
			});
		});

		$("#ImageUpdate"+output+""+groupOfJobs+"").click(function() {

			lastSelectJobsCalled = $(this).attr("name");
			groupBeingUpdated = $(this).attr("name");

			$.each($("#"+output+"GroupOfJobs"+lastSelectJobsCalled+" :input"), function() {
				$("input[name="+manyInput+"][value='"+$(this).val()+"']").click();
			});

			$("#"+manyDiv+"").css("top",""+((($(window).height())/2)-(($("#"+manyDiv+"").height())/2)+$(window).scrollTop())+"px");
			$("#"+manyDiv+"").css("left",""+(($(window).width())/2)-(($("#"+manyDiv+"").width())/2)+"px");

			$("#"+manyDiv+"").show().effect("highlight", {}, 500);

		});

	}

	function AppendJob(inputValue) {

		var groupOfJobs = ""+output+"GroupOfJobs"+lastSelectJobsCalled+"";

		var checkbox = $("input[name="+manyInput+"][value=\""+inputValue+"\"]");

		$("#"+groupOfJobs+"").append(""+checkbox.parent().text()+"<input type=\"hidden\" name=\""+output+""+lastSelectJobsCalled+"\" value=\""+checkbox.val()+"\" \/><br \/>"); 

	}

	$("#"+oneAdd+"").click(function() {

		var optionValue = $("select[name="+oneSelect+"]").val();

		if(optionValue != "0") {

			AppendMovieCrewPerson(optionValue);

			$("#"+output+""+optionValue+"").hide().fadeIn("fast");

			$("#"+oneDiv+"").effect("transfer", {to: "#"+oneToManyAdd+"", className: "ui-effects-transfer"}, 500).hide();

		}

	});

	$("#"+oneCancel+"").click(function() {
		$("#"+oneDiv+"").effect("transfer", {to: "#"+oneToManyAdd+"", className: "ui-effects-transfer"}, 500).hide();
	});

	$("#"+oneToManyReset+"").click(function() {
		if(confirm("Delete All?")) {
			$("#"+oneToManyContent+"").empty();
			$("select[name="+oneSelect+"] option").prop("disabled", false);
		}
	});

	$("#"+manyAdd+"").click(function() {

		var containError = false;

		if(!($("input[name="+manyInput+"]").is(":checked"))) {
			alert("Select at Least One Job");
			containError = true;
		}

		if(containError == false) {

		var groupOfJobs = ""+output+"GroupOfJobs"+lastSelectJobsCalled+"";

		AppendMovieCrewPersonJobs();

		$.each($("input[name="+manyInput+"]:checked"), function() {
			$("#"+groupOfJobs+"").append(""+$(this).parent().text()+"<input type=\"hidden\" name=\""+output+""+lastSelectJobsCalled+"\" value=\""+$(this).val()+"\" \/><br \/>"); 

			$(this).click();
			$(this).parent().removeClass("multiselect-on");
		});

		$("input[name="+manyInput+"]").parent().parent().scrollTop(0);

		$("#"+manyDiv+"").effect("transfer", {to: "input[name="+lastSelectJobsCalled+"]", className: "ui-effects-transfer"}, 500).hide();

		}

	});

	$("#"+manyCancel+"").click(function() {
		$.each($("input[name="+manyInput+"]:checked"), function() {
			$(this).click();
			$(this).parent().removeClass("multiselect-on");
		});
		$("input[name="+manyInput+"]").parent().parent().scrollTop(0);

		$("#"+manyDiv+"").effect("transfer", {to: "input[name="+lastSelectJobsCalled+"]", className: "ui-effects-transfer"}, 500).hide();
	});

	/*
	AppendMovieCrewPerson("1");
	lastSelectJobsCalled = "1";
	AppendMovieCrewPersonJobs();
	AppendJob("1");
	*/

	for(var i=0;i<load.length;i++) {
		if(load[i].match("^M")) {
			AppendMovieCrewPerson(load[i].substr(1, load[i].length));
			lastSelectJobsCalled = load[i].substr(1, load[i].length);
			AppendMovieCrewPersonJobs();
		} else {
			AppendJob(load[i]);
		}
	}

}
