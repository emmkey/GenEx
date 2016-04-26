<?php
	//Verbindung zur Datenbank herstellen
	function connect() {
		//Logindaten fuer Datenbank setzen
		$servername = "localhost";
		$username = "root";
		$password = "";
		$dbname = "celwebsite";

		// Create connection
		$conn = new mysqli($servername, $username, $password, $dbname);
		// Check connection
		if ($conn->connect_error) {
		    die("Connection failed: " . $conn->connect_error);
		}

		return $conn;
	}
	
	//printbuttons
	function print_buttons($totalbtns, $btn_offset) {
		echo "<div id='pagination'>";
		echo "<hr>";

		if ($btn_offset > 5) {
			echo "<button type=\"button\" id=\"1\" onclick=\"applyfilter(this.id);\">First</button>";
			echo "...";
		}

		if ($btn_offset < 6) {
			$printfrom = 1;
		}
		else {
			$printfrom = $btn_offset-5;
		}
		if ($btn_offset+5 > $totalbtns) {
			$limit = $totalbtns;
		}
		else {
			$limit = $btn_offset+5;
		}
		
		for ($x = $printfrom; $x <= $limit; $x++) {
			//echo "<button id=\"btn_$x\" value=\"$x\">";
			echo "<button type=\"button\" id=\"$x\" onclick=\"applyfilter(this.id);\">$x</button>";
		}

		if ($btn_offset < $totalbtns-6) {
			echo "...";
			echo "<button type=\"button\" id=\"$totalbtns\" onclick=\"applyfilter(this.id);\">Last</button>";
		}
		echo "<hr>";
		echo "</div>";
	}

	//Header von beliebiger Tabelle bekommen
	function get_header($tablename,$conn) {
		$header_query = "SHOW columns FROM `$tablename`";
		$result = $conn->query($header_query);

		return $result;
	}

	//Abfrage als Tabelle ausgeben
	function print_results($tablename, $query, $conn, $page) {
		//Tabelle erstellen
		echo "<table class=\"table\" id=\"resultT\">";

		//Header auslesen
		$result = get_header($tablename,$conn);

		//Header ausgeben
		
		echo "<thead>";
		//echo "<div id='s_header'>";
		echo "<tr>";
		while ($header = $result->fetch_array(MYSQLI_NUM)) {
			echo "<th> $header[0] <a onClick=\"sortBy('" . $header[0] . "','up');\" style=\"cursor: pointer; cursor: hand;\">⇑</a> <a onClick=\"sortBy('" . $header[0] . "','down');\" style=\"cursor: pointer; cursor: hand;\">⇓</a></th>";
		}




		echo "</tr>";
		//echo "</div>";
		echo "</thead>";
		


		//clean result
		$result->free();


		$result = $conn->query($query);
		/*
		while ($row = $result->fetch_array(MYSQLI_NUM)) {
			echo "<tr>";	
			for($x = 0; $x < sizeof($row); $x++) {
				echo "<th> $row[$x] </th>";
			}	
			echo "</tr>";
		}
		echo "</table>";*/

		//$result_array = $result->fetch_all(MYSQLI_NUM);

		for ($result_array = array(); $tmp = $result->fetch_array(MYSQLI_NUM);) {
			$result_array[] = $tmp;
		} 

		$items_per_page = 50;
		$offset = ($page-1)*$items_per_page;
		$length = $items_per_page;


		$outputarray = array_slice($result_array, $offset, $length);
		
		echo "<tbody>";
		foreach ($outputarray as $row) {
			echo "<tr>";	
			foreach($row as $column) {
				echo "<td> $column </td>";
			}
			echo "</tr>";
		}
		echo "</tbody>";
		echo "</table>";

		//Zeilen "Zebraen" (Farben wechseln sich ab zur besseren Uebersicht)
		echo '
		<script>

		var allRows = document.getElementsByTagName("tr");
		for (var i = 0; i < allRows.length; i++) {
			if(i % 2 !== 0) {
				allRows[i].classList.add("paint-row");
			}
		}

		</script>

		';

		echo '

		<script type="text/javascript" src="js/jquery.js"></script>	

	<script type="text/javascript" src="js/jquery.freezeheader.js"></script>

	<script type="text/javascript">

        $(document).ready(function () {
            $("#resultT").freezeHeader();   
        });
 

    </script>

		';
	
		$total_page_num = ceil(mysqli_num_rows($result)/50);
		$btn_offset = $offset+1;
		print_buttons($total_page_num, $page);
	}

	//Verzeichnisse zum Speichern des User-In- und Outputs
	function makeDir() {
		$dirname = strval(time());

		$oldumask = umask(0);

		mkdir("./Output/$dirname", 0777, true);
		//Ordner fuer Plots
		mkdir("./Output/$dirname/plots", 0777, true);
		//Ordner fuer txt-Tabellen
		mkdir("./Output/$dirname/tables", 0777, true);
		//Ordner erstellen fuer Workingdirectory(R)
		mkdir("./Output/$dirname/wd", 0777, true);

		umask($oldumask); 


		return $dirname;
	}

	//verschiebt alle hochgeladenen CEL-Files in die Workingdirectory
	function moveCels($dirname) {

        //Zaehlen, wie viele Dateien hochgeladen wurden
        $filecounter = count($_FILES['Datei']['name']);

		// Loop through each file
		for($i=0; $i<$filecounter; $i++) {
	  		//tmp_name von File auslesen
	  		$tmpFilePath = $_FILES['Datei']['tmp_name'][$i];

	  		//Sicherstellen, dass es Dateipfad gibt
	  		if ($tmpFilePath != ""){

	    		//"Ziel-Pfad" festlegen
	    		$newFilePath = "./Output/$dirname/wd/" . $_FILES['Datei']['name'][$i];

	    		//Datei verschieben
	    		if(move_uploaded_file($tmpFilePath, $newFilePath)) {

	      			echo "Datei verschoben nach $newFilePath<br/>";

	    		}
	  		}
		}
	}

	//Workingdirectory setzen
	function setWd($dirname, $rscript) {
		$rcode = 'setwd("./Output/' . $dirname . '/wd")';
		$newscript = $rcode . $rscript;

		return $newscript;
	}

	//Textdatei in Datenbank schreiben
	function writeToDb($filename) {

		//zuerst nur die erste Zeile lesen und parsen,
		//wie viele CEL-Files die Datei hat
		$myfile = fopen($filename, "r") or die("Unable to open file!");
		$firstline = fgets($myfile);
		fclose($myfile);

		//Alle Woerter aus dem Header parsen und in Array $num_colums speichern
		preg_match_all('/"[^"]*"/', $firstline, $num_colums);

		//Zaehlt, wie viele Spalten nach AffyID u. GENENAME kommen => wie viele CEL-Files die Datei "hat"
		$cel_counter = count($num_colums[0]) - 2;

		//Logindaten fuer Datenbank setzen
		$servername = "localhost";
		$username = "root";
		$password = "";
		$dbname = "celwebsite";

		// Create connection
		$conn = new mysqli($servername, $username, $password, $dbname);
		// Check connection
		if ($conn->connect_error) {
		    die("Connection failed: " . $conn->connect_error);
		} 


		//Tabellennamen festlegen
		//Gibt die seit Beginn der Unix-Epoche (Januar 1 1970 00:00:00 GMT) bis jetzt vergangenen Sekunden zurück.
		//=> einzigartiger Tabellenname
		//strval: int => string
		$tablename = strval(time());
		echo 'Tabellenname: ' . $tablename . "<br>";

		//Tabelle erstellen, die vorerst nur die AffyID als Key enthaelt
		$sql = "CREATE TABLE `$tablename` (
		AffyID VARCHAR(30) PRIMARY KEY
		)";

		if ($conn->query($sql) === TRUE) {
		    echo "<br> Tabelle $tablename erfolgreich erstellt";
		} else {
		    echo "<br> Error bei Tabellenerstellung: " . $conn->error;
		}

		//Array fuer Header erstellen (wird nach der For-Schleife,
		//zum Einfuegen der Daten in die Tabelle benoetigt)
		$header_array = array();
		$header_array[] = "AffyID";

		//Spalten fuer Info und CEL-Files anfuegen
		for ($x = 1; $x < sizeof($num_colums[0]); $x++) {
			$col_name = $num_colums[0][$x];
			
			//pruefen, ob .CEL nicht enthalten ist 
			//dann nur die Anfuehrungszeichen wegschneiden
			if (strpos($col_name, '.CEL') == false) {
		    		$col_name = substr($col_name,1,-1);
			//Wenn .CEL vorhanden, dann Anfuehrungszeichen und ".CEL" wegschneiden	
			} else {
				$col_name = substr($col_name,1,-5);
			}
			
			//zurechtgeschnittene Zeilenbezeichnung in header-array schreiben
			$header_array[] = $col_name;

			$alter_query = "ALTER TABLE `$tablename` ADD `$col_name` VARCHAR(200) NOT NULL";
			if ($conn->query($alter_query) === TRUE) {
				echo "<br>" . "Spalte fuer CEL-File hinzugefuegt";
			} else {
				echo "<br>" . "Fehler beim Hinzufuegen der CEL-Spalten";
			}
		} 

		//Array in String Komma-Separierten String umschreiben
		$comma_separated = implode(", ",$header_array);



		    	

		//Jetzt kann die Tabelle gefuellt werden

		$file_to_db = 	"LOAD DATA LOCAL INFILE '" . $filename . "' 
				INTO TABLE `$tablename` 
				FIELDS TERMINATED BY '\\t' 
				OPTIONALLY ENCLOSED BY '\"' 
				LINES TERMINATED BY '\\n'
				IGNORE 1 LINES
				($comma_separated)";


		if ($conn->query($file_to_db) === TRUE) {
			//printf($conn->error);
			echo "<br>File erfolgreich in Tabelle!!!";	

		} else {
			printf($conn->error);
			echo "<br> Fehler beim Einfuegen in Tabelle";
		}




		$conn->close();

		return $tablename;

	}
?>