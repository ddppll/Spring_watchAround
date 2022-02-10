//회원가입버튼 클릭 체크
  	function fCheck() {
	var email = myform.email.value;
	var pwd = myform.pwd.value;
	var nickName = myform.nickName.value;
	var cellphone2 = myform.cellphone2.value;
	var cellphone3 = myform.cellphone3.value;
	
	if(pwd == "") {
		alert("비밀번호를 입력하세요");
		myform.pwd.focus();
	}
	else if(nickName == "") {
		alert("닉네임을 입력하세요");
		myform.nickName.focus();
	}
	// 기타 추가 체크해야 할 항목들을 모두 체크하세요.
	else {
			myform.submit();
		}
	}


// 비밀번호 검사
function pwdCheck(){
    let pwd = document.getElementById("pwd").value;
    let regpwd = /^(?=.*[a-zA-z])(?=.*[0-9])(?=.*[$`~!@$!%*#^?&\\(\\)\-_=+])(?!.*[^a-zA-z0-9$`~!@$!%*#^?&\\(\\)\-_=+]).{8,16}$/gm;
    
    if(pwd.length < 8 || pwd.length > 16){
        document.getElementById("pwddemo").innerHTML="비밀번호는 8자 이상 16자 이하로 입력하세요"
    }
    else{
        if(!regpwd.test(pwd)){
            document.getElementById("pwddemo").innerHTML = "영어/숫자/특수문자를 포함한 8~16자로 입력하세요"
        }
        else{
            document.getElementById("pwddemo").innerHTML = " ";
        }
    }
}

// 비밀번호 확인 일치 검사
function pwdConfirmCheck(){
    let pwd = document.getElementById("pwd").value;
    let pwdConfirm = document.getElementById("pwdConfirm").value;
    if(!(pwdConfirm == pwd)){
        document.getElementById("pwdConfirmDemo").innerHTML = "비밀번호가 일치하지 않습니다."
    }
    else{
        document.getElementById("pwdConfirmDemo").innerHTML = " ";
    }
}

// 닉네임 검사
function nickCheck2(){
    let name = document.getElementById("nickName").value;
    let regname = /^[0-9|가-힣|a-z|A-Z|]+$/gm;
    if(name.length<2 || name.length>8){
        document.getElementById("namedemo").innerHTML = "닉네임은 2자 이상 8자 이하로 입력하세요."
    }
    else{
        if(!regname.test(name)){
            document.getElementById("namedemo").innerHTML = "닉네임은 영어/한글/숫자로만 입력하세요"
        }
        else{
            document.getElementById("namedemo").innerHTML = " ";
        }
    }
}

//휴대 전화 검사
function cellphoneCheck2(){
    let phone2 = document.getElementById("cellphone2").value;
    let regphone2 = /^[0-9]{3,4}$/gm;
    
        if(!regphone2.test(phone2)){
            document.getElementById("cellphonedemo").innerHTML = "다시 입력하세요";
        }
        else{
            document.getElementById("cellphonedemo").innerHTML = " ";
        }
    
}
//휴대 전화 검사2
function cellphoneCheck3(){
    let phone2 = document.getElementById("cellphone3").value;
    let regphone2 = /^[0-9]{4}$/gm;
    
        if(!regphone2.test(phone2)){
            document.getElementById("cellphonedemo").innerHTML = "다시 입력하세요";
        }
        else{
            document.getElementById("cellphonedemo").innerHTML = " ";
        }

}
	

	
