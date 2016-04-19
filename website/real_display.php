<html>
<head>
	<script type="text/javascript" src="jquery.js"></script>
	<?php require_once('functions.php') ?>
	<!-- Bootstrap core CSS -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
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
	

	<h3>Filter</h1>
	<hr>
	<div>
		<select id="selection" name="filterselection" size="1">
	    	<option>All</option>
	    	<option>Top 100</option>
	    	<option>Example</option>
	    	<option>Example</option>
	    	<option>Example</option>
	  	</select>
		<hr>
		<input type="submit" id="applybtn" value="ApplyFilter" onclick="applyfilter();"></input>
		<script type="text/javascript" src="real_display.js"></script>
		<hr>
	</div>
	<div id="result"></div>
	

</body>
</html>

