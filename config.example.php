<?php
    // 把這個檔案複製後，名稱改名為 config.php
    // 跟目錄中要新增'templates_c'、'cache'資料夾

    require_once './libs/Smarty.class.php';

    $smarty = new Smarty;

    $smarty->debugging = false;
    $smarty->caching = true;
    $smarty->cache_lifetime = 120;
    //$smarty->force_compile = true;

    $dbms   =   'mysql';     // 資料庫類型
    $host   =   'localhost'; // 資料庫主機名稱
    $dbName =   'your_db_name';    // 要使用的資料庫
    $user   =   'your_db_user_name';      // 資料庫連接的用戶名
    $pass   =   'your_db_user_password';          // 對應的密碼

    $dsn    =   "$dbms:host=$host;dbname=$dbName;charset=utf8";

    try{
        $dbconnect = new PDO($dsn,$user,$pass, array(
            PDO::ATTR_PERSISTENT => true// 開啟 DB 長連接
        )); // 初始化一個PDO物件
        $dbconnect->exec("SET CHARACTER SET utf8");
        $dbconnect->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        // echo "connect sucess<br>";
        // $dbconnect = null;
    }catch (PDOException $e) {
            die ("Error!: " . $e->getMessage() . "<br/>");
    }

    date_default_timezone_set("Asia/Taipei");