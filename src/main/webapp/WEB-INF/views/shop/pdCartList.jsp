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
<title>PdCartList.jsp</title>
<jsp:include page="/WEB-INF/views/include/bs4.jsp"/>
<jsp:include page="/WEB-INF/views/include/nav.jsp"/>
<jsp:include page="/WEB-INF/views/include/shopNav.jsp"/>
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
	//천단위마다 쉼표 표시하는 함수
	function numberWithCommas(x) {
	  return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}

	//결제 금액 계산
	function onTotal(){
		var total = 0;
		var maxIdx = document.getElementById("maxIdx").value;
		for(var i=1;i<=maxIdx;i++){
	        if($("#totalPrice"+i).length != 0 && document.getElementById("idx"+i).checked){  
	          total = total + parseInt(document.getElementById("totalPrice"+i).value); 
	        }
	      }
		document.getElementById("total").value = numberWithCommas(total);
		
		if(total>=50000 || total == 0){	//배송비 출력 안하는 조건
			document.getElementById("baesong").value = 0;
		} 
		else{
			document.getElementById("baesong").value = 2500;
		}
		var finalPrice = parseInt(document.getElementById("baesong").value) + total;
		document.getElementById("finalPrice").value = numberWithCommas(finalPrice);
		document.getElementById("orderTotalPrice").value = numberWithCommas(finalPrice);
	}
	
	//체크박스 전체 체크
	function allCheck(){
		var maxIdx = document.getElementById("maxIdx").value;
		if(document.getElementById("allcheck").checked){
			for(var i=1; i<=maxIdx; i++){
				if($("#idx" + i).length != 0){
					document.getElementById("idx"+i).checked = true;
				}
			}
		}
		else{
			for(var i=1;i<=maxIdx;i++){
				if($("#idx"+i).length != 0){
					document.getElementById("idx"+i).checked=false;
				}
			}
		}
		onTotal();
	}
	
	//체크박스 한개 체크
	function onCheck(){
		var maxIdx = document.getElementById("maxIdx").value;
		var cnt = 0;
		for(var i=1; i<=maxIdx; i++){
			if($("#idx" + i).length != 0 && document.getElementById("idx"+i).checked == false){
				cnt++;
				break;
			}
		}
		if(cnt != 0){
			document.getElementById("allcheck").checked=false;
		}
		else{
			document.getElementById("allcheck").checked=true;
		}
		onTotal();
	}
	
	//장바구니 비우기(전체 삭제)
	function cartAllDel(){
		var ans = confirm("장바구니를 비우시겠습니까?");
		if(ans){
			$.ajax({
				url : "${ctp}/shop/cartAllDel",
				method : "get",
				success : function(data){
					location.reload();
				}
			});
		}
	}
	
	//장바구니 품목 개별 삭제 - 버튼
	function cartDel(idx){
		var ans = confirm("해당 상품을 장바구니에서 삭제하시겠습니까?");
		if(!ans) return false;
		$.ajax({
			type : "post",
			url : "${ctp}/shop/cartDel",
			data :{idx : idx},
			success : function(){
				location.reload();
			}
		});
	}
	
	//장바구니 선택 삭제 - 체크박스
	function cartSelectDel(){
		var maxIdx = document.getElementById("maxIdx").value;
		var ans = confirm("선택한 상품을 모두 삭제하시겠습니까?");
		if(ans){
			var delItems = "";
			for(var i=1; i<=maxIdx; i++){
				if($("#idx"+i).length != 0 && document.getElementById("idx"+i).checked) delItems += i + "/";
			}
			if(delItems == ""){
				alert("선택한 항목이 없습니다");
				return false;
			}
			$.ajax({
				url : "${ctp}/shop/cartSelectDel",
				method : "post",
				data : {delItems : delItems},
				success : function(data){
					location.reload();
				}
			});
		}
	}
	
	//선택 상품 주문
	function orderSelect(){
		var maxIdx = document.getElementById("maxIdx").value;
		for(var i=1; i<=maxIdx; i++){
			if($("#idx"+i).length != 0 && document.getElementById("idx" + i).checked){
				document.getElementById("checkItem" + i).value = "1";
			}
		}
		if(document.getElementById("finalPrice").value == 0){
			alert("장바구니에서 상품을 선택하세요");
			return false;
		}
		else{
			document.cartForm.submit();
		}
	}
	
	//전체 상품 주문 - 버튼 클릭
	function orderAll(){
		var maxIdx = document.getElementById("maxIdx").value;
		var ans = confirm("전체 상품을 모두 주문하시겠습니까?");
		if(ans){
			for(var i=1; i<=maxIdx; i++){
				if($("#idx" + i).length != 0){
					document.getElementById("idx"+i).checked = true;
				}
			}
			document.cartForm.submit();
		}
	}
	
	//옵션 없는 개별 상품 수량 조절시 db 반영
	function numChange(idx){
		var num = document.getElementById("numBox" + idx).value;	//수량 값
		var mainPrice = document.getElementById("mainPrice" + idx).value * num; // 상품가격 * 수량
		var tPrice = parseInt(mainPrice);
		
		//alert("tPrice : " + tPrice);
		
		document.getElementById("showTPrice"+idx).value = numberWithCommas(tPrice)+"원";
		document.getElementById("totalPrice"+idx).value = tPrice;
		//alert("수량" + num);
		//장바구니 db 수정
		var query = {
				idx : idx,
				num : num,
				totalPrice : tPrice
		}
		$.ajax({
			url : "${ctp}/shop/cartPdNumChange",
			method : "post",
			data : query,
			success : function(data){
				location.reload();
			}
		});
	}
	
</script>
</head>
<body style="background-color : #171721;">
<div class="container">
	<form name="cartForm" method="post">
		<table class="table table-borderless pt-3 mb-0" style="background-color:white; width:100%; font-family : 'pretendard';">
			<tr>
				<td class="text-center mt-3 mb-3" colspan="7">
					<br/>
					<h2 style="font-family : 'pretendard'; margin-bottom:0px;">장바구니</h2>
					<br/>
				</td>
			</tr>
			<tr style="border-bottom : 1px solid #D5D5D5; border-top : 1px solid #D5D5D5;background-color:#F6F6F6;">
				<th><input type="checkbox" id="allcheck" onclick="allCheck()"/></th>
				<th colspan="2">상품</th>
				<th>가격</th>
				<th>수량</th>
				<th>합계</th>
				<th></th>
			</tr>
			<c:set var="maxIdx" value="0"/>
			<c:forEach var="listVo" items="${cartListVos}">
				<tr style="border-bottom: 1px solid  #D5D5D5">
					<td style="text-align:center; width:5%;"><input type="checkbox" name="idxChecked" id="idx${listVo.idx}" value="${listVo.idx}" onclick="onCheck()"/></td>
					<td class="text-center" style="width:15%;">
						<a href="${ctp}/shop/shopContent?idx=${listVo.productIdx}">
							<img src="${ctp}/dbShop/${listVo.thumbImg}" class="thumb" style="width:100px;"/>
						</a>
					</td>
					<c:set var="optionNames" value="${fn:split(listVo.optionName,',')}"/>
			        <c:set var="optionPrices" value="${fn:split(listVo.optionPrice,',')}"/>
			        <c:set var="optionNums" value="${fn:split(listVo.optionNum,',')}"/>
					<td style="width:25%;">
						<div style="display:table; height:100px;">
							<p style="display: table-cell; vertical-align:middle;">
								<a href="${ctp}/shop/shopContent?idx=${listVo.productIdx}" style="color:black;">
									${listVo.productName}
								</a>
							</p>
						</div>
					</td>
					<td style="width:15%;">
						<c:forEach var="i" begin="0" end="${fn:length(optionNames)-1}">
							<c:if test="${optionNames[i] == '기본품목' && listVo.saleRate == '1'}">
				            	<b>◽${optionNames[i]}</b><br/>
				            	<font color="#f77f00"><fmt:formatNumber value="${listVo.mainPrice}"/>원</font> / <input type="text" value="${optionNums[i]}개" id="singleOptionNums${listVo.idx}" style="border:none; outline:none;text-align:center;width:20%;" readonly/><br/>
							</c:if>
							<c:if test="${optionNames[i] == '기본품목' && listVo.saleRate != '1'}">
				            	<b>◽${optionNames[i]}</b><br/>
				            	<font color="#EA5455"><b><fmt:formatNumber value="${listVo.saleRate}" type="percent"/></b></font>
				            	<span style="text-decoration: line-through;color:#5D5D5D;">${listVo.costPrice}</span>원
				            	<br/>
				            	<font color="#f77f00"><fmt:formatNumber value="${optionPrices[i]}"/>원</font> / ${optionNums[i]}개<br/>
							</c:if>
							<c:if test="${optionNames[i] != '기본품목'}">
								<b>◽${optionNames[i]}</b>
								<br/><font color="#f77f00"><fmt:formatNumber value="${optionPrices[i]}"/>원</font> / ${optionNums[i]}개<br/>
							</c:if>
			          	</c:forEach>
					</td>
					<td class="text-center">
						<c:forEach var="i" begin="0" end="${fn:length(optionNames)-1}">
							<c:if test="${fn:length(optionNums)==1}">
								<div style="width:100%; display:table; height:100px;">
									<p style="display: table-cell; text-align:center; vertical-align:middle;">
										<input type="number" id="numBox${listVo.idx}" style="width:50px;" value="${optionNums[0]}" onchange="numChange(${listVo.idx})" min="1">
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
					<td class="text-center">
						<div style="width:100%; display:table; height:100px;"><p style="display: table-cell; text-align:center; vertical-align:middle;">
							<b>
								<input type="text" id="showTPrice${listVo.idx}" style="color:#f77f00;border:none; outline:none;text-align:center;width:60%;" value="<fmt:formatNumber value="${listVo.totalPrice}" pattern='#,###원'/>">
							</b>
							<input type="hidden" id="totalPrice${listVo.idx}" value="${listVo.totalPrice}"/>
						</p></div>
					</td>
					<td class="text-center" style="width:8%;">
						<div style="width:100%; margin-right:0px; display:table; height:100px; text-align:center;"><p style="display: table-cell; text-align:center; vertical-align:middle;">
							<button type="button" class="btn btn-outline-dark btn-sm" onClick="cartDel(${listVo.idx})">삭제</button>
						</p></div>
							<input type="hidden" name="checkItem" value="0" id="checkItem${listVo.idx}"/>
					        <input type="hidden" name="idx" value="${listVo.idx }"/>
					        <input type="hidden" name="thumbImg" value="${listVo.thumbImg}"/>
					        <input type="hidden" name="productName" value="${listVo.productName}"/>
					        <input type="hidden" name="mainPrice" id="mainPrice${listVo.idx}" value="${listVo.mainPrice}"/>
					        <input type="hidden" name="optionName" value="${optionNames}"/>
					        <input type="hidden" name="optionPrice" value="${optionPrices}"/>
					        <input type="hidden" name="optionNum" value="${optionNums}"/>
					        <input type="hidden" name="totalPrice" value="${listVo.totalPrice}"/>
					        <input type="hidden" name="email" value="${sEmail}"/>
					</td>
				</tr>
				<c:set var="maxIdx" value="${listVo.idx}"/>
			</c:forEach>
		</table>
		<input type="hidden" id="maxIdx" name="maxIdx" value="${maxIdx}"/>
	  	<input type="hidden" name="orderTotalPrice" id="orderTotalPrice"/>
	
	<div class="container mt-0 mb-0" style="background-color:white; margin-top:0px;"><br/>
		<div class="row">
			<div class="col-3 text-left">
				<button type="button" class="btn btn-outline-dark btn-sm" onclick="cartSelectDel()">선택삭제</button>
			</div>
			<div class="col"></div>
			<div class="col-3 text-right">
				<button type="button" class="btn btn-outline-dark btn-sm text-right" onclick="cartAllDel()">장바구니 비우기</button>
			</div>
		</div>
		<br/>
	</div>
	<div class="container mt-0 mb-0 text-center" style="background-color:white; margin-top:0px;">
		<table class="table table-borderless mb-0 text-center" style="width:80%; background-color:white; margin-left:auto; margin-right:auto;">
			<tr style="border-bottom:1px solid #BDBDBD;">
				<td colspan="5">
					<p class="mb-0"><font color="grey">50,000원 이상 구매시 무료배송</font></p>
				</td>
			</tr>
			<tr style="border-bottom:1px solid #BDBDBD;">
				<th style="width:35%;">상품 총 금액</th>
				<th></th>
				<th>배송비</th>
				<th></th>
				<th>결제 금액</th>
			</tr>
			<tr style="border-bottom:1px solid #BDBDBD;">
				<td>
					<input type="text" id="total" class="box" value="0" style="border:none; outline:none;text-align:center; width: 100%;" readonly/>
				</td>
				<td>+</td>
				<td>
					<input type="text" id="baesong" class="box" value="0" style="border:none; outline:none;text-align:center; width: 80%;" readonly/>
				</td>
				<td>=</td>
				<td>
					<input type="text" id="finalPrice" class="box" value="0" style="border:none; outline:none; text-align:center; width: 80%; color:#EA5455;" readonly/>
				</td>
			</tr>
			<tr>
				<td colspan="2" class="col-5 text-right">
					<br/><button type="button" class="btn btn-dark text-right" onclick="orderSelect()">선택상품주문</button>
				</td>
				<td>
					<br/><button type="button" class="btn btn-dark text-right" onclick="orderAll()">전체상품주문</button>
				</td>
				<td colspan="2" class="col-5 text-left">
					<br/><button type="button" class="btn btn-dark text-right" onclick="location.href='${ctp}/shop/productList';">쇼핑계속하기</button>
				</td>
			</tr>
		</table><br/>
	</div>
	</form>
</div>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>