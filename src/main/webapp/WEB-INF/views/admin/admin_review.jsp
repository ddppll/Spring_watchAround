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
	<title>admin_review.jsp</title>
	<body style="background-color : #171721;">
	<jsp:include page="/WEB-INF/views/include/bs4.jsp"/>
	<jsp:include page="/WEB-INF/views/include/nav.jsp"/>
	<jsp:include page="/WEB-INF/views/include/adminNav.jsp"/>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.24.0/moment.min.js"></script>
	<script>
	</script>
</head>
<body>
	<div class="container" style="font-family:'pretendard';">
		<table class="table table-borderless mb-0" style="background-color:white;">
			<tr>
				<td colspan="2" style="background-color:white;"><br/>
					<h3 style="text-align:center; font-family: 'pretendard'; color:#264653;">
						<a href="#" style="color:#264653;text-decoration-line: none;">리뷰 상세 정보</a>
					</h3>
				</td>
			</tr>
		</table>
		<div class="container mt-0 mb-0" style="background-color:white;">
		<table class="table table-borderless mb-0" style="background-color:white; width:70%; margin:auto;">
			
			<tr style="border-bottom:1px solid lightgrey">
				<td colspan="2"><b>상품 정보</b></td>
			</tr>
			<tr class="text-center">
				<td class="text-center" rowspan="4">
					<img src="${ctp}/dbShop/${vo.FSName}" class="thumb" width="150px"/>
				</td>
				<td><b>${vo.productName }</b></td>
			</tr>
			<tr class="text-center">
				<td><font color=grey>${vo.detail}</font></td>
			</tr>
			<tr class="text-center">
				<td>
					<c:if test="${vo.rating == '1'}">
						<fmt:formatNumber value="${vo.mainPrice}"/>원
					</c:if>
					<c:if test="${vo.rating != '1'}">
						<c:if test="${vo.saleRate != '1'}">
							<strike><fmt:formatNumber value="${vo.mainPrice}"/>원</strike>
							<b><font color="#f77f00"><fmt:formatNumber value="${vo.salePrice}"/>원</font></b>
							&nbsp;<b><font color="#EA5455"><fmt:formatNumber value="${vo.saleRate}" type="percent"/></font></b>
						</c:if>
						<c:if test="${vo.saleRate == '1'}">
							<b><font color="#f77f00"><fmt:formatNumber value="${vo.mainPrice}"/>원</font></b>
						</c:if>
					</c:if>
				</td>
			</tr>
			<tr class="text-center">
				<td>리뷰&nbsp;&nbsp;<b>${reviewCnt}</b>건&nbsp;&nbsp;&nbsp;평점&nbsp;&nbsp;<b><fmt:formatNumber value="${reviewRateAvg}" pattern=".0"/></b></td>
			</tr>
		</table><br/>
		
		<table class="table table-borderless mt-0" style="background-color:white; width:70%; margin:auto;">
			<tr style="border-bottom:1px solid lightgrey;">
				<td colspan="2"><b>리뷰정보</b></td>
			</tr>
			<tr style="border-bottom:1px solid lightgrey;">
				<td class="col-1 text-center"><b>별점</b></td>
				<td>
					<c:if test="${vo.rating == 1}">
						<p class="ml-4 mb-0">
							<label class="outputStar" style="color:#f90;">&#9733;</label>
							<label class="outputStar" style="color:#ccc;">&#9733;</label>
							<label class="outputStar" style="color:#ccc;">&#9733;</label>
							<label class="outputStar" style="color:#ccc;">&#9733;</label>
							<label class="outputStar" style="color:#ccc;">&#9733;</label>
							&nbsp;<b>${vo.rating}</b>&nbsp;
						</p>
					</c:if>
					<c:if test="${vo.rating == 2}">
						<p class="ml-4 mb-0">
							<label class="outputStar" style="color:#f90;">&#9733;</label>
							<label class="outputStar" style="color:#f90;">&#9733;</label>
							<label class="outputStar" style="color:#ccc;">&#9733;</label>
							<label class="outputStar" style="color:#ccc;">&#9733;</label>
							<label class="outputStar" style="color:#ccc;">&#9733;</label>
							&nbsp;<b>${vo.rating}</b>&nbsp;
						</p>
					</c:if>
					<c:if test="${vo.rating == 3}">
						<p class="ml-4 mb-0">
							<label class="outputStar" style="color:#f90;">&#9733;</label>
							<label class="outputStar" style="color:#f90;">&#9733;</label>
							<label class="outputStar" style="color:#f90;">&#9733;</label>
							<label class="outputStar" style="color:#ccc;">&#9733;</label>
							<label class="outputStar" style="color:#ccc;">&#9733;</label>
							&nbsp;<b>${vo.rating}</b>&nbsp;
						</p>
					</c:if>
					<c:if test="${vo.rating == 4}">
						<p class="ml-4 mb-0">
							<label class="outputStar" style="color:#f90;">&#9733;</label>
							<label class="outputStar" style="color:#f90;">&#9733;</label>
							<label class="outputStar" style="color:#f90;">&#9733;</label>
							<label class="outputStar" style="color:#f90;">&#9733;</label>
							<label class="outputStar" style="color:#ccc;">&#9733;</label>
							&nbsp;<b>${vo.rating}</b>&nbsp;
						</p>
					</c:if>
					<c:if test="${vo.rating == 5}">
						<p class="ml-4 mb-0">
							<label class="outputStar" style="color:#f90;">&#9733;</label>
							<label class="outputStar" style="color:#f90;">&#9733;</label>
							<label class="outputStar" style="color:#f90;">&#9733;</label>
							<label class="outputStar" style="color:#f90;">&#9733;</label>
							<label class="outputStar" style="color:#f90;">&#9733;</label>
							&nbsp;<b>${vo.rating}</b>&nbsp;
						</p>
					</c:if>
				</td>
				<td class="text-center">
					<b>작성일시</b>
				</td>
				<td>${vo.reviewDate}</td>
				<td class="text-center">
					<b>작성자</b>
				</td>
				<td>${vo.email}</td>
			</tr>
			<tr style="border-bottom:1px solid lightgrey;">
				<c:if test="${vo.photo != null}">
					<td style="padding-bottom:13px;" colspan="3">
						<p class="ml-4 mb-0">${fn:replace(vo.content,newLine,'<br/>')}</p>
					</td>
				</c:if>
				<c:if test="${vo.photo == null}">
					<td colspan="2" style="padding-bottom:13px;" colspan="6">
						<p class="ml-4 mb-0">${fn:replace(vo.content,newLine,'<br/>')}</p>
					</td>
				</c:if>
				<c:if test="${vo.photo != null}">
					<td class="text-right pr-4" style="padding-bottom:13px;" colspan="3">
						<img src="${ctp}/review/${vo.photo}" width="100px" height="100px" class="reviewImg" style="cursor:pointer;" onclick="window.open('${ctp}/review/${vo.photo}','리뷰이미지','width=500px, height=500px, resizable=yes, location=no, toolbar=no')"/>
					</td>
				</c:if>
			</tr>
		</table>
		<br/>
		<p class="text-center">
			<button type="button" class="btn btn-dark text-center" onclick="location.href='${ctp}/admin/admin_reviewList';">목록</button>
		</p><br/>
		</div>
	</div>
	<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>