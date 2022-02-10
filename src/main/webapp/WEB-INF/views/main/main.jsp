<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<% pageContext.setAttribute("newLine", "\n"); %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="css/main.css">
<meta charset="UTF-8">
<title>main.jsp</title>
<script type="text/javascript">

//네비바 검색창 검색엔진
function mainSearch(){
	var keyword = document.getElementById("keyword").value;
	if(keyword == ""){
		alert("검색할 작품 제목을 입력하세요!");
		document.getElementById("keyword").focus();
		return false;
	}
	else{
		myform.submit();
	}
	
}
</script>
<style>
	#keyword{
		height:50px;
		border : 1px solid lightgrey;
		border-radius : 5px;
		background-color:#263155;
		font-family : 'pretendard';
		padding-left : 10px;
		color : white;
	}
	#keyword:focus{outline:none;}
	#keyword::placeholder{color:white; text-align:center;}
	
	.mainImg:hover{
		filter:brightness(50%);
	}
</style>
</head>
<body style="background-color : #171721;">
<jsp:include page="/WEB-INF/views/include/bs4.jsp"/>
<jsp:include page="/WEB-INF/views/include/nav.jsp"/>

	<div class="container">
		<video src="${ctp}/video/main.mp4" muted autoplay loop></video>
		<div class="mainTitle">
			<p>한 번의 검색으로<br/>모든 컨텐츠를 즐기세요</p>
		</div>
	</div>
		<div style="background-color:#263155; padding-top:30px; padding-bottom:30px; width:1110px; margin:0 auto;">
			<form class="form-inline" name="myform" action="${ctp}/search/searchKeyword">
				<input type="text" id="keyword" name="keyword" placeholder="검색할 작품명을 입력하세요" style="width:80%; margin:0 auto;"/>
			    <input type="button" class="btn btn-outline-dark" value="검색" onclick="mainSearch()" style="display:none;">
			</form>
		</div>
	<div class="container pt-5 pb-5 pr-0 pl-0 mt-0" style="font-family:'pretendard'; width:1110px; background-color:white; border-bottom:solid 1px #171721;">
	<c:set var="cnt" value="0"/>
		<br/><br/>
		<c:if test="${vos[0] == null}">
			<div class="text-center"><font size=5 color=#2a9d8f>영화의 감동을 간직할 다양한 상품들을 만나보세요</font></div><br/>
			<br/>
			<div class="text-center">
				<b>가장 많이 찜한 상품들</b>
			</div>
			<br/>
			<div class="row text-center">
				<c:forEach var="vo" items="${mostVos}">
				<div class="col-sm">
					<div style="text-align:center;">
						<a href="${ctp}/shop/shopContent?idx=${vo.idx}">
							<img src="${ctp}/dbShop/${vo.FSName}" class="mainImg" width="200px" height="200px"/>
							<div class="mt-3">
								<font size="3rem" color="#171721";>
								<b>${vo.productName}</b></font>
							</div>
							<c:if test="${fn:length(vo.detail)>35}">
								<c:set var="detail1" value="${fn:substring(vo.detail, 0, 35)}"/>
								<c:set var="detail2" value="..."/>
								<div><font size="1.5rem" color="#2a9d8f"><b>${detail1}${detail2}</b></font></div>
							</c:if>
							<c:if test="${fn:length(vo.detail)<=35}">
					            <div><font size="1.5rem" color="#2a9d8f"><b>${vo.detail}</b></font></div>
							</c:if>
							<c:if test="${vo.saleRate == '1'}">
					            <div><font size="2rem" color="#f77f00"><b><fmt:formatNumber value="${vo.mainPrice}" pattern="#,###"/>원</b></font></div>
							</c:if>
							<c:if test="${vo.saleRate != '1'}">
					            <div>
					            	<font size="3rem" color="#EA5455"><b><fmt:formatNumber value="${vo.saleRate}" type="percent"/></b></font>
					            	<font size="2rem" color="#f77f00"><b><fmt:formatNumber value="${vo.salePrice}" pattern="#,###"/>원</b></font>
					            	<font size="2rem" color="grey" style="text-decoration:line-through;"><fmt:formatNumber value="${vo.mainPrice}" pattern="#,###"/>원</font>
					            </div>
					            <div></div>
							</c:if>
						</a>
					</div>		
				</div>
				<c:set var="cnt" value="${cnt+1}"/>
			</c:forEach>
			</div>
		</c:if>
			<br/>
			<br/>
			<div class="text-center">
				<b>가장 많이 구매하신 상품들</b>
			</div>
			<br/>
			<div class="row text-center">
				<c:forEach var="vo" items="${mostSellVos}">
				<div class="col-sm">
					<div style="text-align:center;">
						<a href="${ctp}/shop/shopContent?idx=${vo.productIdx}">
							<img src="${ctp}/dbShop/${vo.FSName}" class="mainImg" width="200px" height="200px"/>
							<div class="mt-3">
								<font size="3rem" color="#171721";>
								<b>${vo.productName}</b></font>
							</div>
							<c:if test="${fn:length(vo.detail)>35}">
								<c:set var="detail1" value="${fn:substring(vo.detail, 0, 35)}"/>
								<c:set var="detail2" value="..."/>
								<div><font size="1.5rem" color="#2a9d8f"><b>${detail1}${detail2}</b></font></div>
							</c:if>
							<c:if test="${fn:length(vo.detail)<=35}">
					            <div><font size="1.5rem" color="#2a9d8f"><b>${vo.detail}</b></font></div>
							</c:if>
							<c:if test="${vo.saleRate == '1'}">
					            <div><font size="2rem" color="#f77f00"><b><fmt:formatNumber value="${vo.mainPrice}" pattern="#,###"/>원</b></font></div>
							</c:if>
							<c:if test="${vo.saleRate != '1'}">
					            <div>
					            	<font size="3rem" color="#EA5455"><b><fmt:formatNumber value="${vo.saleRate}" type="percent"/></b></font>
					            	<font size="2rem" color="#f77f00"><b><fmt:formatNumber value="${vo.salePrice}" pattern="#,###"/>원</b></font>
					            	<font size="2rem" color="grey" style="text-decoration:line-through;"><fmt:formatNumber value="${vo.mainPrice}" pattern="#,###"/>원</font>
					            </div>
					            <div></div>
							</c:if>
						</a>
					</div>		
				</div>
			</c:forEach>
			<br/>
			<br/>
			</div>
			<br/>
			<br/>
			<br/>
	</div>
	

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>