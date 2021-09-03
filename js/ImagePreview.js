
	function readURL(input, divId, imageId) {

		if(input.files && input.files[0]) {
			var reader = new FileReader();

			var file = input.files[0];

			var name = file.name;
			var size = file.size;

			$("#"+divId+"").empty().append("<table class=\"Preview\"><tbody><th rowspan=\"2\"><img src=\"\" id=\""+imageId+"\" width=\"200\" height=\"200\" alt=\"Image Choosen\" /><td height=\"100\" id=\"FileNameFor"+imageId+"\" class=\"tdLeft\"></td></th><tr><td id=\"FileSizeFor"+imageId+"\" class=\"tdLeft\"></td></tr></tbody></table>");

			$("#FileNameFor"+imageId+"").append(file.name);
			$("#FileSizeFor"+imageId+"").append(((file.size)/1024).toFixed(2)+" Kbytes");

			reader.onload = function(e) {
				$("#"+imageId+"").attr("src", e.target.result);
			}

			reader.readAsDataURL(input.files[0]);
		}
	}

	function isMSIE() {
		return (navigator.appName == "Microsoft Internet Explorer");
	}
