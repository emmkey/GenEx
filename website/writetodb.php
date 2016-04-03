<?php
$filename = $_FILES['Datei']['tmp_name'];
echo "Das ist der Filename: $filename <br>";
//zuerst nur die erste Zeile lesen und parsen,
//wie viele CEL-Files die Datei hat
$myfile = fopen($filename, "r") or die("Unable to open file!");
$firstline = fgets($myfile);
fclose($myfile);
echo "Das ist Firstline: $firstline <br>";
preg_match_all('/"[^"]*"/', $firstline, $num_colums);
$cel_counter = count($num_colums[0]) - 2;
//echo 'celcounter: ' . $cel_counter;

//Table erstellen
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

$tablename = "ceelfile1";

// sql to create table
$sql = "CREATE TABLE $tablename (
affyid VARCHAR(30) PRIMARY KEY, 
info VARCHAR(100) NOT NULL
)";



if ($conn->query($sql) === TRUE) {
    echo "Table $tablename created successfully";
} else {
    echo "Error creating table: " . $conn->error;
}

$conn->close();





/*
echo "so gross ist" . count($num_colums[0]) . "<br>";
echo "das ist erste: " . $num_colums[1][0];
echo '$num_colums[0][0]: ' . $num_colums[0][0] . "<br>";
echo '$num_colums[0][1]: ' . $num_colums[0][1] . "<br>";
echo '$num_colums[0]: ' . $num_colums[0] . "<br>";
echo '$num_colums[1]: ' . $num_colums[1] . "<br>";
echo '$num_colums[1][0]: ' . $num_colums[1][0] . "<br>";
*/

/*
//Textfile einlesen/oeffnen; "r" fuer: read-only
$filename = celfile.txt
$handle = fopen("inputfile.txt", "r");
if ($handle) {
    while (($line = fgets($handle)) !== false) {
        // process the line read.
    }

    fclose($handle);
} else {
    // error opening the file.
} 


*/
?>

