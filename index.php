<?php
session_start();

require_once './libs/Smarty.class.php';

$smarty = new Smarty;

$smarty->force_compile  = true;
$smarty->debugging      = false;
$smarty->caching        = true;
$smarty->cache_lifetime = 120;

$op     = isset($_REQUEST['op'])    ? filter_var($_REQUEST['op'],   FILTER_SANITIZE_MAGIC_QUOTES) : '';
$msg    = isset($_REQUEST['msg'])   ? filter_var($_REQUEST['msg'],  FILTER_SANITIZE_MAGIC_QUOTES) : '';

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