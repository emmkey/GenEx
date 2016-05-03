<html>
<head>
	<script type="text/javascript" src="js/jquery.js"></script>	
	<script src="js/bootstrap.js"></script>
	<script type="text/javascript" src="js/jquery.freezeheader.js"></script>

	<script type="text/javascript">
/*
        $(document).ready(function () {
            $("#resultT").freezeHeader();   
        });
 */

    </script>


	<?php require_once('functions.php') ?>
	<!-- Bootstrap core CSS -->
    <link href="css/bootstrap.css" rel="stylesheet">
    <!-- Custom styles for this template -->
    <link href="jumbotron-narrow.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="css/normalize.css" />
	<link rel="stylesheet" type="text/css" href="css/demo.css" />
	<link rel="stylesheet" type="text/css" href="css/component.css" />
    <script type="text/javascript" src="real_display.js"></script>
	<script type="text/javascript" src="js/sortBy.js"></script>
	<script type="text/javascript" src="js/changeTab.js"></script>

</head>
 <body onload="sortBy(1,header,direction);"> 
<!--<body>-->

	<ul id="tabz" class="nav nav-tabs">
		<li id="plots" class="active"><a onClick="changeTab('plots');" style="cursor: pointer; cursor: hand;">Plots</a></li>
		<li id="table"><a onClick="changeTab('table');" style="cursor: pointer; cursor: hand;">Table</a></li>

	</ul>

	<?php
	//Tabellennamen auslesen
	$tablename = $_GET['tbname'];
	$direction = "NULL";
	$header = "NULL";
	?>

	<!-- Tabellennamen von PHP => Javascript -->
	<script>
	var tablename = "<?php echo $tablename; ?>";
	var direction = "<?php echo $direction; ?>";
	var header = "<?php echo $header; ?>";
	</script>
	
	<div id="table-div" style="display: none;">
	<!--<input type="submit" id="applybtn" value="ApplyFilter" onClick="sortBy(1,'NULL','NULL');"></input>-->
	<!--<input type="submit" id="applybtn" value="ApplyFilter" onClick="sortBy(1,header,direction);"></input>-->
	
	
	
	<div id="result"></div>
	</div>
	

	<div id="plots-div">
		<div id="myCarousel" class="carousel slide" data-ride="carousel" >
  		<!-- Indicators 
		  <ol class="carousel-indicators">
		    <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
		    <li data-target="#myCarousel" data-slide-to="1"></li>
		    <li data-target="#myCarousel" data-slide-to="2"></li>
		    <li data-target="#myCarousel" data-slide-to="3"></li>
		  </ol>-->

		   
		   
		    <!--<div class="carousel-inner" role="listbox" style=" width:500px; height: auto !important;">-->
			<div class="carousel-inner" role="listbox" style="width: 400px; margin: 0 auto">
		    <?php $dirname = "Output/$tablename/plots/";
		    //echo $dirname;
			$images = glob($dirname."*.png");
			//echo '<div class="img-responsive center-block active"> <img src="'.$images[0].'" alt="'.$images[0].'"> </div>';
			echo '<div class="item active"> <img src="'.$images[0].'" alt="'.$images[0].'" > </div>';
			//echo '<div class="img-responsive center-block"> <img src="'.$images[0].'" alt="'.$images[0].'"> </div>';
			for($i = 1; $i < count($images); $i++) {
				
				//echo '<div class="img-responsive center-block"> <img src="'.$images[$i].'" alt="'.$images[$i].'"> </div>';
				echo '<div class="item"> <img src="'.$images[$i].'" alt="'.$images[$i].'" > </div>';
				//echo '<div class="img-responsive center-block"> <img src="'.$images[$i].'" alt="'.$images[$i].'"> </div>';
				
			} ?>
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

		<!-- Alle Plots in Zip Datei speichern und zum Download anbieten -->
		<?
		// die maximale Ausführzeit erhöhen
		//ini_set("max_execution_time", 300);
		/*
		// Objekt erstellen und schauen, ob der Server zippen kann
		$zip = new ZipArchive();
		$zipname = "./Output/" . $tablename . "/" . $tablename . "_plots.zip";
		echo "zipname: " . $zipname;
		if ($zip->open($zipname, ZIPARCHIVE::CREATE) !== TRUE) {
			die ("Could not open archive");
		}
		$tozip = "./Output/" . $tablename . "/plots/";
		echo "topzip: " . $tozip;
		// Gehe durch die Ordner und füge alles dem Archiv hinzu
		$iterator = new RecursiveIteratorIterator(new RecursiveDirectoryIterator($tozip));
		foreach ($iterator as $key=>$value) {
			$zip->addFile(realpath($key), $key) or die ("ERROR: Could not add file: $key");
		}
		// speicher die Zip-Datei
		//echo $zip.getStatusString();
		$zip->close();
			
		
		echo "Archive erfolgreich erstellt.";
		echo '<a href="' . $zip . '">Download Plots as Zip</a>';
		*/
		$zipname = "Output/" . $tablename . "/" . $tablename . "_plots.zip";
		$tozip = "Output/" . $tablename . "/plots/*.png";
		
		$zip = new ZipArchive;
		$zip->open($zipname, ZipArchive::CREATE);
	
		foreach (glob($tozip) as $file) {
		    $zip->addFile($file);
		    
		    
		}
		
		$zip->close();
		/*
		$oldname = "Output/" . $tablename . "/tables/outtable.txt";
		$newname = "Output/" . $tablename . "/tables/" . $tablename . "_table.txt";
		rename($oldname, $newname);*/
		

		//header("Content-type: text/plain");
   		//header("Content-Disposition: attachment; filename=$newname");

		?>
		<div id="downloadz">
		<table id="dwn_table">
		<tr>
		<td><h4>Plots as Zip</h4></td>
		<td><a href="<?php echo $zipname; ?>" class="btn btn-info" role="button">Download</a></td>
		</tr>
		<tr>
		<td><h4>Table</h4></td>
		<td><a href="downloadtxt.php?table=<?php echo $tablename; ?>" class="btn btn-info" role="button">Download</a></td>
		</tr>
		</table>
		</div>
		


	</div>
	
	

</body>
</html>

