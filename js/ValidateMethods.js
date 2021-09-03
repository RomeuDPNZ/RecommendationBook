
jQuery.validator.addMethod("regex", function(value, element, regexp) {
            return this.optional(element) || new RegExp(regexp).test(value);
}, "Invalid Input");

jQuery.validator.addMethod("hasMoreThanNLineBreaks", function(value, element, max) {
	return this.optional(element) || (!(value.split("\n").length > max));
}, "Text Area Has Too Many Line Breaks");

jQuery.validator.addMethod("imageCantBeBiggerThanNBytes", function(value, element, max) {
	return this.optional(element) || (element.files && element.files[0] && element.files[0].size <= max);
}, "Image File Cannot be Bigger Than 50Kbytes");

jQuery.validator.addMethod("checkIfMatch", function(value, element, outro) {
	return this.optional(element) || (value == $("#"+outro+"").val());
}, "The Fields Are Not Equal");

jQuery.validator.addMethod("checkForInvalidCharacters", function(value, element) {
	return this.optional(element) || ((value.indexOf("<") == -1) && (value.indexOf(">") == -1));
}, "The Characters < and > Are Not Allowed");

jQuery.validator.addMethod("isPasswordValid", function(value, element) {
	var result = false;

	var letters = 0;
	var numbers = 0;
	var punctuations = 0;
	var prohibited = 0;

	var passwordArray = value.split("");

	passwordArray.forEach(function(character) {
		
		if(new RegExp("^[a-zA-Z]$").test(character)) {
			++letters;
		} else if(new RegExp("^[0-9]$").test(character)) {
			++numbers;
		} else if(new RegExp("^[#+-_]$").test(character)) {
			++punctuations;
		} else {
			++prohibited;
		}

	});

	if((letters >= 6) && (numbers >= 2) && (punctuations >= 1) && (prohibited == 0) && (value.length >= 9) && (value.length <= 50)) {
		result = true;
	}

	return this.optional(element) || result;
}, "The Password Must Have at Least 6 Letters: a-z A-Z, at Least 2 Numbers: 0-9 and at Least 1 Punctuation From The Following: # + - _");