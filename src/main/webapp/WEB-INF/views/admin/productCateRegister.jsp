<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>productCateRegister.jsp</title>
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
	//대분류 등록
	function categoryMainCheck(){
		var categoryMainCode = cateMainInputForm.categoryMainCode.value;
		var categoryMainName = cateMainInputForm.categoryMainName.value;
		if(categoryMainCode == ""){
			alert("대분류 코드를 입력하세요");
			cateMainInputForm.categoryMainCode.focus();
			return false;
		}
		if(categoryMainName == ""){
			alert("대분류명을 입력하세요");
			cateMainInputForm.categoryMainName.focus();
			return false;
		}
		$.ajax({
			type : "post",
			url : "${ctp}/admin/cateMainInput",
			data : {
				categoryMainCode : categoryMainCode,
				categoryMainName : categoryMainName
			},
			success:function(data){
				if(data == "0") alert("이미 등록된 대분류입니다."); location.reload();
				if(data == "1") alert("대분류가 등록되었습니다."); location.reload();
			}
		});
	}
	
	//중분류 등록
	function categoryMidCheck(){
		var categoryMainCode = cateMiddleInputForm.categoryMainCode.value;
		var categoryMiddleCode = cateMiddleInputForm.categoryMiddleCode.value;
		var categoryMiddleName = cateMiddleInputForm.categoryMiddleName.value;
		if(categoryMainCode == ""){
			alert("대분류명을 선택하세요");
			return false;
		}
		if(categoryMiddleCode == ""){
			alert("중분류 코드를 입력하세요");
			cateMiddleInputForm.categoryMiddleCode.focus();
			return false;
		}
		if(categoryMiddleName == ""){
			alert("중분류명을 입력하세요");
			cateMiddleInputForm.categoryMiddleName.focus();
			return false;
		}
		$.ajax({
			type : "post",
			url : "${ctp}/admin/cateMidInput",
			data : {
				categoryMainCode : categoryMainCode,
				categoryMiddleCode : categoryMiddleCode,
				categoryMiddleName : categoryMiddleName
			}, 
			success : function(data){
				if(data == "0"){
					alert("이미 등록된 중분류입니다.");
				}
				else{
					alert("중분류가 등록되었습니다.");
				}
				location.reload();
			}
		});
	}
	
	//대분류 삭제
	function cateMainDel(categoryMainCode) {
	   	var ans = confirm("해당 대분류를 삭제하시겠습니까?");
	   	if(!ans) return false;
	   	$.ajax({
	   		type : "post",
	   		url  : "${ctp}/admin/cateMainDel",
	   		data : {categoryMainCode : categoryMainCode},
	   		success:function(data) {
	   			if(data == 0) {
	   				alert("하위 항목을 먼저 삭제하세요.");
	   			}
	   			else {
	   				alert("해당 대분류 항목이 삭제되었습니다.");
	   				location.reload();
	   			}
	   		}
	   	});
	}
	
	 // 중분류 삭제
	function cateMidDel(categoryMiddleCode) {
		var ans = confirm("해당 중분류를 삭제하시겠습니까?");
		if(!ans) return false;
		$.ajax({
			type : "post",
			url  : "${ctp}/admin/cateMidDel",
			data : {categoryMiddleCode : categoryMiddleCode},
			success:function(data) {
				if(data == 0){
					alert("하위 항목을 먼저 삭제하세요");
				}
				else{
					alert("해당 중분류 항목이 삭제되었습니다");
					location.reload();
				}
			}
		});
	}
</script>

</head>
<body>
	<div class="container" style="width:100%;">
		<table class="table mb-0">
			<thead>
				<tr>
					<td colspan="4">
						<h3 style="text-align:center; font-family: 'pretendard'; color:#264653;" class="mb-0">
							<a href="#" style="color:#264653;text-decoration-line: none;">분류관리</a>
						</h3>
					</td>
				</tr>
			</thead>
			<tbody>
				<tr style="background-color:#f0f0f0;">
					<td class="col-5 text-center" colspan="2" style="border-right:1px solid #DEE2E6;"><h5 class="mb-0">대분류</h5></td>
					<td class="col-5 text-center" colspan="2"><h5 class="mb-0">중분류</h5></td>
				</tr>
				<tr>
					<form name="cateMainInputForm">
						<td class="col-4 text-center">
							<input type="text" name="categoryMainCode" placeholder="대분류코드" style="width:80%;"/><br/>
							<input type="text" name="categoryMainName" placeholder="대분류명" class="mt-1" style="width:80%;"/>
						</td>
						<td class="col-1" style="border-right:1px solid #DEE2E6;">
							<input type="button" class="btn btn-dark btn-sm" value="등록" onclick="categoryMainCheck()" style="border-right:1px solid;"/>
						</td>
					</form>
					<form name="cateMiddleInputForm">
						<td class="col-4 text-center">
							<select name="categoryMainCode" style="height:28px;">
								<option>대분류명</option>
								<c:forEach var="mainVo" items="${mainVos}">
									<option value="${mainVo.categoryMainCode}">${mainVo.categoryMainName}</option>
								</c:forEach>
							</select>
							<input type="text" name="categoryMiddleCode" placeholder="중분류코드" style="width:60%;"/><br/>
							<input type="text" name="categoryMiddleName" placeholder="중분류명" class="mt-1" style="width:82%;"/>
						</td>
						<td class="col-1">
							<input type="button" class="btn btn-dark btn-sm" value="등록" onclick="categoryMidCheck()"/>
						</td>
					</form>
				</tr>
			</tbody>
		</table>
		<div class="row m-0">
			<div class="col p-0" style="background-color:white;">
				<table class="table mt-0 mb-0">
					<tr style="background-color:#f0f0f0;">
						<td style="width:25%; border-right:1px solid #DEE2E6;"class="text-center"><h6 class="mb-0" style="font-family:pretendard;">대분류코드</h6></td>
						<td style="border-right:1px solid #DEE2E6;" class="text-center"><h6 class="mb-0" style="font-family:pretendard;">대분류명</h6></td>
					</tr>
					<c:forEach var="mainVo" items="${mainVos}" varStatus="st">
					<tr style="border-bottom:1px solid #DEE2E6;">
						<td class="text-center" style="width:25%; border-right:1px solid #DEE2E6; background-color:#94D2BD;">${mainVo.categoryMainCode}</td>
						<td class="text-center">${mainVo.categoryMainName} <a href="javascript:cateMainDel('${mainVo.categoryMainCode}');"><i style="font-size:0.8rem; color:#e76f51;" class="far fa-window-close"></i></a></td>
					</tr>
					</c:forEach>
				</table>
			</div>
			<div class="col p-0" style="background-color:white;">
				<table class="table mt-0 mb-0">
					<tr style="background-color:#f0f0f0;">
						<td class="text-center" style="width:20%; border-right:1px solid #DEE2E6;"><h6 class="mb-0" style="font-family:pretendard;">대분류코드</h6></td>
						<td class="text-center" style="width:20%; border-right:1px solid #DEE2E6;"><h6 class="mb-0" style="font-family:pretendard;">중분류코드</h6></td>
						<td class="text-center"><h6 class="mb-0" style="font-family:pretendard;">중분류명</h6></td>
					</tr>
					<c:forEach var="middleVo" items="${middleVos}" varStatus="st">
					<tr>
			    	    <td class="text-center" style="border-right:1px solid #DEE2E6; border-left:1px solid #DEE2E6; background-color:#94D2BD;">${middleVo.categoryMainCode}</td>
						<td class="text-center" style="border-right:1px solid #DEE2E6;">${middleVo.categoryMiddleCode}</td>
			    	    <td class="text-center">${middleVo.categoryMiddleName} <a href="javascript:cateMidDel('${middleVo.categoryMiddleCode}');"><i style="font-size:0.8rem; color:#e76f51;" class="far fa-window-close"></i></a></td>
					</tr>
					</c:forEach>
				</table>	
			</div>
		</div>
	</div>


<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>