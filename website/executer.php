<?php

require_once("functions.php");



//Verzeichnis fuer den Output erstellen
if ($dirname = makeDir()) {
	echo "Output Verzeichnis erstellt: $dirname";
}

moveCels($dirname);

//testscript in WD kopieren
$file = './R/testscript.R';
$newfile = "./Output/$dirname/wd/testscript.R";

if (!copy($file, $newfile)) {
    echo "copy $file schlug fehl...\n";
}

$file = "./Output/$dirname/wd/testscript.R";
// Öffnet die Datei, um den vorhandenen Inhalt zu laden
$current = file_get_contents($file);
// Fügt eine neue Person zur Datei hinzu
$setwdR = 'setwd("./Output/' . $dirname . '/wd")' . "\xA";
$setwdR .= $current;

// Schreibt den Inhalt in die Datei zurück
file_put_contents($file, $setwdR);




//$filename = $_FILES['Datei']['name'];
//echo "<br> filename: $filename";

$rpath = $_POST['rpfad'];
echo "R-Pfad: " . $rpath;

if (strtoupper(substr(php_uname('s'), 0, 3)) === 'WIN') {
//$command = '"$rpath\bin\R.exe" "C:\XAMPP\htdocs\SWPwebseite\R\testscript.R"';
$command = '"$rpath\bin\R.exe" "C:\XAMPP\htdocs\SWPwebseite\R\testscript.R"';
$output = shell_exec($command);
echo "<pre>$output</pre>";
}
else{
//$command = "$rpath/bin/R < /home/admini/Uni/Softwareprojekt/GenEx/website/R/testscript.R --save;";
$command = "$rpath/bin/R < /home/admini/Uni/Softwareprojekt/GenEx/website/Output/$dirname/wd/testscript.R --save;";
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


?>