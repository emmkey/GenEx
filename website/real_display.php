<?php

echo '<link href="css/bootstrap.min.css" rel="stylesheet">';

//Tabellennamen auslesen
$tablename = $_GET['tbname'];

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

echo "<table class=\"table\">";
//Header bekommen
$header_query = "SHOW columns FROM `$tablename`";
$result = $conn->query($header_query);

echo "<tr>";
while ($header = $result->fetch_array(MYSQLI_NUM)) {
	echo "<th> $header[0] </th>";
}


echo "</tr>";

//clean result
$result->free();

$all_query = "SELECT * FROM `$tablename`";

$result = $conn->query($all_query);

while ($row = $result->fetch_array(MYSQLI_NUM)) {
	echo "<tr>";	
	for($x = 0; $x < sizeof($row); $x++) {
		echo "<th> $row[$x] </th>";
	}	
	echo "</tr>";
}
echo "</table>";

$conn->close();
?>


