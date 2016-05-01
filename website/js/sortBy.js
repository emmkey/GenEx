function sortBy(header,direction) {
	
		var option = $('#selection').val();

		$.post('sorter.php',{postoption:option,posttablename:tablename,postheader:header,postdirection:direction},
			function(data) {
				$('#result').html(data);
			});

}