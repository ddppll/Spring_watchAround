<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="${ctp}/css/memberLogin.css">
<script src="${ctp}/js/memberEdit.js"></script>
<script>
	// 닉네임 중복체크(ajax처리)
	function nickCheck() {
		var nickName = $("#nickName").val();
			$.ajax({
				type : "post",
				url  : "${ctp}/member/nickNameCheck",
				data : {nickName : nickName},
				success : function(data){
					if(data == "1"){
						alert("이미 사용중인 닉네임입니다.")
						$("#nickName").focus();
					}
					else{
						alert("사용 가능한 닉네임입니다.");
					}
				},
				error : function(){
					alert("전송 오류");
				}
			});
	}
</script>
<meta charset="UTF-8">
<title>memberEdit.jsp</title>
</head>
<body style="background-color : #171721;font-family: 'pretendard';">
<jsp:include page="/WEB-INF/views/include/bs4.jsp"/>
<!-- <div class="container"> -->
	<!-- <div class="modal-dialog modal-dialog-centered"> -->
      <!-- <div class="modal-content" style="top:50%;"> -->
      	<div class="container" style="padding:30px; background-color:white; width:700px; margin-top:10%;">
			<h2 style="font-family: 'pretendard';">회원 정보 수정</h2>
			<hr/>
			<form name="myform" method="post" class="was-validated">
				<table class="table table-borderless" id="basicTable">
					<tr style="background-color: white;">
						<td colspan="2">
							<b>기본정보</b>&nbsp;
								<font style="color: blue; font-weight: bold;">*</font><font style="font-size : 10pt; color: gray;">표시는 필수입력입니다</font>
						</td>
					</tr>
					<tr style="background-color: white;">
						<td class="category" >이메일<font style="color: blue; font-weight: bold;"> *</font></td>
						<td>
							<input type="text" class="form-control" value="${sEmail}" placeholder="이메일 형식으로 입력" name="email" id="email" required oninvalid="this.setCustomValidity('이메일을 입력하세요.')" style="display:inline-block; width:200px;" readonly/> 
						</td>
					</tr>
					<tr style="background-color: white;">
						<td class="category">비밀번호<font style="color: blue; font-weight: bold;"> *</font></td>
						<td>
							<input type="password" class="form-control" placeholder="영어/숫자/특수문자,8~16자" name="pwd" id="pwd" required oninvalid="this.setCustomValidity('비밀번호를 입력하세요.')" oninput="pwdCheck()">
							<div><span id="pwddemo" style="font-size: 10pt; color: red;"></span></div>
						</td>
					</tr>
					<tr style="background-color: white;">
						<td class="category">비밀번호 확인<font style="color: blue; font-weight: bold;"> *</font></td>
						<td>
							<input type="password" class="form-control" placeholder="비밀번호 확인" name="pwdConfirm" id="pwdConfirm" required oninvalid="this.setCustomValidity('비밀번호를 입력하세요.')" oninput="pwdConfirmCheck()">
							<div><span id="pwdConfirmDemo" style="font-size: 10pt; color: red;"></span></div>
						</td>
					</tr>
					<tr style="background-color: white;">
						<td class="category">닉네임<font style="color: blue; font-weight: bold;"> *</font></td>
						<td>
							<input type="text" class="form-control" placeholder="영어/한글, 2~8자" name="nickName" id="nickName" value="${vo.nickName}" required oninvalid="this.setCustomValidity('닉네임을 입력하세요.')" oninput="nickCheck2()" style="width:200px;display: inline-block;">&nbsp;
							<button type="button" class="btn btn-outline-dark btn-sm" id="nameTest" style="text-decoration-line: none;" onclick="nickCheck()">중복확인</button>
							<div><span id="namedemo" style="font-size: 10pt; color: red;"></span></div>
						</td>
					</tr>
					<tr style="background-color: white;">
						<td class="category">연락처</td>
						<td>
							<select class="form-control" id="cellphone" name="cellphone" style="width:100px;display: inline-block;">
							<c:set var="tel1" value="${fn:split(vo.tel,'/')[0]}"/>
								<option value="010" ${tel1=='010' ? 'selected' : ''}>010</option>
								<option value="011" ${tel1=='011' ? 'selected' : ''}>011</option>
								<option value="016" ${tel1=='016' ? 'selected' : ''}>016</option>
								<option value="017" ${tel1=='017' ? 'selected' : ''}>017</option>
								<option value="018" ${tel1=='018' ? 'selected' : ''}>018</option>
								<option value="019" ${tel1=='019' ? 'selected' : ''}>019</option>
							</select> -
							<input type="text" class="form-control" name="cellphone2" id="cellphone2" value="${fn:split(vo.tel,'/')[1]}" required oninvalid="this.setCustomValidity('번호를 입력하세요.')" oninput="cellphoneCheck2()" style="width:100px;display: inline-block;"> -
							<input type="text" class="form-control" name="cellphone3" id="cellphone3" value="${fn:split(vo.tel,'/')[2]}" required oninvalid="this.setCustomValidity('번호를 입력하세요.')" oninput="cellphoneCheck3()" style="width:100px;display: inline-block;">
							<div><span id="cellphonedemo" style="font-size: 10pt; color: red;"></span></div>
						</td>
					</tr>
					<tr>
						<td colspan="2" style="text-align: center;">
							<button type="button" class="btn btn-outline-dark" id="idtest" style="text-decoration-line: none;"  onclick="fCheck()">수정하기</button>
						</td>
					</tr>
				</table>
			</form> 
			</div>
		<!-- </div> -->
	<!-- </div> -->
<!-- </div> -->
</body>
</html>