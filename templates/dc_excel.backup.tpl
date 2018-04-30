<table style="width:100%" border =1>
    <tr>
        <th style="width:100px">    商品名稱    </th>
        <th style="width:100px">    定價        </th>
        <th style="width:100px">    總進貨量    </th>
        <th style="width:100px">    總出貨量    </th>
        <th style="width:100px">    獲利        </th>
        <th style="width:100px">    日期        </th>
        <th style="width:100px">    明細        </th>
    </tr>
</table>
<p></p>

{foreach $result item=$item}
<table style="width:100%" border =1>
    <tr>
        <td style="width:100px">    {$item.name}                        </td>
        <td style="width:100px">    {$item.price}                       </td>
        <td style="width:100px">    {$item.stock_amount}                </td>
        <td style="width:100px">    {$item.ship_amount}                 </td>
        <td style="width:100px">    {$item.earn}                        </td>
        <td style="width:100px">    {$item.startDate} ~ {$item.endDate} </td>
        <td style="width:100px">
            <button id="bID_{$item.sn}" value="{$item.sn}_{$item.startDate}_{$item.endDate}_0" type="button">明細</button>
        </td>
    </tr>
</table>

<div class="flip" id="flip_{$item.sn}">
    <p>
        <div class="panel">
                <table id="detal_{$item.sn}" style="width:100%"  border =1>
                    <tr>
                        <th style="width:100px">    商品名稱    </th>
                        <th style="width:100px">    市價        </th>
                        <th style="width:100px">    進出貨量    </th>
                        <th style="width:100px">    進出貨價格  </th>
                        <th style="width:100px">    進貨後庫存  </th>
                        <th style="width:100px">    日期        </th>
                    </tr>
                </table>

        </div>
    </p>
</div>

{/foreach}


<script>

$(function(){
    $(".panel").hide();
    $(".flip").click(function(){
        $(this).find(".panel").toggle();
        //$(".panel").toggle("slow");
        //$(this).next().toggle();
        //$("#flip0").toggle();
     });
})

$(document).ready(function(){

    $("button").click(function(){
        var arr = $(this).val().split('_'); // 按紐的值做切割
        var flip = "#flip_"+arr[0];

        if($(flip).find(".panel").is(":hidden") || arr[3] == 0){
            $.ajax({
                url:            "getExcel.php",// 取得資料的頁面網址
                contentType:    "application/json",
                data:{
                    q:          arr[0],
                    startDate:  arr[1],
                    endDate:    arr[2]
                },
                dataType:       "json",// 傳回的資料格式

                success:function(data){ //ajax 成功後要執行的函式
                    var table = "#detal_"+arr[0];
                    var remove = table+" tr:gt(0)";
                    $(remove).remove(); // 刪除detal表格第一列之外的其他列
                    // 要做無資料判定
                    // if(data.length==0) alert("暫無明細");
                    $.each(data,function(index,item){ //EmployeeID:資料表的欄位名稱

                        $(table).append(
                            "<tr>"+
                            "<td>" + item.name      + "</td>" +
                            "<td>" + item.price     + "</td>"+
                            "<td>" + item.amount    + "</td>"+
                            "<td>" + item.price     + "</td>"+
                            "<td>" + item.store     + "</td>"+
                            "<td>" + item.time      + "</td>"+
                            "</tr>"
                        );
                    })
                },
                error:function() {
                    alert("Error!!!"); // 回傳的資料非json會到這邊，pdo的errorInfo()
                }
            });
        }
        if(arr[3]==0){
            $(flip).find(".panel").show("slow");
            var bValuse = arr[0]+"_"+arr[1]+"_"+arr[2]+"_1";
            $(this).val(bValuse);
        }
        else{
            $(flip).find(".panel").toggle("slow");
        }

        //$(flip).find(".panel").toggle();

        // if( lastButtonID == $(this).attr('id' )){ // 跟上一次按的按鈕一樣
        //     $(flip).find(".panel").toggle("slow");
        // }
        // else{ // 跟上一次按的按鈕不一樣
        //     lastButtonID = $(this).attr('id');
        //     $(flip).find(".panel").toggle("slow");
        //     //$(flip).find(".panel").show("slow");
        // }

    });
});
</script>