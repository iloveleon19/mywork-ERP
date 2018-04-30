<?php
session_start();
    require_once 'config.php';

    function output($smarty, $op, $msg){
        //$smarty->clear_all_assign();
        //$smarty->clearCache('index.tpl');

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
    
    $op     = isset($_REQUEST['op'])    ?   filter_var($_REQUEST['op'],     FILTER_SANITIZE_MAGIC_QUOTES)   : '';
    $amount = isset($_POST['amount'])   ?   filter_var($_POST['amount'],    FILTER_SANITIZE_NUMBER_INT)     : '';
    $price  = isset($_POST['price'])    ?   filter_var($_POST['price'],     FILTER_SANITIZE_NUMBER_INT)     : '';

    switch ($op){

        case "addItem":
        
            if(!isset($_SESSION['user']) || !isset($_POST['item'])){ // 判斷是否搗亂
                echo "permission denied";
                //header('location:index.php?msg=沒有權限');
                exit;
            }
            else{
                $item = filter_var($_POST['item'], FILTER_SANITIZE_MAGIC_QUOTES);

                if($item=='' || $amount=='' || $price==''||$price<0){
                    //header('location:page_op.php?op=itemPage&msg=商品已存在');
                    echo "empty data";
                    exit;
                }

                $sql = "SELECT `name` FROM `item` WHERE `name`='{$item}'";
                $statement = $dbconnect->query($sql); // 成功查詢會傳回 PDOStatement object

                foreach($statement as $row){
                    if ($row['name'] == $item){
                        echo "exist";
                        //header('location:page_op.php?op=itemPage&msg=商品已存在');
                        exit;
                    }
                }
            
                $sql = "INSERT INTO `item` (`name`,`price`,`amount`) 
                    VALUES ('{$item}', {$price}, {$amount})";
                $query = $dbconnect->prepare($sql);
                $result = $query->execute ();
                        //or die(print_r($dbconnect->errorInfo(), true)); // 如果SQL語法影響的行數為 0 會執行
                if($query->rowCount() == 1){
                    // 傳回成功訊息
                    echo "success";
                    //header('location:page_op.php?op=itemPage&msg=新增成功');
                }
                else{
                    // 傳回失敗訊息
                    echo "failed";
                    //header('location:page_op.php?op=itemPage&msg=新增失敗');
                }
                exit;
            }
            break;

        case "updateItem":
            if(!isset($_SESSION['user']) || !isset($_POST['sn'])){ // 判斷是否搗亂
                //header('location:index.php?msg=沒有權限');
                echo "permission denied";
                exit;
            }

            else{
                $sn = filter_var($_POST['sn'], FILTER_SANITIZE_NUMBER_INT);

                $item = isset($_POST['item']) ? filter_var($_POST['item'], FILTER_SANITIZE_MAGIC_QUOTES):'';

                if($sn==''||$item==''||$price==''||$amount==''||$price<0){
                    echo "empty data";
                    exit;
                }

                $sql = "UPDATE `item` SET 
                            `name`='{$item}',`price`='{$price}',`amount`='{$amount}' WHERE `sn`='{$sn}'";
                $query = $dbconnect->prepare($sql);
                $result = $query->execute ();

                if($query->rowCount() == 1){
                    // 傳回成功訊息
                    // header('location:page_op.php?op=itemPage&msg=更新成功');
                    echo "success";
                }
                else{
                    // 傳回失敗訊息
                    //header('location:page_op.php?op=itemPage&msg=更新失敗');
                    echo "failed";
                }
                exit;
            }
            break;

        case "deleteItem":
            if(!isset($_SESSION['user']) || !isset($_POST['sn'])){ // 判斷是否搗亂
                //header('location:index.php?msg=沒有權限');
                echo "permission denied";
                exit;
            }

            else{
                $sn = filter_var($_POST['sn'], FILTER_SANITIZE_NUMBER_INT);

                if($sn==''){
                    echo "empty data";
                    exit;
                }

                $sql = "DELETE FROM `item` WHERE `sn`='".$_POST['sn']."'";
                $query = $dbconnect->prepare($sql);
                $result = $query->execute ();

                if($query->rowCount() == 1){
                    // 傳回成功訊息
                    //header('location:page_op.php?op=itemPage&msg=刪除成功');
                    echo "success";
                }
                else{
                    // 傳回失敗訊息
                    //header('location:page_op.php?op=itemPage&msg=刪除失敗');
                    echo "failed";
                }
                exit;
            }
            break;

        case "stock":
            if(!isset($_SESSION['user']) || !isset($_POST['number'])){ // 判斷是否搗亂
                //header('location:index.php?msg=沒有權限');
                echo "permission denied";
                exit;
            }

            updateStock($dbconnect, $amount);
            exit;
            break;
        case "ship":
            if(!isset($_SESSION['user']) || !isset($_POST['number'])){ // 判斷是否搗亂
                //header('location:index.php?msg=沒有權限');
                echo "permission denied";
                exit;
            }

            updateStock($dbconnect, -$amount); // $amount = -$amount 轉負值
            exit;
            break;

        default: // 導向沒有任何操作的index.php
            header('location:page_op.php?op=return&msg=請確認操作');
            exit;
            break;
    }

function updateStock($dbconnect, $amount){
    $sql = "UPDATE `item` SET `amount`=`amount`+$amount WHERE `sn`=".$_POST['number'].
    " AND `amount`+$amount <10000 AND `amount`+$amount >0";

    $query = $dbconnect->prepare($sql);
    $result = $query->execute ();
        //or die(print_r($dbconnect->errorInfo(), true)); // 如果SQL語法影響的行數為 0 會執行

    if($query->rowCount()==1){ // 增加 io 資料
        $sql = "SELECT `amount` FROM `item` WHERE `sn`= '".$_POST['number']."'";
        $result = $dbconnect->query($sql);
        //or die(print_r($dbconnect->errorInfo(), true)); // 如果SQL語法影響的行數為 0 會執行
        
        foreach($result as $row){
            $sql = "INSERT INTO `stock` (`item_num`, `price`,`amount`, `store`, `op_business`, `time`)
            VALUES ('".$_POST['number']."','".$_POST['price']."', '".$amount."','".$row['amount']."','".$_SESSION['user']['sn']."', NOW())";
            $query = $dbconnect->prepare($sql);
            $result = $query->execute ();
                //or die(print_r($query->errorInfo(), true)); // 如果SQL語法影響的行數為 0 會執行
            if($query->rowCount()==1){
                //header('location:page_op.php?op=POSPage&msg=進出貨成功');
                echo "success";
            }
            else{
                // 回復 item 的存貨量
                $sql = "UPDATE `item` SET `amount`=`amount`-$amount WHERE `sn`=".$_POST['number'];                
                $query = $dbconnect->prepare($sql);
                $result = $query->execute ();
                //header('location:page_op.php?op=POSPage&msg=進出貨失敗');
                echo "failed";
            }
        }
    }
    else{
        //header('location:page_op.php?op=POSPage&msg=更新失敗');
        echo "error";
    }
}
?>