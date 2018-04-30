<form id="stockForm" class="form-horizontal"> {* method="POST" action="item_op.php" *} 
        <div class="form-group">
            <label class="col-sm-2 col-form-label" for="number">商品名稱</label>
            <div class="col-sm-10">
                <select class="form-control form-control-lg" id="number" name="number" onchange="showPrice(this.value)" required >
                        <option value ="">請選擇</option>
                        {foreach from=$item_result item=$item}
                            <option value ="{$item.sn}">{$item.name} ( 存貨{$item.amount} ) </option>
                        {/foreach}
                </select>
            </div>
        </div>



        <div class="form-group">
            <label class="col-sm-2 col-form-label" for="amount">數量</label>
            <div class="col-sm-10">
                <input type="number" class="form-control form-control-lg" id="amount" name="amount" required />
            </div>
        </div>

        <div class="form-inline form-group">
            <label class="col-sm-2 col-form-label" for="txtHint">定價</label>
            <div class="col-sm-10">
                <div id="txtHint" class="col-sm-2">
                -----
                </div>
                <label>元</label>
            </div>
        </div>

        <div class="form-inline form-group">
            <label class="col-sm-2 col-form-label" for="price">價格</label>
            <div class="col-sm-10">
                <input type="numbe" class="form-control form-control-lg" id="price" name="price" required />
                <label>元</label>
            </div>
        </div>

        <div class="form-group"> {* 用ajax可以變成按鈕 *}
            <label class="col-sm-2 col-form-label" for="op">動作</label>
            <div class="col-sm-10">
                <select class="form-control form-control-lg" id="op" name="op" required>
                    <option value ="">請選擇</option>
                    <option value="stock">進貨</option>
                    <option value="ship">出貨</option>
                </select>
            </div>
        </div>

        <div class="form-group">
            <label>
                <button type="button" class="btn btn-primary">提交</button>
            </label>
        </div>
</form>
{literal}
<script> 
    //$(function() { 
    //    $("#stockForm").validate();
    //});

    $('#stockForm').bootstrapValidator({
        // To use feedback icons, ensure that you use Bootstrap v3.1.0 or later
        feedbackIcons: {
            valid: 'glyphicon glyphicon-ok',
            invalid: 'glyphicon glyphicon-remove',
            validating: 'glyphicon glyphicon-refresh'
        },
        fields: {
            number: {
                message: 'The item is required',
                validators: {
                    notEmpty: {
                        message: 'The item is required'
                    },
                }
            },
            op: {
                message: 'The operate is required',
                validators: {
                    notEmpty: {
                        message: 'The operate is required'
                    },
                }
            },
            amount: {
                validators: {
                    notEmpty: {
                        message: 'The amount is required'
                    },
                    regexp: { // 正規表示法
                        regexp: /^\+?[0-9][0-9]*$/,
                        message: 'The value is not a Positive number'
                    },
                    stringLength: {
                        min: 1,
                        max: 10,
                        message: 'The number must between 1 to 10 characters'
                    }
                }
            },
            price: {
                validators: {
                    notEmpty: {
                        message: 'The price is required'
                    },
                    regexp: { // 正規表示法
                        regexp: /^\+?[0-9][0-9]*$/,
                        message: 'The value is not a Positive number'
                    },
                    stringLength: {
                        min: 1,
                        max: 10,
                        message: 'The number must between 1 to 10 characters'
                    }
                }
            }
        }
    });

    $(document).ready(function(){
        $(".btn-primary").click(function(){
            // 在 bootstrapValidator 下操作ajax
            var bv = $("#stockForm").data('bootstrapValidator');
            bv.validate();
            if (bv.isValid()) {
                //發送ajax請求

                console.log( $(this).parents(".form-horizontal").serialize() );

                $.ajax({
                    url:        'item_op.php',
                    data:       $(this).parents(".form-horizontal").serialize(),
                    //contentType:    "application/json",
                    type:       'POST',
                    dataType:   "text",

                    success:function(msg){
                        if(msg=="success"){
                            alert("提交成功");
                            location.reload(); // 刷新頁面
                        }
                        else if(msg=="permission denied"){
                            alert("沒有權限");
                        }
                        else if(msg=="failed"){
                            alert("提交失敗");
                        }
                        else if(msg=="error"){
                            alert("存貨不足");
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

<script>
// ajax 測試
var xmlHttp;

function showPrice(str)
{ 
    xmlHttp=GetXmlHttpObject()
    if (xmlHttp==null){
        alert ("Browser does not support HTTP Request")
        return
    }
    var url="getprice.php"
    url=url+"?q="+str
    url=url+"&sid="+Math.random()
    xmlHttp.onreadystatechange=stateChanged
    xmlHttp.open("GET",url,true)
    xmlHttp.send(null)
}

function stateChanged() 
{ 
    if (xmlHttp.readyState==4 || xmlHttp.readyState=="complete"){ 
        document.getElementById("txtHint").innerHTML=xmlHttp.responseText 
    } 
}

function GetXmlHttpObject()
{
    var xmlHttp=null;
    try{
        // Firefox, Opera 8.0+, Safari
        xmlHttp=new XMLHttpRequest();
    }
    catch (e){
        //Internet Explorer
        try{
            xmlHttp=new ActiveXObject("Msxml2.XMLHTTP");
        }
        catch (e){
            xmlHttp=new ActiveXObject("Microsoft.XMLHTTP");
        }
    }
    return xmlHttp;
}
</script>