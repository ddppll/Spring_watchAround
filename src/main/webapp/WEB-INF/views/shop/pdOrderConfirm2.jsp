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
<title>pdOrder.jsp</title>
<jsp:include page="/WEB-INF/views/include/bs4.jsp"/>
<jsp:include page="/WEB-INF/views/include/nav.jsp"/>
<jsp:include page="/WEB-INF/views/include/shopNav.jsp"/>
<!-- 아래는 다음 주소 API를 활용한 우편번호검색 -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="<%=request.getContextPath()%>/js/woo.js"></script>
<style>
	body{
		font-family : 'pretendard';
	}
	table{
		font-family : 'pretendard';
	}
	th{
		text-align:center;
	}
	#orderCellphone, #orderCellphone2, #orderCellphone3{
    width: 80px;
    
    display: inline-block;
}
</style>

<script>
	//천단위마다 쉼표 표시하는 함수
	function numberWithCommas(x) {
	  return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}
	
</script>
</head>
<body style="background-color : #171721;">
<div class="container">
	<table class="table table-borderless pt-3 mb-0" style="background-color:white; width:100%; font-family:'pretendard';">
		<tr>
			<td class="text-center mt-3 mb-3">
				<br/>
				<h2 style="font-family : 'pretendard'; margin-bottom:0px;">주문확인</h2>
				<br/>
			</td>
		</tr>
	</table>
	<div class="container mt-0 mb-0" style="background-color:white; margin-top:0px;">
		<table class="table table-borderless pt-3 mb-0" style="background-color:white; width:90%; font-family : 'pretendard'; margin:auto;">
			<tr style="border : 1px solid #D5D5D5;background-color:#F6F6F6;">
				<th>주문번호</th>
				<th colspan="2">상품</th>
				<th>가격</th>
				<th>수량</th>
				<th>주문상태</th>
			</tr>
			<c:set var="orderTotalPrice" value="0"/>
			<c:set var="vo" value="${vos}"/>
				<tr style="border-bottom: 1px solid  #D5D5D5; border-left: 1px solid  #D5D5D5; border-right: 1px solid  #D5D5D5">
					<td>
						<div style="width:100%; display:table; height:100px;">
							<p style="display: table-cell; text-align:center; vertical-align:middle;">
								${vo.orderIdx}
							</p>
						</div>
					</td>
					<td class="text-center" style="width:15%;">
						<a href="${ctp}/shop/shopContent?idx=${vo.productIdx}">
							<img src="${ctp}/dbShop/${vo.thumbImg}" class="thumb" style="width:100px;"/>
						</a>
					</td>
					<c:set var="optionNames" value="${fn:split(vo.optionName,',')}"/>
			        <c:set var="optionPrices" value="${fn:split(vo.optionPrice,',')}"/>
			        <c:set var="optionNums" value="${fn:split(vo.optionNum,',')}"/>
					<td style="width:30%;">
						<div style="display:table; height:100px;">
							<p style="display: table-cell; vertical-align:middle;">
								<a href="${ctp}/shop/shopContent?idx=${vo.productIdx}" style="color:black;">
									${vo.productName}
								</a>
							</p>
						</div>
					</td>
					<td style="width:15%;">
						<c:forEach var="i" begin="0" end="${fn:length(optionNames)-1}">
							<c:if test="${optionNames[i] == '기본품목' && listVo.saleRate == '1'}">
				            	<b>◽${optionNames[i]}</b><br/>
				            	<font color="#f77f00"><fmt:formatNumber value="${optionPrices[i]}"/>원</font> / ${optionNums[i]}개<br/>
							</c:if>
							<c:if test="${optionNames[i] == '기본품목' && listVo.saleRate != '1'}">
				            	<b>◽${optionNames[i]}</b><br/>
				            	<font color="#EA5455"><b><fmt:formatNumber value="${vo.saleRate}" type="percent"/></b></font>
				            	<span style="text-decoration: line-through;color:#5D5D5D;">${vo.costPrice}</span>원
				            	<br/>
				            	<font color="#f77f00"><fmt:formatNumber value="${optionPrices[i]}"/>원</font> / ${optionNums[i]}개<br/>
							</c:if>
							<c:if test="${optionNames[i] != '기본품목'}">
								<b>◽${optionNames[i]}</b>
								<br/><font color="#f77f00"><fmt:formatNumber value="${optionPrices[i]}"/>원</font> / ${optionNums[i]}개<br/>
							</c:if>
			          	</c:forEach>
					</td>
					<td class="text-center" style="width:10%;">
						<c:forEach var="i" begin="0" end="${fn:length(optionNames)-1}">
							<c:if test="${fn:length(optionNums)==1}">
								<div style="width:100%; display:table; height:100px;">
									<p style="display: table-cell; text-align:center; vertical-align:middle;">
										${optionNums[0]}개
									</p>
								</div>
							</c:if>
							<c:if test="${fn:length(optionNums)!=1}">
								<c:if test="${optionNames[i] == '기본품목'}">
									<b>◽${optionNames[i]}</b><br/>
									: ${optionNums[i]}개<br/>
								</c:if>
								<c:if test="${optionNames[i] != '기본품목'}">
									<b>◽${optionNames[i]}</b><br/>
									: ${optionNums[i]}개
								</c:if>
							</c:if>
						</c:forEach>
					</td>
					<td class="text-center" style="width:15%;">
						<div style="width:100%; display:table; height:100px;">
							<p style="display: table-cell; text-align:center; vertical-align:middle;">
								<font color="#f77f00"><b>${dVo.orderStatus}</b></font>
							</p>
						</div>
					</td>
				</tr>
				<c:set var="orderTotalPrice" value="${orderTotalPrice + vo.totalPrice}"/>
		</table>
	</div>
	<div class="container mt-0 mb-0" style="background-color:white; margin-top:0px;"><br/>
		<table class="table table-borderless mb-0 text-center" style="width:90%; background-color:white; margin-left:auto; margin-right:auto;">
			<tr style="border-bottom:1px solid #D5D5D5;">
				<td colspan="5" class="text-left">
					<font style="font-family : 'pretendard'; font-size:18.75px; font-weight:500;">결제 금액 </font>
					<font style="font-size : 10pt; color: gray;">50,000원 이상 구매시 무료배송</font>
				</td>
			</tr>
			<tr style="border-bottom:1px solid #D5D5D5; border-left:1px solid #D5D5D5; border-right:1px solid #D5D5D5;background-color:#F6F6F6;">
				<th style="width:35%;">상품 총 금액</th>
				<th></th>
				<th>배송비</th>
				<th></th>
				<th>결제 금액</th>
			</tr>
			<tr style="border-bottom:1px solid #D5D5D5; border-left:1px solid #D5D5D5; border-right:1px solid #D5D5D5;">
				<td>
					<input type="text" id="total" class="box" value="${orderTotalPrice}원" style="border:none; outline:none;text-align:center; width: 100%;" readonly/>
				</td>
				<td>+</td>
				<td>
					<c:if test="${orderTotalPrice >= 50000}">
						<input type="text" id="baesong" class="box" value="0" style="border:none; outline:none;text-align:center; width: 80%;" readonly/>
					</c:if>
					<c:if test="${orderTotalPrice < 50000}">
						<input type="text" id="baesong" class="box" value="2500원" style="border:none; outline:none;text-align:center; width: 80%;" readonly/>
					</c:if>
				</td>
				<td>=</td>
				<td>
					<c:if test="${orderTotalPrice >= 50000}">
						<input type="text" id="finalPrice" class="box" value="${orderTotalPrice}원" style="border:none; outline:none; text-align:center; width: 80%; color:#EA5455;" readonly/>
					</c:if>
					<c:if test="${orderTotalPrice < 50000}">
						<input type="text" id="finalPrice" class="box" value="${orderTotalPrice+2500}원" style="border:none; outline:none; text-align:center; width: 80%; color:#EA5455;" readonly/>
					</c:if>
				</td>
			</tr>
		</table>
	<div class="container mt-0 mb-0" style="background-color:white; margin-top:0px;"><br/>
			<c:set var="dvo" value="${dVo}"/>
			<%-- <c:set var="dvoPayment" value="${dvo.payment}"/> --%>
			<c:set var="payment" value="${fn:substring(dvo.payment,0,1)}"/>
			<table class="table table-borderless mb-0 text-center" style="width:90%; background-color:white; margin-left:auto; margin-right:auto;">
				<tr style="border-bottom:1px solid #D5D5D5;">
					<td colspan="5" class="text-left">
						<font style="font-family : 'pretendard'; font-size:18.75px; font-weight:500;">결제 수단 </font>
					</td>
				</tr>
				<tr style="border-bottom:1px solid #D5D5D5; border-left:1px solid #D5D5D5; border-right:1px solid #D5D5D5;background-color:#F6F6F6;">
					<th class="col-6">결제 수단</th>
					<th class="col-6">비고</th>
				</tr>
				<tr style="border-bottom:1px solid #D5D5D5; border-left:1px solid #D5D5D5; border-right:1px solid #D5D5D5;">
					<td style="border-right:1px solid #D5D5D5;">
						<c:if test="${payment == 'c'}">
							핸드폰 결제
						</c:if>
						<c:if test="${payment == 'C'}">
							카드 결제
						</c:if>
						<c:if test="${payment == 'B'}">
							무통장 입금
						</c:if>
					</td>
					<td>
						<c:if test="${payment == 'C'}">
							카드 번호 : ${dvo.payMethod}
						</c:if>
						<c:if test="${payment == 'B'}">
							계좌 번호 : ${dvo.payMethod}
						</c:if>
					</td>
				</tr>
			</table>
		<div class="text-center p-3">
			<button type="button" class="btn btn-dark" onclick="location.href='${ctp}/shop/productList';">계속하기</button>
			<button type="button" class="btn btn-dark" onClick="location.href='${ctp}/shop/pdMyOrder';">구매내역</button>
		</div>
	</div>
	
</div>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>