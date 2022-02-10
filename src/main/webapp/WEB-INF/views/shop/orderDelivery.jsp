<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<% pageContext.setAttribute("newLine", "\n"); %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>orderDelivery.jsp</title>
<jsp:include page="/WEB-INF/views/include/bs4.jsp"/>
<style>
	body{
		font-family : 'pretendard';
	}
</style>
</head>
<body>
	<div class="container pt-3" style="margin:auto;">
		<table class="table table-borderless" style="margin:auto; border-top:none;">
			<c:if test="${fn:substring(vo.payment,0,1) == 'C'}"><c:set var="payment" value="카드결제"/></c:if>
  			<c:if test="${fn:substring(vo.payment,0,1) == 'B'}"><c:set var="payment" value="무통장입금"/></c:if>
  			<c:if test="${vo.payment == 'cellphonePay'}"><c:set var="payment" value="핸드폰결제"/></c:if>
  			<tr class="text-center pt-2">
  				<td colspan="4"><h3 style="font-family:'pretendard';">배송조회</h3><hr/></td>
  			</tr>
			<tr>
				<td class="text-center" style="background-color:#E8E8E4; width:20%;">수령인</td>
				<td>${vo.name}</td>
			</tr>
			<tr>
				<td class="text-center" style="background-color:#E8E8E4">연락처</td>
				<td colspan="3">${vo.tel}</td>
			</tr>
			<tr>
				<td class="text-center" style="background-color:#E8E8E4">주소</td>
				<td colspan="3">${vo.address}</td>
			</tr>
			<tr>
				<td class="text-center" style="background-color:#E8E8E4">배송메모</td>
				<td colspan="3">
					<c:if test="${empty vo.message}">없음</c:if> 
					${vo.message}
				</td>
			</tr>
			<tr>
				<td class="text-center" style="background-color:#E8E8E4">결제방법</td>
				<td>${payment}</td>
				<c:if test="${payment != '핸드폰결제'}">
					<td class="text-center" style="background-color:#E8E8E4;">은행</td>
					<td>${fn:substring(vo.payment,1,fn:length(vo.payment))}</td>
				</c:if>
			</tr>
			<tr class="text-center">
				<td colspan="4" class="text-center">
					<input type="button" class="btn btn-outline-dark" value="닫기" onclick="window.close()"/>
				</td>
			</tr>
		</table>
	</div>
</body>
</html>