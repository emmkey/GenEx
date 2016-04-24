$(document).ready(function() {
	
	var header = $('thead');
	var banner = $('#filter_select');
	var pos = header.position();
	

	$(window).scroll(function() {

		var windowpos = $(window).scrollTop();
		//var topper = $('thead').offset().top;
		//if (windowpos>=banner.outerHeight()) {
		if (windowpos>=0) {
			//alert(banner.outerHeight());
			//alert(topper);
			$("thead").addClass('fixedTop');
		}
		
		else {
			//alert("ELSE");
			$("thead").removeClass('fixedTop');
		}
		
	});
		});
			// end
