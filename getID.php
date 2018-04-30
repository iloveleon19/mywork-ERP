<?php
require_once 'config.php';

$q=$_POST['uid'];

$sql="SELECT `id` FROM `member` WHERE `id` = '{$q}'";

$result = $dbconnect->query($sql)->fetch(PDO::FETCH_ASSOC); // 可以拿來測試fetch

if(!empty($result['id'])){
    $isAvailable = false;
}

else{
    $isAvailable = true;
}

echo json_encode(array(
    'valid' => $isAvailable
));