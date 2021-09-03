
function FormOneToManyToMany(load, OMM_SelectTimeLine, OMM_manyToManyDiv, OMM_manyToManyDelete, OMM_manyDiv, OMM_manyInput, OMM_manyOtherTimeLines, OMM_manyAddAnotherTimeLine, OMM_manyAdd, OMM_manyCancel, OMM_oneDiv, OMM_oneSelect, OMM_oneAdd, OMM_oneAdd, OMM_oneCancel, OMM_Add, OMM_Reset, OMM_Content, OMM_addButton, OMM_resetButton, OMM_instructions, OMM_output) {

	var lastSelectInstrumentsCalled = "";
	var groupBeingUpdated = "none";
	var groupCount = 0;
	var groupOfInstruments = "";

	$("#"+OMM_oneDiv+"").hide();
	$("#"+OMM_manyDiv+"").hide();
	$("#"+OMM_manyToManyDiv+"").hide();

	$("#"+OMM_Add+"").click(function() {

		$("#"+OMM_oneDiv+"").css("top",""+((($(window).height())/2)-(($("#"+OMM_oneDiv+"").height())/2)+$(window).scrollTop())+"px");
		$("#"+OMM_oneDiv+"").css("left",""+(($(window).width())/2)-(($("#"+OMM_oneDiv+"").width())/2)+"px");

		$("#"+OMM_oneDiv+"").show().effect("highlight", {}, 500);
		/* $("#"+OMM_oneDiv+"").show().effect("shake", {}, 500); */
		/* $("#"+OMM_oneDiv+"").show().effect("bounce", {}, 500); */
	});

	function AppendMusician(optionValue) {

		/* Add"+OMM_output+" Reset"+OMM_output+" */

		$("#"+OMM_Content+"").append("<div class=\"Musician\" id=\""+OMM_output+""+optionValue+"\">"+$("select[name="+OMM_oneSelect+"] option[value=\""+optionValue+"\"]").text()+"<img class=\"ImageDeleteMusician\" id=\"ImageDelete"+OMM_output+""+optionValue+"\" src=\"./img/static/Delete.png\" alt=\"\" /><input type=\"hidden\" name=\""+OMM_output+""+optionValue+"\" value=\"M"+optionValue+"\" \/><div class=\"InstrumentsTimeLine\" id=\""+OMM_output+"TimeLine"+optionValue+"\"><\/div><br \/><br \/><input type=\"button\" id=\"Select"+OMM_output+""+optionValue+"\" name=\""+optionValue+"\" value=\""+OMM_addButton+"\" \/><input type=\"button\" id=\"Reset"+OMM_output+""+optionValue+"\" name=\""+optionValue+"\" value=\""+OMM_resetButton+"\" \/><br \/><span class=\"Instruction\">"+OMM_instructions+"<\/span><\/div>");

		$("#Reset"+OMM_output+""+optionValue+"").click(function() {
			if(confirm("Delete All Instruments?")) {
				$("#"+OMM_output+"TimeLine"+$(this).attr("name")+"").empty();
			}
		});

		$("#Select"+OMM_output+""+optionValue+"").click(function() {

			$("#"+OMM_manyDiv+"").css("top",""+((($(window).height())/2)-(($("#"+OMM_manyDiv+"").height())/2)+$(window).scrollTop())+"px");
			$("#"+OMM_manyDiv+"").css("left",""+(($(window).width())/2)-(($("#"+OMM_manyDiv+"").width())/2)+"px");

			$("#"+OMM_manyDiv+"").show().effect("highlight", {}, 500);

			lastSelectInstrumentsCalled = $(this).attr("name");
			groupBeingUpdated = "none";
		});

		$("#ImageDelete"+OMM_output+""+optionValue+"").click(function() {

			$(this).parent().fadeOut(300, function(){
				$(this).remove();
			});

			$("select[name="+OMM_oneSelect+"] option[value=\""+optionValue+"\"]").prop("disabled", false);
		});

		$("select[name="+OMM_oneSelect+"] option[value=\""+optionValue+"\"]").prop("disabled", true);
		$("select[name="+OMM_oneSelect+"] option:not([disabled]):first-child").attr("selected", "selected");

	}

	function AppendMusicianInstrumentsTimeline() {

		if(groupBeingUpdated == "none") {

			groupOfInstruments = ""+OMM_output+"GroupOfInstruments"+lastSelectInstrumentsCalled+""+(groupCount+1)+"";

			$("#"+OMM_output+"TimeLine"+lastSelectInstrumentsCalled+"").append("<div class=\"GroupOfInstruments\" id=\""+groupOfInstruments+"\"><img class=\"ImageDeleteMusician\" id=\"ImageDelete"+OMM_output+""+groupOfInstruments+"\" src=\"./img/static/Delete.png\" alt=\"\" /><img class=\"ImageUpdateMusician\" id=\"ImageUpdate"+OMM_output+""+groupOfInstruments+"\" name=\""+lastSelectInstrumentsCalled+"-"+(groupCount+1)+"\" src=\"./img/static/Update.png\" alt=\"\" /><\/div>"); 

		} else {

			groupOfInstruments = ""+OMM_output+"GroupOfInstruments"+lastSelectInstrumentsCalled+""+groupBeingUpdated+"";

			$("#"+groupOfInstruments+"").empty();

			$("#"+groupOfInstruments+"").append("<img class=\"ImageDeleteMusician\" id=\"ImageDelete"+OMM_output+""+groupOfInstruments+"\" src=\"./img/static/Delete.png\" alt=\"\" /><img class=\"ImageUpdateMusician\" id=\"ImageUpdate"+OMM_output+""+groupOfInstruments+"\" name=\""+lastSelectInstrumentsCalled+"-"+groupBeingUpdated+"\" src=\"./img/static/Update.png\" alt=\"\" />");

		}

		$("#ImageDelete"+OMM_output+""+groupOfInstruments+"").click(function() {
			$(this).parent().fadeOut(300, function(){
				$(this).remove();
			});
		});

		$("#ImageUpdate"+OMM_output+""+groupOfInstruments+"").click(function() {

			lastSelectInstrumentsCalled = $(this).attr("name").substr(0, $(this).attr("name").indexOf("-"));
			groupBeingUpdated = $(this).attr("name").substr($(this).attr("name").indexOf("-")+1, $(this).attr("name").length);

			var pula = 0;
			var updateTimeLine = [];

			$.each($("#"+OMM_output+"GroupOfInstruments"+lastSelectInstrumentsCalled+""+groupBeingUpdated+" :input"), function() {
				if($(this).val().match("^I") != null) {
					$("input[name="+OMM_manyInput+"][value='"+$(this).val().substr(1, $(this).val().length)+"']").click();
				}
				if($(this).val().match("^TL") != null) {
					updateTimeLine.push($(this).val().substr(2, $(this).val().length));

					if(pula > 1) {
						$("#"+OMM_manyOtherTimeLines+"").append($("#"+OMM_manyToManyDiv+"").html());

						$("input."+OMM_manyToManyDelete+"").click(function() {
							$(this).parent().remove();
						});

						pula = 0;
					}
					++pula;
				}
			});

			pula = 0;
			var i = 0;

			$.each($("select[name="+OMM_SelectTimeLine+"]"), function() {
				if(pula > 1) {
					$(this).val(""+updateTimeLine[i]+"");
					++i;
				}
				++pula;
			});

			$("#"+OMM_manyDiv+"").css("top",""+((($(window).height())/2)-(($("#"+OMM_manyDiv+"").height())/2)+$(window).scrollTop())+"px");
			$("#"+OMM_manyDiv+"").css("left",""+(($(window).width())/2)-(($("#"+OMM_manyDiv+"").width())/2)+"px");

			$("#"+OMM_manyDiv+"").show().effect("highlight", {}, 500);

		});

	}

	function AppendInstrument(inputValue) {

		var input = $("input[name="+OMM_manyInput+"][value=\""+inputValue+"\"]");

		$("#"+groupOfInstruments+"").append(""+input.parent().text()+"<input type=\"hidden\" name=\""+OMM_output+""+lastSelectInstrumentsCalled+"\" value=\"I"+input.val()+"\" \/><br \/>"); 

	}

	function AppendTimeLine(selectValue) {

		$("#"+groupOfInstruments+"").append("<div class=\"TimeLineAfterInstruments\">"+selectValue[0]+"<input type=\"hidden\" name=\""+OMM_output+""+lastSelectInstrumentsCalled+"\" value=\"TL"+selectValue[0]+"\" \/> - "+selectValue[1]+"<input type=\"hidden\" name=\""+OMM_output+""+lastSelectInstrumentsCalled+"\" value=\"TL"+selectValue[1]+"\" \/><\/div>"); 

	}

	$("#"+OMM_oneAdd+"").click(function() {

		var optionValue = $("select[name="+OMM_oneSelect+"]").val();

		if(optionValue != "0") {

			AppendMusician(optionValue);

			/* Primeiramente esconde somente para exibir novamente com um efeito Fade In */
			$("#"+OMM_output+""+optionValue+"").hide().fadeIn("fast");

			$("#"+OMM_oneDiv+"").effect("transfer", {to: "#"+OMM_Add+"", className: "ui-effects-transfer"}, 500).hide();

		}

	});

	$("#"+OMM_oneCancel+"").click(function() {
		$("#"+OMM_oneDiv+"").effect("transfer", {to: "#"+OMM_Add+"", className: "ui-effects-transfer"}, 500).hide();
	});

	$("#"+OMM_Reset+"").click(function() {
		if(confirm("Delete All?")) {
			$("#"+OMM_Content+"").empty();
			$("select[name="+OMM_oneSelect+"] option").prop("disabled", false);
		}
	});

	$("#"+OMM_manyAdd+"").click(function() {

		var containError = false;

		/*
		 *
		 * Valida se ao menos um instrumento foi selecionado
		 *
		 */

		if(!($("input[name="+OMM_manyInput+"]").is(":checked"))) {
			alert("Select at Least One Instrument");
			containError = true;
		}

		/*
		 *
		 * Valida se Todas as Timelines foram selecionadas
		 *
		 */

		var pulaDoisPrimeirosFromToTimeLine = 0;
		var warnedOneTime = false;

		$.each($("select[name="+OMM_SelectTimeLine+"] option:selected"), function() {
			if(pulaDoisPrimeirosFromToTimeLine > 1) {
				if(($(this).val() == 0) && (warnedOneTime == false)) {
					alert("Select a Date for all Timelines");
					containError = true;
					warnedOneTime = true;
				}
			}
			++pulaDoisPrimeirosFromToTimeLine;
		});

		/*
		 *
		 * Valida se "Present" está sendo adicionado somente uma vez no div SelectMusicianInstruments
		 *
		 */

		if($("select[name="+OMM_SelectTimeLine+"] option[value='Present']:selected").length > 1) {
			alert("Present Can Be Selected Only One Time and Needs To Be In The Last Timeline");
			containError = true;
		}

		/*
		 *
		 * Valida se as datas estão consistentes
		 *
		 */

		pulaDoisPrimeirosFromToTimeLine = 0;
		var conjuntoFromToValidation = [];
		var lastDate = 0;

		$.each($("select[name="+OMM_SelectTimeLine+"] option:selected"), function() {
			if(pulaDoisPrimeirosFromToTimeLine > 1) {
				conjuntoFromToValidation.push($(this).val());
				if(conjuntoFromToValidation.length == 2) {
					if((conjuntoFromToValidation[0] < lastDate) && (conjuntoFromToValidation[0] != "Unknow")) {
						alert("Inconsistent TimeLine");
						containError = true;
					}
					if((conjuntoFromToValidation[1] < lastDate) && (conjuntoFromToValidation[1] != "Present")) {
						alert("Inconsistent TimeLine");
						containError = true;
					}
					if((conjuntoFromToValidation[0] != "Unknow") && (conjuntoFromToValidation[1] != "Present")) {
						if(conjuntoFromToValidation[0] > conjuntoFromToValidation[1]) {
							alert("Each Date in the 'From' Field Can't Be Bigger Than Each Date in the 'To' Field");
							containError = true;
						}
					}
					if((conjuntoFromToValidation[0] != "Unknow")) {
						lastDate = conjuntoFromToValidation[0];
					}
					if((conjuntoFromToValidation[1] != "Present")) {
						lastDate = conjuntoFromToValidation[1];
					}
					conjuntoFromToValidation.splice(0, conjuntoFromToValidation.length);
				}
			}
			++pulaDoisPrimeirosFromToTimeLine;
		});

		/*
		 *
		 * Valida se dois grupos iguais não estão sendo adicionados
		 *
		 */

		var alreadyAdded = [];
		var jumpFirst = false;
		var afterTimeLine = false;
		var afterInstruments = false;
		var group = "";

		$.each($("input[name=\""+OMM_output+""+lastSelectInstrumentsCalled+"\"]"), function() {
			if(jumpFirst) {
				if($(this).val().match("^TL") != null) {
					afterInstruments = true;
				}
				if(afterInstruments) {
					if($(this).val().match("^I") != null) {
						afterTimeLine = true;
					}
				}
				if(afterTimeLine) {
					alreadyAdded.push(group);
					group = "";
					afterInstruments = false;
					afterTimeLine = false;
				}
				group = group.concat($(this).val());
			}
			jumpFirst = true;
		});
		if(group != "") {
			alreadyAdded.push(group);
		}

		groupCount = alreadyAdded.length;

		var beingAdded = "";
		var instruments = "";
		var timelines = "";

		$.each($("input[name="+OMM_manyInput+"]:checked"), function() {
			instruments = instruments.concat("I"+$(this).val());
		});

		pulaDoisPrimeirosFromToTimeLine = 0;

		$.each($("select[name="+OMM_SelectTimeLine+"] option:selected"), function() {
			if(pulaDoisPrimeirosFromToTimeLine > 1) {
				timelines = timelines.concat("TL"+$(this).val());
			}
			++pulaDoisPrimeirosFromToTimeLine;
		});

		beingAdded = beingAdded.concat(instruments, timelines);

		if(jQuery.inArray(beingAdded, alreadyAdded) != -1) {
			alert("Group of Instruments and Timeline Already Added");
			containError = true;
		}

		/*
		 *
		 * Valida se "Present" está em último lugar
		 *
		 */

		if($("select[name="+OMM_SelectTimeLine+"] option[value='Present']:selected").length == 1) {
			if($("select[name="+OMM_SelectTimeLine+"] option:selected:last").is("option[value='Present']") == false) {
				alert("Present Can Be Selected Only One Time and Needs To Be In The Last Timeline");
				containError = true;
			}
		}

		/*
		 *
		 * Caso nenhum erro tenha sido encontrado adiciona um grupo de instrumentos
		 *
		 */

		if(containError == false) {

		AppendMusicianInstrumentsTimeline();

		$.each($("input[name="+OMM_manyInput+"]:checked"), function() {
			$("#"+groupOfInstruments+"").append(""+$(this).parent().text()+"<input type=\"hidden\" name=\""+OMM_output+""+lastSelectInstrumentsCalled+"\" value=\"I"+$(this).val()+"\" \/><br \/>"); 

			$(this).click();
			$(this).parent().removeClass("multiselect-on");
		});

		$("input[name="+OMM_manyInput+"]").parent().parent().scrollTop(0);

		pulaDoisPrimeirosFromToTimeLine = 0;
		var conjuntoFromTo = [];

		$.each($("select[name="+OMM_SelectTimeLine+"] option:selected"), function() {
			if(pulaDoisPrimeirosFromToTimeLine > 1) {
				conjuntoFromTo.push($(this).text());
				conjuntoFromTo.push($(this).val());
				if(conjuntoFromTo.length == 4) {
					$("#"+groupOfInstruments+"").append("<div class=\"TimeLineAfterInstruments\">"+conjuntoFromTo[0]+"<input type=\"hidden\" name=\""+OMM_output+""+lastSelectInstrumentsCalled+"\" value=\"TL"+conjuntoFromTo[1]+"\" \/> - "+conjuntoFromTo[2]+"<input type=\"hidden\" name=\""+OMM_output+""+lastSelectInstrumentsCalled+"\" value=\"TL"+conjuntoFromTo[3]+"\" \/><\/div>");
					conjuntoFromTo.splice(0, conjuntoFromTo.length);
				}
			}
			++pulaDoisPrimeirosFromToTimeLine;
		});

		$("#"+OMM_manyOtherTimeLines+"").empty();
		$.each($("select[name="+OMM_SelectTimeLine+"] option:first-child"), function() {
			$(this).attr("selected", "selected");
		});

		$("#"+OMM_manyDiv+"").effect("transfer", {to: "input[id=Select"+OMM_output+""+lastSelectInstrumentsCalled+"]", className: "ui-effects-transfer"}, 500).hide();

		}

	});

	$("#"+OMM_manyCancel+"").click(function() {
		$.each($("input[name="+OMM_manyInput+"]:checked"), function() {
			$(this).click();
			$(this).parent().removeClass("multiselect-on");
		});
		$("input[name="+OMM_manyInput+"]").parent().parent().scrollTop(0);

		$("#"+OMM_manyOtherTimeLines+"").empty();
		$.each($("select[name="+OMM_SelectTimeLine+"] option:first-child"), function() {
			$(this).attr("selected", "selected");
		});

		$("#"+OMM_manyDiv+"").effect("transfer", {to: "input[id=Reset"+OMM_output+""+lastSelectInstrumentsCalled+"]", className: "ui-effects-transfer"}, 500).hide();
	});

	$("#"+OMM_manyAddAnotherTimeLine+"").click(function() {

		$("#"+OMM_manyOtherTimeLines+"").append($("#"+OMM_manyToManyDiv+"").html());

		$("input."+OMM_manyToManyDelete+"").click(function() {
			$(this).parent().remove();
		});

	});

	var conjuntoFromToOutro = [];
	var appendedOneTime = false;

	for(var i=0;i<load.length;i++) {

		if(load[i].match("^M")) {
			AppendMusician(load[i].substr(1, load[i].length));
			lastSelectInstrumentsCalled = load[i].substr(1, load[i].length);
			groupCount = 0;
		}

		if(load[i].match("^I")) {
			if(appendedOneTime == false) {
				AppendMusicianInstrumentsTimeline();
				++groupCount;
				appendedOneTime = true;
			}
			AppendInstrument(load[i].substr(1, load[i].length));
		}

		if(load[i].match("^TL")) {
			appendedOneTime = false;
			conjuntoFromToOutro.push(load[i].substr(2, load[i].length));
			if(conjuntoFromToOutro.length == 2) {
					AppendTimeLine(conjuntoFromToOutro);
					conjuntoFromToOutro.splice(0, conjuntoFromToOutro.length);
			}
		}

	}

}
