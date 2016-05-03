<html>
<head>
	<script type="text/javascript" src="js/jquery.js"></script>	
</head>
<body>
<h1>Upload CEL-Files</h1>
<form action="executer.php" method="post" enctype="multipart/form-data">
	<br>
    <p>Enter path to local R-folder:</p>
	(e.g. C:\Program Files\R\R-X.X.X)<br><br>
	<input name="rpfad" type="text">
 	<br><br><br><p>Choose CEL-Files:<br></p> 
	<input class="btn btn-default" name="Datei[]" type="file" size="50" multiple="multiple" style="margin: 0 auto; width: 100%;">
	<br>

	
	<div class="checkboxez">
	<div class="checkbox">
	<label><input id="all" type="checkbox" value="" id="checkfilter" checked>Everything</label>
	</div>
	
	<div class="checkbox">
	  <label><input type="checkbox" value="" class="checkfilter">Histograms</label>
	</div>
	<div class="checkbox">
	  <label><input type="checkbox" value="" class="checkfilter">Heatmaps</label>
	</div>
	<script>
		$(function() {
    enable_cb();
    $("#checkfilter").click(enable_cb);
});

function enable_cb() {
    $("input.checkfilter").prop("disabled", !this.checked);
}
	</script>

	</div>
  	<br>
  	<input type="submit" class="btn btn-info" value="Upload">
</form>
</body>
</html>