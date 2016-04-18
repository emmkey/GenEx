<?php

require_once("functions.php");



//Verzeichnis fuer den Output erstellen
if ($outname = makeDir()) {
	echo "Output Verzeichnis erstellt: $outname";
}

moveCels($outname);

//Workingdirectory setzen
setWd($dirname, $rscript)



//$filename = $_FILES['Datei']['name'];
//echo "<br> filename: $filename";

$rpath = $_POST['rpfad'];
echo "R-Pfad: " . $rpath;

if (strtoupper(substr(php_uname('s'), 0, 3)) === 'WIN') {
$command = '"$rpath\bin\R.exe" "C:\XAMPP\htdocs\SWPwebseite\R\testscript.R"';
$output = shell_exec($command);
echo "<pre>$output</pre>";
}
else{
$command = "$rpath/bin/R < /home/admini/Uni/Softwareprojekt/GenEx/website/R/testscript.R --save;";
$output = shell_exec($command);
echo "<pre>$output</pre>";
}

//$zitate = file_get_contents(__DIR__.'/output_example.txt');
//echo "Dateiinhalt: " . nl2br($zitate);



?>