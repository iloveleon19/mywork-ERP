<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/jquery.bootstrapvalidator/0.5.2/css/bootstrapValidator.min.css"/>

    {* <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script> *}
    <script type="text/javascript" src="./js/jquery-3.3.1.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jquery.bootstrapvalidator/0.5.2/js/bootstrapValidator.min.js"></script>

    
    

    <!-- jQuery Validation v1.17.0 -->
    <!--<script type="text/javascript" src="./js/jquery.validate.min.js"></script>-->
    <!-- <script type="text/javascript" src="./js/additional-methods.min.js"></script> -->
    <!-- <script type="text/javascript" src="./js/myDateValid.js"></script> -->
    
    <link rel ="stylesheet" href="./css/myCss.css" />
    {* <link rel="stylesheet" href="css/external-stylesheet.css"> *}

    <title>Hello Smarty And Bootstrap 3</title>
</head>

<body>

<nav class="navbar navbar-inverse">
    <div class="container-fluid">

    <div class="navbar-header">
      <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>                        
      </button>
      <a class="navbar-brand" href="#">Logo</a>
    </div>

    <div class="collapse navbar-collapse" id="myNavbar">
      <ul class="nav navbar-nav">
        <li class="active"><a href="index.php">Home</a></li>
        <li><a href="#">About</a></li>
        <li><a href="#">Projects</a></li>
        <li><a href="#">Contact</a></li>
      </ul>
      <ul class="nav navbar-nav navbar-right">
        <li>
            {if $isUser == true}
                <a href="user_op.php?op=logout"><span class="glyphicon glyphicon-log-in"></span> Logout</a>
            {else}
                <a href="page_op.php?op=loginPage"><span class="glyphicon glyphicon-log-in"></span> Login</a>
            {/if}
        </li>
      </ul>
    </div>

  </div>
</nav>

<div class="container-fluid text-center">

    <div class="row content">

        <div class="col-sm-2 sidenav">
            {if $isUser == true && $userType!="0"}

                <p><a href="page_op.php?op=reportsPage">報表</a></p>


                {if $userType=="supervisor"}
                    <p><a href="page_op.php?op=itemPage">商品管理</a></p>
                    <p><a href="page_op.php?op=selectPage">員工管理</a></p>
                {/if}

                {if $userType=="business"}
                    <p><a href="page_op.php?op=POSPage">商品進出貨</a></p>
                {/if}


                <p><a href="page_op.php?op=memberPage">我的資料</a></p>
                <p><a href="page_op.php?op=updatePWPage">修改密碼</a></p>
            {else}
                <p><a href="#">sidebar_left</a></p>
            {/if}
            <p><a href="#">Link</a></p>
        </div>

        <div class="col-sm-8 text-left"> 
            <p>
    {* ************************************************************************************************************************** *}
            {if $msg!=''}
                <div class="alert alert-danger">
                    <a href="#" class="close" data-dismiss="alert">
                        &times;
                    </a>
                    {$msg}
                </div>
            {/if}
    {* ************************************************************************************************************************** *}

                {if $isUser==false} {* 未登入 *}

                    {if $op=="loginPage"}           {include file="dc_login.tpl"}

                    {elseif $op=="registerPage"}    {include file="dc_register.tpl"}

                    {else}
                        {include file="dc_default.tpl"} {* 預設初始畫面 *}
                    {/if}

                {else} {* 已登入 *}

                    {if $op=="memberPage"}          {include file="dc_member.tpl"}
                    
                    {elseif $op=="updatePWPage"}    {include file="dc_updatePW.tpl"}

                    {elseif $op=="reportsPage"}         {include file="dc_reports.tpl"}
                        
                    {elseif $op=="excelPage"}           {include file="dc_excel.tpl"}

                    {elseif $op=="selectPage"}
                        {if $userType=="supervisor"}    {include file="dc_select.tpl"}
                        {* 應該要轉入首頁 *}
                        {else}                          {include file="dc_default.tpl"} {* 預設初始畫面 *} {/if}
                    {elseif $op=="itemPage"}
                        {if $userType=="supervisor"}    {include file="dc_item.tpl"}
                        {* 應該要轉入首頁 *}
                        {else}                          {include file="dc_default.tpl"} {* 預設初始畫面 *} {/if}

                    {elseif $op=="POSPage"}
                        {if $userType=="business"}      {include file="dc_POS.tpl"}
                        {* 應該要轉入首頁 *}
                        {else}                          {include file="dc_default.tpl"} {* 預設初始畫面 *} {/if}

                    {else}
                        {include file="dc_default.tpl"} {* 預設初始畫面 *}
                    {/if}

                {/if}
            </p>
        </div>

        <div class="col-sm-2 sidenav">
            <div class="well">
                <p>
                    {if $isUser == true}
                        <a href="user_op.php?op=logout">登出會員</a>
                    {else}
                        <a href="page_op.php?op=registerPage">註冊會員</a>
                    {/if}
                </p>
            </div>

            <div class="well">
                <p>ADS</p>
            </div>
        </div>

    </div>

</div>

<footer class="container-fluid text-center">
  <p>Footer Text</p>
</footer>

</body>
</html>