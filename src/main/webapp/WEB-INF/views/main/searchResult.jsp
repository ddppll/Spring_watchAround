<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="css/main.css">
<meta charset="UTF-8">
<title>watchAround. - 검색 결과</title>
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
</style>
</head>
<body style="background-color : #171721; font-family:'pretendard';">
<jsp:include page="/WEB-INF/views/include/bs4.jsp"/>
<jsp:include page="/WEB-INF/views/include/nav.jsp"/>
	<div class="container" id="searchHeader" style="width:100%;margin-top:70px;">
		<img src="${ctp}/image/searchTitle.jpg" style="width:1110px; height:auto;"/>
	</div>
	<div class="container" style="background-color:white; width:1110px;margin-top:0px;">
		<div style="background-color:white; padding-top:30px; padding-bottom:30px; ">
			<form class="form-inline" name="myform" action="${ctp}/search/searchKeyword">
				<input type="text" id="keyword" name="keyword" placeholder="검색할 작품명을 입력하세요" style="width:80%; margin:0 auto;"/>
			    <input type="button" class="btn btn-outline-dark" value="검색" onclick="mainSearch()" style="display:none;">
			</form>
		</div>
		<div class="text-center mt-0">
			<br/>
			<b>입력한 검색어</b> : ${keyword}
		</div>
		<div class="text-center">
			<b>찾은 작품</b> : <font color=#EA5455>${contentTitle}</font>
		</div><br/><br/>
		<div class="text-center">
			<font size=5 color=#2a9d8f>지금 바로 감상하러 가세요!</font>
		</div>
		<br/>
		<div class="text-center">
			<c:set var="vo" value="${ott}"/>
			<c:set var="vo2" value="${ottLink}"/>
			<c:forEach var="linkVo" items="${vo2}">
				<c:if test="${fn:contains(linkVo, 'neftlix')}">
					<a href="${linkVo}">
						<img src="${ctp}/image/icon_netflix.jpg" style="width:50px; height:50px;">
					</a>
				</c:if>
				<c:if test="${fn:contains(linkVo, 'coupang')}">
					<a href="${linkVo}">
						<img src="${ctp}/image/icon_coupang.jpg" style="width:50px; height:50px; border-radius:7px;">
					</a>
				</c:if>
				<c:if test="${fn:contains(linkVo, 'wavve')}">
					<a href="${linkVo}">
						<img src="${ctp}/image/icon_wavv.jpg" style="width:50px; height:50px; border-radius:7px;">
					</a>
				</c:if>
				<c:if test="${fn:contains(linkVo, 'watcha')}">
					<a href="${linkVo}">
						<img src="${ctp}/image/icon_watcha.jpg" style="width:50px; height:50px; border-radius:7px;">
					</a>
				</c:if>
				<c:if test="${fn:contains(linkVo, 'disney')}">
					<a href="${linkVo}">
						<img src="${ctp}/image/icon_disney.jpg" style="width:50px; height:50px; border-radius:7px;">
					</a>
				</c:if>
				<c:if test="${fn:contains(linkVo, 'seezn')}">
					<a href="${linkVo}">
						<img src="${ctp}/image/icon_seezn.png" style="width:50px; height:50px; border-radius:7px;">
					</a>
				</c:if>
				<c:if test="${fn:contains(linkVo, 'tving')}">
					<a href="${linkVo}">
						<img src="${ctp}/image/icon_tving.png" style="width:50px; height:50px; border-radius:7px;">
					</a>
				</c:if>
				<c:if test="${fn:contains(linkVo, 'primevideo')}">
					<a href="${linkVo}">
						<img src="${ctp}/image/icon_amazon.jpg" style="width:50px; height:50px; border-radius:7px;">
					</a>
				</c:if>
			</c:forEach>
		</div>
		<br/><br/>
	</div>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>