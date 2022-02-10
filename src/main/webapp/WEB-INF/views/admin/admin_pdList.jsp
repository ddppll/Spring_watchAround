<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>admin_pdList.jsp</title>
	<style>
		#categoryMainCode, #categoryMiddleCode{
			border: 1px solid gray;
		    border-radius: 6px;
		    padding: 4px 6px;
		}
	</style>
	<body style="background-color : #171721;">
	<jsp:include page="/WEB-INF/views/include/bs4.jsp"/>
	<jsp:include page="/WEB-INF/views/include/nav.jsp"/>
	<jsp:include page="/WEB-INF/views/include/adminNav.jsp"/>
	
	<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.24.0/moment.min.js"></script>
	<script>
		//대분류 선택시 중분류 가져와서 뿌리기
		function categoryMainChange(){
			var categoryMainCode = admin_pdListForm.categoryMainCode.value;
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
		
		//카테고리별로 보기
		function pdListSearch(){
			var categoryMainCode = $("#categoryMainCode").val();
			var categoryMiddleCode = $("#categoryMiddleCode").val();
			alert(categoryMainCode);
			if(categoryMainCode==""){
				alert("분류항목을 선택하세요.");
				$("#categoryMainCode").focus();
				return false;
			}
			else if(categoryMainCode!="" && categoryMiddleCode==""){
				var ans = confirm("대분류로만 보시겠습니까?");
				if(ans){
					location.href="${ctp}/admin/admin_pdList?categoryMainCode="+categoryMainCode+"&pageSize=${pageSize}";
				}
			}
			else if(categoryMainCode!="" && categoryMiddleCode!=""){
				var ans = confirm("해당 중분류로 검색하시겠습니까?");
				if(ans){
					location.href="${ctp}/admin/admin_pdList?categoryMainCode="+categoryMainCode+"&categoryMiddleCode="+categoryMiddleCode+"&pageSize=${pageSize}";
				}
			}
		}
		
		//선택 상품 db 삭제
		function productDel(){
			ans = confirm("선택된 모든 상품 정보를 DB에서 삭제하시겠습니까?");
			if(!ans) return false;
			var delItems = "";
			
			for(var i=0; i<admin_pdListForm.chk.length; i++) {
	    		if(admin_pdListForm.chk[i].checked == true) delItems += admin_pdListForm.chk[i].value + "/";
	    	}
	  		$.ajax({
	  			url : "${ctp}/admin/admin_pdDel",
	  			type : "post",
	  			data : {delItems : delItems},
	  			success : function(){
	  				location.reload();
	  			},
	  			error : function(){
	  				alert("삭제 오류");
	  			}
	  		});
	    }
		
		//상품 상세보기페이지
		function adminPdDetail(idx){
			location.href="${ctp}/admin/adminPdDetail?idx="+idx;
		}
	</script>
</head>
<body>
	<div class="container" style="font-family:'pretendard';">
		<form name="admin_pdListForm" method="post">
			<table class="table table-borderless mb-0" style="background-color:white;">
				<thead>
					<tr>
						<td colspan="3">
							<h3 style="text-align:center; color:#264653;">
								<a href="#" style="color:#264653;text-decoration-line: none; font-family: 'pretendard';">상품 목록</a>
							</h3>
						</td>
					</tr>
				</thead>
				<tbody>
					<tr style="border-bottom:1px solid #DEE2E6;">
					</tr>
					<tr>
						<td class="col-3 pr-0">
							<select id="categoryMainCode" name="categoryMainCode" onchange="categoryMainChange()" style="width:150px;">
								<option value="">대분류명</option>
								<c:forEach var="mainVo" items="${mainVos}">
									<option value="${mainVo.categoryMainCode}">${mainVo.categoryMainName}</option>
								</c:forEach>
							</select>
							<select id="categoryMiddleCode" name="categoryMiddleCode" style="width:150px;">
								<option value="">중분류</option>
								<c:forEach var="middleVo" items="${middleVos}">
									<option value=""></option><!-- value에 categoryMiddleCode가 들어감 -->
								</c:forEach>
							</select>
							<input type="button" class="btn btn-sm btn-dark" value="보기" onclick="pdListSearch()">
						</td>
						<td class="col-4 text-right">
							<input type="button" class="btn btn-sm btn-dark" value="삭제" onclick="productDel()">
						</td>
					</tr>
				</tbody>
			</table>
			
			<!-- ~~~~~~~~~~상품 목록 출력부~~~~~~~~~~ -->
			
			<table class="table table-borderless table-hover mb-0" style="background-color:white;">
				<tr class="text-center" style="background-color:#94D2BD;">
					<th class="text-center">전체 <input type="checkbox" id="checkAll"/></th>
					<th class="text-center">번호</th>
					<th class="text-center">상품코드</th>
					<th class="text-center">상품</th>
					<th class="text-center">정보</th>
					<th class="text-center">원가</th>
					<th class="text-center">할인가</th>
				</tr>
				
				<c:forEach var="vo" items="${vos}">
				<tr style="border-bottom:1px solid #DEE2E6;">
					<td class="text-center">
						<div style="display:table; height:100px; text-align:center; margin:auto;">
							<p style="display: table-cell; vertical-align:middle; align:center;">
								<input type="checkbox" id="chk" class="chk" value="${vo.idx}"/>
							</p>
				    	</div>
					</td>
					<td>
						<div style="display:table; height:100px; text-align:center; margin:auto;">
							<p style="display: table-cell; vertical-align:middle; align:center;">
								${curScrStrarNo}
							</p>
				    	</div>
					</td>
					<td>
						<div style="display:table; height:100px; text-align:center; margin:auto;">
							<p style="display: table-cell; vertical-align:middle; align:center;">
								<a href="javascript:adminPdDetail('${vo.idx}');" style="color:black;">
									${vo.productCode}
								</a>
							</p>
				    	</div>
					</td>
					<td>
						<a href="${ctp}/shop/shopContent?idx=${vo.idx}" style="color:black;">
							<img src="${ctp}/dbShop/${vo.FSName}" class="thumb" width="100px"/>
						</a>
					</td>
					<td>
						<br/>
						<a href="javascript:adminPdDetail('${vo.idx}');" style="color:black;"><b>${vo.productName}</b></a><br/>
						${vo.detail}
					</td>
					<td>
						<div style="display:table; height:100px; text-align:center; margin:auto;">
							<p style="display: table-cell; vertical-align:middle; align:center; color:#f77f00;">
								<b><fmt:formatNumber value="${vo.mainPrice}"/>원</b>
							</p>
				    	</div>
					</td>
					<td>
						<div style="display:table; height:100px; text-align:center; margin:auto;">
							<p style="display: table-cell; vertical-align:middle; align:center;">
								<c:if test="${vo.saleRate == '1'}">
									할인 없음
								</c:if>
								<c:if test="${vo.saleRate != '1'}">
									<b><font color="#EA5455"><fmt:formatNumber value="${vo.salePrice}"/>원</font></b>
								</c:if>
							</p>
				    	</div>
					</td>
				</tr>
				<c:set var="curScrStrarNo" value="${curScrStrarNo - 1}"/>
				</c:forEach>
			</table>
		</form>
		
		<!-- 블록 페이징처리 시작(BS4 스타일적용) -->
		<div class="container mt-0 mb-0" style="background-color:white; margin-top:0px;"><br/>
			<ul class="pagination justify-content-center mb-0">
				<c:if test="${totPage == 0}"><p style="text-align:center"><b>자료가 없습니다.</b></p></c:if>
				<c:if test="${totPage != 0}">
				  <c:if test="${pag != 1}">
				    <li class="page-item"><a href="${ctp}/admin/admin_pdList?pag=1&pageSize=${pageSize}&categoryMainCode=${categoryMainCode}&categoryMiddleCode=${categoryMiddleCode}" title="첫페이지" class="page-link text-secondary">◁◁</a></li>
				  </c:if>
				  <c:if test="${curBlock > 0}">
				    <li class="page-item"><a href="${ctp}/admin/admin_pdList?pag=${(curBlock-1)*blockSize + 1}&pageSize=${pageSize}&categoryMainCode=${categoryMainCode}&categoryMiddleCode=${categoryMiddleCode}" title="이전블록" class="page-link text-secondary">◀</a></li>
				  </c:if>
				  <c:forEach var="i" begin="${(curBlock*blockSize)+1}" end="${(curBlock*blockSize)+blockSize}">
				    <c:if test="${i == pag && i <= totPage}">
				      <li class="page-item active"><a href='${ctp}/admin/admin_pdList?pag=${i}&pageSize=${pageSize}&categoryMainCode=${categoryMainCode}&categoryMiddleCode=${categoryMiddleCode}' class="page-link text-light bg-secondary border-secondary">${i}</a></li>
				    </c:if>
				    <c:if test="${i != pag && i <= totPage}">
				      <li class="page-item"><a href='${ctp}/admin/admin_pdList?pag=${i}&pageSize=${pageSize}&categoryMainCode=${categoryMainCode}&categoryMiddleCode=${categoryMiddleCode}' class="page-link text-secondary">${i}</a></li>
				    </c:if>
				  </c:forEach>
				  <c:if test="${curBlock < lastBlock}">
				    <li class="page-item"><a href="${ctp}/admin/admin_pdList?pag=${(curBlock+1)*blockSize + 1}&pageSize=${pageSize}&categoryMainCode=${categoryMainCode}&categoryMiddleCode=${categoryMiddleCode}" title="다음블록" class="page-link text-secondary">▶</a>
				  </c:if>
				  <c:if test="${pag != totPage}">
				    <li class="page-item"><a href="${ctp}/admin/admin_pdList?pag=${totPage}&pageSize=${pageSize}&categoryMainCode=${categoryMainCode}&categoryMiddleCode=${categoryMiddleCode}" title="마지막페이지" class="page-link" style="color:#555">▷▷</a>
				  </c:if>
				</c:if>
			</ul><br/>
		</div>
		<!-- 블록 페이징처리 끝 -->
		
	</div>
	<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>