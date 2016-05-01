<html>
<head>
	<script type="text/javascript" src="js/jquery.js"></script>	

	<script type="text/javascript" src="js/jquery.freezeheader.js"></script>

	<script type="text/javascript">

        $(document).ready(function () {
            $("#resultT").freezeHeader();   
        });
 

    </script>


	<?php require_once('functions.php') ?>
	<!-- Bootstrap core CSS -->
    <link href="css/bootstrap.css" rel="stylesheet">
    <!-- Custom styles for this template -->
    <link href="jumbotron-narrow.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="css/normalize.css" />
	<link rel="stylesheet" type="text/css" href="css/demo.css" />
	<link rel="stylesheet" type="text/css" href="css/component.css" />
    

</head>
<body>

	<ul id="tabz" class="nav nav-tabs">
		<li id="plots" class="active"><a onClick="changeTab('plots');" style="cursor: pointer; cursor: hand;">Plots</a></li>
		<li id="table"><a onClick="changeTab('table');" style="cursor: pointer; cursor: hand;">Table</a></li>

	</ul>

	<?php
	//Tabellennamen auslesen
	$tablename = $_GET['tbname'];
	?>

	<!-- Tabellennamen von PHP => Javascript -->
	<script>
	var tablename = "<?php echo $tablename; ?>";
	</script>
	
	<div id="table-div" style="display: none;">
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
		<script type="text/javascript" src="js/sortBy.js"></script>
		<script type="text/javascript" src="js/changeTab.js"></script>
		<hr>
	</div>
	<div id="result"></div>
	</div>

	<div id="plots-div">
		<div id="myCarousel" class="carousel slide" data-ride="carousel">
  		<!-- Indicators -->
		  <ol class="carousel-indicators">
		    <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
		    <li data-target="#myCarousel" data-slide-to="1"></li>
		    <li data-target="#myCarousel" data-slide-to="2"></li>
		    <li data-target="#myCarousel" data-slide-to="3"></li>
		  </ol>

		  <!-- Wrapper for slides -->
		  <div class="carousel-inner" role="listbox">
		    <div class="item active">
		      <img src="Output/<?php echo $tablename; ?>/plots/" alt="Chania">
		    </div>

		    <div class="item">
		      <img src="img_chania2.jpg" alt="Chania">
		    </div>

		    <div class="item">
		      <img src="img_flower.jpg" alt="Flower">
		    </div>

		    <div class="item">
		      <img src="img_flower2.jpg" alt="Flower">
		    </div>
		  </div>

		  <!-- Left and right controls -->
		  <a class="left carousel-control" href="#myCarousel" role="button" data-slide="prev">
		    <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
		    <span class="sr-only">Previous</span>
		  </a>
		  <a class="right carousel-control" href="#myCarousel" role="button" data-slide="next">
		    <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
		    <span class="sr-only">Next</span>
		  </a>
		</div>
	</div>
	
	

</body>
</html>

