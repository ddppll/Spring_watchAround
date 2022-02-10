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
</style>
<script>
	//천단위마다 콤마를 표시해 주는 함수
	function numberWithCommas(x) {
		return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g,",");
	}

	var idxArray = new Array();

    $(function(){
    	$("#selectOption").change(function(){						
    		var selectOption = $(this).val();							// <option value="${vo.idx}:${vo.optionName}_${vo.optionPrice}">${vo.optionName}</option>
    		var idx = selectOption.substring(0,selectOption.indexOf(":")); 	// 현재 옵션의 고유번호
    		var optionName = selectOption.substring(selectOption.indexOf(":")+1,selectOption.indexOf("_")); // 옵션명
    		var optionPrice = selectOption.substring(selectOption.indexOf("_")+1); 			// 옵션가격
    		var commaPrice = numberWithCommas(optionPrice);									// 콤마붙인 가격
    		
    		if($("#layer"+idx).length == 0 && selectOption != "") {
    		  idxArray[idx] = idx;		// 옵션을 선택한 개수만큼 배열의 크기로 잡는다.
    		  
	    		var str = "";
	    		str += "<input type='number' class='numBox' id='numBox"+idx+"' name='optionNum' onchange='numChange("+idx+")' value='1' min='1'/> &nbsp;";
	    		str += "<div class='layer row' id='layer"+idx+"'><div class='col'>"+optionName+"</div>";
	    		str += "<input type='text' id='imsiPrice"+idx+"' class='price' value='"+commaPrice+"' readonly />";
	    		str += "<input type='hidden' id='price"+idx+"' class='price' value='"+optionPrice+"'/> &nbsp;";
	    		str += "<input type='button' class='btn btn-outline-secondary btn-sm' onclick='remove("+idx+")' value='삭제'/>";
	    		str += "<input type='hidden' name='statePrice' id='statePrice"+idx+"' value='"+optionPrice+"'/>";
	    		str += "<input type='hidden' name='optionIdx' value='"+idx+"'/>";
	    		str += "<input type='hidden' name='optionName' value='"+optionName+"'/>";
	    		str += "<input type='hidden' name='optionPrice' value='"+optionPrice+"'/>";
	    		str += "</div>";
	    		$("#product1").append(str);
	    		onTotal();
    	  }
    	  else {
    		  alert("이미 선택한 옵션입니다.");
    	  }
    	});
    });

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
					<!-- 옵션 있을 때 -->
					<c:if test="${optionVos.size()!= 0}">
					<hr class="mr-5 mt-0"/>
					<select size="1" class="form-control" id="selectOption" style="width:90%;">
						<option value="" disabled selected>옵션선택</option>
						<c:forEach var="vo" items="${optionVos}">
							<option value="${vo.idx}:${vo.optionName}_${vo.optionPrice}">${vo.optionName}</option>
						</c:forEach>
					</select><br/>
					<input type="number" id="numBox${vo.idx}" name="optionNum" onchange="numChange('${vo.idx}')" value='1' min='1' style="width:20%;">
					</c:if>
					<!-- 옵션 없을 때 -->
					<br/><br/>
					<c:if test="${optionVos.size() == 0}">
						<p>${productVo.idx}</p>
						<input type="number" id="numBox${productVo.idx}" name="optionNum" onchange="numChange('${productVo.idx}')" value='1' min='1' style="width:20%;">
						<input type="number" id="test" name="test"  value='1' min='1' style="width:20%;">
					</c:if>
					
				</form>
				<form name="myform" method="post">
					<input type="hidden" name="mid" value="${sMid}"/>
				    <input type="hidden" name="productIdx" value="${productVo.idx}"/>
				    <input type="hidden" name="productName" value="${productVo.productName}"/>
				    <input type="hidden" name="mainPrice" value="${productVo.mainPrice}"/>
				    <input type="hidden" name="thumbImg" value="${productVo.FSName}"/>
				    <input type="hidden" name="totalPrice" id="totalPriceResult"/>
				    <div id="product1"></div>
				</form>
			</div>
			
			<hr class="mr-5"/>
			<div class="productPrice">
				<b>총 상품 금액</b>
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
  	<div id="content" class="container">
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

</div>
<script src="${ctp}/js/bootstrap-number-input.js"></script>
<script>
	$('#numBox"+${vo.idx}+"').bootstrapNumber({
		upClass: 'dark',
		downClass: 'outline-dark'
	});
	$('#numBox'+${productVo.idx}).bootstrapNumber({
		upClass: 'dark',
		downClass: 'outline-dark'
	});
	$('#test').bootstrapNumber({
		upClass: 'dark',
		downClass: 'outline-dark'
	});
	/*$("img").attr("style", "width:100%");*/
</script>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>