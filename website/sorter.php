<?php

require_once("functions.php");

$pagenumber = $_POST['postbtnid'];

/*$newurl = addOrUpdateUrlParam("page", $pagenumber);

header( "Location: $newurl" );*/

$tablename = $_POST['posttablename'];
$direction = $_POST['postdirection'];
$header = $_POST['postheader'];


/*
//UP o. DOWN und header per GET abfragen
$direction = $_GET['direc'];
$header = $GET['header'];


//Falls nach etwas anderem sortiert wurde => header und UP o. DOWN von Javascript holen
if ("NULL" != $_POST['postdirection']) {
    $direction = $_POST['postdirection'];
    $newurl = addOrUpdateUrlParam("direc", $direction);
    header( "Location: $newurl" );

    $header = $_POST['postheader'];
    $newurl = addOrUpdateUrlParam("header", $header);
    header( "Location: $newurl" );
}
*/

$conn = connect();

$query = "SELECT * FROM `$tablename`";


//append query
if ($direction == "up") {
	$query .= " ORDER BY $header ASC;";
}
elseif ($direction == "down") {
	$query .= " ORDER BY $header DESC;";
}


print_results($tablename, $query, $conn, $pagenumber, $header, $direction);
?>






