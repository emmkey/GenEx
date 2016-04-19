function applyfilter() {
		
		var option = $('#selection').val();

		$.post('show.php',{postoption:option,posttablename:tablename},
			function(data) {
				$('#result').html(data);
			});

}