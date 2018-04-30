<form id="passwordForm" class="form-horizontal"> {*  method="POST" action="user_op.php"  *}
    <input name="op" type="hidden" value="updatePW" />

    <div class="form-group">
        <label class="col-sm-3 control-label">舊密碼</label>
        <div class="col-sm-5">
            <input type="password" class="form-control" name="password" required />
        </div>
    </div>

    <div class="form-group">
        <label class="col-sm-3 control-label">新密碼</label>
        <div class="col-sm-5">
            <input type="password" class="form-control" name="password_new" required />
        </div>
    </div>

    <div class="form-group">
        <label class="col-sm-3 control-label">確認新密碼</label>
        <div class="col-sm-5">
            <input type="password" class="form-control" name="confirm_Password" required />
        </div>
    </div>

    <div class="form-group">
        <div class="col-sm-9 col-sm-offset-3">
            <!-- Do NOT use name="submit" or id="submit" for the Submit button -->
            <button type="button" class="btn btn-default">修改密碼</button>
        </div>
    </div>
</form>


<script>
$(document).ready(function() {
    $('#passwordForm').bootstrapValidator({
        // To use feedback icons, ensure that you use Bootstrap v3.1.0 or later
        feedbackIcons: {
            valid: 'glyphicon glyphicon-ok',
            invalid: 'glyphicon glyphicon-remove',
            validating: 'glyphicon glyphicon-refresh'
        },
        fields: {
            password: {
                validators: {
                    notEmpty: {
                        message: 'The password is required and cannot be empty'
                    },
                    stringLength: {
                        min: 8,
                        message: 'The password must have at least 8 characters'
                    }
                }
            },
            password_new: {
                validators: {
                    notEmpty: {
                        message: 'The new password is required and cannot be empty'
                    },
                    different: { // 不可以跟舊密碼一樣
                        field: 'password',
                        message: 'The new password cannot be the same as password'
                    },
                    stringLength: {
                        min: 8,
                        message: 'The new password must have at least 8 characters'
                    }
                }
            },
            confirm_Password: {
                validators: {
                    notEmpty: {
                        message: 'The confirm password is required and cannot be empty'
                    },
                    identical: { // 判斷與新密碼是否相同
                        field: 'password_new',
                        message: 'The new password and its confirm are not the same'  
                    },
                    stringLength: {
                        min: 8,
                        message: 'The confirm password must have at least 8 characters'
                    }
                }
            }
        }
    });

    $('button').click(function(){

        // 在 bootstrapValidator 下操作ajax
        var bv = $("#passwordForm").data('bootstrapValidator');
        bv.validate();
        if (bv.isValid()) {
            //console.log($("#passwordForm").serialize());
            //發送ajax請求
            $.ajax({
                url:        "user_op.php",
                data:       $("#passwordForm").serialize(),
                //async: false, //同步，會阻塞操作
                //contentType:    "application/json",
                type:       "POST",
                dataType:   "text",

                success:function(msg){
                    if(msg=="success"){
                        alert("更新成功");
                        location.replace("user_op.php?op=logout");
                    }
                    else if(msg=="permission denied"){
                        alert("沒有權限");
                    }
                    else if(msg=="failed"){
                        alert("更新失敗");
                    }
                    else if(msg=="wrong passowrd"){
                        alert("舊密碼錯誤");
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