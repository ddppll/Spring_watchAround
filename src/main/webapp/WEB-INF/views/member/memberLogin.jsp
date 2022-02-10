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
      	<div class="container" style="padding:30px; background-color:white; width:500px; margin-top:14%;">
			<h2 style="font-family: 'pretendard';">로그인</h2>
			<hr/>
			<form name="myform" method="post" class="was-validated">
				<div class="row">
				   <span class="col mb-3"><input type="checkbox" name="emailSave" checked/> 이메일 저장</span>
				</div>
				<div class="form-group">
				    <input type="text" class="form-control" id="email" placeholder="이메일을 입력하세요." name="email" value="${email}" required autofocus style="width:100%;" />
				    <div class="invalid-feedback">이메일을 입력하세요</div>
				  </div>
				  <div class="form-group">
				    <input type="password" class="form-control" id="pwd" placeholder="비밀번호를 입력하세요" name="pwd" required style="width:100%;"/>
				    <div class="invalid-feedback">비밀번호를 입력하세요</div>
				  </div>
				  <div class="mb-3 text-center" style="float:none; margin:0 auto;">
				  	<a href="${ctp}/member/pwdConfirm" style="text-decoration:none; text-align:center;">비밀번호를 잊어버리셨나요?</a>
				  </div>
				  <div class="text-center">
					  <button type="submit" class="btn btn-dark btn-block">로그인</button><br/>
					  <button type="button" onclick="location.href='${ctp}/main';" class="btn btn-block btn-outline-dark">돌아가기</button>
				  </div>
			</form> 
			</div>
		<!-- </div> -->
	<!-- </div> -->
<!-- </div> -->
</body>
</html>