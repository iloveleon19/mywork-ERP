<?php
session_start();
    require_once 'config.php';

    function output($smarty, $op, $msg){
        //$smarty->clear_all_assign();
        $smarty->clearCache('index.tpl');

        $userType    = false;
        $isUser     = false;
        
        if (isset($_SESSION['user'])) {

            $isUser = true;
            $userType = $_SESSION['user']['manager'];
        
            $smarty->assign('login_user', $_SESSION['user']);
        }

        $smarty->assign('msg',      $msg,       true);
        $smarty->assign('userType', $userType,   true);
        $smarty->assign('isUser',   $isUser,    true);
        $smarty->assign("op",       $op,        true);
        
        $smarty->clearCache('index.tpl');
        $smarty->display('index.tpl');
    }

    $op     = isset($_REQUEST['op'])    ? filter_var($_REQUEST['op'],   FILTER_SANITIZE_MAGIC_QUOTES) : '';
    $msg    = isset($_REQUEST['msg'])   ? filter_var($_REQUEST['msg'],  FILTER_SANITIZE_MAGIC_QUOTES) : '';

    switch ($op){ // 不用判斷搗亂，index.tpl有判斷了

        // 轉入會員介面
        case "memberPage":
            if(isset($_POST['sn'])){
                $sn = filter_var($_POST['sn'], FILTER_SANITIZE_NUMBER_INT);
                $canDelet = true; // 有POST過來的‵`sn`資料，表示可以管理
            }
            else{
                $sn = $_SESSION['user']['sn'];
                $canDelet = false;
            }

            $sql = "SELECT * FROM `member` WHERE `sn`='".$sn."'";
            $employee = $dbconnect->query($sql)->fetch();

            $smarty->assign("canDelet", $canDelet, true);
            $smarty->assign("employee", $employee, true);

            output($smarty,$op,$msg);
            exit;
            break;

        case "selectPage":

            $sql = "SELECT `business` AS `sn` FROM `relation` WHERE `supervisor` ='".$_SESSION['user']['sn']."'";
            //die(print("$sql"));
            $b_data = $dbconnect->query($sql)->fetchAll();

            foreach($b_data as $key => &$row){
                $sql = "SELECT `id` FROM `member` WHERE `sn` ='{$row['sn']}'";
                $b_id = $dbconnect->query($sql)->fetchColumn();
                $row['id'] = $b_id;
            }
            unset($row);

            $smarty->assign("result", $b_data, true);

            output($smarty,$op,$msg);
            exit;
            break;
        
        case "POSPage":
            showItems($dbconnect,$smarty);
            output($smarty,$op,$msg);
            exit;
            break;
        
        // 轉入商品管理介面
        case "itemPage":
            showItems($dbconnect,$smarty);
            output($smarty,$op, $msg);
            exit;
            break;

        case "reportsPage":
            $today=array(
                "year"=>date('Y'),
                "mon"=>date('m'),
                "day"=>date('d')
            );
            showItems($dbconnect,$smarty);
            $smarty->assign("today", $today, true);

            output($smarty,$op,$msg);
            exit;
            break;

        // 提示結果
        case "return":
            // output($smarty, $op, $msg);
            // exit;
            // break;

        // 轉入登入介面
        case "loginPage":
            // output($smarty,$op, $msg);
            // exit;
            // break;

        // 轉入註冊介面
        case "registerPage":
            // output($smarty,$op, $msg);
            // exit;
            // break;

        // 變更密碼頁面
        case "updatePWPage":
            // output($smarty,$op,$msg);
            // exit;
            // break;

        case "excelPage": // 這個頁面只能經由 reportsPage 操作後訪問
            // exit;
            // break; // 沒有使用break會直接接到下一個case -> default
        
        default: // 導向沒有任何操作的index.php
            output($smarty,$op,$msg);
            exit;
            break;
    }

    function showItems($dbconnect,$smarty){
        $sql = "SELECT * FROM `item`";
        $item = $dbconnect->query($sql)->fetchAll();
        $smarty->assign("item_result", $item, true);
    }
?>