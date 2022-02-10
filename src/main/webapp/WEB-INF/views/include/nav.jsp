<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<link rel="stylesheet" type="text/css" href="${ctp}/css/memberJoin.css">
<%
	int level = session.getAttribute("sLevel")==null? 99 : (int)session.getAttribute("sLevel");
%>
<script src="${ctp}/js/memberJoin.js"></script>
<script>
	var emailCheckOn = 0;
	var nickCheckOn = 0;
	// 이메일 중복체크(ajax처리)
	function emailCheck() {
		var email = $("#email").val();
		
			$.ajax({
				type : "post",
				url  : "${ctp}/member/emailCheck",
				data : {email : email},
				success : function(data){
					
					if(data == "1"){
						alert("이미 사용중인 이메일입니다.")
						$("#email").focus();
					}
					else{
						alert("사용 가능한 이메일입니다.");
			   			emailCheckOn = 1;	//이메일 중복검사 버튼을 클릭했을 때 emailCheckOn이 1이 됨
					}
				},
				error : function(){
					alert("전송 오류");
				}
			});
	}
		
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
						nickCheckOn = 1;	//닉네임 중복검사 버튼을 클릭했을 때 nickCheckOn이 1이 됨
					}
				},
				error : function(){
					alert("전송 오류");
				}
			});
	}
	
	function emailReset() {
		emailCheckOn = 0;
	}
	
	function nickReset() {
		nickCheckOn = 0;
	}

	
	function memDeleteCheck(){
		var ans = confirm("정말 탈퇴하시겠습니까?");
		if(ans) {
			ans = confirm("탈퇴하시게되면 1개월간 동일 아이디로 재가입이 불가능합니다.\n탈퇴하시겠습니까?");
			if(ans) location.href="${ctp}/member/memDelete";
		}
	}
</script>
<style>
	.modal-content{
		font-family: 'pretendard';	
	}
	.modal-title{
		text-align:center;
	}
	nav{
		font-family: 'pretendard';	
	}
</style>
<nav class="navbar navbar-expand-sm py-3 fixed-top" id="navbar">
	<a class="navbar-brand" style="font-family: 'pretendard'; color: white;" href="${ctp}/main">watchAround.</a>
	<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#collapsibleNavbar">
		<!--<span class="navbar-toggler-icon"></span>-->
		<i class="fas fa-bars" style="color:white;"></i>
	</button>
	<div class="collapse navbar-collapse" id="collapsibleNavbar">
		<ul class="navbar-nav ml-auto" style="font-family: 'pretendard';">
			<!--  <form class="form-inline" name="myform" action="${ctp}/search/searchKeyword">
			    <input class="form-control mr-sm-2" type="text" id="keyword" name="keyword" placeholder="Search"/>
			    <input type="button" class="btn btn-sm btn-light" value="검색" onclick="mainSearch()">
			    <button class="btn btn-light" onclick="mainSearch()" type=>Search</button>
	 		</form>-->
	 		<li class="nav-item">
	 			<a class="nav-link" href="${ctp}/board/boardList" style="color: white;">게시판</a>
	 		</li>
	 		<li class="nav-item">
	 			<a class="nav-link" href="${ctp}/shop/productList" style="color: white;">Shop</a>
	 		</li>
	 		<li class="nav-item">
	 			<a class="nav-link" href="${ctp}/shop/pdCartList" style="color: white;"><i class="fas fa-shopping-cart" id="fas"></i></a>
	 		</li>
			<li class="nav-item dropdown">
				<c:if test="${!empty sLevel}"><a class="nav-link dropdown-toggle" href="#" id="navbardrop" data-toggle="dropdown" style="color: white;">
				회원메뉴
				</a></c:if>
				<div class="dropdown-menu">
				    <c:if test="${sLevel == 0}"><a class="dropdown-item" href="${ctp}/admin/adminMain">관리자메뉴</a></c:if>
					<a class="dropdown-item" href="${ctp}/member/memberEdit">정보수정</a>
					<a class="dropdown-item" href="${ctp}/shop/myGoods">찜 목록</a>
					<a class="dropdown-item" href="${ctp}/shop/pdMyOrder">구매내역</a>
				    <a class="dropdown-item" href="javascript:memDeleteCheck()">회원탈퇴</a>
				</div>
			</li>
			<li class="nav-item">
				<c:if test="${empty sLevel}"><a class="nav-link" href="${ctp}/member/memberLogin" style="color: white;">로그인</a></c:if>
				<c:if test="${!empty sLevel}"><a class="nav-link" href="${ctp}/member/memberLogout" style="color: white;">로그아웃</a></c:if>
			</li>
			<li class="nav-item">
				<c:if test="${empty sLevel}"><a class="nav-link" href="#myModal" data-toggle="modal" style="color: white;">회원가입</a></c:if>
			</li>
		</ul>
	</div>
	
	<!-- The Modal -->
 <div class="modal fade" id="myModal" data-backdrop="false">
   <div class="modal-dialog modal-dialog-centered modal-lg">
     <div class="modal-content">
     
        <!-- Modal Header -->
	    <div class="modal-header">
	      <h4 class="modal-title" style="font-family:'pretendard';">회원 가입</h4>
	      <button type="button" class="close" data-dismiss="modal">&times;</button>
	    </div>
	    
	    <!-- Modal body -->
	    <div class="modal-body">
	    	
	      	<form name="joinForm" method="post" action="${ctp}/member/memberJoin">
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
							<input type="text" class="form-control" oninput="emailCheck2()" onkeyup="emailReset()" placeholder="이메일 형식으로 입력" name="email" id="email" required oninvalid="this.setCustomValidity('이메일을 입력하세요.')" style="display:inline-block; width:200px;"/> 
							<button type="button" class="btn btn-outline-dark btn-sm" id="emailTest" style="text-decoration-line: none;" onclick="emailCheck()">중복확인</button>
							<div><span id="emaildemo" style="font-size: 10pt; color: red;"></span></div>
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
							<input type="text" class="form-control" onkeyup="nickReset()" placeholder="영어/한글, 2~8자" name="nickName" id="nickName" required oninvalid="this.setCustomValidity('닉네임을 입력하세요.')" oninput="nickCheck2()" style="width:200px;display: inline-block;">&nbsp;
							<button type="button" class="btn btn-outline-dark btn-sm" id="nameTest" style="text-decoration-line: none;" onclick="nickCheck()">중복확인</button>
							<div><span id="namedemo" style="font-size: 10pt; color: red;"></span></div>
						</td>
					</tr>
					<tr style="background-color: white;">
						<td class="category">연락처</td>
						<td>
							<select class="form-control" id="cellphone" name="cellphone" >
								<option value="010">010</option>
								<option value="011">011</option>
								<option value="016">016</option>
								<option value="017">017</option>
								<option value="018">018</option>
								<option value="019">019</option>
							</select> -
							<input type="text" class="form-control" name="cellphone2" id="cellphone2" required oninvalid="this.setCustomValidity('번호를 입력하세요.')" oninput="cellphoneCheck2()"> -
							<input type="text" class="form-control" name="cellphone3" id="cellphone3" required oninvalid="this.setCustomValidity('번호를 입력하세요.')" oninput="cellphoneCheck3()">
							<div><span id="cellphonedemo" style="font-size: 10pt; color: red;"></span></div>
						</td>
					</tr>
					<tr>
						<td colspan="2" style="text-align: center;">
							<button type="button" class="btn btn-outline-dark btn-sm" id="idtest" style="text-decoration-line: none;"  onclick="fCheck()">가입하기</button>
						</td>
					</tr>
				</table>
	      </form>
	    </div>
	    
	    <!-- Modal footer -->
	    <div class="modal-footer">
	      <button type="button" class="btn btn-outline-secondary btn-sm" data-dismiss="modal">닫기</button>
	    </div>
     </div>
   </div>
 </div>
  
</nav>