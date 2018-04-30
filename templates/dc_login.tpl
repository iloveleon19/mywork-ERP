<form class="form-horizontal" role="form" id="loginForm">{* method="POST" action="user_op.php" *}
    <input name="op" type="hidden" value="login" />

    <div class="form-group">
        <label class="col-sm-3 control-label" for="uid">帳號</label>
        <div class="col-sm-6">
            <input type="text" class="form-control" id="uid" name="uid" aria-describedby="idHelp" placeholder="Enter id" required />
            <small id="idHelp" class="form-text text-muted">請輸入帳號</small>
        </div>
    </div>

    <div class="form-group">
        <label class="col-sm-3 control-label" for="password">密碼</label>
        <div class="col-sm-6">
            <input type="password" class="form-control" id="password" name="password" placeholder="Password" required />
        </div>
    </div>

    <div class="form-group">
        <div class="col-sm-9 col-sm-offset-3"> 
            <button type="button" class="btn btn-primary">登入</button>
            <a href="page_op.php?op=registerPage">註冊會員</a>
        </div>
    </div>

</form>

{* http://bootstrapvalidator.votintsev.ru/getting-started/ *}
{literal}
<script>
$(document).ready(function() {

    $('#loginForm').bootstrapValidator({
        // To use feedback icons, ensure that you use Bootstrap v3.1.0 or later
        feedbackIcons: {
            valid: 'glyphicon glyphicon-ok',
            invalid: 'glyphicon glyphicon-remove',
            validating: 'glyphicon glyphicon-refresh'
        },
        fields: {
            uid: {
                message: 'The id is not valid',
                validators: {
                    notEmpty: {
                        message: 'The id is required and cannot be empty'
                    },
                    stringLength: {
                        min: 6,
                        max: 30,
                        message: 'The id must be more than 6 and less than 30 characters long'
                    },
                    regexp: {
                        regexp: /^[a-zA-Z0-9_]+$/,
                        message: 'The id can only consist of alphabetical and number'
                    },
                    different: {
                        field: 'password',
                        message: 'The id and password cannot be the same as each other'
                    }
                }
            },
            password: {
                validators: {
                    notEmpty: {
                        message: 'The password is required and cannot be empty'
                    },
                    different: {
                        field: 'uid',
                        message: 'The password cannot be the same as id'
                    },
                    stringLength: {
                        min: 8,
                        message: 'The password must have at least 8 characters'
                    }
                }
            }
        }
    });

    $('button').click(function(){

        // 在 bootstrapValidator 下操作ajax
        var bv = $("#loginForm").data('bootstrapValidator');
        bv.validate();
        if (bv.isValid()) {
            //console.log($("#loginForm").serialize());
            //發送ajax請求
            $.ajax({
                url:        "user_op.php",
                data:       $("#loginForm").serialize(),
                //async: false, //同步，會阻塞操作
                //contentType:    "application/json",
                type:       "POST",
                dataType:   "text",

                success:function(msg){
                    if(msg=="success"){
                        alert("登入成功");
                        location.reload(); // 刷新頁面
                    }
                    else if(msg=="permission denied"){
                        alert("沒有權限");
                    }
                    else if(msg=="failed"){
                        alert("登入失敗");
                    }
                },
                error:function(xhr,ajaxOptions,thrownError){
                    console.log("Error");
                    alert(xhr.staus);
                    alert(thrownError);
                }
            });
        }

    });
});
</script>
{/literal}