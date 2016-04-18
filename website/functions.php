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
	
	//Header von beliebiger Tabelle bekommen
	function get_header($tablename) {
		$header_query = "SHOW columns FROM `$tablename`";
		$result = $conn->query($header_query);

		return $result;
	}

	//Abfrage als Tabelle ausgeben
	function print_results($tablename, $query) {
		//Tabelle erstellen
		echo "<table class=\"table\">";

		//Header auslesen
		$result = getheader($tablename);

		//Header ausgeben
		echo "<tr>";
		while ($header = $result->fetch_array(MYSQLI_NUM)) {
			echo "<th> $header[0] </th>";
		}


		echo "</tr>";

		//clean result
		$result->free();


		$result = $conn->query($query);

		while ($row = $result->fetch_array(MYSQLI_NUM)) {
			echo "<tr>";	
			for($x = 0; $x < sizeof($row); $x++) {
				echo "<th> $row[$x] </th>";
			}	
			echo "</tr>";
		}
		echo "</table>";
	}

	//Verzeichnisse zum Speichern des User-In- und Outputs
	function makeDir() {
		$dirname = strval(time());
		mkdir("./Output/$dirname", 0700);
		//Ordner fuer Plots
		mkdir("./Output/$dirname/plots", 0700);
		//Ordner fuer txt-Tabellen
		mkdir("./Output/$dirname/tables", 0700);
		//Ordner erstellen fuer Workingdirectory(R)
		mkdir("./Output/$dirname/wd", 0700);

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

	      			echo "Datei verschoben nach $newFilePath";

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
?>