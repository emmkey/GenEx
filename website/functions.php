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
?>