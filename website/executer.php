<?php
//$filename = $_FILES['Datei']['name'];
//echo "<br> filename: $filename";

$rpath = $_POST['rpfad'];
echo "R-Pfad: " . $rpath;

$command = "$rpath/bin/R < /home/admini/plotscript.R --save;";
$output = shell_exec($command);
echo "<pre>$output</pre>";


//$zitate = file_get_contents(__DIR__.'/output_example.txt');
//echo "Dateiinhalt: " . nl2br($zitate);




?>
