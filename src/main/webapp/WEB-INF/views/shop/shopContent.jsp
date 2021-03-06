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
	//??????????????? ????????? ????????? ?????? ??????
	function numberWithCommas(x) {
		return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g,",");
	}
	
	var idxArray = new Array();
	
	$(function(){
    	$("#selectOption").change(function(){						
    		var selectOption = $(this).val();							// <option value="${vo.idx}:${vo.optionName}_${vo.optionPrice}">${vo.optionName}</option>
    		var idx = selectOption.substring(0,selectOption.indexOf(":")); 	// ?????? ????????? ???????????? - ??????????????? 0
    		var optionName = selectOption.substring(selectOption.indexOf(":")+1,selectOption.indexOf("_")); // ?????????
    		var optionPrice = selectOption.substring(selectOption.indexOf("_")+1); 			// ????????????
    		var commaPrice = numberWithCommas(optionPrice);									// ???????????? ??????
    		
    		if($("#layer"+idx).length == 0 && selectOption != "") {
    		  idxArray[idx] = idx;		// ????????? ????????? ???????????? ????????? ????????? ?????????.
    		  
	    		var str = "";
	    		str += "<div id='layer"+idx+"'><br/><b>"+optionName+"</b><br/>";
	    		str += "<input type='number' class='numBox' id='numBox"+idx+"' name='optionNum' onchange='numChange("+idx+")' value='1' min='1' style='width:30%;'/> &nbsp;";
	    		str += "<div class='text-right pr-5'><input type='text' id='imsiPrice"+idx+"' class='price' value='"+commaPrice+"' readonly'/> ???&nbsp;";
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
    		  alert("?????? ????????? ???????????????.");
    	  }
    	});
    });
	
	// ??????(??????)?????? ?????? ?????? ????????????
    function remove(idx) {
  	  $("div").remove("#layer"+idx);
  	  onTotal();
    }
	
 // ?????? ??? ?????? ??????
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
 
    // ?????? ????????? ???????????? ??????(?????? ?????? ???)
    function numChange(idx) {
    	var price = document.getElementById("statePrice"+idx).value * document.getElementById("numBox"+idx).value;
    	document.getElementById("imsiPrice"+idx).value = numberWithCommas(price);
    	document.getElementById("price"+idx).value = price;
    	onTotal();
    }
    
    //???????????? ??????
    function cart(){
    	if('${sEmail}' == ""){
    		alert("????????? ??? ?????? ???????????????");
    		location.href = "${ctp}/member/memberLogin";
    	}
    	else if(document.getElementById("totalPrice").value == 0){
    		alert("????????? ???????????????");
    		return false;
    	}
    	else{
    		var ans = confirm("??????????????? ????????? ??????????????????????");
    		if(!ans){
    			return false;
    		}
    		else{
    			/* document.myform.action = "${ctp}/shop/shopContent"; */
    			$("#myform").submit();
    		}
    	}
    }
    
    //?????? ??????
    function order(email){
    	if('${sEmail}' == ""){
    		alert("????????? ??? ?????? ???????????????");
    		/* location.href = "${ctp}/member/memberLogin"; */
    		return false;
    	}
    	else if(document.getElementById("totalPrice").value == 0 || document.getElementById("totalPrice").value == ""){
    		alert("????????? ??????????????????");
    		location.reload(); 
    	}
    	else{
    		document.getElementById("immeOrder").value = "immeOrderOk";
    		$("#myform").submit();
    	}
    }
    
    //?????? ?????? ?????????
    function review(){
    	var content = document.getElementById("content").value;
    	var email = "${sEmail}";
    	var productIdx = "${productVo.idx}";
    	var fName = reviewForm.fName.value;
    	var ext = fName.substring(fName.lastIndexOf(".")+1);	// ?????? ????????? ??????
    	var uExt = ext.toUpperCase();
    	var maxSize = 1024 * 1024 * 10;							//?????? ?????? : 10mb
    	var rating = reviewForm.rating.value;					//??????
    	//alert(productIdx + "/" + rating + "/" + email + "/" + content);
    	if(email == null || email == ""){
    		alert("????????? ??? ?????? ???????????????");
    		return false;
    	}
    	else if(content == ""){
    		alert("?????? ????????? ???????????????");
    		reviewForm.content.focus();
    		return false;
    	}
    	else{
    		if(reviewForm.fName.value!=""){
		    	var fileSize = document.getElementById("fName").files[0].size;
	    		
	    		if(uExt != "JPG" && uExt != "GIF" && uExt != "PNG") {
		    		alert("????????? ????????? ????????? 'JPG/GIF/PNG");
		    		return false;
		    	}
		    	else if(fName.indexOf(" ") != -1) {
		    		alert("???????????? ??????????????? ????????? ????????? ??? ????????????.");
		    		return false;
		    	}
		    	else if(fileSize > maxSize) {
		    		alert("???????????? ????????? ????????? 10MByte ???????????????.");
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
    				alert("?????? ?????? ?????? ????????? ????????????");
    				return false;
    			}
    			else{
	    			reviewForm.rating.value = rating;
	    			reviewForm.submit();
    			}
    		}
    	});
    }
    
    //?????? ?????????
     function like(idx){
    	var email = "${sEmail}";
    	if(email == null || email == ""){
    		alert("????????? ??? ?????? ???????????????");
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
    
   //?????? ??????
	function reviewDelCheck(idx){
		var ans = confirm("?????? ????????? ?????????????????????????");
    	if(!ans) return false;
		
		$.ajax({
			type : "post",
			url : "${ctp}/shop/reviewDelete",
			data : {idx : idx},
			success : function(){
				location.reload();
			},
			error : function(){
				alert("?????? ??????");
			}
		});
	}
    
    
</script>

</head>
<body style="background-color : #171721;">


<div class="container pt-5 pb-5 pr-0 pl-0" style="font-family:'pretendard'; width:1110px; background-color:white; border-bottom:solid 1px #171721;">
	<div class="row">
		<!-- ?????? ?????? ????????? -->
		<div class="col-sm-6 text-center">
			<div id="thumbnail" align="center">
				<img src="${ctp}/dbShop/${productVo.FSName}" width="90%;">
			</div>
		</div>
		<!-- ?????? ?????? ?????? -->
		<div class="col-sm-6 ml-0 pl-0">
			<p style="font-size:2rem; margin-bottom:0px;">${productVo.productName}</p>
			<p style="font-size:1rem;">${productVo.detail}</p>
			<c:if test="${productVo.saleRate == '1'}">
				<div class="text-right pr-5" style="float:right;">
					<label style="font-size:1.5rem"><font color="#f77f00"><b><fmt:formatNumber value="${productVo.mainPrice}" pattern="#,###"/>???</b></font></label>
				</div>
			</c:if>
			<c:if test="${productVo.saleRate != '1'}">
				<label style="font-size:2rem;"><font color="#EA5455"><b><fmt:formatNumber value="${productVo.saleRate}" type="percent"/></b></font></label>
				<div class="text-right pr-5" style="float:right;">
					<label style="font-size:1rem"><font color="grey" style="text-decoration:line-through;"><b><fmt:formatNumber value="${productVo.mainPrice}" pattern="#,###"/>???</b></font></label>&nbsp;
					<label style="font-size:1.5rem"><font color="#f77f00"><b><fmt:formatNumber value="${productVo.salePrice}" pattern="#,###"/>???</b></font></label>
				</div>
			</c:if>
			<!-- ?????? ????????? -->
			<div>
				<form name="optionForm">
					<select size="1" class="form-control" id="selectOption" style="width:90%;">
						<option value="" disabled selected>????????????</option>
						<c:if test="${productVo.saleRate != '1'}">
							<option value="0:????????????_${productVo.salePrice}">????????????</option>
						</c:if>
						<c:if test="${productVo.saleRate == '1'}">
							<option value="0:????????????_${productVo.mainPrice}">????????????</option>
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
				<b>??? ?????? ??????</b>
				<p class="text-right pr-5"><input type="text" class="totalPrice text-right" id="totalPrice" value="<fmt:formatNumber value='0'/>" readonly />???</p>
			</div>
			<hr class="mr-5"/>
				<div>
					<input type="button" class="btn btn-dark btn-block" onclick="order('${sEmail}')" style="width:90%;" value="????????????">
				</div>
				
					<table class="table table-borderless" style="width:90%;">
						<tr>
							<td class="col-6 pl-0"><input type="button" class="btn btn-outline-dark btn-block" onclick="cart()" value="????????????"></td>
							<c:if test="${not empty goodsVo.email}">
								<td class="col-6 pr-0"><input type="button" class="btn btn-dark btn-block" onclick="like(${productVo.idx})" value="???????????? ${goodsCnt}"></td>
							</c:if>
							<c:if test="${empty goodsVo.email}">
								<td class="col-6 pr-0"><input type="button" class="btn btn-outline-dark btn-block" onclick="like(${productVo.idx})" value="???????????? ${goodsCnt}"></td>
							</c:if>
						</tr>
					</table>
				</form>
			</div>
		</div>
	</div>
	<br/>
	<!-- ????????? -->
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
  	<!-- ?????? ???????????? -->
  	<div id="content1" class="container">
  		<div class="next">
  			<p class="text-center">${productVo.content}</p>
  		</div>
  	</div>
  	<br/>
  	<!-- ????????? -->
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
				<td class="pb-2"><font size=4 color=#2A9D8F><b>?????? ${totRecCnt}???</b></font><br/></td>
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
						<img src="${ctp}/review/${vo.photo}" width="100px" height="100px" class="reviewImg" style="cursor:pointer;" onclick="window.open('${ctp}/review/${vo.photo}','???????????????','width=500px, height=500px, resizable=yes, location=no, toolbar=no')"/>
					</td>
				</c:if>
			</tr>
			</c:forEach>
		</table><br/>
		<!-- ?????? ??????????????? ??????(BS4 ???????????????) -->
		<%-- <div class="container mt-0 mb-0" style="background-color:white; margin-top:0px;"><br/>
			<ul class="pagination justify-content-center">
				<c:if test="${totPage == 0}"><p style="text-align:center"><b>????????? ????????????.</b></p></c:if>
				<c:if test="${totPage != 0}">
				  <c:if test="${pag != 1}">
				    <li class="page-item"><a href="${ctp}/shop/shopContent?pag=1&pageSize=${pageSize}&idx=${vo.idx}" title="????????????" class="page-link text-secondary">??????</a></li>
				  </c:if>
				  <c:if test="${curBlock > 0}">
				    <li class="page-item"><a href="${ctp}/shop/shopContent?pag=${(curBlock-1)*blockSize + 1}&pageSize=${pageSize}&idx=${vo.idx}" title="????????????" class="page-link text-secondary">???</a></li>
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
				    <li class="page-item"><a href="${ctp}/shop/shopContent?pag=${(curBlock+1)*blockSize + 1}&pageSize=${pageSize}&idx=${vo.idx}" title="????????????" class="page-link text-secondary">???</a>
				  </c:if>
				  <c:if test="${pag != totPage}">
				    <li class="page-item"><a href="${ctp}/shop/shopContent?pag=${totPage}&pageSize=${pageSize}&idx=${vo.idx}" title="??????????????????" class="page-link" style="color:#555">??????</a>
				  </c:if>
				</c:if>
			</ul> --%>
			<!-- ?????? ??????????????? ??? -->
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
			<p class="text-right"><button class="btn btn-outline-dark" type="button" onclick="review()">????????????</button></p>
			<input type="hidden" name="email" value="${sEmail}"/>
		    <input type="hidden" name="productIdx" value="${productVo.idx}"/>
		    <input type="hidden" name="productName" value="${productVo.productName}"/>
		    <input type="hidden" name="nickName" value="${sNickName}"/>
		</div>
		</form>
	</div><br/>
	
	<!-- ????????? -->
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
  	
  	<!-- ?????????????????? -->
  	<div class="container" style="width:80%;">
  		<!-- <div class="text-center mt-3" style="font-size:20px;">?????? ?????? ??????</div> -->
  		<div class="que">
  			<span>??????????????? ?????? ????????? ?????? ?????????.</span>
  		</div>
  		<div class="anw">
  			<span> - ???????????? ???????????? : 1544-1234<br/>
					- ?????? ?????? : ?????? ?????? 9??? 30??? ~ ?????? 6??? (???????????? : ?????? 11??? 30??? ~ ?????? 1??? 30??? / ??????, ????????? ??????)<br/>
					- ?????? ????????? ????????? ?????? ????????? ??????????????? ????????? ??????????????? ?????? ??? ????????? ????????????????????????.<br/>
					??? ???????????? ?????? ?????? ?????? ?????? ??? ????????? ????????? ??? ????????????.</span>
  		</div>
  		<div class="que">
  			<span>????????? ?????? ??????????</span>
  		</div>
  		<div class="anw">
  			<span>
  				- ????????? ?????? ?????? 1??? ?????? ?????? ?????? ????????? :  ?????? ???????????????. (?????? ?????? ??????)<br/>
				- ???????????? ?????? ?????? ???????????? ???????????????.<br/>
				(????????? ?????? ??????/????????? ????????? ????????? ????????? ??????, ????????? 1~3??? ????????? ???????????????. <br/>
				????????? ?????? ?????? ????????? (????????? ??????) 3???~7??? ?????? ????????????, ?????? ????????? ????????? ?????? ????????? ??? ????????????.)<br/>
				??? ?????? ????????? ?????? ????????? ?????? ??????????????? ?????? ????????? ????????? ??? ?????? ??? ?????? ??????????????????.
  			</span>
  		</div>
  		<div class="que">
  			<span>????????? ????????? ??????????????? ???????????? ?????????.</span>
  		</div>
  		<div class="anw">
  			<span>
  				- ??????????????? ?????? ?????? ??? ?????????????????? 1~2?????? ????????? ????????? ????????????,<br/>
				?????? ??? 7??? ????????? ?????? ????????? ?????? ?????? ????????? ???????????? ?????? ???????????????.
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
//?????????????????? ??????????????????
$(".que").click(function() {
	$(this).next(".anw").stop().slideToggle(300);
	$(this).toggleClass('on').siblings().removeClass('on');
	$(this).next(".anw").siblings(".anw").slideUp(300); // 1?????? ?????????
});
</script>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>