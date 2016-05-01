<?php

require_once("functions.php");

$tablename = $_POST['posttablename'];
$option = $_POST['postoption'];
$header = $_POST['postheader'];
$direction = $_POST['postdirection'];

//echo "This is post: $option<br>This is tablename: $tablename";

$conn = connect();

$query = "";

switch ($option) {
    case "All":
        $query = "SELECT * FROM `$tablename`";
        break;
    case "Top 100":
        $query = "SELECT * FROM `$tablename` LIMIT 100";
        break;
    case "Kuchen":
        echo "i ist Kuchen";
        break;
}


//append query
if ($direction == "up") {
	$query .= " ORDER BY $header ASC;";
}
elseif ($direction == "down") {
	$query .= " ORDER BY $header DESC;";
}


print_results($tablename, $query, $conn, 1);
?>






