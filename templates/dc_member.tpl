<form id="updateForm"> {*  method="POST" action="user_op.php" *}

    <div class="form-group row">
        <label for="sn" class="col-sm-2 col-form-label">帳號</label>
        <div class="col-sm-10">
            {$employee.id}
            <input type="hidden" class="form-control" id="sn" name="sn" value="{$employee.sn}" />
        </div>
    </div>

    <div class="form-group row">
        <label for="email" class="col-sm-2 col-form-label">E-mail</label>
        <div class="col-sm-10">
            <input type="email" class="form-control" id="email" name="email" value="{$employee.email}" required />
        </div>
    </div>

    <div class="form-group row">
        <label for="phoneNum" class="col-sm-2 col-form-label">電話號碼</label>
        <div class="col-sm-10">
            <input type="text" class="form-control" id="phoneNum" name="phoneNum" value="{$employee.phoneNum}" required />
        </div>
    </div>

    <div class="form-group">
        <label>
            <button type="button" class="btn btn-warning">更新</button>
        </label>
    

        {if $canDelet==true} {* if($manager==1 && $noDelet ==0) *}
                <label>
                    <button type="button" class="btn btn-danger">刪除</button>
                </label>
        {/if}
    </div>

    {* <div class="form-group row">
        <label for="op" class="col-sm-2 col-form-label">動作</label>
        <div class="col-sm-10">
            <select class="form-control form-control-lg" id="op" name="op">
                <option value ="update">更新</option> *}
                {* {if $canDelet==true}   *}
                    {* //if($manager==1 && $noDelet ==0) *}
                    {* <option value ="delete">刪除</option> *}
                {* {/if} *}
            {* </select>
        </div>
    </div> *}

    {* <button type="submit" class="btn btn-primary">Submit</button> *}
</form>


<script>
$(document).ready(function() {

{literal}
    $('#updateForm').bootstrapValidator({
        // To use feedback icons, ensure that you use Bootstrap v3.1.0 or later
        feedbackIcons: {
            valid: 'glyphicon glyphicon-ok',
            invalid: 'glyphicon glyphicon-remove',
            validating: 'glyphicon glyphicon-refresh'
        },
        fields: {
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
{/literal}

    $(".btn-warning").click(function(){
        //console.log( $(this).parents(".form-inline").serialize() );
        var bv = $("#updateForm").data('bootstrapValidator');
        bv.validate();
        if (bv.isValid()) {
            $.ajax({
                url:        'user_op.php?op=update',
                data:       $('#updateForm').serialize(),
                //contentType:    "application/json",
                type:       'POST',
                dataType:   "text",

                success:function(msg){
                    if(msg=="success"){
                        alert("更新成功");
                        location.reload(); // 刷新頁面
                    }
                    //else if(msg=="empty data"){
                    //    alert("有欄位填寫錯誤");
                    //}
                    else if(msg=="permission denied"){
                        alert("沒有權限");
                    }
                    else if(msg=="failed"){
                        alert("請檢查資料是否有異動");
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

    $(".btn-danger").click(function(){
        //console.log( $(this).parents("form").find(":hidden").serialize() );

        $.ajax({
            url:        'user_op.php?op=delete',
            data:       $(this).parents("form").find(":hidden").serialize(),
            //contentType:    "application/json",
            type:       'POST',
            dataType:   "text",

            success:function(msg){
                if(msg=="success"){
                    alert("刪除成功");
                    location.replace("page_op.php?op=selectPage"); // 管理員工頁面
                }
                //else if(msg=="empty data"){
                //    alert("有欄位填寫錯誤");
                //}
                else if(msg=="permission denied"){
                    alert("沒有權限");
                }
                else if(msg=="failed"){
                    alert("刪除失敗");
                }
            },
            error:function(xhr,ajaxOptions,thrownError){
                console.log("Error");
                alert(xhr.staus);
                alert(thrownError);
            }
        });

    });
});
</script>
