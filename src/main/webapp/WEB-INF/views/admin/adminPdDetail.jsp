<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>adminPdDetail.jsp</title>
	<style>
	</style>
	<body style="background-color : #171721;">
	<jsp:include page="/WEB-INF/views/include/bs4.jsp"/>
	<jsp:include page="/WEB-INF/views/include/nav.jsp"/>
	<jsp:include page="/WEB-INF/views/include/adminNav.jsp"/>
	<script>
		//수정버튼 클릭시
		function productEdit(idx) {
			location.href="${ctp}/admin/productEdit?idx="+idx;
		}
	</script>
</head>
<body>
	<div class="container" style="font-family:'pretendard';">
		<table class="table table-borderless pt-3 mb-0" style="background-color:white; width:100%; font-family:'pretendard';">
			<tr>
				<td class="text-center mt-3 mb-3">
					<br/>
					<h2 style="font-family : 'pretendard'; margin-bottom:0px;">상품 상세 정보</h2>
					<br/>
				</td>
			</tr>
		</table>
		<div class="container mt-0 mb-0" style="background-color:white; margin-top:0px;">
			<table class="table table-borderless pt-3 mb-0" style="background-color:white; width:90%; font-family : 'pretendard'; margin:auto;">
				<c:set var="mainCode" value="${fn:substring(vo.productCode,0,1)}"/>
				<c:set var="middleCode" value="${fn:substring(vo.productCode,1,3)}"/>	
				<tr style="border-top:1px solid #DEE2E6; border-bottom:1px solid #DEE2E6;">
					<td rowspan="6" class="col-4"><img src="${ctp}/dbShop/${vo.FSName}" width="100%;"></td>
					<td class="text-center" style="background-color:#f0f0f0;">등록번호</td>
					<td class="text-left">${vo.idx}</td>
				</tr>
				<tr style="border-bottom:1px solid #DEE2E6;">
					<td class="text-center" style="background-color:#f0f0f0;">상품코드</td>
					<td>${vo.productCode}</td>
				</tr>
				<tr style="border-bottom:1px solid #DEE2E6;">
					<td class="text-center" style="background-color:#f0f0f0;">대분류</td>
					<td>
						<c:if test="${mainCode == 'A'}">음반</c:if>
						<c:if test="${mainCode == 'B'}">BD&DVD</c:if>
						<c:if test="${mainCode == 'C'}">포스터</c:if>
						<c:if test="${mainCode == 'D'}">기타</c:if>
					</td>
				</tr>
				<tr style="border-bottom:1px solid #DEE2E6;">
					<td class="text-center" style="background-color:#f0f0f0;">중분류</td>
					<td>
						<c:if test="${middleCode == '01'}">CD</c:if>
						<c:if test="${middleCode == '02'}">LP</c:if>
						<c:if test="${middleCode == '03'}">BD&DVD</c:if>
						<c:if test="${middleCode == '04'}">미니</c:if>
						<c:if test="${middleCode == '05'}">대형</c:if>
						<c:if test="${middleCode == '06'}">문구</c:if>
						<c:if test="${middleCode == '07'}">뱃지</c:if>
					</td>
				</tr>
				<tr style="border-bottom:1px solid #DEE2E6;">
					<td class="text-center" style="background-color:#f0f0f0;">상품명</td>
					<td>${vo.productName}</td>
				</tr>
				<tr style="border-bottom:1px solid #DEE2E6;">
					<td class="text-center" style="background-color:#f0f0f0;">간단설명</td>
					<td>${vo.detail}</td>
				</tr>
			</table><br/>
			<table class="table table-borderless pt-3 mb-0" style="background-color:white; width:90%; font-family : 'pretendard'; margin:auto;">
				<tr>
					<td colspan="4"><b>가격정보</b></td>
				</tr>
				<tr style="border-top:1px solid #DEE2E6; border-bottom:1px solid #DEE2E6;">
					<td style="background-color:#f0f0f0;" class="text-center">원가</td>
					<td><fmt:formatNumber value="${vo.mainPrice}"/>원</td>
					<td style="background-color:#f0f0f0;" class="text-center">할인가</td>
					<td>
						<c:if test="${vo.saleRate == '1'}">
							할인 없음
						</c:if>
						<c:if test="${vo.saleRate != '1'}">
							<font color="#EA5455"><fmt:formatNumber value="${vo.salePrice}"/>원</font>
						</c:if>
					</td>
					<td style="background-color:#f0f0f0;" class="text-center">할인율</td>
					<td>
						<c:if test="${vo.saleRate == '1'}">
							할인 없음
						</c:if>
						<c:if test="${vo.saleRate != '1'}">
							<font color="#EA5455"><fmt:formatNumber value="${vo.saleRate}" type="percent"/></font>
						</c:if>
					</td>
				</tr>
				<tr style="border-bottom:1px solid #DEE2E6;">
					<c:forEach var="vo" items="${optionVos}">
						<td style="background-color:#f0f0f0;" class="text-center">옵션명</td>
						<td>${vo.optionName}</td>
						<td style="background-color:#f0f0f0;" class="text-center">옵션가격</td>
						<td>${vo.optionPrice}</td>
					</c:forEach>
				</tr>
			</table><br/>
			<table class="table table-borderless pt-3 mb-0" style="background-color:white; width:90%; font-family : 'pretendard'; margin:auto;">
				<tr>
					<td><b>상세정보</b></td>
				</tr>
				<tr style="border-top:1px solid #DEE2E6; border-bottom:1px solid #DEE2E6;">
					<td>${vo.content}</td>
				</tr>
			</table>
			<div class="text-center">
				<button type="button" class="btn btn-dark text-center" onclick="productEdit(${vo.idx})">수정하기</button>
				<button type="button" class="btn btn-dark text-center" onclick="location.href='${ctp}/admin/admin_pdList';">상품목록</button>
			</div><br/>
		</div>
	</div>
	<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>