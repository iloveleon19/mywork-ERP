<form id="selectForm" method="POST" action="page_op.php">
    <input name="op" type="hidden" value="memberPage" />

    <div class="form-group row">
        <label for="op" class="col-sm-2 col-form-label">選擇的員工</label>
        <div class="col-sm-10">
            <select class="form-control form-control-lg" id ="sn" name="sn" required>
                <option value ="">請選擇</option>
                {foreach from=$result item=empolyee}
                    <option value ="{$empolyee.sn}">{$empolyee.id}</option>;
                {/foreach}
            </select>
        </div>
    </div>

    <button type="submit" class="btn btn-primary">修改</button>
</form>

<div id="txtHint"></div>

<script>
$(document).ready(function(){

    $('#selectForm').bootstrapValidator({
        // To use feedback icons, ensure that you use Bootstrap v3.1.0 or later
        feedbackIcons: {
            valid: 'glyphicon glyphicon-ok',
            invalid: 'glyphicon glyphicon-remove',
            validating: 'glyphicon glyphicon-refresh'
        },
        fields: {
            sn: {
                validators: {
                    notEmpty: {
                        message: 'The sn must be select'
                    }
                }
            }
        }
    });

    $("#sn").change(function(){
        var urls="getEmployee.php";

        urls=urls+"?q="+$("#sn").val();
        urls=urls+"&sid="+Math.random();

        $.ajax({
            url:            urls,// 取得資料的頁面網址
            contentType:    "application/json",
            data:{
                q:          $("#sn").val()
            },
            dataType:       "json",// 傳回的資料格式

            success:function(data){ //ajax 成功後要執行的函式
                if ( data.length!=0){ // 如果有資料
                    $.each(data,function(index,item){
                        $('#txtHint').html( // 建立select標籤
                            $('<table/>')
                            .addClass("table table-striped")
                            .html(
                                $('<thead/>').html(
                                    $('<tr/>').append(
                                        $('<th/>').append('名稱')
                                    ).append(
                                        $('<th/>').append('E-mail')
                                    ).append(
                                        $('<th/>').append('電話號碼')
                                    )
                                )
                            ).append(
                                $('<tbody/>').html(
                                    $('<tr/>').append(
                                        $('<td/>').append(item.id)
                                    ).append(
                                        $('<td/>').append(item.email)
                                    ).append(
                                        $('<td/>').append(item.phoneNum)
                                    )
                                )
                            )
                        );
                    })
                }
                else{
                    $("#txtHint").html('');
                }
            },
            error:function() {
                alert("Error!!!"); // 回傳的資料非json會到這邊，pdo的errorInfo()
            }
        });
    });
});
</script>