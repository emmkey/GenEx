<?php
	$tablename = $_GET['tbname'];

echo "<h2>Text-File uploaded successfully </h2>
<form action=\"real_display.php?tbname=$tablename\" method=\"post\" enctype=\"multipart/form-data\">
	<button class=\"btn btn-info\" type=\"submit\">Display File</button>
</form>"


?>
