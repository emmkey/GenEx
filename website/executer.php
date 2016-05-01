<?php

require_once("functions.php");

$rpath = $_POST['rpfad'];
echo "Eingegebener R-Pfad: $rpath <br/>";

//Verzeichnis fuer den Output erstellen
if ($dirname = makeDir()) {
	echo "Output Verzeichnis erstellt: $dirname<br/>";
}



moveCels($dirname);


if (strtoupper(substr(php_uname('s'), 0, 3)) === 'WIN') {
// $command = '"$rpath\bin\Rscript.exe" "C:\XAMPP\htdocs\SWPwebseite\R\TestScript.R"';
// $command = '"$rpath\bin\Rscript.exe" "C:\XAMPP\htdocs\SWPwebseite\Output\$dirname\wd\testscript.R"';
$wincmd_left = "$rpath\bin\Rscript.exe";
$wincmd_right = "C:\\XAMPP\htdocs\SWPwebseite\Output\\$dirname\wd\\testscript.R";
$command = "\"$wincmd_left\" \"$wincmd_right\"";
$output = shell_exec($command);
echo "<pre>$output</pre>";
}
else{
//$command = "$rpath/bin/R < /home/admini/Uni/Softwareprojekt/GenEx/website/R/testscript.R --save;";
$command = "$rpath/bin/Rscript /home/admini/Uni/Softwareprojekt/GenEx/website/R/testscript.R --wd $dirname";
$output = shell_exec($command);
echo "<pre>$output</pre>";
}

//$zitate = file_get_contents(__DIR__.'/output_example.txt');
//echo "Dateiinhalt: " . nl2br($zitate);

//Durch R-Skript erzeugte Tabelle jetzt in die Datenbank schreiben
$filename = "./Output/$dirname/tables/outtable.txt";

if ($tablename = writeToDb($filename)) {
	echo "Tabelle erstellt: $tablename";
}

echo "<script type=\"text/javascript\">
		window.location.href=\"index.php?page=display_txt&tbname=$tablename\";
		</script>"; 
?>
