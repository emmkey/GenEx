function applyfilter(buttonid) {
	
		var option = $('#selection').val();

		$.post('show.php',{postoption:option,posttablename:tablename,postbtnid:buttonid},
			function(data) {
				$('#result').html(data);
			});

}

