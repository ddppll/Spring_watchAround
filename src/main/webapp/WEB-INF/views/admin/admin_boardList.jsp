<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" type="text/css" href="${ctp}/css/boardList.css">
	<meta charset="UTF-8">
	<title>myGoods.jsp</title>
	<body style="background-color : #171721;">
	<jsp:include page="/WEB-INF/views/include/bs4.jsp"/>
	<jsp:include page="/WEB-INF/views/include/nav.jsp"/>
	<jsp:include page="/WEB-INF/views/include/adminNav.jsp"/>
	<script>
		// 리스트 출력 건수
		function pageCheck(){
	  		var pageSize = document.getElementById("pageSize").value;
	  		location.href="${ctp}/admin/admin_boardList?page=${pag}&pageSize="+pageSize;
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
		
		//선택 게시글 삭제
		function chkDel(){
			ans = confirm("선택된 모든 게시물을 삭제하시겠습니까?");
			if(!ans) return false;
			var delItems = "";
			
			for(var i=0; i<admin_boardForm.chk.length; i++) {
	    		if(admin_boardForm.chk[i].checked == true) delItems += admin_boardForm.chk[i].value + "/";
	    	}
	  		$.ajax({
	  			url : "${ctp}/admin/admin_boardDel",
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
		
		//선택 게시글 공지 설정
		function changeCategory(){
			ans = confirm("선택한 게시글의 카테고리를 변경하시겠습니까?");
			if(!ans) return false;
			var changeItems = "";
			
			for(var i=0; i<admin_boardForm.chk.length; i++) {
	    		if(admin_boardForm.chk[i].checked == true) changeItems += admin_boardForm.chk[i].value + "/";
	    	}
			
			var selectCategory = $("#selectCategory").val(); //select 에서 고른 카테고리
			var query = {
					changeItems : changeItems,
					selectCategory : selectCategory
			}
			
			$.ajax({
				url : "${ctp}/admin/admin_changeCategory",
				type : "post",
				data : query,
				success : function(){
					alert("카테고리가 변경되었습니다");
					location.reload();
				},
				error : function(){
					alert("변경 오류");
				}
			});
		} 
		

		//카테고리별 리스트 출력
		function searchCategory(){
			var category = admin_boardForm.searchCategorySelect.value;
			location.href = "${ctp}/admin/admin_boardList?category="+category;
		}
	</script>
</head>
<body>
	<div class="container">
		<form name="admin_boardForm">
			<table class="table table-borderless table-hover mb-0">
				<thead>
					<tr>
						<td colspan="8" style="background-color:white;"><br/>
							<h3 style="text-align:center; font-family: 'pretendard'; color:#264653;">
								<a href="#" style="color:#264653;text-decoration-line: none;">게시판 관리 (${totRecCnt}건)</a>
							</h3>
						</td>
					</tr>
					<tr>
						<td style="background-color:white; width:55px;"">
							<select name="pageSize" id="pageSize" onchange="pageCheck()" class="p-0 m-0" style="height:28px;">
					      		<option value="5" ${pageSize==5 ? 'selected' : ''}>5건</option>
					      		<option value="10" ${pageSize==10 ? 'selected' : ''}>10건</option>
					      		<option value="15" ${pageSize==15 ? 'selected' : ''}>15건</option>
					      		<option value="20" ${pageSize==20 ? 'selected' : ''}>20건</option>
					      	</select>
						</td>
						<td colspan="7" style="background-color:white;">
							<select name="searchCategorySelect" onchange="searchCategory()" class="p-0 m-0" style="height:28px;">
					      		<option value="99" <c:if test="${category==99}">selected</c:if>>전체</option>
					      		<option value="0" <c:if test="${category==0}">selected</c:if>>공지</option>
					      		<option value="1" <c:if test="${category==1}">selected</c:if>>정보</option>
					      		<option value="2" <c:if test="${category==2}">selected</c:if>>잡담</option>
					      		<option value="3" <c:if test="${category==3}">selected</c:if>>후기</option>
					      	</select>
						</td>
					</tr>
					<tr>
						<td colspan="8" style="background-color:#263155;">
							<input type="button" class="btn btn-sm btn-light" value="삭제" onclick="chkDel()">&nbsp;&nbsp;|&nbsp;&nbsp;
							<select name="selectCategory" id="selectCategory" style="height:28px;">
								<option value="0">공지</option>
								<option value="1">정보</option>
								<option value="2">잡담</option>
								<option value="3">후기</option>
							</select>
							<input type="button" class="btn btn-sm btn-outline-light" value="변경" onclick="changeCategory()">
						</td>
					</tr>
					<tr>
						<th class="check text-center">전체 <input type="checkbox" id="checkAll"/></th>
						<th class="no text-center">번호</th>
						<th class="cate text-center col-1">카테고리</th>
						<th class="title col-5">제목</th>
						<th class="date text-center">날짜</th>
						<th class="nickName text-center col-1">글쓴이</th>
						<th class="read_no text-center col-1">조회</th>
						<th class="good text-center col-1">추천</th>
					</tr>
				</thead>
				<c:forEach var="vo" items="${vos}">
				<tbody>
					<c:if test="${vo.category == 0}">
						<tr style="background-color:#f0f0f0;">
					</c:if>
					<c:if test="${vo.category != 0}">
						<tr>
					</c:if>
						<td class="text-center"><input type="checkbox" id="chk" class="chk" value="${vo.idx}"/></td>
						<td class="text-center">${curScrStrarNo}</td>
						<td class="text-center col-1">
							<c:if test="${vo.category == 0}"><font color="#EA5455"><b>공지</b></font></c:if>
							<c:if test="${vo.category == 1}"><font color="#2a9d8f">정보</font></c:if>
							<c:if test="${vo.category == 2}"><font color="#f77f00">잡담</font></c:if>
							<c:if test="${vo.category == 3}"><font color="#6a4c93">후기</font></c:if>
						</td>
						<td class="col-5">
							<a href="${ctp}/board/boardContent?idx=${vo.idx}&pag=${pag}&pageSize=${pageSize}&lately=${lately}" style="color:black;">${vo.title}</a>
							<c:if test="${vo.diffTime <=24}"><img src="${ctp}/image/new_icon_1.png"/></c:if>
						</td>
						<td class="text-center">
							<c:if test="${vo.diffTime <= 24}">${fn:substring(vo.WDate,11,19)}</c:if> 
	     						<c:if test="${vo.diffTime > 24}">${fn:substring(vo.WDate,0,10)}</c:if> 
						</td>
						<td class="text-center col-1">${vo.nickName}</td>
						<td class="text-center col-1">${vo.readNum}</td>
						<td class="text-center col-1">${vo.good}</td>
					</tr>
				</tbody>
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
				    <li class="page-item"><a href="${ctp}/admin/admin_boardList?pag=1&pageSize=${pageSize}&lately=${lately}&category=${category}" title="첫페이지" class="page-link text-secondary">◁◁</a></li>
				  </c:if>
				  <c:if test="${curBlock > 0}">
				    <li class="page-item"><a href="${ctp}/admin/admin_boardList?pag=${(curBlock-1)*blockSize + 1}&pageSize=${pageSize}&lately=${lately}&category=${category}" title="이전블록" class="page-link text-secondary">◀</a></li>
				  </c:if>
				  <c:forEach var="i" begin="${(curBlock*blockSize)+1}" end="${(curBlock*blockSize)+blockSize}">
				    <c:if test="${i == pag && i <= totPage}">
				      <li class="page-item active"><a href='${ctp}/admin/admin_boardList?pag=${i}&pageSize=${pageSize}&lately=${lately}&category=${category}' class="page-link text-light bg-secondary border-secondary">${i}</a></li>
				    </c:if>
				    <c:if test="${i != pag && i <= totPage}">
				      <li class="page-item"><a href='${ctp}/admin/admin_boardList?pag=${i}&pageSize=${pageSize}&lately=${lately}&category=${category}' class="page-link text-secondary">${i}</a></li>
				    </c:if>
				  </c:forEach>
				  <c:if test="${curBlock < lastBlock}">
				    <li class="page-item"><a href="${ctp}/admin/admin_boardList?pag=${(curBlock+1)*blockSize + 1}&pageSize=${pageSize}&lately=${lately}&category=${category}" title="다음블록" class="page-link text-secondary">▶</a>
				  </c:if>
				  <c:if test="${pag != totPage}">
				    <li class="page-item"><a href="${ctp}/admin/admin_boardList?pag=${totPage}&pageSize=${pageSize}&lately=${lately}&category=${category}" title="마지막페이지" class="page-link" style="color:#555">▷▷</a>
				  </c:if>
				</c:if>
			</ul><br/>
			<!-- 블록 페이징처리 끝 -->
			<!-- 검색 처리 시작 -->
		</div>
		
		
	</div>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>