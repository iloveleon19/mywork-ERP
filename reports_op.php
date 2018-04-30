<?php
session_start();
    require_once 'config.php';

    $op     = isset($_REQUEST['op'])    ?   filter_var($_REQUEST['op'],     FILTER_SANITIZE_MAGIC_QUOTES)   : '';


    $amount = isset($_POST['amount'])   ?   filter_var($_POST['amount'],    FILTER_SANITIZE_NUMBER_INT)     : '';

    $sn     = isset($_POST['sn'])       ?   filter_var($_POST['sn'],        FILTER_SANITIZE_NUMBER_INT)     : $_SESSION['user']['sn'];

    if(!isset($_SESSION['user']) || !isset($_POST['number'])){ // 判斷是否搗亂
        //header('location:index.php?msg=沒有權限');
        echo "permission denied";
        exit;
    }

    $startDate=$_POST["startDate"];
    $endDate=$_POST["endDate"];


    $statment_Date = "(`time` >= '$startDate 00:00:00' AND `time` <= '$endDate 23:59:59')";

    if($_POST['number']==0){
        $statment_sn = true; // 全部物件
    }
    else{
        $statment_sn = "item_num = ".$_POST['number']; // 物件編號等於提交編號
    }

    $sql = $sql = "SELECT `manager` FROM `member` WHERE `sn`='$sn'";
    $query = $dbconnect->query($sql)->fetchColumn();

    switch($query){

        case 'supervisor':
            //die(print('supervisor'));
            $sql = "SELECT `business` AS sn FROM `relation` WHERE `supervisor`='$sn'";
            $b_data = $dbconnect->query($sql)->fetchAll(PDO::FETCH_ASSOC); // $b_data目前只有sn欄位
            // or die(print_r($dbconnect->errorInfo(), true));  // 如果SQL語法影響的行數為 0 會執行

            foreach($b_data as $key => &$row){
                $sql ="SELECT `id` FROM `member` WHERE `sn`='{$row['sn']}'";
                $b_id = $dbconnect->query($sql)->fetch(PDO::FETCH_ASSOC);

                $sql = "SELECT SUM(amount*price) AS stock_amount FROM `stock` WHERE $statment_sn AND op_business={$row['sn']} AND amount>0 AND $statment_Date";
                $stock_amount = $dbconnect->query($sql)->fetchColumn();
        
                $sql = "SELECT SUM(amount*price) AS stock_amount FROM `stock` WHERE $statment_sn AND op_business={$row['sn']} AND amount<0 AND $statment_Date";
                $ship_amount = $dbconnect->query($sql)->fetchColumn();
                        
                $row['id']            = $b_id['id'];
                $row['manager']       = "business";
                $row['stock_amount']  = $stock_amount+0;
                $row['ship_amount']   = -$ship_amount+0;
                $row['earn']          = -($stock_amount+$ship_amount)+0;
            }

            unset($row); // 取消 &$row 的引用

            // 找回上一個點的資訊
            $sql = "SELECT `sn`,`id`,`manager` FROM `member` WHERE `sn`='{$_SESSION['user']['sn']}'"; // 會到這個 CASE 的不是 supervisor 自己，就是 accountant
            $back_data = $dbconnect->query($sql)->fetchAll(PDO::FETCH_ASSOC);

            $b_data = array_merge($b_data,$back_data);

            echo json_encode($b_data);
            exit;
            break;

        case 'business':

            $sql = "SELECT `item_num`,-amount*`price` AS amount,`time` FROM `stock` WHERE $statment_sn  AND `op_business`='$sn' AND $statment_Date";
        
            $stock = $dbconnect->query($sql)->fetchAll(PDO::FETCH_ASSOC);
                
            foreach($stock as $key => &$row){
                $sql = "SELECT `name` FROM `item` WHERE `sn`={$row['item_num']}";
                $name = $dbconnect->query($sql)->fetch(PDO::FETCH_ASSOC);
                $row['item_name'] = $name['name'];
            }

            unset($row); // 取消 &$row 的引用

            // 找回上一個點的資訊
            $sql = "SELECT `supervisor` AS sn FROM `relation` WHERE `business`='$sn'"; // 不能用 SESSION 的資訊找
            $back_data = $dbconnect->query($sql)->fetchAll(PDO::FETCH_ASSOC); // $back_data目前只有sn欄位

            foreach($back_data as $key => &$row){
                $sql ="SELECT `id` FROM `member` WHERE `sn`='{$row['sn']}'";
                $result = $dbconnect->query($sql)->fetch(PDO::FETCH_ASSOC);

                $row['id']=$result['id'];
                $row['manager']="supervisor";
            }
            unset($row); // 取消 &$row 的引用

            $stock = array_merge($stock,$back_data);
            echo json_encode($stock);
            exit;

            break;

        case 'accountant':
            $sql = "SELECT `id` ,`sn`,`manager` FROM `member` WHERE `manager`='supervisor'";

            $super = $dbconnect->query($sql)->fetchAll(PDO::FETCH_ASSOC);
                        //or die(print_r($dbconnect->errorInfo(), true));  // 如果SQL語法影響的行數為 0 會執行
        
            foreach($super as $key => &$row_s){
                $sql = "SELECT `business` AS b_sn FROM `relation` WHERE `supervisor`={$row_s['sn']}";
                $business = $dbconnect->query($sql)->fetchAll(PDO::FETCH_ASSOC);
                                //or die(print_r($dbconnect->errorInfo(), true));  // 如果SQL語法影響的行數為 0 會執行
            
                $stock_amount   = 0;
                $ship_amount    = 0;
                foreach($business as $key => $row_b){
            
                    $sql = "SELECT SUM(amount*price) AS stock_amount FROM `stock` WHERE $statment_sn AND op_business={$row_b['b_sn']} AND amount>0 AND $statment_Date";
                    $stock_amount += $dbconnect->query($sql)->fetchColumn();
            
                    $sql = "SELECT SUM(amount*price) AS stock_amount FROM `stock` WHERE $statment_sn AND op_business={$row_b['b_sn']} AND amount<0 AND $statment_Date";
                    $ship_amount += $dbconnect->query($sql)->fetchColumn();
                }
                //$row_s內已經有sn,id,manager
                $row_s['stock_amount']    = $stock_amount+0;
                $row_s['ship_amount']     = -$ship_amount+0;
                $row_s['earn']            = -($stock_amount+$ship_amount)+0;
            }

            unset($row_s); // 取消 &$row 的引用

            $sql = "SELECT `sn`,`id`,`manager` FROM `member` WHERE `sn`='{$_SESSION['user']['sn']}'"; // 會到這個 CASE 的，就只有 accountant
            $back_data = $dbconnect->query($sql)->fetchAll(PDO::FETCH_ASSOC);

            $super = array_merge($super,$back_data);

            echo json_encode($super);
            exit;
            break;
    }