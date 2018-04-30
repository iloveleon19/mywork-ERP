function validate_email(field,alerttxt){
    with (field){
        apos=value.indexOf("@")
        dotpos=value.lastIndexOf(".")
        if (apos<1||dotpos-apos<2){
            alert(alerttxt);
            return false;
        }
        else{
            return true;
        }
    }
}
function validate_phoneNum(field,alerttxt){
    var numberRegxp = /^09[0-9]{2}-[0-9]{6}$/; //格式需為09XX-XXXXXX

    if (numberRegxp.test(value) != true){
        alert(alerttxt);
        return false;
    }
    else{
        return true;
    }                
}
function validate_form(thisform){
    if(act.value !="delete"){
        with (thisform){
            if (validate_email(email,"e-mail格式不符合")==false){
                email.focus();
                return false;
            }
            else if(validate_phoneNum(phoneNum,"電話格式需為09XX-XXXXXX")==false){
                phoneNum.focus();
                return false;                    
            }
        }
    }

    // if(confirm("確定要送出此資料嗎？")){
    //     return true;
    // }else{
    //     return false;
    // }
}