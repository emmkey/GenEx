<h1>Upload CEL-Files</h1>
<form action="executer.php" method="post" enctype="multipart/form-data">
	<br>
    <p>Enter path to local R-folder:</p>
	(e.g. C:\Program Files\R\R-X.X.X)<br><br>
	<input name="rpfad" type="text">
 	<br><br><br><p>Choose CEL-Files:<br></p> 
	<input name="Datei[]" type="file" size="50" multiple="multiple">
	<br>
  	<button type="submit">Upload</button>
</form>
