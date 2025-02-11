<?php
$host='localhost';
$db = 'adise23_2019_032-240';
require_once "config_local.php";

$user=$DB_USER;
$pass=$DB_PASS;

mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
if(gethostname()=='users.iee.ihu.gr') {
	$mysqli = new mysqli($host, $user, $pass, $db,null,'/home/student/iee/2019/iee2019032/mysql/run/mysql.sock');
} else {
        $mysqli = new mysqli($host, $user, $pass, $db);
}

if ($mysqli->connect_errno) {
    echo "Failed to connect to MySQL: (" . 
    $mysqli->connect_errno . ") " . $mysqli->connect_error;
}

?>
