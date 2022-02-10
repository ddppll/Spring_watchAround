<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<% pageContext.setAttribute("newLine", "\n"); %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>productList.jsp</title>
<style>
	.pdImg:hover{
		filter:brightness(50%);
	}
</style>
</head>
<body style="background-color : #171721;">
<jsp:include page="/WEB-INF/views/include/bs4.jsp"/>
<jsp:include page="/WEB-INF/views/include/nav.jsp"/>
<jsp:include page="/WEB-INF/views/include/shopNav.jsp"/>

<div class="container pt-5 pb-5 pr-0 pl-0" style="font-family:'pretendard'; width:1110px; background-color:white; border-bottom:solid 1px #171721;">
<c:set var="cnt" value="0"/>
	<div class="row">
		<c:forEach var="vo" items="${vos}">
		<div class="col-md-3">
			<div style="text-align:center;">
				<a href="${ctp}/shop/shopContent?idx=${vo.idx}">
					<img src="${ctp}/dbShop/${vo.FSName}" class="pdImg" width="200px" height="200px"/>
					<div class="mt-3"><font size="3rem" color="#171721";><b>${vo.productName}</b></font></div>
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
		<c:if test="${cnt%4 == 0}">
			</div>
			<div class="row mt-5">
		</c:if>
		</c:forEach>
	</div>
	
	<!-- 블록 페이징처리 시작(BS4 스타일적용) -->
		<div class="container mt-0 mb-0" style="background-color:white; margin-top:0px;"><br/>
			<ul class="pagination justify-content-center">
				<c:if test="${totPage == 0}"><p style="text-align:center"><b>자료가 없습니다.</b></p></c:if>
				<c:if test="${totPage != 0}">
				  <c:if test="${pag != 1}">
				    <li class="page-item"><a href="${ctp}/shop/productList?pag=1&pageSize=${pageSize}&mainCate=${mainCate}&midCate=${midCate}" title="첫페이지" class="page-link text-secondary">◁◁</a></li>
				  </c:if>
				  <c:if test="${curBlock > 0}">
				    <li class="page-item"><a href="${ctp}/shop/productList?pag=${(curBlock-1)*blockSize + 1}&pageSize=${pageSize}&mainCate=${mainCate}&midCate=${midCate}" title="이전블록" class="page-link text-secondary">◀</a></li>
				  </c:if>
				  <c:forEach var="i" begin="${(curBlock*blockSize)+1}" end="${(curBlock*blockSize)+blockSize}">
				    <c:if test="${i == pag && i <= totPage}">
				      <li class="page-item active"><a href='${ctp}/shop/productList?pag=${i}&pageSize=${pageSize}&mainCate=${mainCate}&midCate=${midCate}' class="page-link text-light bg-secondary border-secondary">${i}</a></li>
				    </c:if>
				    <c:if test="${i != pag && i <= totPage}">
				      <li class="page-item"><a href='${ctp}/shop/productList?pag=${i}&pageSize=${pageSize}&mainCate=${mainCate}&midCate=${midCate}' class="page-link text-secondary">${i}</a></li>
				    </c:if>
				  </c:forEach>
				  <c:if test="${curBlock < lastBlock}">
				    <li class="page-item"><a href="${ctp}/shop/productList?pag=${(curBlock+1)*blockSize + 1}&pageSize=${pageSize}&mainCate=${mainCate}&midCate=${midCate}" title="다음블록" class="page-link text-secondary">▶</a>
				  </c:if>
				  <c:if test="${pag != totPage}">
				    <li class="page-item"><a href="${ctp}/shop/productList?pag=${totPage}&pageSize=${pageSize}&mainCate=${mainCate}&midCate=${midCate}" title="마지막페이지" class="page-link" style="color:#555">▷▷</a>
				  </c:if>
				</c:if>
			</ul>
		</div>
		<!-- 블록 페이징처리 끝 -->
	
</div>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>