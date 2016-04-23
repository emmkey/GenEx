$(document).ready(function() {
	
	var header = $('thead');
	var banner = $('#filter_select');
	var pos = header.position();
	
	$(window).scroll(function() {

		var windowpos = $(window).scrollTop();
		
		if (windowpos>=banner.outerHeight()) {
			//alert(banner.outerHeight());
			$("thead").addClass('fixedTop');
		}
		
		else {
			$("thead").removeClass('fixedTop');
		}
		
	});
		});
			// end
