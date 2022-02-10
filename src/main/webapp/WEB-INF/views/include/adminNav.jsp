<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>adminNav.jsp</title>
<style>
	#adminNav{
		color:#263155;
	}
</style>
</head>
<body>
	<p><br/><br/><br/><br/><br/></p>
	<div>
		<h2 style="text-align:center; font-family: 'pretendard'; color:#a8dadc;"><a href="${ctp}/admin/adminMain" style="text-decoration:none; color:#a8dadc; font-family: 'pretendard';">관리자 페이지</a></h2>
	</div>	
<br/><br/>
<div class="container text-center" style="width:100%; text-align:center;">
	<div class="w3-bar w3-center" style="background-color:white; width:100%; text-align:center; font-family: 'pretendard'; border-bottom:1px solid lightgrey;">
	    <a href="${ctp}/admin/admin_memList" class="w3-bar-item w3-mobile" style="text-align:center; color:#263155; text-decoration:none;">회원관리</a>
	    <a href="${ctp}/admin/admin_boardList" class="w3-bar-item w3-mobile w3-center" style="text-align:center; color:#263155;text-decoration:none;">게시판관리</a>
	    <a href="${ctp}/admin/admin_orderList" class="w3-bar-item w3-mobile" style="text-align:center; color:#263155; text-decoration:none;">주문관리</a>
		<div class="w3-dropdown-hover w3-mobile" style="background-color:transparent; text-align:center;">
			<button class="w3-button" style="color:#263155;">상품관리 <i class="fa fa-caret-down"></i></button>
			<div class="w3-dropdown-content w3-bar-block w3-border">
				<a href="${ctp}/admin/productRegister" class="w3-bar-item w3-mobile" style="color:#263155; text-decoration:none;">상품등록</a>
				<a href="${ctp}/admin/admin_pdList" class="w3-bar-item w3-mobile" style="color:#263155; text-decoration:none;">상품목록</a>
				<a href="${ctp}/admin/productCateRegister" class="w3-bar-item w3-mobile" style="color:#263155; text-decoration:none;">분류관리</a>
				<a href="${ctp}/admin/pdOptionRegister" class="w3-bar-item w3-mobile" style="color:#263155; text-decoration:none;">옵션관리</a>
				<a href="${ctp}/admin/admin_reviewList" class="w3-bar-item w3-mobile" style="color:#263155; text-decoration:none;">리뷰관리</a>
			</div>
		</div>
  	</div>
</div>
</body>
</html>