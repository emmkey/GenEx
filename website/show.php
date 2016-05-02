<?php

require_once("functions.php");

$buttonid = $_POST['postbtnid'];

$newurl = addOrUpdateUrlParam($page, $pagenumber);

$tablename = $_POST['posttablename'];
$option = $_POST['postoption'];


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

print_results($tablename, $query, $conn, $buttonid);







?>