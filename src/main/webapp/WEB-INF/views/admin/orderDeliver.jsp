<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>orderDeliver.jsp</title>
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
						<a href="#" style="color:#264653;text-decoration-line: none;">주문 상세 정보</a>
					</h3>
				</td>
			</tr>
		</table>
		<div class="container mt-0 mb-0" style="background-color:white;">
		<table class="table table-borderless mb-0" style="background-color:white; width:90%; margin:auto;">
			
			<tr style="border-bottom:1px solid lightgrey">
				<td colspan="2"><b>주문정보</b></td>
			</tr>
			<tr>
				<td class="col-3">주문번호</td>
				<td>${orderVos.orderIdx}</td>
			</tr>
			<tr>
				<td>주문일자</td>
				<td>${orderVos.orderDate}</td>
			</tr>
			<tr>
				<td>주문자</td>
				<td>${sNickName}</td>
			</tr>
			<tr>
				<td>주문처리상태</td>
				<td>${orderVos.orderStatus}</td>
			</tr>
		</table><br/>
		<table class="table table-borderless mt-0" style="background-color:white; width:90%; margin:auto;">
			<tr style="border-bottom:1px solid lightgrey;">
				<td colspan="2"><b>결제정보</b></td>
			</tr>
			<tr>
				<td class="col-3">결제금액</td>
				<td>${orderVos.orderTotalPrice}</td>
			</tr>
			<tr>
				<td>결제수단</td>
				<td>
					<c:set var="payment" value="${fn:substring(orderVos.payment,0,1)}"/>
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
			</tr>
		</table>
		<br/>
		<table class="table table-borderless mt-0" style="background-color:white; width:90%; margin:auto;">
	       	<tr>
				<td colspan="2"><b>주문상품 정보</b></td>
			</tr>
	       
	        <tr style="border-bottom:1px solid lightgrey; border-top:1px solid lightgrey; " class="text-center">
	        	<th>상품</th>
	        	<th>내역</th>
	        	<th>가격</th>
	        	<th>주문처리상태</th>
	        </tr>
	        
			<c:forEach var="vo" items="${productInfo}">
	        <tr style=" border-bottom:1px solid lightgrey;">
	        	<c:set var="optionNames" value="${fn:split(vo.optionName,',')}"/>
		        <c:set var="optionPrices" value="${fn:split(vo.optionPrice,',')}"/>
		        <c:set var="optionNums" value="${fn:split(vo.optionNum,',')}"/>
		        <td class="text-center">
					<a href="${ctp}/shop/shopContent?idx=${vo.productIdx}" style="color:black;">
						<img src="${ctp}/dbShop/${vo.thumbImg}" class="thumb" width="100px"/>
					</a>
				</td>
				<td>
					<div style="display:table; height:100px;">
						<p style="display: table-cell; vertical-align:middle;">
							<a href="${ctp}/shop/shopContent?idx=${vo.productIdx}" style="color:black;">
								<b>${vo.productName}</b>
							</a>
						<c:if test="${fn:length(optionNames) > 1}">(옵션 ${fn:length(optionNames)-1}개 포함)</c:if><br/>
				          <c:forEach var="i" begin="1" end="${fn:length(optionNames)}">
				          ㆍ ${optionNames[i-1]} / <font color="#f77f00"><fmt:formatNumber value="${optionPrices[i-1]}"/>원</font> / ${optionNums[i-1]}개<br/>
				          </c:forEach>
				    	</p>
		  				</div>
				</td>
				<td>
					<div style="display:table; height:100px; text-align:center; margin:auto;">
						<p style="display: table-cell; vertical-align:middle; align:center;">
							<fmt:formatNumber value="${vo.totalPrice}"/>원
						</p>
			    	</div>
				</td>
				<td class="text-center">
					<div style="display:table; height:100px; text-align:center; margin:auto;">
						<p style="display: table-cell; vertical-align:middle; align:center;">
							${vo.orderStatus}
						</p>
			    	</div>
				</td>
			</tr>
			</c:forEach> 
		</table><br/>
		
		<table class="table table-borderless mt-0" style="background-color:white; width:90%; margin:auto;">
			<tr>
				<td colspan="2"><b>배송지 정보</b></td>
			</tr>
	        <tr style="border-top:1px solid lightgrey; ">
				<td class="col-3">받으시는 분</td>
				<td>${orderVos.name}</td>
	        </tr>
	        <tr>
	        	<td>주소</td>
	        	<td>${orderVos.address}</td>
	        </tr>
	        <tr>
	        	<td>연락처</td>
	        	<td>${orderVos.tel}</td>
	        </tr>
	        <tr>
	        	<td>배송 메세지</td>
	        	<td>${orderVos.message}</td>
	        </tr>
		</table><br/>
		<p class="text-center">
			<button type="button" class="btn btn-dark text-center" onclick="location.href='${ctp}/admin/admin_orderList';">주문목록</button>
		</p><br/>
		</div>
	</div>
	<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>