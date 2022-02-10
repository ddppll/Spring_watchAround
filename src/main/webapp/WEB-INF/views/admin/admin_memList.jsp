<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" type="text/css" href="${ctp}/css/boardList.css">
	<meta charset="UTF-8">
	<title>admin_memList.jsp</title>
	<body style="background-color : #171721;">
	<jsp:include page="/WEB-INF/views/include/bs4.jsp"/>
	<jsp:include page="/WEB-INF/views/include/nav.jsp"/>
	<jsp:include page="/WEB-INF/views/include/adminNav.jsp"/>
	<script>
		// 리스트 출력 건수
		function pageCheck(){
	  		var pageSize = document.getElementById("pageSize").value;
	  		location.href="${ctp}/admin/admin_memList?page=${pag}&pageSize="+pageSize;
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
		
		//선택 회원 DB 삭제
		function chkDel(){
			ans = confirm("선택된 모든 회원 정보를 DB에서 삭제하시겠습니까?");
			if(!ans) return false;
			var delItems = "";
			
			for(var i=0; i<admin_memForm.chk.length; i++) {
	    		if(admin_memForm.chk[i].checked == true) delItems += admin_memForm.chk[i].value + "/";
	    	}
	  		$.ajax({
	  			url : "${ctp}/admin/admin_memDel",
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
		
		//선택 회원 탈퇴유무 설정
		function changeCategory(){
			ans = confirm("선택한 회원의 활동 상태를 변경하시겠습니까?");
			if(!ans) return false;
			var changeItems = "";
			
			for(var i=0; i<admin_memForm.chk.length; i++) {
	    		if(admin_memForm.chk[i].checked == true) changeItems += admin_memForm.chk[i].value + "/";
	    	}
			
			var selectCategory = $("#selectCategory").val(); //select 에서 고른 카테고리
			var query = {
					changeItems : changeItems,
					selectCategory : selectCategory
			}
			
			$.ajax({
				url : "${ctp}/admin/admin_memChange",
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
		
		//활동상태별 리스트 출력
		function searchCategory(){
			var category = admin_memForm.searchCategorySelect.value;
			location.href = "${ctp}/admin/admin_memList?category="+category;
		}
		
		// 검색버튼 클릭시 수행할 내용.
	    function searchCheck() {
	    	var keyword = admin_memForm.keyword.value;
	    	var search = admin_memForm.search.value;
	    	if(keyword == "") {
	    		location.href = "${ctp}/admin/admin_memList";
	    	}
	    	else{
	    		//alert("keyword : " + keyword + "\n" + "search : " + search)
	    		location.href = "${ctp}/admin/admin_memList?keyword="+keyword+"?search="+search;
	    	}
	    }		
	</script>
</head>
<body>
	<div class="container">
		<form name="admin_memForm">
			<table class="table table-borderless table-hover mb-0">
				<thead>
					<tr>
						<td colspan="8" style="background-color:white;"><br/>
							<h3 style="text-align:center; font-family: 'pretendard'; color:#264653;">
								<a href="#" style="color:#264653;text-decoration-line: none;">회원 목록</a>
							</h3>
						</td>
					</tr>
					<tr>
						<td style="background-color:white; width:55px;">
							<select name="pageSize" id="pageSize" onchange="pageCheck()" class="p-0 m-0" style="height:28px;">
					      		<option value="5" ${pageSize==5 ? 'selected' : ''}>5건</option>
					      		<option value="10" ${pageSize==10 ? 'selected' : ''}>10건</option>
					      		<option value="15" ${pageSize==15 ? 'selected' : ''}>15건</option>
					      		<option value="20" ${pageSize==20 ? 'selected' : ''}>20건</option>
					      	</select>
						</td>
						<td colspan="6" style="background-color:white;">
							<select name="searchCategorySelect" onchange="searchCategory()" class="p-0 m-0" style="height:28px;">
					      		<option value="ALL" <c:if test="${category eq 'ALL'}">selected</c:if>>전체</option>
					      		<option value="NO" <c:if test="${category eq 'NO'}">selected</c:if>>활동중</option>
					      		<option value="OK" <c:if test="${category eq 'OK'}">selected</c:if>>탈퇴신청</option>
					      	</select>
						</td>
					</tr>
					<tr>
						<td colspan="3" style="background-color:#263155;">
							<input type="button" class="btn btn-light" value="회원탈퇴" onclick="chkDel()">&nbsp;&nbsp;|&nbsp;&nbsp;
							<select name="selectCategory" id="selectCategory" style="height:34px;">
								<option value="NO">활동중</option>
								<option value="OK">탈퇴신청</option>
							</select>
							<input type="button" class="btn btn-outline-light" value="변경" onclick="changeCategory()">
						</td>
						<td colspan="4" class="text-right" style="background-color:#263155;">
							<select name="search" style="height:34px;">
						      <option value="email">이메일</option>
						      <option value="nickName">닉네임</option>
						    </select>
							<input class="form-control mr-sm-2" type="text" id="keyword" name="keyword" placeholder="Search" style="display:inline-block;width:150px;">
			    			<button class="btn btn-light" onclick="searchCheck()">검색</button>
						</td>
					</tr>
					<tr>
						<th class="text-center">전체 <input type="checkbox" id="checkAll"/></th>
						<th class="text-center">번호</th>
						<th class="text-center">닉네임</th>
						<th class="text-center col-4">이메일</th>
						<th class="col-2">연락처</th>
						<th class="text-center">마지막접속일</th>
						<th class="text-center col-1">활동상태</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="vo" items="${vos}">
						<tr>
							<td class="text-center"><input type="checkbox" id="chk" class="chk" value="${vo.idx}"/></td>
							<td class="text-center">${curScrStrarNo}</td>
							<td class="text-center">${vo.nickName}</td>
							<td>${vo.email}</td>
							<td>${vo.tel}</td>
							<td class="text-center">${vo.lastDate}</td>
							<td class="text-center">
								<c:if test="${vo.userDel == 'OK'}"><font color="#EA5455"><b>탈퇴신청</b></font></c:if>
								<c:if test="${vo.userDel != 'OK'}">활동중</c:if>
							</td>
						</tr>
						<c:set var="curScrStrarNo" value="${curScrStrarNo - 1}"/>
					</c:forEach>
				</tbody>
			</table>
			
			<input type="hidden" name="pag" value="${pag}"/>
	  		<input type="hidden" name="pageSize" value="${pageSize}"/>
		</form>
		<!-- 블록 페이징처리 시작(BS4 스타일적용) -->
		<div class="container mt-0 mb-0" style="background-color:white; margin-top:0px;"><br/>
			<ul class="pagination justify-content-center mb-0">
				<c:if test="${totPage == 0}"><p style="text-align:center"><b>자료가 없습니다.</b></p></c:if>
				<c:if test="${totPage != 0}">
				  <c:if test="${pag != 1}">
				    <li class="page-item"><a href="${ctp}/admin/admin_memList?pag=1&pageSize=${pageSize}&search=${search}&keyword=${keyword}&category=${category}" title="첫페이지" class="page-link text-secondary">◁◁</a></li>
				  </c:if>
				  <c:if test="${curBlock > 0}">
				    <li class="page-item"><a href="${ctp}/admin/admin_memList?pag=${(curBlock-1)*blockSize + 1}&pageSize=${pageSize}&search=${search}&keyword=${keyword}&category=${category}" title="이전블록" class="page-link text-secondary">◀</a></li>
				  </c:if>
				  <c:forEach var="i" begin="${(curBlock*blockSize)+1}" end="${(curBlock*blockSize)+blockSize}">
				    <c:if test="${i == pag && i <= totPage}">
				      <li class="page-item active"><a href='${ctp}/admin/admin_memList?pag=${i}&pageSize=${pageSize}&search=${search}&keyword=${keyword}&category=${category}' class="page-link text-light bg-secondary border-secondary">${i}</a></li>
				    </c:if>
				    <c:if test="${i != pag && i <= totPage}">
				      <li class="page-item"><a href='${ctp}/admin/admin_memList?pag=${i}&pageSize=${pageSize}&search=${search}&keyword=${keyword}&category=${category}' class="page-link text-secondary">${i}</a></li>
				    </c:if>
				  </c:forEach>
				  <c:if test="${curBlock < lastBlock}">
				    <li class="page-item"><a href="${ctp}/admin/admin_memList?pag=${(curBlock+1)*blockSize + 1}&pageSize=${pageSize}&search=${search}&keyword=${keyword}&category=${category}" title="다음블록" class="page-link text-secondary">▶</a>
				  </c:if>
				  <c:if test="${pag != totPage}">
				    <li class="page-item"><a href="${ctp}/admin/admin_memList?pag=${totPage}&pageSize=${pageSize}&search=${search}&keyword=${keyword}&category=${category}" title="마지막페이지" class="page-link" style="color:#555">▷▷</a>
				  </c:if>
				</c:if>
			</ul><br/>
			<!-- 블록 페이징처리 끝 -->
	</div>
</div>
	<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>