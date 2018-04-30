{if !isset($result)}

<p class="text-center">查無資料</p>

{else}
    {if $login_user.manager=="business"}

        <div class="container-fluid">
            <div class="row">
                <div class="col-sm-6 text-center"><p>{$startDate} ~ {$endDate}  </p></div>
                <div class="col-sm-6 text-center"><p>{$login_user.id}           </p></div>
            </div>
        </div>

        <p>
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th style="width:150px">產品</th>
                        <th style="width:100px">進出貨</th>
                        <th style="width:150px">日期</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach $result item=$item}
                            <tr>
                                <td style="width:100px"> {$item.item_name}  </td>
                                <td style="width:100px"> {$item.amount}     </td>
                                <td style="width:100px"> {$item.time}     </td>
                            </tr>
                    {/foreach}
                </tbody>
            </table>
        </p>

    {elseif $login_user.manager=="accountant" || $login_user.manager=="supervisor"}

    <div class="container-fluid">
        <div class="row">
            <div class="col-sm-6 text-center"><p>{$startDate} ~ {$endDate}</p></div>

            {if $login_user.manager=="accountant"}
                <div class="col-sm-6 text-center"><p>公司</p></div>

            {elseif $login_user.manager=="supervisor"}
                <div class="col-sm-6 text-center"><p>{$login_user.id}</p></div>

            {/if}

        </div>
    </div>

    <table class="table table-striped">
        <thead>
            <tr>
                <th style="width:150px">人員</th>
                <th style="width:100px">進貨</th>
                <th style="width:100px">出貨</th>
                <th style="width:100px">小計</th>
            </tr>
        </thead>
    </table>

    {foreach $result item=$user}
    <p>
        <table class="table table-striped">
            <tbody>
                <tr>
                    <td style="width:150px">
                    {if $login_user.manager=="accountant"}
                        <button type="button" class="btn btn-info" id="{$user.id}" value="{$user.sn}_0">
                    {elseif $login_user.manager=="supervisor"}
                        <button type="button" class="btn btn-success" id="{$user.id}" value="{$user.sn}_0">
                    {/if}
                            {$user.id}
                        </button>
                    </td>

                    <td style="width:100px"> {$user.stock_amount}   </td>
                    <td style="width:100px"> {$user.ship_amount}    </td>
                    <td style="width:100px"> {$user.earn}           </td>
                </tr>
            </tbody>
        </table>

        <div class="container-fluid" id="insert_{$user.sn}"></div>

    </p>
    {/foreach}

    {/if}

<script>

$(document).ready(function(){
    
    $(".container-fluid").on("click",".btn-success",function(){
        var arr = $(this).val().split('_'); // 按紐的值做切割
        var insert_id   = "#insert_"+arr[0]; // 要插入的地方
        //var new_tableId = "#table_"++arr[0];
        if(arr[1] == 0){

            $(insert_id).html( // 建立標籤
                $('<div/>')
                .addClass('container-fluid')
                .html(
                    $('<div/>')
                    .addClass('row')
                    .append(
                        $('<div/>')
                        .addClass('col-sm-6 text-center')
                        .html(
                            $('<p/>').html('{$startDate} ~ {$endDate}')
                        )
                    ).append(
                        $('<div/>')
                        .addClass('col-sm-6 text-center')
                        .html($(this).attr('id'))
                    )
                )
            ).append(
                '<table class="table table-striped">'+
                    '<thead>'+
                        '<tr>'+
                            '<th style="width:150px">產品</th>'+
                            '<th style="width:100px">進出貨</th>'+
                        '</tr>'+
                    '</thead>'+
                '</table>'
            );

            $.ajax({
                //url:            "getItemExcel.php",// 取得資料的頁面網址
                url:            "reports_op.php",// 取得資料的頁面網址
                //contentType:    "application/json", // POST時不用這個選項
                type:           "POST", // 開啟後接收端_REQUEST要改成_POST
                data:{
                    'query':        'business',
                    'sn':           arr[0],
                    'startDate':    '{$startDate}',
                    'endDate':      '{$endDate}',
                    'number':       '{$item_num}',
                    'ajax':         'true'
                },
                dataType:       "JSON",// 傳回的資料格式

                success:function(data){ //ajax 成功後要執行的函式
                    // 要做無資料判定
                    // if(data.length==0) alert("暫無明細");
                    $(insert_id).append('<table class="table table-striped"><tbody></tbody></table>');

                    $.each(data,function(index,item){ //EmployeeID:資料表的欄位名稱
                        $(insert_id).children(".table").children("tbody").append(
                            '<tr>'+
                                '<td style="width:150px"> '+item.item_name+'</td>'+
                                '<td style="width:100px"> '+item.amount+   '</td>'+
                            '</tr>'
                        );
                    });
                },
                error:function() {
                    alert("Error!!!"); // 回傳的資料非json會到這邊，pdo的errorInfo()
                }
            });

            var bValuse = arr[0]+"_1";
            $(this).val(bValuse);
            return false; // 阻止冒泡事件
        }
        else{
            $(insert_id).html('');

            var bValuse = arr[0]+"_0";
            $(this).val(bValuse);
            return false; // 阻止冒泡事件
        }
    });

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    $(".btn-info").click(function(){
        var arr = $(this).val().split('_'); // 按紐的值做切割
        var insert_id   = "#insert_"+arr[0]; // 要插入的地方
        //var new_tableId = "#table_"++arr[0];

        if(arr[1] == 0){

            $(insert_id).html( // 建立標籤
                $('<div/>')
                .addClass('container-fluid')
                .html(
                    $('<div/>')
                    .addClass('row')
                    .append(
                        $('<div/>')
                        .addClass('col-sm-6 text-center')
                        .html(
                            $('<p/>').html('{$startDate} ~ {$endDate}')
                        )
                    ).append(
                        $('<div/>')
                        .addClass('col-sm-6 text-center')
                        .html($(this).attr('id'))
                    )
                )
            ).append(
                '<table class="table table-striped">'+
                    '<thead>'+
                        '<tr>'+
                            '<th style="width:150px">人員</th>'+
                            '<th style="width:100px">進貨</th>'+
                            '<th style="width:100px">出貨</th>'+
                            '<th style="width:100px">小計</th>'+
                        '</tr>'+
                    '</thead>'+
                '</table>'
            );

            $.ajax({
                //url:            "getExcel.php",// 取得資料的頁面網址
                url:            "reports_op.php",// 取得資料的頁面網址
                // contentType:    "application/json", // POST時不用這個選項
                type:           "POST", // 開啟後接收端_REQUEST要改成_POST
                data:{
                    'query':        'supervisor',
                    'sn':           arr[0],
                    'startDate':    '{$startDate}',
                    'endDate':      '{$endDate}',
                    'number':       '{$item_num}',
                    'ajax':         true
                },
                dataType:       "JSON",// 傳回的資料格式

                success:function(data){ //ajax 成功後要執行的函式
                    // 要做無資料判定
                    // if(data.length==0) alert("暫無明細");

                    $.each(data,function(index,user){ //EmployeeID:資料表的欄位名稱
                        $(insert_id).append(
                                '<table class="table table-striped">'+
                                    '<tbody>'+
                                        '<tr>'+
                                            '<td style="width:150px">'+
                                                '<button type="button" class="btn btn-success" id="'+user.id+'" value="'+user.sn+'_0">'+
                                                    user.id+
                                                '</button>'+
                                            '</td>'+

                                            '<td style="width:100px"> '+user.stock_amount+'   </td>'+
                                            '<td style="width:100px"> '+user.ship_amount+'    </td>'+
                                            '<td style="width:100px"> '+user.earn+'           </td>'+
                                        '</tr>'+
                                    '</tbody>'+
                                '</table>'
                        ).append(
                            '<div class="container-fluid" id="insert_'+user.sn+'"></div>'
                        );
                    })
                },
                error:function(xhr,ajaxOptions,thrownError) {
                    alert("Error!!!"); // 回傳的資料非json會到這邊，pdo的errorInfo()
                    alert(xhr.staus);
                    alert(thrownError);
                }
            });

            var bValuse = arr[0]+"_1";
            $(this).val(bValuse);
        }
        else{
            $(insert_id).html('');

            var bValuse = arr[0]+"_0";
            $(this).val(bValuse);
        }
    });
});
</script>
{/if}