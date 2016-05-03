<?php

$tablename = $_GET['table'];

$file = "Output/" . $tablename . "/tables/" . $tablename . "_table.txt";

//$newname = $_POST['postpath'];
/*
header("Content-type: text/plain");
header("Content-Disposition: attachment; filename=$newname");

readfile($newfile);
*/

//$file = 'monkey.gif';

if (file_exists($file)) {
    header('Content-Description: File Transfer');
    header('Content-Type: text/plain');
    header('Content-Disposition: attachment; filename="'.basename($file).'"');
    header('Expires: 0');
    header('Cache-Control: must-revalidate');
    header('Pragma: public');
    header('Content-Length: ' . filesize($file));
    readfile($file);
    exit;
}

?>