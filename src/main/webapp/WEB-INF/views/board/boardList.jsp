<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" type="text/css" href="${ctp}/css/boardList.css">
	<meta charset="UTF-8">
	<title>boardList.jsp</title>
	<body style="background-color : #171721;">
	<jsp:include page="/WEB-INF/views/include/bs4.jsp"/>
	<jsp:include page="/WEB-INF/views/include/nav.jsp"/>
	<script>
	// 리스트 출력 건수
	function pageCheck(){
  		var pageSize = document.getElementById("pageSize").value;
  		location.href="${ctp}/board/boardList?page=${pag}&pageSize="+pageSize;
  	}
	
	//카테고리별 리스트 출력
	function searchCategory(){
		var category = categoryForm.searchCategorySelect.value;
		location.href = "${ctp}/board/boardList?category="+category;
	}
	
	function searchCheck(){
		var search_target = searchForm.search_target.value;	//조회 카테고리
    	var searchString = searchForm.searchString.value;	//검색어
    	if(searchString == "") {
    		location.href = "${ctp}/board/boardList";
    	}
    	else{
    		//alert("keyword : " + keyword + "\n" + "search : " + search)
    		location.href = "${ctp}/board/boardList?searchString="+searchString+"&search_target="+search_target;
    	}
	}
	
	</script>
</head>
<body>
	<div class="container" style="margin-top:70px;">
		<table class="table table-borderless table-hover mb-0">
			<thead>
				<tr>
					<td style="background-color:#263155; width:55px;" class="m-0">
						<select name="pageSize" id="pageSize" onchange="pageCheck()" class="p-0 m-0" style="height:28px;">
				      		<option value="5" ${pageSize==5 ? 'selected' : ''}>5건</option>
				      		<option value="10" ${pageSize==10 ? 'selected' : ''}>10건</option>
				      		<option value="15" ${pageSize==15 ? 'selected' : ''}>15건</option>
				      		<option value="20" ${pageSize==20 ? 'selected' : ''}>20건</option>
				      	</select>
				    </td>
				    <td colspan="7" style="background-color:#263155;">
				      	<form name="categoryForm">
							<select name="searchCategorySelect" onchange="searchCategory()" class="p-0 m-0" style="height:28px;">
					      		<option value="99" <c:if test="${category==99}">selected</c:if>>전체</option>
					      		<option value="0" <c:if test="${category==0}">selected</c:if>>공지</option>
					      		<option value="1" <c:if test="${category==1}">selected</c:if>>정보</option>
					      		<option value="2" <c:if test="${category==2}">selected</c:if>>잡담</option>
					      		<option value="3" <c:if test="${category==3}">selected</c:if>>후기</option>
					      	</select>
					    </form>
					</td>
				</tr>
				<tr>
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
						<td class="text-center">${curScrStrarNo}</td>
						<td class="text-center col-1">
							<c:if test="${vo.category == 0}"><font color="#EA5455"><b>공지</b></font></c:if>
							<c:if test="${vo.category == 1}"><font color="#2a9d8f">정보</font></c:if>
							<c:if test="${vo.category == 2}"><font color="#f77f00">잡담</font></c:if>
							<c:if test="${vo.category == 3}"><font color="#6a4c93">후기</font></c:if>
						</td>
						<td class="col-5">
						<c:if test="${vo.category != 0}">
							<a href="${ctp}/board/boardContent?idx=${vo.idx}&pag=${pag}&pageSize=${pageSize}" style="color:black;">${vo.title}</a>
						</c:if>
						<c:if test="${vo.category == 0}">
							<b><a href="${ctp}/board/boardContent?idx=${vo.idx}&pag=${pag}&pageSize=${pageSize}" style="color:#14213d;">${vo.title}</a></b>
						</c:if>
							<c:if test="${vo.diffTime <=24}"><img src="${ctp}/image/new_icon_1.png"/></c:if>
							<c:if test="${vo.replyCount != 0}">&nbsp;[${vo.replyCount}]</c:if>
							
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
		
		<!-- 블록 페이징처리 시작(BS4 스타일적용) -->
		<div class="container mt-0 mb-0" style="background-color:white; margin-top:0px;"><br/>
			<ul class="pagination justify-content-center">
				<c:if test="${totPage == 0}"><p style="text-align:center"><b>자료가 없습니다.</b></p></c:if>
				<c:if test="${totPage != 0}">
				  <c:if test="${pag != 1}">
				    <li class="page-item"><a href="${ctp}/board/boardList?pag=1&pageSize=${pageSize}&category=${category}&search_target=${search_target}&searchString=${searchString}" title="첫페이지" class="page-link text-secondary">◁◁</a></li>
				  </c:if>
				  <c:if test="${curBlock > 0}">
				    <li class="page-item"><a href="${ctp}/board/boardList?pag=${(curBlock-1)*blockSize + 1}&pageSize=${pageSize}&category=${category}&search_target=${search_target}&searchString=${searchString}" title="이전블록" class="page-link text-secondary">◀</a></li>
				  </c:if>
				  <c:forEach var="i" begin="${(curBlock*blockSize)+1}" end="${(curBlock*blockSize)+blockSize}">
				    <c:if test="${i == pag && i <= totPage}">
				      <li class="page-item active"><a href='${ctp}/board/boardList?pag=${i}&pageSize=${pageSize}&category=${category}&search_target=${search_target}&searchString=${searchString}' class="page-link text-light bg-secondary border-secondary">${i}</a></li>
				    </c:if>
				    <c:if test="${i != pag && i <= totPage}">
				      <li class="page-item"><a href='${ctp}/board/boardList?pag=${i}&pageSize=${pageSize}&category=${category}&search_target=${search_target}&searchString=${searchString}' class="page-link text-secondary">${i}</a></li>
				    </c:if>
				  </c:forEach>
				  <c:if test="${curBlock < lastBlock}">
				    <li class="page-item"><a href="${ctp}/board/boardList?pag=${(curBlock+1)*blockSize + 1}&pageSize=${pageSize}&category=${category}&search_target=${search_target}&searchString=${searchString}" title="다음블록" class="page-link text-secondary">▶</a>
				  </c:if>
				  <c:if test="${pag != totPage}">
				    <li class="page-item"><a href="${ctp}/board/boardList?pag=${totPage}&pageSize=${pageSize}&category=${category}&search_target=${search_target}&searchString=${searchString}" title="마지막페이지" class="page-link" style="color:#555">▷▷</a>
				  </c:if>
				</c:if>
			</ul>
		<!-- 블록 페이징처리 끝 -->
		<!-- 검색 처리 시작 -->
			<div class="row">
				<div class="col-3 text-left">
					<input type="button" class="btn btn-outline-dark" onclick="location.href='${ctp}/board/boardWrite';" value="글쓰기">
				</div>
				<div class="col text-center">
					<form name="searchForm">
						<select id="search_target" name="search_target" onchange="searchChange()">
							<option value="title">제목</option>
							<option value="nickName">작성자</option>
							<option value="content">내용</option>
						</select>
						<input type="text"  id="searchString" name="searchString"/>
						<input type="button" class="btn btn-outline-dark" value="검색" onclick="searchCheck()"/>
						<input type="hidden" name="pag" value="${pag}"/>
						<input type="hidden" name="pageSize" value="${pageSize}"/>
					</form>
				</div>
				<div class="col-3 text-right">
				</div>
			</div><br/>
		</div>
		<!-- 검색 처리 끝 -->
	</div>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>