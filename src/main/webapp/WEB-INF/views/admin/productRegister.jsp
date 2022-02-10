<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<% pageContext.setAttribute("newLine", "\n"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>productRegister.jsp</title>
<jsp:include page="/WEB-INF/views/include/bs4.jsp"/>
<jsp:include page="/WEB-INF/views/include/nav.jsp"/>
<jsp:include page="/WEB-INF/views/include/adminNav.jsp"/>
<script src="${ctp}/ckeditor/ckeditor.js"></script>

<style>
	body{
		font-family : 'pretendard';
		background-color:#171721;
	}
	
	table{
		background-color : white;
		font-family : 'pretendard';
	}
</style>

<script>
	//대분류 선택시 중분류 가져와서 뿌리기
	function categoryMainChange(){
		var categoryMainCode = productRegiForm.categoryMainCode.value;
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

	//할인가격 계산
	function saleCheck(val){
		var mainPrice = parseInt(productRegiForm.mainPrice.value); //입력한 가격
		var dcRate = val; //할인률
		var salePrice = "";
		
		if(dcRate == "1"){
			document.getElementById("salePrice").value = mainPrice;
		}
		else{
			if(mainPrice == "" || isNaN(mainPrice)){
				alert("입력한 기본 가격을 확인하세요(숫자)");
				$("#disNo").prop("checked", true);
				productRegiForm.mainPrice.focus();
				return false;
			}
			var dcRateFloat = parseFloat(dcRate);
			salePrice = mainPrice - (mainPrice * dcRateFloat);
			document.getElementById("salePrice").value = parseInt(salePrice);
			document.getElementById("salePrice").readOnly = true;
		}
	}
	
	//상품 DB 등록
	function fCheck(){
		var categoryMainCode = productRegiForm.categoryMainCode.value;		// 대분류코드
		var categoryMiddleCode = productRegiForm.categoryMiddleCode.value;	// 중분류코드
		var productName = productRegiForm.productName.value;				// 상품명
		var mainPrice = productRegiForm.mainPrice.value;					// 기본 가격
		var saleRate = $("input:radio[name='sale']:checked").val();				// 할인율
		var salePrice = productRegiForm.salePrice.value;					// 할인 가격	
		var detail = productRegiForm.detail.value;							// 기본 설명
		var file = productRegiForm.file.value;	
		var ext = file.substring(file.lastIndexOf(".")+1);					// 메인이미지 업로드 파일 확장자
		var uExt = ext.toUpperCase();										// 확장자 대문자로 바꾼거
		var regExpPrice = /^[0-9|_]*$/; 									// 가격 정규식(숫자만 입력받음)
		/* alert("saleRate : " + saleRate); */
		if (categoryMiddleCode == ""){
			alert("상품 중분류를 선택하세요");
			return false;
		}
		else if(productName == ""){
			alert("상품명을 입력하세요");
			return false;
		}
		else if(mainPrice == "" || !regExpPrice.test(mainPrice)){
			alert("입력한 기본 가격을 다시 확인하세요");
			return false;
		}
		else if(file == ""){
			alert("상품 메인 이미지를 등록하세요");
			return false;
		}
		else if(uExt != "JPG" && uExt != "GIF" && uExt != "PNG" && uExt != "JPEG"){
			alert("업로드 가능한 파일이 아닙니다");
			return false;
		}
		else if(detail == ""){
			alert("상품 기본 설명을 입력하세요");
			return false;
		}
		else if(document.getElementById("file").value != "") {
			var maxSize = 1024 * 1024 * 10;  // 10MByte까지 허용
			var fileSize = document.getElementById("file").files[0].size;
			if(fileSize > maxSize) {
				alert("첨부파일의 크기는 10MB 이내로 등록하세요");
				return false;
			}
			else {
				/* alert("saleRate : " + saleRate); */
				productRegiForm.saleRate.value = saleRate;
				productRegiForm.submit();
			}
		}
	}
</script>

</head>
<body>
	<div class="container">
		<form name="productRegiForm" method="post" enctype="multipart/form-data">
			<table class="table table-borderless">
				<thead>
					<tr>
						<td colspan="2">
							<h3 style="text-align:center; color:#264653;">
								<a href="#" style="color:#264653;text-decoration-line: none; font-family: 'pretendard';">상품 등록</a>
							</h3>
						</td>
					</tr>
				</thead>
				<tbody>
					<tr style="border-bottom:1px solid #DEE2E6;">
					</tr>
					<tr>
						<td style="width:50%;">
							<b>대분류</b> 
							<select name="categoryMainCode" onchange="categoryMainChange()" class="form-control">
								<option value="">대분류명</option>
								<c:forEach var="mainVo" items="${mainVos}">
									<option value="${mainVo.categoryMainCode}">${mainVo.categoryMainName}</option>
								</c:forEach>
							</select>
						</td>
						<td>
							<b>중분류</b>
							<select id="categoryMiddleCode" name="categoryMiddleCode" class="form-control">
								<option value="">중분류</option>
								<c:forEach var="middleVo" items="${middleVos}">
									<option value=""></option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<td>
							<b>상품명</b>
							<input type="text" name="productName" id="productName" class="form-control" placeholder="상품명을 입력하세요" required/>
						</td>
						<td>
							<b>메인 이미지</b><font size="2rem" color="#EA5455"> <b>(업로드 가능 파일 : jpg, jpeg, gif, png)</b></font>
							<input type="file" name="file" id="file" class="form-control-file border" accept=".jpg, .gif, .png, .jpeg" required/>
						</td>
					</tr>
					<tr>
						<td>
							<b>기본 가격</b>
							<input type="text" name="mainPrice" class="form-control" required/>
						</td>
						<td>
							<div class="form-check-inline">
							<b>할인 가격</b> &nbsp;
							<!-- 	<label class="form-check-label"> -->
									<input type="radio" class="form-check-input" name="sale" id="disNo" value="1" onclick="saleCheck(this.value)" checked/>없음&nbsp;
									<input type="radio" class="form-check-input" name="sale" value="0.05" onclick="saleCheck(this.value)"/>5%&nbsp;
									<input type="radio" class="form-check-input" name="sale" value="0.1" onclick="saleCheck(this.value)"/>10%&nbsp;
									<input type="radio" class="form-check-input" name="sale" value="0.15" onclick="saleCheck(this.value)"/>15%&nbsp;
									<input type="radio" class="form-check-input" name="sale" value="0.20" onclick="saleCheck(this.value)"/>20%
								<!-- </label> -->
							</div>
							<input type="text" id="salePrice" name="salePrice" class="form-control" readonly/>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<b>기본 설명</b>
							<textarea rows="5" name="detail" class="form-control" required></textarea>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<b>상품 상세 설명</b>
							<textarea rows="5" name="content" id="CKEDITOR" class="form-control" required></textarea>
							<script>
								CKEDITOR.replace("content",{
									uploadUrl: "${ctp}/admin/imageUpload",
									filebrowserUploadUrl : "${ctp}/admin/imageUpload",
									height : 400
								});
							</script>
						</td>
					</tr>
					<tr>
						<td colspan="2" class="text-center">
							<input type="button" value="등록" onclick="fCheck()" class="btn btn-dark"/>
						</td>
					</tr>
				</tbody>
			</table>
			<input type="hidden" name="saleRate"/>
		</form>
	</div>


<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>