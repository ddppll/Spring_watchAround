<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="${ctp}/css/memberLogin.css">
<meta charset="UTF-8">
<title>memberLogin.jsp</title>
</head>
<body style="background-color : #171721;font-family: 'pretendard';">
<jsp:include page="/WEB-INF/views/include/bs4.jsp"/>
<!-- <div class="container"> -->
	<!-- <div class="modal-dialog modal-dialog-centered"> -->
      <!-- <div class="modal-content" style="top:50%;"> -->
      	<div class="container " style="padding:30px; background-color:white; width:500px; margin-top:14%;">
			<h2 style="font-family: 'pretendard';">비밀번호 찾기</h2>
			<hr/>
			<form name="myform" method="post" class="was-validated">
				<div class="form-group">
				    <input type="text" class="form-control" id="toMail" placeholder="가입 시 등록한 이메일을 입력하세요." name="toMail" value="${sEmail}" required autofocus style="width:100%;" />
				    <div class="invalid-feedback">이메일을 입력하세요</div>
				</div>
				<div class="mb-3 text-center" style="float:none; margin:0 auto;">
				  	<p><font size="2rem" color="#2a9d8f">기존에 가입하신 이메일 주소를 입력하시면 임시 비밀번호가 발송됩니다. <br/>발급받은 비밀번호로 로그인한 뒤 새 비밀번호를 설정하세요.</font></p>
				</div>
				<div class="text-center">
					  <button type="submit" class="btn btn-dark btn-block">확인</button><br/>
					  <button type="button" onclick="location.href='${ctp}/member/memberLogin';" class="btn btn-block btn-outline-dark">돌아가기</button>
				</div>
			</form> 
			</div>
		<!-- </div> -->
	<!-- </div> -->
<!-- </div> -->
</body>
</html>