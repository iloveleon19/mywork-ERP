<?php
session_start();
    require_once 'config.php';

    $op = isset($_REQUEST['op']) ? filter_var($_REQUEST['op'], FILTER_SANITIZE_MAGIC_QUOTES) : '';

    switch ($op){
        // 登入的資料操作
        case "login":
            if(!isset($_POST['uid'])){
                //header('location:index.php?msg=沒有權限'); // msg給值之後一直存在提示，要再看一下流程
                echo "permission denied";
                exit;
            }
            $sql = "SELECT * FROM `member` WHERE `id`='".$_POST['uid']."'";
            $user = $dbconnect->query($sql)->fetch();
            //die( print( $dbconnect->query($sql)->rowCount() ) );
            if (password_verify($_POST['password'], $user['password'])){
                $_SESSION['user'] = $user;
                //header('location:page_op.php?op=return&msg=登入成功');
                echo "success";
            }
            else{
                //header('location:page_op.php?op=return&msg=登入失敗');
                echo "failed";
            }
            exit;
            break;

        // 使用者登出
        case "logout":
            if(isset($_SESSION['user'])){
                session_destroy();
            }
            header('location:page_op.php?op=return&msg=成功登出');
            exit;
            break;

        // 註冊的資料操作
        case "register":
            if(!isset($_POST['uid'])){
                //header('location:index.php?msg=沒有權限'); // msg給值之後一直存在提示，要再看一下流程
                echo "permission denied";
                exit;
            }
            $sql = "SELECT `id` FROM `member` WHERE `id`='".$_POST['uid']."'";
            $statement = $dbconnect->query($sql); // 成功查詢會傳回 PDOStatement object
        
            foreach($statement as $row){
                if ($row['id'] == $_POST['uid']){
                    //header('location:page_op.php?op=return&msg=已有相同ID名稱');
                    echo "check id";
                    exit;
                }
            }
            if(!isset($_POST['manager'])){
                $_POST['manager']=0; // 只有 0 或 1
            }
            else{
                $_POST['manager']=1; // 只有 0 或 1
            }

            $new_passwd   = password_hash($_POST['password'], PASSWORD_DEFAULT);
            $sql = "INSERT INTO `member` (`id`,`password`,`email`,`phoneNum`,`manager`) 
                VALUES ('".$_POST['uid']."', '".$new_passwd."', '".$_POST['email']."', '".$_POST['phoneNum']."', '".$_POST['manager']."')";

            $query = $dbconnect->prepare($sql);
            $result = $query->execute ();
            //         or die(print_r($dbconnect->errorInfo(), true)); // 如果SQL語法影響的行數為 0 會執行
            if($query->rowCount() == 1){
                //header('location:page_op.php?op=return&msg=註冊成功');
                echo "success";
                exit;
            }
            else{
                //header('location:page_op.php?op=return&msg=註冊失敗');
                echo "failed";
                exit;
            }
            break;
        
        case "update":
            if(!isset($_SESSION['user']) || !isset($_POST['sn'])){ // 判斷是否搗亂
                //header('location:index.php?msg=沒有權限'); 
                echo "permission denied";
                exit;
            }

            $sql = "UPDATE `member` SET 
                        `email`='".$_POST['email']."',`phoneNum`='".$_POST['phoneNum']."' WHERE `sn`='".$_POST['sn']."'";
            $query = $dbconnect->prepare($sql);
            $result = $query->execute ();

            if($query->rowCount() == 1){
                if($_POST['sn'] == $_SESSION['user']['sn']){ //提交的帳號與登入的帳號一樣
                    // 在抓一次資料，更新自己的session
                    $sql = "SELECT * FROM `member` WHERE `sn`='".$_POST['sn']."'";
                    $user = $dbconnect->query($sql)->fetch();
    
                    $_SESSION['user'] = $user;

                    //header('location:page_op.php?op=memberPage&msg=更新成功');
                    echo "success";
                    exit;
                }
                else{
                    //header('location:page_op.php?op=selectPage&msg=更新成功');
                    echo "success";
                    exit;
                }
            }
            else{
                //header('location:page_op.php?op=return&msg=更新失敗');
                echo "failed";
                exit;
            }
            break;

        case "updatePW":
            if(!isset($_SESSION['user']) || !isset($_POST['password'])){ // 判斷是否搗亂
                //header('location:index.php?msg=沒有權限'); 
                echo "permission denied";
                exit;
            }

            if( password_verify($_POST['password'], $_SESSION['user']['password'])){
                $new_passwd   = password_hash($_POST['password_new'], PASSWORD_DEFAULT);

                $sql = "UPDATE `member` 
                    SET `password`='{$new_passwd}' WHERE `sn`='".$_SESSION['user']['sn']."'";
                $query = $dbconnect->prepare($sql);
                $result = $query->execute ();
                if($query->rowCount() == 1){
                    //header('location:user_op.php?op=logout');
                    echo "success";
                    exit;
                }
                else{
                    //header('location:page_op.php?op=return&msg=更新失敗');
                    echo "failed";
                    exit;
                }
            }
            else{
                echo "wrong passowrd";
                exit;
            }
            break;

        case "delete":
            if(!isset($_SESSION['user']) || !isset($_POST['sn'])){ // 判斷是否搗亂
                //header('location:index.php?msg=沒有權限');
                echo "permission denied";
                exit;
            }
            
            $sql = "DELETE FROM `member` WHERE `sn`='".$_POST['sn']."'";
            $query = $dbconnect->prepare($sql);
            $result = $query->execute ();

            if($query->rowCount() == 1){
                //header('location:page_op.php?op=selectPage&msg=刪除成功');
                $sql = "DELETE FROM `relation` WHERE `business`='".$_POST['sn']."'";
                $query = $dbconnect->prepare($sql);
                $result = $query->execute ();
                echo "success";
                exit;
            }
            else{
                //header('location:page_op.php?op=selectPage&msg=刪除失敗');
                echo "failed";
                exit;
            }
            break;

        // 導向沒有任何操作的index.php
        default:
            //header('location:page_op.php?op=return&msg=請確認動作');
            echo "permission denied";
            exit;
            break;
    }
?>