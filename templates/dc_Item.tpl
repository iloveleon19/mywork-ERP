<form class="form-inline" role="form" id="addForm"> {* method="POST" action="item_op.php" *}
    <input name="op" type="hidden" value="addItem" />

    <div class="form-group">
        <div class="form-inline col-sm-12">
            <label class="form-label">產品名稱</label>
            <input type="text" class="form-control" name="item" placeholder="產品名稱">
        </div>
    </div>

    <div class="form-group">
        <div class="form-inline col-sm-12">
            <label class="form-label">庫存</label>
            <input type="text" class="form-control" name="amount" placeholder="庫存">
        </div>
    </div>

    <div class="form-group">
        <div class="form-inline col-sm-12">
            <label class="form-label">定價</label>
            <input type="text" class="form-control" name="price" placeholder="定價">
        </div>
    </div>

    <div class="form-group">
        <label>
            <button type="button" class="btn btn-success">新增商品</button> {* 改成用ajax *}
        </label>
    </div>
</form>

<p></p>

{foreach $item_result item=$item }
    <form class="form-inline" role="form" id="updateForm_{$item.sn}" method="POST" action="item_op.php">
        <input name="sn" type="hidden" value="{$item.sn}" />

        <div class="form-group">
            <div class="form-inline col-sm-12">
                <label class="form-label">產品名稱</label>
                <input type="text" class="form-control" name="item" value="{$item.name}">
            </div>
        </div>

        <div class="form-group">
            <div class="form-inline col-sm-12">
                <label class="form-label">庫存</label>
                <input type="text" class="form-control" name="amount" value="{$item.amount}">
            </div>
        </div>

        <div class="form-group">
            <div class="form-inline col-sm-12">
                <label class="form-label">定價</label>
                <input type="text" class="form-control" name="price" value="{$item.price}">
            </div>
        </div>

        <div class="form-group">
            <label>
                <button type="button" class="btn btn-warning">更新</button>
            </label>
        </div>

        <div class="form-group">
            <label>
                <button type="button" class="btn btn-danger">刪除</button>
            </label>
        </div>
    </form>
{/foreach}

<script> 
    //$(function() { 
    //    $("#addForm").validate();
    //});
$(document).ready(function(){

    $(".btn-warning").click(function(){
        //console.log( $(this).parents(".form-inline").serialize() );

        $.ajax({
            url:        'item_op.php?op=updateItem',
            data:       $(this).parents(".form-inline").serialize(),
            //contentType:    "application/json",
            type:       'POST',
            dataType:   "text",

            success:function(msg){
                if(msg=="success"){
                    alert("更新成功");
                    location.reload(); // 刷新頁面
                }
                else if(msg=="empty data"){
                    alert("有欄位填寫錯誤");
                }
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

    });

    $(".btn-danger").click(function(){
        //console.log( $(this).parents(".form-inline").children(":hidden").serialize() );

        $.ajax({
            url:        'item_op.php?op=deleteItem',
            data:       $(this).parents(".form-inline").children(":hidden").serialize(),
            //contentType:    "application/json",
            type:       'POST',
            dataType:   "text",

            success:function(msg){
                if(msg=="success"){
                    alert("刪除成功");
                    location.reload(); // 刷新頁面
                }
                else if(msg=="empty data"){
                    alert("有欄位填寫錯誤");
                }
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

    $(".btn-success").click(function(){
        //console.log($('#addForm').serialize());
        $.ajax({
            url:        'item_op.php',
            data:       $('#addForm').serialize(),
            //contentType:    "application/json",
            type:       'POST',
            dataType:   "text",

            success:function(msg){
                if(msg=="success"){
                    alert("新增成功");
                    location.reload(); // 刷新頁面
                }
                else if(msg=="exist"){
                    alert("已存在");
                }
                else if(msg=="empty data"){
                    alert("有欄位填寫錯誤");
                }
                else if(msg=="permission denied"){
                    alert("沒有權限");
                }
                else if(msg=="failed"){
                    alert("新增失敗");
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