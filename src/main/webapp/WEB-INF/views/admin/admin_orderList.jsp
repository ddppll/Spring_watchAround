<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" type="text/css" href="${ctp}/css/boardList.css">
	<meta charset="UTF-8">
	<title>admin_orderList.jsp</title>
	<body style="background-color : #171721;">
	<jsp:include page="/WEB-INF/views/include/bs4.jsp"/>
	<jsp:include page="/WEB-INF/views/include/nav.jsp"/>
	<jsp:include page="/WEB-INF/views/include/adminNav.jsp"/>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.24.0/moment.min.js"></script>
	<script>
		// 리스트 출력 건수
		function pageCheck(){
	  		var pageSize = document.getElementById("pageSize").value;
	  		location.href="${ctp}/admin/admin_orderList?page=${pag}&pageSize="+pageSize;
	  	}
		
		//전체선택
		$(function(){
	    	$("#checkAll").click(function(){
	    		if($("#checkAll").prop("checked")) {
		    		$(".chk").prop("checked", true);
	    		}
	    		else {
		    		$(".chk").prop("checked", false);
	    		}
			});
		});
		
		//선택한 주문 상태 설정
		function changeCategory(){
			ans = confirm("선택한 상품의 주문 처리 상태를 변경하시겠습니까?");
			if(!ans) return false;
			var changeItems = "";
			
			for(var i=0; i<admin_orderForm.chk.length; i++) {
	    		if(admin_orderForm.chk[i].checked == true) changeItems += admin_orderForm.chk[i].value + "/";
	    	}
			
			var changeStatus = $("#changeStatus").val(); //select 에서 고른 카테고리
			var query = {
					changeItems : changeItems,
					changeStatus : changeStatus
			}
			//alert(changeStatus);
			$.ajax({
				url : "${ctp}/admin/admin_orderChange",
				type : "post",
				data : query,
				success : function(){
					alert("주문 처리 상태가 변경되었습니다");
					location.reload();
				},
				error : function(){
					alert("변경 오류");
				}
			});
		}
		
		// 날찌기간에 따른 조건검색
	    function myOrderStatus() {
	    	var startDateJumun = new Date(document.getElementById("startJumun").value);
	    	var endDateJumun = new Date(document.getElementById("endJumun").value);
	    	var orderStatus = admin_orderForm.orderStatus.value;
	    	
	    	if((startDateJumun - endDateJumun) > 0) {
	    		alert("주문일자를 확인하세요!");
	    		return false;
	    	}
	    	
	    	startJumun = moment(startDateJumun).format("YYYY-MM-DD");
	    	endJumun = moment(endDateJumun).format("YYYY-MM-DD");
	    	location.href="${ctp}/admin/admin_orderList?startJumun="+startJumun+"&endJumun="+endJumun+"&pag=${pag}"+"&orderStatus="+orderStatus;
	    }
	</script>
</head>
<body>
	<div class="container">
		<form name="admin_orderForm">
			<c:set var="orderStatus" value="${orderStatus}"/>
			<table class="table table-borderless table-hover mb-0">
				<thead>
					<tr>
						<td colspan="9" style="background-color:white;"><br/>
							<h3 style="text-align:center; font-family: 'pretendard'; color:#264653;">
								<a href="#" style="color:#264653;text-decoration-line: none;">주문 목록</a>
							</h3>
						</td>
					</tr>
					<tr>
						<td style="background-color:white; width:55px;" colspan="9">
							<select name="pageSize" id="pageSize" onchange="pageCheck()" class="p-0 m-0" style="height:28px;">
					      		<option value="5" ${pageSize==5 ? 'selected' : ''}>5건</option>
					      		<option value="10" ${pageSize==10 ? 'selected' : ''}>10건</option>
					      		<option value="15" ${pageSize==15 ? 'selected' : ''}>15건</option>
					      		<option value="20" ${pageSize==20 ? 'selected' : ''}>20건</option>
					      	</select>
						</td>
					</tr>
					<tr>
						<td colspan="5" style="background-color:#263155;">
							<input type="date" name="startJumun" id="startJumun"/> ~<input type="date" name="endJumun" id="endJumun"/>
							<select name="orderStatus" id="orderStatus" style="height:25px;">
								<option value="전체"    ${orderStatus == '전체'    ? 'selected' : ''}>전체</option>
					            <option value="결제완료" ${orderStatus == '결제완료' ? 'selected' : ''}>결제완료</option>
					         	<option value="배송중"  ${orderStatus == '배송중'   ? 'selected' : ''}>배송중</option>
					          	<option value="배송완료" ${orderStatus == '배송완료' ? 'selected' : ''}>배송완료</option>
							</select>
        					<button type="button" id="orderDateSearch" onclick="myOrderStatus()" class="btn btn-light btn-sm m-0 p-1">조회</button>
						</td>
						<td colspan="2" class="text-right" style="background-color:#263155;">
							<select name="changeStatus" id="changeStatus"style="height:30px;">
								<option value="결제완료">결제완료</option>
								<option value="상품준비">상품준비</option>
								<option value="배송중">배송중</option>
								<option value="배송완료">배송완료</option>
							</select>
							<input type="button" class="btn btn-sm btn-light" value="변경" onclick="changeCategory()">
						</td>
					</tr>
					<tr class="text-center">
						<th class="text-center">전체 <input type="checkbox" id="checkAll"/></th>
						<th class="text-center">번호</th>
						<th class="text-center">주문번호</th>
						<th class="text-center">상품</th>
						<th class="text-center">내역</th>
						<th class="col-2">결제금액</th>
						<th class="text-center">주문처리상태</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="vo" items="${orderVos}">
						<tr>
							<c:set var="optionNames" value="${fn:split(vo.optionName,',')}"/>
					        <c:set var="optionPrices" value="${fn:split(vo.optionPrice,',')}"/>
					        <c:set var="optionNums" value="${fn:split(vo.optionNum,',')}"/>
					        
							<td class="text-center">
								<div style="display:table; height:100px; text-align:center; margin:auto;">
									<p style="display: table-cell; vertical-align:middle; align:center;">
										<input type="checkbox" id="chk" class="chk" value="${vo.idx}"/>
									</p>
						    	</div>
							</td>
							<td class="text-center">
								<div style="display:table; height:100px; text-align:center; margin:auto;">
									<p style="display: table-cell; vertical-align:middle; align:center;">
										${curScrStrarNo}
									</p>
						    	</div>
							</td>
							<td class="text-center">
							<div style="display:table; height:100px; margin:auto; text-align:center;">
								<p style="display: table-cell; vertical-align:middle;">
									<a href="${ctp}/admin/orderDeliver?orderIdx=${vo.orderIdx}" style="color:black;">
										<b>${vo.orderIdx}</b>
									</a>
									<br/>
									${fn:substring(vo.orderDate,0,10)}<br/>
									${fn:substring(vo.orderDate,11,19)}
								</p>
					    	</div>
							</td>
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
										<c:if test="${vo.orderStatus == '배송완료'}">
											<font color="#EA5455">${vo.orderStatus}</font>
										</c:if>
										<c:if test="${vo.orderStatus == '결제완료'}">
											<font color="#f77f00">${vo.orderStatus}</font>
										</c:if>
										<c:if test="${vo.orderStatus == '배송중'}">
											<font color="#2A9D8F">${vo.orderStatus}</font>
										</c:if>
										<c:if test="${vo.orderStatus == '상품준비'}">
											${vo.orderStatus}
										</c:if>
									</p>
						    	</div>
							</td>
							
						</tr>
						<c:set var="curScrStrarNo" value="${curScrStrarNo - 1}"/>
					</c:forEach>
				</tbody>
			</table>
			
			<input type="hidden" name="pag" value="${pag}"/>
	  		<input type="hidden" name="pageSize" value="${pageSize}"/>
		</form>
		<!-- 블록 페이징처리 시작(BS4 스타일적용) -->
		<div class="container mt-0 mb-0" style="background-color:white; margin-top:0px;"><br/>
			<!-- ~~~~~~~~~~~~~검색 조회시~~~~~~~~~~~~~~~~~~~~~ -->
			<c:if test="${startJumun != null && endJumun != null && orderStatus != null}">
			<ul class="pagination justify-content-center mb-0">
				<c:if test="${totPage == 0}"><p style="text-align:center"><b>자료가 없습니다.</b></p></c:if>
				<c:if test="${totPage != 0}">
				  <c:if test="${pag != 1}">
				    <li class="page-item"><a href="${ctp}/admin/admin_orderList?pag=1&pageSize=${pageSize}&startJumun=${startJumun}&endJumun=${endJumun}&orderStatus=${orderStatus}" title="첫페이지" class="page-link text-secondary">◁◁</a></li>
				  </c:if>
				  <c:if test="${curBlock > 0}">
				    <li class="page-item"><a href="${ctp}/admin/admin_orderList?pag=${(curBlock-1)*blockSize + 1}&pageSize=${pageSize}&startJumun=${startJumun}&endJumun=${endJumun}&orderStatus=${orderStatus}" title="이전블록" class="page-link text-secondary">◀</a></li>
				  </c:if>
				  <c:forEach var="i" begin="${(curBlock*blockSize)+1}" end="${(curBlock*blockSize)+blockSize}">
				    <c:if test="${i == pag && i <= totPage}">
				      <li class="page-item active"><a href='${ctp}/admin/admin_orderList?pag=${i}&pageSize=${pageSize}&startJumun=${startJumun}&endJumun=${endJumun}&orderStatus=${orderStatus}' class="page-link text-light bg-secondary border-secondary">${i}</a></li>
				    </c:if>
				    <c:if test="${i != pag && i <= totPage}">
				      <li class="page-item"><a href='${ctp}/admin/admin_orderList?pag=${i}&pageSize=${pageSize}&startJumun=${startJumun}&endJumun=${endJumun}&orderStatus=${orderStatus}' class="page-link text-secondary">${i}</a></li>
				    </c:if>
				  </c:forEach>
				  <c:if test="${curBlock < lastBlock}">
				    <li class="page-item"><a href="${ctp}/admin/admin_orderList?pag=${(curBlock+1)*blockSize + 1}&pageSize=${pageSize}&startJumun=${startJumun}&endJumun=${endJumun}&orderStatus=${orderStatus}" title="다음블록" class="page-link text-secondary">▶</a>
				  </c:if>
				  <c:if test="${pag != totPage}">
				    <li class="page-item"><a href="${ctp}/admin/admin_orderList?pag=${totPage}&pageSize=${pageSize}&startJumun=${startJumun}&endJumun=${endJumun}&orderStatus=${orderStatus}" title="마지막페이지" class="page-link" style="color:#555">▷▷</a>
				  </c:if>
				</c:if>
			</ul><br/>
			</c:if>
			<!-- ~~~~~~~~~~~~~검색 조회시~~~~~~~~~~~~~~~~~~~~~ -->
			<c:if test="${startJumun == null && endJumun == null && orderStatus != null}">
			<ul class="pagination justify-content-center mb-0">
				<c:if test="${totPage == 0}"><p style="text-align:center"><b>자료가 없습니다.</b></p></c:if>
				<c:if test="${totPage != 0}">
				  <c:if test="${pag != 1}">
				    <li class="page-item"><a href="${ctp}/admin/admin_orderList?pag=1&pageSize=${pageSize}&orderStatus=${orderStatus}" title="첫페이지" class="page-link text-secondary">◁◁</a></li>
				  </c:if>
				  <c:if test="${curBlock > 0}">
				    <li class="page-item"><a href="${ctp}/admin/admin_orderList?pag=${(curBlock-1)*blockSize + 1}&pageSize=${pageSize}&orderStatus=${orderStatus}" title="이전블록" class="page-link text-secondary">◀</a></li>
				  </c:if>
				  <c:forEach var="i" begin="${(curBlock*blockSize)+1}" end="${(curBlock*blockSize)+blockSize}">
				    <c:if test="${i == pag && i <= totPage}">
				      <li class="page-item active"><a href='${ctp}/admin/admin_orderList?pag=${i}&pageSize=${pageSize}&orderStatus=${orderStatus}' class="page-link text-light bg-secondary border-secondary">${i}</a></li>
				    </c:if>
				    <c:if test="${i != pag && i <= totPage}">
				      <li class="page-item"><a href='${ctp}/admin/admin_orderList?pag=${i}&pageSize=${pageSize}&orderStatus=${orderStatus}' class="page-link text-secondary">${i}</a></li>
				    </c:if>
				  </c:forEach>
				  <c:if test="${curBlock < lastBlock}">
				    <li class="page-item"><a href="${ctp}/admin/admin_orderList?pag=${(curBlock+1)*blockSize + 1}&pageSize=${pageSize}&orderStatus=${orderStatus}" title="다음블록" class="page-link text-secondary">▶</a>
				  </c:if>
				  <c:if test="${pag != totPage}">
				    <li class="page-item"><a href="${ctp}/admin/admin_orderList?pag=${totPage}&pageSize=${pageSize}&orderStatus=${orderStatus}" title="마지막페이지" class="page-link" style="color:#555">▷▷</a>
				  </c:if>
				</c:if>
			</ul><br/>
			</c:if>
		</div>
		<!-- 블록 페이징처리 끝 -->
</div>
	<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>