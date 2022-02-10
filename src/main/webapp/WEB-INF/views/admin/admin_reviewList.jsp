<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>admin_reviewList.jsp</title>
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
		
		
		//선택 리뷰 db 삭제
		function reviewDel(){
			ans = confirm("선택된 모든 리뷰를 삭제하시겠습니까?");
			if(!ans) return false;
			var delItems = "";
			
			for(var i=0; i<admin_reviewListForm.chk.length; i++) {
	    		if(admin_reviewListForm.chk[i].checked == true) delItems += admin_reviewListForm.chk[i].value + "/";
	    	}
	  		$.ajax({
	  			url : "${ctp}/admin/reviewDel",
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
		
	</script>
</head>
<body>
	<div class="container" style="font-family:'pretendard';">
		<form name="admin_reviewListForm" method="post">
			<table class="table table-borderless mb-0" style="background-color:white;">
				<thead>
					<tr>
						<td colspan="3">
							<h3 style="text-align:center; color:#264653;">
								<a href="#" style="color:#264653;text-decoration-line: none; font-family: 'pretendard';">리뷰 목록</a>
							</h3>
						</td>
					</tr>
					<tr>
						<td>
							<input type="button" class="btn btn-sm btn-dark" value="삭제" onclick="reviewDel()">
						</td>
					</tr>
				</thead>
			</table>
			
			<!-- ~~~~~~~~~~상품 목록 출력부~~~~~~~~~~ -->
			
			<table class="table table-borderless table-hover mb-0" style="background-color:white;">
				<tr class="text-center" style="background-color:#94D2BD;">
					<th class="text-center">전체 <input type="checkbox" id="checkAll"/></th>
					<th class="text-center">번호</th>
					<th class="text-center">상품코드</th>
					<th class="text-center">상품</th>
					<th class="text-center">정보</th>
					<th class="text-center">작성자</th>
					<th class="text-center">작성날짜</th>
				</tr>
				<c:forEach var="vo" items="${vos}">
					<tr>
						<td>
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
									${vo.productCode}
								</p>
					    	</div>			
						</td>
						<td class="text-center">
							<a href="${ctp}/shop/shopContent?idx=${vo.productIdx}" style="color:black;">
								<img src="${ctp}/dbShop/${vo.FSName}" class="thumb" width="100px"/>
							</a>
						</td>
						<td>
							<div style="display:table; height:100px; text-align:center; margin:auto;">
								<p style="display: table-cell; vertical-align:middle; align:center;">
									<a href="${ctp}/admin/admin_review?idx=${vo.idx}&productIdx=${vo.productIdx}" style="color:black;">
										<b>${vo.productName }</b><br/>
										<font color=grey>${vo.detail}</font>
									</a>
								</p>
					    	</div>
							
						</td>
						<td>
							<div style="display:table; height:100px; text-align:center; margin:auto;">
								<p style="display: table-cell; vertical-align:middle; align:center;">
									${vo.nickName}
								</p>
					    	</div>
						</td>
						<td>
							<div style="display:table; height:100px; text-align:center; margin:auto;">
								<p style="display: table-cell; vertical-align:middle; align:center;">
									${fn:substring(vo.reviewDate,0,10)}<br/>
									${fn:substring(vo.reviewDate,11,19)}
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
				    <li class="page-item"><a href="${ctp}/admin/admin_reviewList?pag=1&pageSize=${pageSize}" title="첫페이지" class="page-link text-secondary">◁◁</a></li>
				  </c:if>
				  <c:if test="${curBlock > 0}">
				    <li class="page-item"><a href="${ctp}/admin/admin_reviewList?pag=${(curBlock-1)*blockSize + 1}&pageSize=${pageSize}" title="이전블록" class="page-link text-secondary">◀</a></li>
				  </c:if>
				  <c:forEach var="i" begin="${(curBlock*blockSize)+1}" end="${(curBlock*blockSize)+blockSize}">
				    <c:if test="${i == pag && i <= totPage}">
				      <li class="page-item active"><a href='${ctp}/admin/admin_reviewList?pag=${i}&pageSize=${pageSize}' class="page-link text-light bg-secondary border-secondary">${i}</a></li>
				    </c:if>
				    <c:if test="${i != pag && i <= totPage}">
				      <li class="page-item"><a href='${ctp}/admin/admin_reviewList?pag=${i}&pageSize=${pageSize}' class="page-link text-secondary">${i}</a></li>
				    </c:if>
				  </c:forEach>
				  <c:if test="${curBlock < lastBlock}">
				    <li class="page-item"><a href="${ctp}/admin/admin_reviewList?pag=${(curBlock+1)*blockSize + 1}&pageSize=${pageSize}" title="다음블록" class="page-link text-secondary">▶</a>
				  </c:if>
				  <c:if test="${pag != totPage}">
				    <li class="page-item"><a href="${ctp}/admin/admin_reviewList?pag=${totPage}&pageSize=${pageSize}" title="마지막페이지" class="page-link" style="color:#555">▷▷</a>
				  </c:if>
				</c:if>
			</ul><br/>
		</div>
		<!-- 블록 페이징처리 끝 -->
		
	</div>
	<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>