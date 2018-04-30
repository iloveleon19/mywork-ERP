<form id="registerForm" class="form-horizontal"> {*  method="POST" action="user_op.php"  *}
    <input name="op" type="hidden" value="register" />

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
            <input type="password" class="form-control" id="password" name="password" required />
        </div>
    </div>

    <div class="form-group">
        <label class="col-sm-3 control-label" for="confirm_Password">確認新密碼</label>
        <div class="col-sm-6">
            <input type="password" class="form-control" id="confirm_Password" name="confirm_Password" required />
        </div>
    </div>

    <div class="form-group">
        <label  class="col-sm-3 control-label" for="email">E-mail</label>
        <div class="col-sm-6">
            <input type="email" class="form-control" id="email" name="email" placeholder="someone@example.com" required />
        </div>
    </div>

    <div class="form-group">
        <label class="col-sm-3 control-label" for="phoneNum">電話號碼</label>
        <div class="col-sm-6">
            <input type="text" class="form-control" id="phoneNum" name="phoneNum" required />
        </div>
    </div>

    <div class="form-group">
        <div class="col-sm-9 col-sm-offset-3">
            <!-- Do NOT use name="submit" or id="submit" for the Submit button -->
            <button type="button" class="btn btn-primary">註冊</button>
            <a href="page_op.php?op=loginPage">登入會員</a>
        </div>
    </div>
</form>

{literal}
<script>
$(document).ready(function() {
    $('#registerForm').bootstrapValidator({
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
                    },
                    threshold :  6 , //有6字符以上才发送ajax请求，（input中输入一个字符，插件会向服务器发送一次，设置限制，6字符以上才开始）
                    remote: { // ajax驗證。server result:{"valid",true or false}向server發送input name值，獲得一個json數據。例如表示正確：{"valid",true}  
                        url: 'getID.php', // 驗證地址
                        message: '帳號已存在', // 提示訊息
                        delay :  1000, // 如果每輸入一個字符，就ajax請求，server壓力還是過大，設置一秒發送一次ajax（預設是每輸入一個字符，就提交一次）
                        type: 'POST' // 請求方式
                        /**自定義提交數據，預設是提交目前 input value
                            data: function(validator) {
                                return {
                                    password: $('[name="passwordNameAttributeInYourForm"]').val(),
                                    whatever: $('[name="whateverNameAttributeInYourForm"]').val()
                                };
                            }
                        **/
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
            },
            confirm_Password: {
                validators: {
                    notEmpty: {
                        message: 'The confirm password is required and cannot be empty'
                    },
                    identical: { // 判斷與新密碼是否相同
                        field: 'password',
                        message: 'The password and its confirm are not the same'  
                    },
                    stringLength: {
                        min: 8,
                        message: 'The password must have at least 8 characters'
                    }
                }
            },
            email: {
                validators: {
                    notEmpty: {
                        message: 'The email address is required and cannot be empty'
                    },
                    emailAddress: {
                        message: 'The email address is not a valid'
                    }
                }
            },
            phoneNum: {
                validators: {
                    notEmpty: {
                        message: 'The password is required and cannot be empty'
                    },
                    regexp: { // 正規表示法
                        regexp: /(^09\d{2}\-?\d{3}\-?\d{3}$)|(^0\d{1,2}\d{6,8}$)/,
                        message: 'The value is not a number'
                    }//,
                    //stringLength: {
                    //    min: 8,
                    //    max: 10,
                    //    message: 'The number must between 8 to 10 characters'
                    //}
                }
            }
        }
    });

    $('button').click(function(){

        // 在 bootstrapValidator 下操作ajax
        var bv = $("#registerForm").data('bootstrapValidator');
        bv.validate();
        if (bv.isValid()) {
            //console.log($("#loginForm").serialize());
            //發送ajax請求
            $.ajax({
                url:        "user_op.php",
                data:       $("#registerForm").serialize(),
                //async: false, //同步，會阻塞操作
                //contentType:    "application/json",
                type:       "POST",
                dataType:   "text",

                success:function(msg){
                    if(msg=="success"){
                        alert("註冊成功");
                        location.replace("page_op.php?op=loginPage"); // 轉入登入頁面
                    }
                    else if(msg=="permission denied"){
                        alert("沒有權限");
                    }
                    else if(msg=="failed"){
                        alert("註冊失敗");
                    }
                    else if(msg=="check id"){
                        alert("已有相同的ID");
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