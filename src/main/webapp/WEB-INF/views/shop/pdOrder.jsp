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
	

	
	//결제 버튼 클릭시
	function order(){
		var regExpTel2 = /^[0-9]{3,4}$/gm;  // 숫자만
		var regExpTel3 = /^[0-9]{3,4}$/gm;  // 숫자만
		
		var nameOrder = document.getElementById("deliverName").value;
		
		var tel2 = document.getElementById("orderCellphone2").value; 
		var tel3 = document.getElementById("orderCellphone3").value;
		var telPay = document.getElementById("orderCellphone").value + "/" + tel2 + "/" + tel3;
		var tel = document.getElementById("orderCellphone").value + "/" + tel2 + "/" + tel3;
		
		var postcode = document.getElementById("sample4_postcode").value;
		var roadAddress = document.getElementById("sample4_roadAddress").value;
		var detailAddress = document.getElementById("sample4_detailAddress").value;
		var address = postcode + "/" + roadAddress + "/" + detailAddress;
		if(address == "//") address = "";
		
		var paymentCard = document.getElementById("paymentCard").value;		//카드사 선택
    	var payMethodCard = document.getElementById("payMethodCard").value;	//카드번호
		var paymentBank = document.getElementById("paymentBank").value;		//입금은행 선택
    	var payMethodBank = document.getElementById("payMethodBank").value;	//입금자
    	
    	if (deliverName ==""){
    		alert("받는 사람을 입력하세요");
    		deliverName.focus();
    		return false;
    	}
    	else if(roadAddress == ""){
    		alert("주소를 입력하세요");
    		document.getElementById("sample4_roadAddress").focus();
    		return false;
    	}
    	else if(tel2 == "" || !regExpTel2.test(tel2)){
    	//else if(tel2 == ""){
    		alert("연락처2를 제대로 입력해주세요");
    		document.getElementById("orderCellphone2").focus();
    		return false;
    	}
    	else if(tel3 == "" || !regExpTel3.test(tel3)){
    	//else if(tel3=""){
    		alert("연락처3을 제대로 입력해주세요");
    		document.getElementById("orderCellphone3").focus();
    		return false;
    	}
    	else if(paymentCard != "" && payMethodCard == ""){
    		alert("결제 방식과 번호를 입력하세요.");
    		return false;
    	}
    	else if(paymentCard != "" && payMethodCard == "") {
    		alert("카드 번호를 입력하세요.");
    		document.getElementById("payMethodCard").focus();
    		return false;
    	}
    	else if(paymentBank != "" && payMethodBank == "") {
    		alert("입금자명을 입력하세요.");
    		return false;
    	}
    	var ans = confirm("결제하시겠습니까?");
    	if(ans){
    		if(paymentCard != "" && payMethodCard != "") {
    			document.getElementById("payment").value = "C"+paymentCard;
    			document.getElementById("payMethod").value = payMethodCard;
    		}
    		else if(paymentBank != "" && payMethodBank != ""){
    			document.getElementById("payment").value = "B"+paymentBank;
    			document.getElementById("payMethod").value = payMethodBank;
    		}
    		else{
	    		document.getElementById("payment").value = "cellphonePay";
	    		document.getElementById("payMethod").value = telPay;
    		}
			document.getElementById("deliverName").value = nameOrder;
			document.getElementById("address").value = address;
			document.getElementById("tel").value = tel;
			
    		//$("#myform").action("${ctp}/dbShop/orderInput");
    		//document.myform.action = "${ctp}/dbShop/orderInput";
    		//alert("payment : " + payment + "\n" + "payMethod : " + payMethod);
    		$("#myform").submit();
    	}
	}
	
</script>
</head>
<body style="background-color : #171721;">
<div class="container">
	<table class="table table-borderless pt-3 mb-0" style="background-color:white; width:100%; font-family:'pretendard';">
		<tr>
			<td class="text-center mt-3 mb-3">
				<br/>
				<h2 style="font-family : 'pretendard'; margin-bottom:0px;">주문하기</h2>
				<br/>
			</td>
		</tr>
	</table>
	<div class="container mt-0 mb-0" style="background-color:white; margin-top:0px;">
		<table class="table table-borderless pt-3 mb-0" style="background-color:white; width:90%; font-family : 'pretendard'; margin:auto;">
			<tr style="border : 1px solid #D5D5D5;background-color:#F6F6F6;">
				<th colspan="2">상품</th>
				<th>가격</th>
				<th>수량</th>
				<th>합계</th>
			</tr>
			<c:set var="orderTotalPrice" value="0"/>
			<c:forEach var="vo" items="${orderVos}">
				<tr style="border-bottom: 1px solid  #D5D5D5; border-left: 1px solid  #D5D5D5; border-right: 1px solid  #D5D5D5">
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
								<font color="#f77f00"><b><fmt:formatNumber value="${vo.totalPrice}" pattern='#,###원'/></b></font>
								<input type="hidden" id="totalPrice${vo.idx}" value="${vo.totalPrice}"/>
							</p>
						</div>
					</td>
				</tr>
				<c:set var="orderTotalPrice" value="${orderTotalPrice + vo.totalPrice}"/>
			</c:forEach>
		</table>
	</div>
	<div class="container mt-0 mb-0" style="background-color:white; margin-top:0px;"><br/>
		<table class="table table-borderless mb-0 text-center" style="width:90%; background-color:white; margin-left:auto; margin-right:auto;">
			<tr style="border-bottom:1px solid #D5D5D5;">
				<td colspan="5" class="text-left">
					<font style="font-family : 'pretendard'; font-size:18.75px; font-weight:500;">결제 예정 금액 </font>
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
		<br/>
	</div>
	
	<!-- ----------------------------배송정보 입력(form)------------------------------- -->
	
	<form name="myform" id="myform" method="post" action="${ctp}/shop/orderInput">
		<div class="container mt-0 mb-0" style="background-color:white; margin-top:0px;">
			<table class="table table-borderless pt-3 mb-0" style="background-color:white; width:90%; font-family : 'pretendard'; margin:auto;">
				<tr style="border-bottom: 1px solid #D5D5D5;">
					<td colspan="2">
						<font style="font-family : 'pretendard'; font-size:18.75px; font-weight:500;">배송 정보  </font>&nbsp;
						<font style="color: blue; font-weight: bold;">*</font>
						<font style="font-size : 10pt; color: gray;">표시는 필수입력입니다</font>
					</td>
				</tr>
				<tr style="border-right: 1px solid #D5D5D5; border-left: 1px solid #D5D5D5;">
					<td>
						받는 사람<font style="color: blue; font-weight: bold;"> *</font>
					</td>
					<td><input class="form-control" name="deliverName" id="deliverName" type="text" style="width:30%;" value="${membersVo.nickName}"/></td>
				</tr>
				<tr style="border-right: 1px solid #D5D5D5; border-left: 1px solid #D5D5D5;">
					<td>
						주소<font style="color: blue; font-weight: bold;"> *</font>
					</td>
					<td>
	      				<input type="text" name="postcode" id="sample4_postcode" placeholder="우편번호">
						<input type="button" class="btn btn-sm btn-dark" onclick="sample4_execDaumPostcode()" value="우편번호 찾기"><br/>
						<input type="text" name="roadAddress" id="sample4_roadAddress" size="50" placeholder="도로명주소">
						<span id="guide" style="color:#999;display:none"></span>
						<input type="text" name="detailAddress" id="sample4_detailAddress" size="30" placeholder="상세주소">
					</td>
				</tr>
				<tr style="border-right: 1px solid #D5D5D5; border-left: 1px solid #D5D5D5;">
					<td>
						연락처<font style="color: blue; font-weight: bold;"> *</font>
					</td>
					<td>
						<select class="form-control" id="orderCellphone" name="orderCellphone" >
							<c:set var="orderCellphone" value="${fn:split(membersVo.tel,'/')[0]}"/>
							<option value="010" ${tel1=='010' ? 'selected' : ''}>010</option>
							<option value="011" ${tel1=='011' ? 'selected' : ''}>011</option>
							<option value="016" ${tel1=='016' ? 'selected' : ''}>016</option>
							<option value="017" ${tel1=='017' ? 'selected' : ''}>017</option>
							<option value="018" ${tel1=='018' ? 'selected' : ''}>018</option>
							<option value="019" ${tel1=='019' ? 'selected' : ''}>019</option>
						</select> -
						<input type="text" class="form-control" name="cellphoneName2" id="orderCellphone2" required oninvalid="this.setCustomValidity('번호를 입력하세요.')" maxlength=4 value="${fn:split(membersVo.tel,'/')[1]}"> - 
						<input type="text" class="form-control" name="cellphoneName3" id="orderCellphone3" required oninvalid="this.setCustomValidity('번호를 입력하세요.')" maxlength=4 value="${fn:split(membersVo.tel,'/')[2]}">
					</td>
				</tr>
				<tr style="border-right: 1px solid #D5D5D5; border-left: 1px solid #D5D5D5;">
					<td>
						이메일<font style="color: blue; font-weight: bold;"> *</font>
					</td>
					<td>
						<input type="text" class="form-control" value="${sEmail}" placeholder="이메일 형식으로 입력" name="email" id="email" required oninvalid="this.setCustomValidity('이메일을 입력하세요.')" style="display:inline-block; width:50%;" readonly />
					</td>
				</tr>
				<tr style="border-right: 1px solid #D5D5D5; border-left: 1px solid #D5D5D5; border-bottom: 1px solid #D5D5D5;">
					<td>배송메세지</td>
					<td>
						<textarea class="form-control" rows="2" name="message" id="message" style="width:100%;"></textarea>
					</td>
				</tr>
			</table><br/>
			
			<ul class="nav nav-tabs" role="tablist" style="width:90%; margin:auto;">
		      	<li class="nav-item" style="color:black;"><a class="nav-link active" data-toggle="tab" href="#card" style="color:black;"><font color="black">카드결제</font></a></li>
			    <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#bank"><font color="black">무통장입금</font></a></li>
			    <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#telCheck"><font color="black">핸드폰결제</font></a></li>
			</ul>
	
			  <!-- Tab panes -->
			  <div class="tab-content" style="width:90%;">
			    <div id="card" class="container tab-pane active" style="width:90%;"><br>
			      <font style="font-family : 'pretendard'; font-size:18.75px; font-weight:500;">카드결제</font><br/>
			      <p class="mt-2"> 카드 선택
			        <select name="paymentCard" id="paymentCard">
			          <option value="">카드선택</option>
			          <option value="국민">국민</option>
			          <option value="현대">현대</option>
			          <option value="신한">신한</option>
			          <option value="농협">농협</option>
			          <option value="BC">BC</option>
			          <option value="롯데">롯데</option>
			          <option value="삼성">삼성</option>
			          <option value="LG">LG</option>
			        </select>
			      </p>
						<p>카드번호 <input type="text" name="payMethodCard" id="payMethodCard"/></p>
			    </div>
			    <div id="bank" class="container tab-pane fade" style="width:90%;"><br>
			      <font style="font-family : 'pretendard'; font-size:18.75px; font-weight:500;">무통장입금</font>
			      <p class="mt-2"> 은행 선택
			        <select name="paymentBank" id="paymentBank">
			          <option value="">은행선택</option>
			          <option value="국민">국민</option>
			          <option value="신한">신한</option>
			          <option value="우리">우리</option>
			          <option value="농협">농협</option>
			          <option value="카카오뱅크">카카오뱅크</option>
			        </select>
			      </p>
						<p>입금자명 <input type="text" name="payMethodBank" id="payMethodBank"/></p>
			    </div>
			    <div id="telCheck" class="container tab-pane fade" style="width:90%;"><br>
			      <font style="font-family : 'pretendard'; font-size:18.75px; font-weight:500;">핸드폰결제</font><br/>
			      * 결제금액이 입력하신 핸드폰 요금에 청구됩니다.<br/>
			      * 월 결제 한도는 최대 50만원입니다.<br/>
			    </div>
			  </div>
			
			<div class="text-center p-3">
				<button type="button" class="btn btn-dark" onClick="order()">결제하기</button>
				<button type="button" class="btn btn-dark" onclick="location.href='${ctp}/shop/pdCartList';">장바구니보기</button>
			</div>
		</div>
		<input type="hidden" name="orderVos" value="${orderVos}"/>
		<input type="hidden" name="orderIdx" value="${orderIdx}"/>
		<input type="hidden" name="orderTotalPrice" value="${orderTotalPrice}"/>
		<%-- <input type="hidden" name="email" value="${sEmail}"/> --%>
		<input type="hidden" name="tel" id="tel"/>
		<input type="hidden" name="address" id="address"/>
		<input type="hidden" name="payment" id="payment"/>
	  	<input type="hidden" name="payMethod" id="payMethod"/>
	</form>
</div>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>