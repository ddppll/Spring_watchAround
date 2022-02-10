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
<title>pdMyOrder.jsp</title>
<jsp:include page="/WEB-INF/views/include/bs4.jsp"/>
<jsp:include page="/WEB-INF/views/include/nav.jsp"/>
<jsp:include page="/WEB-INF/views/include/shopNav.jsp"/>
<!-- 아래는 다음 주소 API를 활용한 우편번호검색 -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="<%=request.getContextPath()%>/js/woo.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.24.0/moment.min.js"></script>
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
</style>

<script>
	//배송지 정보보기
	function nWin(orderIdx) {
		var url = "${ctp}/shop/orderDelivery?orderIdx="+orderIdx;
		window.open(url,"orderDelivery","width=450px,height=450px");
	}
	 $(document).ready(function() {
    	// 주문 상태별 조회
    	$("#orderStatus").on("change",  function() {
	    	var orderStatus = $(this).val();
	    	location.href="${ctp}/shop/pdMyOrder?orderStatus="+orderStatus+"&pag=${pag}";
    	});
    });
	 
	// 날찌기간에 따른 조건검색
	    function myOrderStatus() {
	    	var startDateJumun = new Date(document.getElementById("startJumun").value);
	    	var endDateJumun = new Date(document.getElementById("endJumun").value);
	    	
	    	if((startDateJumun - endDateJumun) > 0) {
	    		alert("주문일자를 확인하세요!");
	    		return false;
	    	}
	    	
	    	startJumun = moment(startDateJumun).format("YYYY-MM-DD");
	    	endJumun = moment(endDateJumun).format("YYYY-MM-DD");
	    	location.href="${ctp}/shop/pdMyOrder?startJumun="+startJumun+"&endJumun="+endJumun+"&pag=${pag}";
	    }
</script>
</head>
<body style="background-color : #171721;">
<c:set var="conditionOrderStatus" value="${conditionOrderStatus}"/>
<c:set var="orderStatus" value="${orderStatus}"/>
<div class="container">
	<table class="table table-borderless pt-3 mb-0" style="background-color:white; width:100%; font-family:'pretendard';">
		<tr>
			<td class="text-center mt-3 mb-3">
				<br/>
				<h2 style="font-family : 'pretendard'; margin-bottom:0px;">주문내역</h2>
				<br/>
			</td>
		</tr>
	</table>
	<div class="container mt-0 mb-0" style="background-color:white; margin-top:0px;">
		<table class="table table-borderless pt-3 mb-0" style="background-color:white; width:90%; font-family : 'pretendard'; margin:auto;">
			<tr style="background-color:#E8E8E4; border-bottom:2px solid white;" class="text-center">
				<td class="col-4"><b>결제완료</b></td>
				<td class="col-4"><b>배송중</b></td>
				<td class="col-4"><b>배송완료</b></td>
			</tr>
			<tr style="background-color:#E8E8E4;" class="text-center">
			<%-- <c:set var="statusVos" value="${statusVos}"/> --%>
			<c:forEach var="statusVos" items="${statusVos}">
			
				<td>
					<div style="display:table; height:40px; text-align:center; margin:auto;">
					<i class="xi-wallet xi-4x"></i>&nbsp; 
						<p style="display: table-cell; vertical-align:middle; align:center;">
							<font size="4rem">${statusVos.payEnd}개</font>
						</p>
			    	</div>
				</td>
				<td>
					<div style="display:table; height:40px; text-align:center; margin:auto;">
					<i class="xi-truck xi-4x"></i> &nbsp; 
						<p style="display: table-cell; vertical-align:middle; align:center;">
							<font size="4rem">${statusVos.deliver}개</font>
						</p>
			    	</div>
				</td>
				<td>
					<div style="display:table; height:40px; text-align:center; margin:auto;">
						<i class="xi-box xi-4x"></i> &nbsp; 
						<p style="display: table-cell; vertical-align:middle; align:center;">
							<font size="4rem">${statusVos.deliverEnd}개</font>
						</p>
			    	</div>
				</td>
			</c:forEach>
			</tr>
			<tr style="background-color:#E8E8E4;">
				<td colspan="2">
					<%-- <c:if test="${startJumun == null}">
          				<c:set var="startJumun" value="<%=new java.util.Date() %>"/>
	        			<c:set var="startJumun"><fmt:formatDate value="${startJumun}" pattern="yyyy-MM-dd"/></c:set>
        			</c:if>
        			<c:if test="${endJumun == null}">
          				<c:set var="endJumun" value="<%=new java.util.Date() %>"/>
	       				<c:set var="endJumun"><fmt:formatDate value="${endJumun}" pattern="yyyy-MM-dd"/></c:set>
        			</c:if> --%>
        			<input type="date" name="startJumun" id="startJumun" value="${startJumun}"/>~<input type="date" name="endJumun" id="endJumun" value="${endJumun}"/>
        			<input type="button" value="조회하기" class="btn btn-dark btn-sm" onclick="myOrderStatus()"/>
				</td>
				<td class="text-right">
					<select name="orderStatus " id="orderStatus" style="height:30px;">
			          <option value="전체" <c:if test="${orderStatus=='전체'}">selected</c:if>>전체</option>
			          <option value="결제완료" <c:if test="${orderStatus=='결제완료'}">selected</c:if>>결제완료</option>
			          <option value="상품준비"  <c:if test="${orderStatus=='상품준비'}">selected</c:if>>상품준비</option>
			          <option value="배송중"  <c:if test="${orderStatus=='배송중'}">selected</c:if>>배송중</option>
			          <option value="배송완료"  <c:if test="${orderStatus=='배송완료'}">selected</c:if>>배송완료</option>
			        </select>
				</td>
			</tr>
		</table>
		<table class="table mb-0" style="background-color:white; width:90%; font-family : 'pretendard'; margin:auto;">
			<tr class="text-center">
				<th>주문번호</th>
				<th>상품</th>
				<th>내역</th>
				<th>금액</th>
				<th>주문일시</th>
				<th>주문상태</th>
			</tr>
			<c:forEach var="vo" items="${myOrderVos}">
			<tr>
				<td class="text-center">
					${vo.orderIdx}<br/><br/>
					<input class="btn btn-sm btn-outline-dark" type="button" value="배송정보" onclick="nWin('${vo.orderIdx}')">
				</td>
				<td class="text-center">
					<img src="${ctp}/dbShop/${vo.thumbImg}" class="thumb" width="100px"/>
				</td>
				<c:set var="optionNames" value="${fn:split(vo.optionName,',')}"/>
		        <c:set var="optionPrices" value="${fn:split(vo.optionPrice,',')}"/>
		        <c:set var="optionNums" value="${fn:split(vo.optionNum,',')}"/>
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
				<td class="text-center">
					<div style="display:table; height:100px; text-align:center; margin:auto;">
						<p style="display: table-cell; vertical-align:middle; align:center;">
							<fmt:formatNumber value="${vo.totalPrice}"/>원
						</p>
			    	</div>
				</td>
				<td>
					<div style="display:table; height:100px; margin:auto; text-align:center;">
						<p style="display: table-cell; vertical-align:middle;">
							${fn:substring(vo.orderDate,0,10)}<br/>
							${fn:substring(vo.orderDate,11,19)}
						</p>
			    	</div>
				</td>
				<td>
					<div style="display:table; height:100px; margin:auto;">
						<p style="display: table-cell; vertical-align:middle;">
							<c:if test="${vo.orderStatus == '배송완료'}">
								<font color="#EA5455">${vo.orderStatus}</font>
							</c:if>
							<c:if test="${vo.orderStatus == '결제완료'}">
								<font color="#f77f00">${vo.orderStatus}</font>
							</c:if>
							<c:if test="${vo.orderStatus != '결제완료' && vo.orderStatus != '배송완료'}">
								<font color="#2A9D8F">${vo.orderStatus}</font>
							</c:if>
						</p>
			    	</div>
				</td>
			</tr>
			<tr>
			</tr>
			</c:forEach>
		</table>
		<!-- 블록페이징 시작 -->
		<ul class="pagination justify-content-center mb-0 pb-3">
			<!-- ~~~~~~~~~~~~기본 페이징~~~~~~~~~~~~~~ -->
			<c:if test="${startJumun == null && endJumun == null && orderStatus == null}">
			<c:if test="${totPage == 0}"><p style="text-align:center"><b>자료가 없습니다.</b></p></c:if>
			<c:if test="${totPage != 0}">
			  <c:if test="${pag != 1}">
			    <li class="page-item"><a href="${ctp}/shop/pdMyOrder?pag=1&pageSize=${pageSize}" title="첫페이지" class="page-link text-secondary">◁◁</a></li>
			  </c:if>
			  <c:if test="${curBlock > 0}">
			    <li class="page-item"><a href="${ctp}/shop/pdMyOrder?pag=${(curBlock-1)*blockSize + 1}&pageSize=${pageSize}" title="이전블록" class="page-link text-secondary">◀</a></li>
			  </c:if>
			  <c:forEach var="i" begin="${(curBlock*blockSize)+1}" end="${(curBlock*blockSize)+blockSize}">
			    <c:if test="${i == pag && i <= totPage}">
			      <li class="page-item active"><a href='${ctp}/shop/pdMyOrder?pag=${i}&pageSize=${pageSize}' class="page-link text-light bg-secondary border-secondary">${i}</a></li>
			    </c:if>
			    <c:if test="${i != pag && i <= totPage}">
			      <li class="page-item"><a href='${ctp}/shop/pdMyOrder?pag=${i}&pageSize=${pageSize}' class="page-link text-secondary">${i}</a></li>
			    </c:if>
			  </c:forEach>
			  <c:if test="${curBlock < lastBlock}">
			    <li class="page-item"><a href="${ctp}/shop/pdMyOrder?pag=${(curBlock+1)*blockSize + 1}&pageSize=${pageSize}" title="다음블록" class="page-link text-secondary">▶</a>
			  </c:if>
			  <c:if test="${pag != totPage}">
			    <li class="page-item"><a href="${ctp}/shop/pdMyOrder?pag=${totPage}&pageSize=${pageSize}" title="마지막페이지" class="page-link" style="color:#555">▷▷</a>
			  </c:if>
			</c:if>
			</c:if>
			
			<!-- ~~~~~~~~~~~~주문상태 페이징~~~~~~~~~~~~~~ -->
			<c:if test="${startJumun == null && endJumun == null && orderStatus != null}">
			<c:if test="${totPage == 0}"><p style="text-align:center"><b>자료가 없습니다.</b></p></c:if>
			<c:if test="${totPage != 0}">
			  <c:if test="${pag != 1}">
			    <li class="page-item"><a href="${ctp}/shop/pdMyOrder?pag=1&pageSize=${pageSize}&orderStatus=${orderStatus}" title="첫페이지" class="page-link text-secondary">◁◁</a></li>
			  </c:if>
			  <c:if test="${curBlock > 0}">
			    <li class="page-item"><a href="${ctp}/shop/pdMyOrder?pag=${(curBlock-1)*blockSize + 1}&pageSize=${pageSize}&orderStatus=${orderStatus}" title="이전블록" class="page-link text-secondary">◀</a></li>
			  </c:if>
			  <c:forEach var="i" begin="${(curBlock*blockSize)+1}" end="${(curBlock*blockSize)+blockSize}">
			    <c:if test="${i == pag && i <= totPage}">
			      <li class="page-item active"><a href='${ctp}/shop/pdMyOrder?pag=${i}&pageSize=${pageSize}&orderStatus=${orderStatus}' class="page-link text-light bg-secondary border-secondary">${i}</a></li>
			    </c:if>
			    <c:if test="${i != pag && i <= totPage}">
			      <li class="page-item"><a href='${ctp}/shop/pdMyOrder?pag=${i}&pageSize=${pageSize}&orderStatus=${orderStatus}' class="page-link text-secondary">${i}</a></li>
			    </c:if>
			  </c:forEach>
			  <c:if test="${curBlock < lastBlock}">
			    <li class="page-item"><a href="${ctp}/shop/pdMyOrder?pag=${(curBlock+1)*blockSize + 1}&pageSize=${pageSize}&orderStatus=${orderStatus}" title="다음블록" class="page-link text-secondary">▶</a>
			  </c:if>
			  <c:if test="${pag != totPage}">
			    <li class="page-item"><a href="${ctp}/shop/pdMyOrder?pag=${totPage}&pageSize=${pageSize}&orderStatus=${orderStatus}" title="마지막페이지" class="page-link" style="color:#555">▷▷</a>
			  </c:if>
			</c:if>
			</c:if>
			
			<!-- ~~~~~~~~~~~~날짜조회 페이징~~~~~~~~~~~~~~ -->
			<c:if test="${startJumun != null && endJumun != null}">
			
			<c:if test="${totPage == 0}"><p style="text-align:center"><b>자료가 없습니다.</b></p></c:if>
			<c:if test="${totPage != 0}">
			  <c:if test="${pag != 1}">
			    <li class="page-item"><a href="${ctp}/shop/pdMyOrder?pag=1&pageSize=${pageSize}&startJumun=${startJumun}&endJumun=${endJumun}&orderStatus=${orderStatus}" title="첫페이지" class="page-link text-secondary">◁◁</a></li>
			  </c:if>
			  <c:if test="${curBlock > 0}">
			    <li class="page-item"><a href="${ctp}/shop/pdMyOrder?pag=${(curBlock-1)*blockSize + 1}&pageSize=${pageSize}&startJumun=${startJumun}&endJumun=${endJumun}&orderStatus=${orderStatus}" title="이전블록" class="page-link text-secondary">◀</a></li>
			  </c:if>
			  <c:forEach var="i" begin="${(curBlock*blockSize)+1}" end="${(curBlock*blockSize)+blockSize}">
			    <c:if test="${i == pag && i <= totPage}">
			      <li class="page-item active"><a href='${ctp}/shop/pdMyOrder?pag=${i}&pageSize=${pageSize}&startJumun=${startJumun}&endJumun=${endJumun}&orderStatus=${orderStatus}' class="page-link text-light bg-secondary border-secondary">${i}</a></li>
			    </c:if>
			    <c:if test="${i != pag && i <= totPage}">
			      <li class="page-item"><a href='${ctp}/shop/pdMyOrder?pag=${i}&pageSize=${pageSize}&startJumun=${startJumun}&endJumun=${endJumun}&orderStatus=${orderStatus}' class="page-link text-secondary">${i}</a></li>
			    </c:if>
			  </c:forEach>
			  <c:if test="${curBlock < lastBlock}">
			    <li class="page-item"><a href="${ctp}/shop/pdMyOrder?pag=${(curBlock+1)*blockSize + 1}&pageSize=${pageSize}&startJumun=${startJumun}&endJumun=${endJumun}&orderStatus=${orderStatus}" title="다음블록" class="page-link text-secondary">▶</a>
			  </c:if>
			  <c:if test="${pag != totPage}">
			    <li class="page-item"><a href="${ctp}/shop/pdMyOrder?pag=${totPage}&pageSize=${pageSize}&startJumun=${startJumun}&endJumun=${endJumun}&orderStatus=${orderStatus}" title="마지막페이지" class="page-link" style="color:#555">▷▷</a>
			  </c:if>
			</c:if>
			</c:if>
		</ul>
		<!-- 블록 페이징처리 끝 -->
		
	</div>
</div>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>