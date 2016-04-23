<html>
<head>
	<script type="text/javascript" src="js/jquery.js"></script>	
	<script type="text/javascript" src="js/stickyheader.js"></script>	
	<?php require_once('functions.php') ?>
	<!-- Bootstrap core CSS -->
    <link href="css/bootstrap.css" rel="stylesheet">
    <!-- Custom styles for this template -->
    <link href="jumbotron-narrow.css" rel="stylesheet">

    

</head>
<body>

	<?php
	//Tabellennamen auslesen
	$tablename = $_GET['tbname'];
	?>

	<!-- Tabellennamen von PHP => Javascript -->
	<script>
	var tablename = "<?php echo $tablename; ?>";
	</script>
	
	<div id="filter_select">
	<h3>Filter</h1>
	<hr>
	
		<select id="selection" name="filterselection" size="1">
	    	<option>All</option>
	    	<option>Top 100</option>
	    	<option>Example</option>
	    	<option>Example</option>
	    	<option>Example</option>
	  	</select>
		<hr>
		<input type="submit" id="applybtn" value="ApplyFilter" onclick="applyfilter(1);"></input>
		<script type="text/javascript" src="real_display.js"></script>
		<hr>
	</div>
	<div id="result"></div>

	
	

</body>
</html>

