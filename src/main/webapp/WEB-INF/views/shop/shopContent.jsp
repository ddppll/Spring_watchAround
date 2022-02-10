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
<title>shopContent.jsp</title>
<jsp:include page="/WEB-INF/views/include/bs4.jsp"/>
<jsp:include page="/WEB-INF/views/include/nav.jsp"/>
<jsp:include page="/WEB-INF/views/include/shopNav.jsp"/>

<style>
	.next p{
		text-align:center;
	}
	.price  {
		width:20%;
		text-align:right;
		font-size:1.2em;
		border:0px;
		outline: none;
    }
    .totalPrice{
    	text-align : right;
    	border : 0px;
    	outline : none;
    	font-size : 1.5em;
    	font-weight : 800;
    	color:#f77f00;
    }
    .star-rating {
	  display:flex;
	  flex-direction: row-reverse;
	  font-size:1.5em;
	  justify-content:space-around;
	  padding:0 0.2em;
	  text-align:center;
	  width:5em;
	  font-family : 'pretendard';
	}
	
	.star-rating input { display:none;}
	.star-rating label {color:#ccc;cursor:pointer;}
	.star-rating :checked ~ label {color:#f90;}
	.star-rating label:hover,
	.star-rating label:hover ~ label {color:#fc0;}
	.outputStar{margin:0px;}
	
	.que{
		position: relative;
		padding: 17px 0;
	  	cursor: pointer;
	  	font-size: 15px;
	  	border-bottom: 1px solid #dddddd;
	}
	.que::before{
	  display: inline-block;
	  content: 'Q';
	  font-size: 15px;
	  color: #263155;
	  margin-right: 5px;
	}
	
	.que.on>span{
	  font-weight: bold;
	  color: #263155; 
	}
	  
	.anw {
	  display: none;
	  overflow: hidden;
	  font-size: 15px;
	  background-color: #f4f4f2;
	  padding: 27px 0;
	}
	  
	.anw::before {
	  display: inline-block;
	  content: 'A';
	  font-size: 15px;
	  font-weight: bold;
	  color: #666;
	  margin-right: 5px;
	}
	
	.reviewImg:hover{
		filter:brightness(50%);
	}
</style>
<script src="${ctp}/js/bootstrap-number-input.js"></script>
<script>
	//천단위마다 콤마를 표시해 주는 함수
	function numberWithCommas(x) {
		return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g,",");
	}
	
	var idxArray = new Array();
	
	$(function(){
    	$("#selectOption").change(function(){						
    		var selectOption = $(this).val();							// <option value="${vo.idx}:${vo.optionName}_${vo.optionPrice}">${vo.optionName}</option>
    		var idx = selectOption.substring(0,selectOption.indexOf(":")); 	// 현재 옵션의 고유번호 - 기본품목은 0
    		var optionName = selectOption.substring(selectOption.indexOf(":")+1,selectOption.indexOf("_")); // 옵션명
    		var optionPrice = selectOption.substring(selectOption.indexOf("_")+1); 			// 옵션가격
    		var commaPrice = numberWithCommas(optionPrice);									// 콤마붙인 가격
    		
    		if($("#layer"+idx).length == 0 && selectOption != "") {
    		  idxArray[idx] = idx;		// 옵션을 선택한 개수만큼 배열의 크기로 잡는다.
    		  
	    		var str = "";
	    		str += "<div id='layer"+idx+"'><br/><b>"+optionName+"</b><br/>";
	    		str += "<input type='number' class='numBox' id='numBox"+idx+"' name='optionNum' onchange='numChange("+idx+")' value='1' min='1' style='width:30%;'/> &nbsp;";
	    		str += "<div class='text-right pr-5'><input type='text' id='imsiPrice"+idx+"' class='price' value='"+commaPrice+"' readonly'/> 원&nbsp;";
	    		str += "<a href='javascript:remove("+idx+");'><i style='font-size:1rem; color:#e76f51;' class='far fa-window-close'></i></a></div> &nbsp;";
	    		str += "<hr class='mt-0 mb-0 mr-5'/>";
	    		str += "<input type='hidden' id='price"+idx+"' class='price' value='"+optionPrice+"'/> &nbsp;";
	    		str += "<input type='hidden' name='statePrice' id='statePrice"+idx+"' value='"+optionPrice+"'/>";
	    		str += "<input type='hidden' name='optionIdx' value='"+idx+"'/>";
	    		str += "<input type='hidden' name='optionName' value='"+optionName+"'/>";
	    		str += "<input type='hidden' name='optionPrice' value='"+optionPrice+"'/>";
	    		str += "</div>";
	    		$("#product1").append(str);
	    		$('#numBox'+idx).bootstrapNumber({
	    			upClass: 'dark',
	    			downClass: 'outline-dark'
	    		});
	    		onTotal(); 
    	  }
    	  else {
    		  alert("이미 선택한 옵션입니다.");
    	  }
    	});
    });
	
	// 등록(추가)시킨 옵션 상품 삭제하기
    function remove(idx) {
  	  $("div").remove("#layer"+idx);
  	  onTotal();
    }
	
 // 상품 총 금액 계산
    function onTotal() {
  	  var total = 0;
  	  for(var i=0; i<idxArray.length; i++) {
  		  if($("#layer"+idxArray[i]).length != 0) {
		  	  //alert(idxArray[i]);
  		  	total +=  parseInt(document.getElementById("price"+idxArray[i]).value);
  		  	document.getElementById("totalPriceResult").value = total;
  		  }
  	  }
  	  document.getElementById("totalPrice").value = numberWithCommas(total);
    }
 
    // 수량 변경시 처리하는 함수(옵션 있을 때)
    function numChange(idx) {
    	var price = document.getElementById("statePrice"+idx).value * document.getElementById("numBox"+idx).value;
    	document.getElementById("imsiPrice"+idx).value = numberWithCommas(price);
    	document.getElementById("price"+idx).value = price;
    	onTotal();
    }
    
    //장바구니 호출
    function cart(){
    	if('${sEmail}' == ""){
    		alert("로그인 후 이용 가능합니다");
    		location.href = "${ctp}/member/memberLogin";
    	}
    	else if(document.getElementById("totalPrice").value == 0){
    		alert("옵션을 선택하세요");
    		return false;
    	}
    	else{
    		var ans = confirm("장바구니에 상품을 담으시겠습니까?");
    		if(!ans){
    			return false;
    		}
    		else{
    			/* document.myform.action = "${ctp}/shop/shopContent"; */
    			$("#myform").submit();
    		}
    	}
    }
    
    //바로 주문
    function order(email){
    	if('${sEmail}' == ""){
    		alert("로그인 후 이용 가능합니다");
    		/* location.href = "${ctp}/member/memberLogin"; */
    		return false;
    	}
    	else if(document.getElementById("totalPrice").value == 0 || document.getElementById("totalPrice").value == ""){
    		alert("옵션을 선택해주세요");
    		location.reload(); 
    	}
    	else{
    		document.getElementById("immeOrder").value = "immeOrderOk";
    		$("#myform").submit();
    	}
    }
    
    //리뷰 버튼 클릭시
    function review(){
    	var content = document.getElementById("content").value;
    	var email = "${sEmail}";
    	var productIdx = "${productVo.idx}";
    	var fName = reviewForm.fName.value;
    	var ext = fName.substring(fName.lastIndexOf(".")+1);	// 파일 확장자 발췌
    	var uExt = ext.toUpperCase();
    	var maxSize = 1024 * 1024 * 10;							//파일 용량 : 10mb
    	var rating = reviewForm.rating.value;					//별점
    	//alert(productIdx + "/" + rating + "/" + email + "/" + content);
    	if(email == null || email == ""){
    		alert("로그인 후 이용 가능합니다");
    		return false;
    	}
    	else if(content == ""){
    		alert("리뷰 내용을 입력하세요");
    		reviewForm.content.focus();
    		return false;
    	}
    	else{
    		if(reviewForm.fName.value!=""){
		    	var fileSize = document.getElementById("fName").files[0].size;
	    		
	    		if(uExt != "JPG" && uExt != "GIF" && uExt != "PNG") {
		    		alert("업로드 가능한 파일은 'JPG/GIF/PNG");
		    		return false;
		    	}
		    	else if(fName.indexOf(" ") != -1) {
		    		alert("업로드할 파일명에는 공백을 포함할 수 없습니다.");
		    		return false;
		    	}
		    	else if(fileSize > maxSize) {
		    		alert("업로드할 파일의 크기는 10MByte 이하입니다.");
		    		return false;
		    	}
    		}
    	}
    	$.ajax({
    		url : "${ctp}/shop/orderCheck",
    		method : "post",
    		data : {
    			email : email,
    			productIdx : productIdx
    		},
    		success : function(data){
    			if(data == "1"){
    				alert("해당 상품 구매 이력이 없습니다");
    				return false;
    			}
    			else{
	    			reviewForm.rating.value = rating;
	    			reviewForm.submit();
    			}
    		}
    	});
    }
    
    //상품 찜하기
     function like(idx){
    	var email = "${sEmail}";
    	if(email == null || email == ""){
    		alert("로그인 후 이용 가능합니다");
    	}
    	else{
    		$.ajax({
    			url : "${ctp}/shop/shopLike",
    			type : "post",
    			data : {
    				email : email,
    				idx : idx
    			},
    			success : function(data){
    				location.reload();
    			}
    		});
    	}
    	
    }  
    
   //리뷰 삭제
	function reviewDelCheck(idx){
		var ans = confirm("해당 리뷰를 삭제하시겠습니까?");
    	if(!ans) return false;
		
		$.ajax({
			type : "post",
			url : "${ctp}/shop/reviewDelete",
			data : {idx : idx},
			success : function(){
				location.reload();
			},
			error : function(){
				alert("전송 오류");
			}
		});
	}
    
    
</script>

</head>
<body style="background-color : #171721;">


<div class="container pt-5 pb-5 pr-0 pl-0" style="font-family:'pretendard'; width:1110px; background-color:white; border-bottom:solid 1px #171721;">
	<div class="row">
		<!-- 상품 메인 이미지 -->
		<div class="col-sm-6 text-center">
			<div id="thumbnail" align="center">
				<img src="${ctp}/dbShop/${productVo.FSName}" width="90%;">
			</div>
		</div>
		<!-- 상품 기본 정보 -->
		<div class="col-sm-6 ml-0 pl-0">
			<p style="font-size:2rem; margin-bottom:0px;">${productVo.productName}</p>
			<p style="font-size:1rem;">${productVo.detail}</p>
			<c:if test="${productVo.saleRate == '1'}">
				<div class="text-right pr-5" style="float:right;">
					<label style="font-size:1.5rem"><font color="#f77f00"><b><fmt:formatNumber value="${productVo.mainPrice}" pattern="#,###"/>원</b></font></label>
				</div>
			</c:if>
			<c:if test="${productVo.saleRate != '1'}">
				<label style="font-size:2rem;"><font color="#EA5455"><b><fmt:formatNumber value="${productVo.saleRate}" type="percent"/></b></font></label>
				<div class="text-right pr-5" style="float:right;">
					<label style="font-size:1rem"><font color="grey" style="text-decoration:line-through;"><b><fmt:formatNumber value="${productVo.mainPrice}" pattern="#,###"/>원</b></font></label>&nbsp;
					<label style="font-size:1.5rem"><font color="#f77f00"><b><fmt:formatNumber value="${productVo.salePrice}" pattern="#,###"/>원</b></font></label>
				</div>
			</c:if>
			<!-- 옵션 출력부 -->
			<div>
				<form name="optionForm">
					<select size="1" class="form-control" id="selectOption" style="width:90%;">
						<option value="" disabled selected>옵션선택</option>
						<c:if test="${productVo.saleRate != '1'}">
							<option value="0:기본품목_${productVo.salePrice}">기본품목</option>
						</c:if>
						<c:if test="${productVo.saleRate == '1'}">
							<option value="0:기본품목_${productVo.mainPrice}">기본품목</option>
						</c:if>
						<c:forEach var="vo" items="${optionVos}">
							<option value="${vo.idx}:${vo.optionName}_${vo.optionPrice}">${vo.optionName}</option>
						</c:forEach>
					</select>
				</form>
				<form id="myform" name="myform" method="post">
					<input type="hidden" name="email" value="${sEmail}"/>
				    <input type="hidden" name="productIdx" value="${productVo.idx}"/>
				    <input type="hidden" name="productName" value="${productVo.productName}"/>
				    <c:if test="${productVo.saleRate =='1'}">
					    <input type="hidden" name="mainPrice" value="${productVo.mainPrice}"/>
				    </c:if>
				    <c:if test="${productVo.saleRate =! '1'}">
					    <input type="hidden" name="mainPrice" value="${productVo.salePrice}"/>
				    </c:if>
				    <input type="hidden" name="saleRate" value="${productVo.saleRate}"/>
				    <input type="hidden" name="thumbImg" value="${productVo.FSName}"/>
				    <input type="hidden" name="totalPrice" id="totalPriceResult"/>
				    <input type="hidden" name="immeOrder" id=immeOrder value="immeOrder"/>
				    <div id="product1"></div>
				
			<div class="productPrice mt-2">
				<b>총 상품 금액</b>
				<p class="text-right pr-5"><input type="text" class="totalPrice text-right" id="totalPrice" value="<fmt:formatNumber value='0'/>" readonly />원</p>
			</div>
			<hr class="mr-5"/>
				<div>
					<input type="button" class="btn btn-dark btn-block" onclick="order('${sEmail}')" style="width:90%;" value="주문하기">
				</div>
				
					<table class="table table-borderless" style="width:90%;">
						<tr>
							<td class="col-6 pl-0"><input type="button" class="btn btn-outline-dark btn-block" onclick="cart()" value="장바구니"></td>
							<c:if test="${not empty goodsVo.email}">
								<td class="col-6 pr-0"><input type="button" class="btn btn-dark btn-block" onclick="like(${productVo.idx})" value="찜하기♥ ${goodsCnt}"></td>
							</c:if>
							<c:if test="${empty goodsVo.email}">
								<td class="col-6 pr-0"><input type="button" class="btn btn-outline-dark btn-block" onclick="like(${productVo.idx})" value="찜하기♡ ${goodsCnt}"></td>
							</c:if>
						</tr>
					</table>
				</form>
			</div>
		</div>
	</div>
	<br/>
	<!-- 이동바 -->
	<div class="w3-row" id="bar1">
	    <a href="#bar1" style="color:black;">
	        <div class="w3-third tablink w3-light-grey w3-padding w3-border-black" style="text-align: center;">Product</div>
	    </a>
	    <a href="#bar2" style="color:black;">
	        <div class="w3-third tablink w3-hover-light-grey w3-padding" style="text-align: center;">Review</div>
	    </a>
	    <a href="#bar3" style="color:black;">
	        <div class="w3-third tablink w3-hover-light-grey w3-padding" style="text-align: center;">Q&A</div>
	    </a>
  	</div>
  	<hr class="mt-0"/>
  	<!-- 상품 상세설명 -->
  	<div id="content1" class="container">
  		<div class="next">
  			<p class="text-center">${productVo.content}</p>
  		</div>
  	</div>
  	<br/>
  	<!-- 이동바 -->
	<div class="w3-row" id="bar2">
	    <a href="#bar1" style="color:black;">
	        <div class="w3-third tablink w3-hover-light-grey w3-padding w3-border-black" style="text-align: center;">Product</div>
	    </a>
	    <a href="#bar2" style="color:black;">
	        <div class="w3-third tablink w3-light-grey w3-padding" style="text-align: center;">Review</div>
	    </a>
	    <a href="#bar3" style="color:black;">
	        <div class="w3-third tablink w3-hover-light-grey w3-padding" style="text-align: center;">Q&A</div>
	    </a>
  	</div>
  	<hr class="mt-0"/>
	<div class="container">
		<table style="width:80%; font-family : 'pretendard'; margin:auto;" class="reviewPrint">
			<tr style="border-bottom:1px solid lightgrey;">
				<td class="pb-2"><font size=4 color=#2A9D8F><b>리뷰 ${totRecCnt}건</b></font><br/></td>
			</tr>
			<c:forEach var="vo" items="${reviewVos}">
			<tr style="height:">
				<td style="font-size:16px;padding-top:13px;" colspan="2">
					<c:if test="${vo.rating == 1}">
						<p class="ml-4 mb-0">
							<label class="outputStar" style="color:#f90;">&#9733;</label>
							<label class="outputStar" style="color:#ccc;">&#9733;</label>
							<label class="outputStar" style="color:#ccc;">&#9733;</label>
							<label class="outputStar" style="color:#ccc;">&#9733;</label>
							<label class="outputStar" style="color:#ccc;">&#9733;</label>
							&nbsp;<b>${vo.rating}</b>&nbsp;
							<c:if test="${vo.email == sEmail || sLevel == 0}">
								<a href="javascript:reviewDelCheck(${vo.idx});"><i style="font-size:0.8rem; color:#e76f51;" class="far fa-window-close"></i></a>
							</c:if>
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
							<c:if test="${vo.email == sEmail || sLevel == 0}">
								<a href="javascript:reviewDelCheck(${vo.idx});"><i style="font-size:0.8rem; color:#e76f51;" class="far fa-window-close"></i></a>
							</c:if>
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
							<c:if test="${vo.email == sEmail || sLevel == 0}">
								<a href="javascript:reviewDelCheck(${vo.idx});"><i style="font-size:0.8rem; color:#e76f51;" class="far fa-window-close"></i></a>
							</c:if>
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
							<c:if test="${vo.email == sEmail || sLevel == 0}">
								<a href="javascript:reviewDelCheck(${vo.idx});"><i style="font-size:0.8rem; color:#e76f51;" class="far fa-window-close"></i></a>
							</c:if>
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
							<c:if test="${vo.email == sEmail || sLevel == 0}">
								<a href="javascript:reviewDelCheck(${vo.idx});"><i style="font-size:0.8rem; color:#e76f51;" class="far fa-window-close"></i></a>
							</c:if>
						</p>
					</c:if>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<c:set var="email" value="${fn:substring(vo.email,0,4)}"/>
					<p class="ml-4 mb-0">
						<font color='#9999a6' size='2'>${email}**** | 
						${fn:substring(vo.reviewDate,0,10)}</font>
					</p>
				</td>
			</tr>
			<tr style="border-bottom:1px solid lightgrey;">
				<c:if test="${vo.photo != null}">
					<td style="padding-bottom:13px;">
						<p class="ml-4 mb-0">${fn:replace(vo.content,newLine,'<br/>')}</p>
					</td>
				</c:if>
				<c:if test="${vo.photo == null}">
					<td colspan="2" style="padding-bottom:13px;">
						<p class="ml-4 mb-0">${fn:replace(vo.content,newLine,'<br/>')}</p>
					</td>
				</c:if>
				<c:if test="${vo.photo != null}">
					<td class="text-right pr-4" style="padding-bottom:13px;">
						<img src="${ctp}/review/${vo.photo}" width="100px" height="100px" class="reviewImg" style="cursor:pointer;" onclick="window.open('${ctp}/review/${vo.photo}','리뷰이미지','width=500px, height=500px, resizable=yes, location=no, toolbar=no')"/>
					</td>
				</c:if>
			</tr>
			</c:forEach>
		</table><br/>
		<!-- 블록 페이징처리 시작(BS4 스타일적용) -->
		<%-- <div class="container mt-0 mb-0" style="background-color:white; margin-top:0px;"><br/>
			<ul class="pagination justify-content-center">
				<c:if test="${totPage == 0}"><p style="text-align:center"><b>자료가 없습니다.</b></p></c:if>
				<c:if test="${totPage != 0}">
				  <c:if test="${pag != 1}">
				    <li class="page-item"><a href="${ctp}/shop/shopContent?pag=1&pageSize=${pageSize}&idx=${vo.idx}" title="첫페이지" class="page-link text-secondary">◁◁</a></li>
				  </c:if>
				  <c:if test="${curBlock > 0}">
				    <li class="page-item"><a href="${ctp}/shop/shopContent?pag=${(curBlock-1)*blockSize + 1}&pageSize=${pageSize}&idx=${vo.idx}" title="이전블록" class="page-link text-secondary">◀</a></li>
				  </c:if>
				  <c:forEach var="i" begin="${(curBlock*blockSize)+1}" end="${(curBlock*blockSize)+blockSize}">
				    <c:if test="${i == pag && i <= totPage}">
				      <li class="page-item active"><a href='${ctp}/shop/shopContent?pag=${i}&pageSize=${pageSize}&idx=${vo.idx}' class="page-link text-light bg-secondary border-secondary">${i}</a></li>
				    </c:if>
				    <c:if test="${i != pag && i <= totPage}">
				      <li class="page-item"><a href='${ctp}/shop/shopContent?pag=${i}&pageSize=${pageSize}&idx=${vo.idx}' class="page-link text-secondary">${i}</a></li>
				    </c:if>
				  </c:forEach>
				  <c:if test="${curBlock < lastBlock}">
				    <li class="page-item"><a href="${ctp}/shop/shopContent?pag=${(curBlock+1)*blockSize + 1}&pageSize=${pageSize}&idx=${vo.idx}" title="다음블록" class="page-link text-secondary">▶</a>
				  </c:if>
				  <c:if test="${pag != totPage}">
				    <li class="page-item"><a href="${ctp}/shop/shopContent?pag=${totPage}&pageSize=${pageSize}&idx=${vo.idx}" title="마지막페이지" class="page-link" style="color:#555">▷▷</a>
				  </c:if>
				</c:if>
			</ul> --%>
			<!-- 블록 페이징처리 끝 -->
		<form name="reviewForm" method="post" enctype="Multipart/form-data" action="${ctp}/shop/reviewInput">
			<div style="width:80%; margin:auto;">
			<div class="star-rating">
				<input type="radio" id="5-stars" name="rating" value="5" />
				<label for="5-stars" class="star">&#9733;</label>
				<input type="radio" id="4-stars" name="rating" value="4" />
				<label for="4-stars" class="star">&#9733;</label>
				<input type="radio" id="3-stars" name="rating" value="3" />
				<label for="3-stars" class="star">&#9733;</label>
				<input type="radio" id="2-stars" name="rating" value="2" />
				<label for="2-stars" class="star">&#9733;</label>
				<input type="radio" id="1-star" name="rating" value="1" />
				<label for="1-star" class="star">&#9733;</label>
			</div>
			<textarea class="form-control" rows="5" id="content" name="content"></textarea><br/>
			<input type="file" name="fName" id="fName" class="form-control-file border"/><br/>
			<p class="text-right"><button class="btn btn-outline-dark" type="button" onclick="review()">리뷰등록</button></p>
			<input type="hidden" name="email" value="${sEmail}"/>
		    <input type="hidden" name="productIdx" value="${productVo.idx}"/>
		    <input type="hidden" name="productName" value="${productVo.productName}"/>
		    <input type="hidden" name="nickName" value="${sNickName}"/>
		</div>
		</form>
	</div><br/>
	
	<!-- 이동바 -->
	<div class="w3-row" id="bar3" style="border-bottom:solid 1px #e5e5e5;">
	
	    <a href="#bar1" style="color:black;">
	        <div class="w3-third tablink w3-hover-light-grey w3-padding w3-border-black" style="text-align: center;">Product</div>
	    </a>
	    <a href="#bar2" style="color:black;">
	        <div class="w3-third tablink w3-hover-light-grey w3-padding w3-border-black" style="text-align: center;">Review</div>
	    </a>
	    <a href="#bar3" style="color:black;">
	        <div class="w3-third tablink w3-light-grey w3-padding" style="text-align: center;">Q&A</div>
	    </a>
  	</div>
  	
  	<!-- 자주하는질문 -->
  	<div class="container" style="width:80%;">
  		<!-- <div class="text-center mt-3" style="font-size:20px;">자주 하는 질문</div> -->
  		<div class="que">
  			<span>고객센터의 상담 시간을 알고 싶어요.</span>
  		</div>
  		<div class="anw">
  			<span> - 고객센터 전화번호 : 1544-1234<br/>
					- 상담 시간 : 평일 오전 9시 30분 ~ 오후 6시 (점심시간 : 오전 11시 30분 ~ 오후 1시 30분 / 주말, 공휴일 휴무)<br/>
					- 전화 연결이 어려운 경우 카카오 상담톡으로 문의를 남겨주시면 확인 후 정성껏 답변드리겠습니다.<br/>
					※ 문의량이 많을 경우 상담 연결 및 답변이 지연될 수 있습니다.</span>
  		</div>
  		<div class="que">
  			<span>배송은 언제 되나요?</span>
  		</div>
  		<div class="anw">
  			<span>
  				- 영업일 기준 오후 1시 이전 결제 완료 주문건 :  당일 출고됩니다. (일부 상품 제외)<br/>
				- 공휴일의 경우 다음 영업일에 출고됩니다.<br/>
				(출고된 경우 서울/수도권 지역은 대부분 다음날 수령, 지방은 1~3일 이내에 배송됩니다. <br/>
				따라서 전체 배송 기간은 (업무일 기준) 3일~7일 정도 소요되며, 일부 택배사 사정에 따라 변동될 수 있습니다.)<br/>
				※ 주문 상품이 재고 부족일 경우 부득이하게 배송 시간은 달라질 수 있는 점 양해 부탁드립니다.
  			</span>
  		</div>
  		<div class="que">
  			<span>무통장 결제로 입금했는데 확인되지 않아요.</span>
  		</div>
  		<div class="anw">
  			<span>
  				- 무통장입금 건은 입금 후 영업시간이내 1~2시간 이후에 확인이 가능하며,<br/>
				주문 후 7일 이내로 입금 확인이 안될 경우 주문이 자동으로 취소 처리됩니다.
  			</span>
  		</div>
  	</div>
</div>
<script src="${ctp}/js/bootstrap-number-input.js"></script>
<script>
	$('#numBox${productVo.idx}').bootstrapNumber({
		upClass: 'dark',
		downClass: 'outline-dark'
	});
	/* $('input[name=optionNum2]').bootstrapNumber({
		upClass: 'dark',
		downClass: 'outline-dark'
	}); */
</script>
<script>
//자주하는질문 아코디언메뉴
$(".que").click(function() {
	$(this).next(".anw").stop().slideToggle(300);
	$(this).toggleClass('on').siblings().removeClass('on');
	$(this).next(".anw").siblings(".anw").slideUp(300); // 1개씩 펼치기
});
</script>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>