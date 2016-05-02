function sortBy(buttonid,header,direction) {
		
		$.post('sorter.php',{postbtnid:buttonid,posttablename:tablename,postheader:header,postdirection:direction},
			function(data) {
				$('#result').html(data);
			});

}