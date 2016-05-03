function applyfilter(buttonid) {
	
		var option = $('#selection').val();

		$.post('show.php',{postoption:option,posttablename:tablename,postbtnid:buttonid},
			function(data) {
				$('#result').html(data);
			});

}

function startDownload(pathToTxt) {
	
		alert('MEISTER');
		$.post('downloadtxt.php',{postpath:pathToTxt},
			function(data) {
				$('#downloadz2').html(data);
			});

}