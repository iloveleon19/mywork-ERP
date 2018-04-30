<?php
require_once 'config.php';

$q=$_GET["q"];

$sql="SELECT `price` FROM `item` WHERE `sn` = '".$q."'";

$result = $dbconnect->query($sql)->fetch(PDO::FETCH_ASSOC); // 可以拿來測試fetch

if($result['price']==''){
    $result['price']='-----';
}

echo $result['price'];