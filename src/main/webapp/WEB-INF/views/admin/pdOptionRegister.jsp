<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>pdOptionRegister.jsp</title>
<jsp:include page="/WEB-INF/views/include/bs4.jsp"/>
<jsp:include page="/WEB-INF/views/include/nav.jsp"/>
<jsp:include page="/WEB-INF/views/include/adminNav.jsp"/>

<style>
	body{
		font-family : 'pretendard';
		background-color:#171721;
	}
	h5{
		font-family : 'pretendard';
	}
	table{
		background-color:white;
		font-family : 'pretendard';
	}
</style>
<script>
	//대분류 선택시 중분류 가져와서 뿌리기
	function categoryMainChange(){
		var categoryMainCode = pdOptionRegisterForm.categoryMainCode.value;
		$.ajax({
			type : "post",
			url : "${ctp}/admin/categoryMiddleName",
			data : {categoryMainCode : categoryMainCode},
			success:function(data){
				var str = "";
				str += "<option value=''>중분류</option>";
				for(var i=0; i<data.length; i++){
					str += "<option value='"+data[i].categoryMiddleCode+"'>"+data[i].categoryMiddleName+"</option>";
				}
				$("#categoryMiddleCode").html(str);
			}
		});
	}
	
	//중분류 선택시 상품명 가져와서 뿌리기
	function categoryMiddleChange(){
		var categoryMiddleCode = pdOptionRegisterForm.categoryMiddleCode.value;
		$.ajax({
			type : "post",
			url : "${ctp}/admin/getPdName",
			data : {categoryMiddleCode : categoryMiddleCode},
			success : function(data){
				var str = "";
				str += "<option value=''>상품선택</option>";
				for(var i=0; i<data.length; i++){
					str += "<option value='"+data[i].idx+"/"+data[i].productName+"'>"+data[i].productName+"</option>";
				}
				$("#productName").html(str);
			}
		});
	}
	
	function fCheck(){
		var optionName = pdOptionRegisterForm.optionName.value;
		var optionPrice = pdOptionRegisterForm.optionPrice.value;
		var productName = pdOptionRegisterForm.productName.value;
		var regExpPrice = /^[0-9|_]*$/; //옵션 가격 정규식 - 숫자만 
		
		if(optionName == ""){
			alert("상품 옵션명을 입력하세요");
			return false;
		}
		else if(optionPrice == ""|| !regExpPrice.test(optionPrice)){
			alert("상품 옵션가격을 확인하세요");
			return false;
		}
		else if(productName == ""){
			alert("상품명을 선택하세요");
			return false;
		}
		else{
			/* alert("optionPrice" + optionPrice);
			alert("optionName" + optionName);
			alert("productName : " + productName); */
			pdOptionRegisterForm.submit();
		}
	}
</script>

</head>
<body>
	<div class="container">
		<form name="pdOptionRegisterForm" method="post">
			<table class="table table-borderless mb-0">
				<thead>
					<tr>
						<td colspan="3">
							<h3 style="text-align:center; color:#264653;">
								<a href="#" style="color:#264653;text-decoration-line: none; font-family: 'pretendard';">옵션 등록</a>
							</h3>
						</td>
					</tr>
				</thead>
				<tbody>
					<tr style="border-bottom:1px solid #DEE2E6;">
					</tr>
					<tr>
						<td class="col-4">
							<b>대분류</b> 
							<select name="categoryMainCode" onchange="categoryMainChange()" class="form-control">
								<option value="">대분류명</option>
								<c:forEach var="mainVo" items="${mainVos}">
									<option value="${mainVo.categoryMainCode}">${mainVo.categoryMainName}</option>
								</c:forEach>
							</select>
						</td>
						<td class="col-4">
							<b>중분류</b>
							<select id="categoryMiddleCode" name="categoryMiddleCode" onchange="categoryMiddleChange()" class="form-control">
								<option value="">중분류</option>
								<c:forEach var="middleVo" items="${middleVos}">
									<option value=""></option>
								</c:forEach>
							</select>
						</td>
						<td class="col-4">
							<b>상품명</b>
							<select name="productName" id="productName" class="form-control">
								<option value="">상품선택</option>
								<c:forEach var="productVo" items="${productVos}">
									<option value=""></option>
								</c:forEach>
							</select>
						</td>
					</tr>
				</tbody>
			</table>
			<table class="table table-borderless mt-0 mb-0">
				<tr>
					<td>
						<b>옵션명</b>
						<input type="text" name="optionName" id="optionName" class="form-control" placeholder="옵션명을 입력하세요" required/>
					</td>
					<td>
						<b>옵션가격</b>
						<input type="text" name="optionPrice" id="optionPrice" class="form-control" placeholder="옵션가격을 입력하세요" required/>
					</td>
				</tr>
				<tr>
					<td colspan="2" class="text-center">
						<input type="button" value="등록" onclick="fCheck()" class="btn btn-dark"/>
					</td>
				</tr>
			</table>
		</form>
	</div>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>