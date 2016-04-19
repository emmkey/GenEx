<?php

require_once("functions.php");

$tablename = $_POST['posttablename'];
$option = $_POST['postoption'];
echo "This is post: $option<br>This is tablename: $tablename";

$conn <- connect();

switch ($option) {
    case "All":
        $query = 
        break;
    case "Balken":
        echo "i ist Balken";
        break;
    case "Kuchen":
        echo "i ist Kuchen";
        break;
}

print_results($tablename, $query);





?>