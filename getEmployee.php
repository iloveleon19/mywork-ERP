<?php
// AJAX用，最後可以寫在同一個檔案分function

require_once 'config.php';

$q=$_REQUEST["q"];

$sql="SELECT `id`, `email`, `phoneNum` FROM `member` WHERE `sn` = '".$q."'";

$result = $dbconnect->query($sql)->fetchAll(PDO::FETCH_ASSOC); // 可以拿來測試fetch，一定要用fatchAll回傳，不然js迴圈無法跑資料

echo json_encode($result);