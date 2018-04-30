<div class="container-fluid" id="insert">
<form class="form-horizontal" id="reportForm"> {*method="POST" action="reports_op.php"*}

        <div class="form-group">
            <label class="col-sm-2 col-form-label" for="number">選擇的商品</label>
            <div class="col-sm-10">
                <select class="form-control form-control-lg" id="number" name="number">
                        <option value ="0">全部商品</option>
                        {foreach $item_result item=$item}
                        <option value ="{$item.sn}">{$item.name}</option>
                        {/foreach}
                </select>
            </div>
        </div>

        <div class="form-group form-row">
            <label class="col-sm-2 col-form-label"  for="startDate">起始日期</label>
                <div class="form-inline col-sm-3">
                    <select class="form-control sel_year" id="startYear" name="startYear" rel="{$today.year}"></select>
                    <label for="sel_year">年</label>
                </div>

                <div class="form-inline col-sm-3">
                    <select class="form-control sel_month" id="startMonth" name="startMonth" rel="1"></select>
                    <label for="sel_month">月</label>
                </div>

                <div class="form-inline col-sm-3">
                    <select class="form-control sel_day" id="startDay" name="startDay" rel="1"></select>
                    <label for="sel_day">日</label>
                </div>
        </div>

        <div class="form-group form-row">
            <label class="col-sm-2 col-form-label" for="endDate">截止日期</label>
                <div class="form-inline col-sm-3">
                    <select class="form-control  sel_year" id="endYear" name="endYear" rel="{$today.year}"></select>
                    <label  for="endYear">年</label>
                </div>

                <div class="form-inline col-sm-3">
                    <select class="form-control sel_month" id="endMonth" name="endMonth" rel="{$today.mon}"></select>
                    <label for="endMonth">月</label>
                </div>
                <div class="form-inline col-sm-3">
                    <select class="form-control sel_day" id="endDay" name="endDay" rel="{$today.day}"></select>
                    <label for="endDay">日</label>
                </div>
        </div>

        <div class="form-group">
            <label>
            <button type="button" class=
                                {if $login_user.manager=="business"}
                                    "btn btn-success"
                                {elseif $login_user.manager=="accountant"}
                                    "btn btn-primary"
                                {elseif $login_user.manager=="supervisor"}
                                    "btn btn-info"
                                {/if}
                                        id="{$login_user.id}" value="{$login_user.sn}_{$login_user.manager}">提交
             </button>
            </label>
        </div>
</form>

</div>

<script>
$(document).ready(function(){

    var startDate,endDate,item_num;

    $(".container-fluid").on("click",".btn",function(){

        if($('#reportForm').length > 0){
            item_num    =   $('#number').val();
            startDate   =   $('#startYear').val()+'-'+$('#startMonth').val()+'-'+$('#startDay').val();
            endDate     =   $('#endYear').val()+'-'+$('#endMonth').val()+'-'+$('#endDay').val();
        }

        var insert_id   = "#insert"; // 要插入的地方
        
        var arr     =   $(this).val().split('_');
        var sn      =   arr[0];
        var manager =   arr[1];

        var button_class, title;

        var back_sn, back_id,back_manager;


        if(manager=='accountant'){
            title = "company";
            button_class=   "btn btn-info";
        }
        else{
            title = $(this).attr('id');
            button_class=   "btn btn-success"; // 給supervisor按下看business用的
        }

        if(manager!='business'){
            thead=  '<table class="table table-striped">'+
                        '<thead>'+
                            '<tr>'+
                                '<th style="width:150px">人員</th>'+
                                '<th style="width:100px">進貨</th>'+
                                '<th style="width:100px">出貨</th>'+
                                '<th style="width:100px">小計</th>'+
                            '</tr>'+
                        '</thead>'+
                    '</table>'
        }
        else{
            thead=  '<table class="table table-striped">'+
                        '<thead>'+
                            '<tr>'+
                                '<th style="width:150px">產品</th>'+
                                '<th style="width:100px">進出貨</th>'+
                                '<th style="width:150px">日期</th>'+
                            '</tr>'+
                        '</thead>'+
                    '</table>'
        }
        
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
                        $('<p/>').html('<strong>'+startDate+' ~ '+endDate+'</strong>')
                    )
                ).append(
                    '<div class="col-sm-6 text-center">'+
                        '<p><strong>'+
                                title+
                        '</strong></p>'+
                    '</div>'
                )
            )
        ).append(thead);

        $.ajax({
            // contentType:    "application/json", // POST時不用這個選項
            url:            "reports_op.php",// 取得資料的頁面網址
            type:           "POST",
            data:{
                'sn':           sn,
                'startDate':    startDate,
                'endDate':      endDate,
                'number':       item_num,
            },
            // 傳回的資料格式，改成TEXT，後端可以傳回訊息來，在console.log中debug
            dataType:       "JSON",

            success:function(data){ //ajax 成功後要執行的函式

                back_sn = data[data.length-1].sn;
                back_id = data[data.length-1].id;
                back_manager = data[data.length-1].manager;

                data.splice(data.length-1); // 刪掉掉back訊息
                //data.length=data.length-1;

                // if(data.length==0) alert("暫無明細"); // 如果要做無資料判定
                
                $(insert_id).children(".table").append($('<tbody/>'));

                if (manager!='business'){
                    var total_stock=0, total_ship=0, total_earn=0; // 不一樣的地方
                    $.each(data,function(index,user){ // 資料表的欄位名稱

                        total_stock += Number(user.stock_amount);
                        total_ship  += Number(user.ship_amount);
                        total_earn  += Number(user.earn);

                        $(insert_id).children(".table").children("tbody").append(
                            '<tr>'+
                                '<td style="width:150px">'+
                                    '<button type="button" class="'+button_class+'" id="'+user.id+'" value="'+user.sn+'_'+user.manager+'">'+
                                        user.id+
                                    '</button>'+
                                '</td>'+

                                '<td style="width:100px"> '+user.stock_amount+'   元</td>'+
                                '<td style="width:100px"> '+user.ship_amount+'    元</td>'+
                                '<td style="width:100px"> '+user.earn+'           元</td>'+
                            '</tr>'
                        );
                    })

                    $(insert_id).children(".table").children("tbody").append(
                        '<tr>'+
                            '<td style="width:150px">統計</td>'+

                            '<td style="width:100px"> '+total_stock+'   元</td>'+
                            '<td style="width:100px"> '+total_ship+'    元</td>'+
                            '<td style="width:100px"> '+total_earn+'    元</td>'+
                        '</tr>'
                    );
                }
                else{
                    var total_amount=0; // 不一樣的地方
                    $.each(data,function(index,item){ // 資料表的欄位名稱

                        total_amount += Number(item.amount);

                        $(insert_id).children(".table").children("tbody").append(
                            '<tr>'+
                                '<td style="width:150px"> '+item.item_name+'</td>'+
                                '<td style="width:100px"> '+item.amount+   '元</td>'+
                                '<td style="width:100px"> '+item.time+   '</td>'+
                            '</tr>'
                        );
                    });

                    $(insert_id).children(".table").children("tbody").append(
                        '<tr>'+
                            '<td style="width:150px">統計</td>'+
                            '<td style="width:100px"> '+total_amount+   '元</td>'+
                            '<td style="width:100px"></td>'+
                        '</tr>'
                    );    
                }
                if( sn!='{$login_user.sn}'){
                    if(back_manager == 'accountant')
                    {
                        button_class="btn btn-primary";
                    }
                    else{
                        button_class="btn btn-info";
                    }
                    $(insert_id).append(
                        '<button type="button" class="'+button_class+'" id="'+back_id+'" value="'+back_sn+'_'+back_manager+'">'+
                            'back to '+back_id+
                        '</button>'
                    );
                }
            },
            error:function(xhr,ajaxOptions,thrownError) {
                alert("Error!!!"); // 回傳的資料非json會到這邊，pdo的errorInfo()
                alert(xhr.staus);
                alert(thrownError);
            }
        });

        return false; // 阻止冒泡事件
    });
});
</script>

<script type="text/javascript" src="./js/date.js"></script>

<script>  
$(function () {
	$.ms_DatePicker({
            YearSelector: "#startYear",
            MonthSelector: "#startMonth",
            DaySelector: "#startDay"
    });
	$.ms_DatePicker();

    $.ms_DatePicker({
            YearSelector: "#endYear",
            MonthSelector: "#endMonth",
            DaySelector: "#endDay"
    });
	$.ms_DatePicker();
}); 
</script>