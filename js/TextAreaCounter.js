
	function TextAreaCounter(textArea, divResult, max) {

		$(""+textArea+"").on("focus keyup keydown keypress", function (e) {
			var $this = $(this);

			var length = this.value.length;

			var msg = "";

			if(length > max) {
				msg = "<span class=\"error\">"+length+" / "+max+"</span>";
			} else {
				msg = "<span class=\"green\">"+length+" / "+max+"</span>";
			}

			$(""+divResult+"").html(msg);
		});

	}
