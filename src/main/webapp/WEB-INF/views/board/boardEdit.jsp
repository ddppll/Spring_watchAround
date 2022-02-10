<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" type="text/css" href="${ctp}/css/boardWrite.css">
	<meta charset="UTF-8">
	<title>boardEdit.jsp</title>
	<body style="background-color : #171721;">
	<jsp:include page="/WEB-INF/views/include/bs4.jsp"/>
	<jsp:include page="/WEB-INF/views/include/nav.jsp"/>
	<script src="${ctp}/ckeditor/ckeditor.js"></script>
	<script>
		function fCheck(){
			var title = document.getElementById("title").value;
			var content = document.getElementById("CKEDITOR").value;
			
			if(title.trim() == ""){
				alert("제목을 입력하세요");
				writeForm.title.focus();
			}
			else{
				writeForm.oriContent.value = document.getElementById("oriContent").innerHTML;
				writeForm.submit();
			}
			
		}
	</script>
</head>
<body>
	<div class="container">
		<form name="writeForm" method="post">
			<table class="table table-borderless" style="margin-bottom:1px;">
				<tr>
					<td>
						<c:set var="category" value="${vo.category}"/>
						<select id="category" name="category">
							<c:if test="${category == 0}">
								<option value="0" selected>공지</option>
							</c:if>
							<c:if test="${category == 1}">
								<option value="1" selected>정보</option>
							</c:if>
							<c:if test="${category == 2}">
								<option value="2" selected>잡담</option>
							</c:if>
							<c:if test="${category == 3}">
								<option value="3" selected>후기</option>
							</c:if>
							<c:if test="${sLevel == 0}">
								${category == 0 ? '' : '<option value="0">공지</option>' }
							</c:if>
							${category == 1 ? '' : '<option value="1">정보</option>' }
							${category == 2 ? '' : '<option value="2">잡담</option>' }
							${category == 3 ? '' : '<option value="3">후기</option>' }
						</select>
					</td>
				</tr>
				<tr>
					<td>
						<input type="text" id="title" name="title" value="${vo.title}"/>
						<hr/>
					</td>
				</tr>
				<tr>
					<td><textarea rows="6" name="content" id="CKEDITOR" class="form-control" required >${vo.content}</textarea></td>
					<script>
						CKEDITOR.replace("content",{
							uploadUrl:"${ctp}/imageUpload",		/* 여러개의 그림파일을 드래그&드롭으로 처리 */
							filebrowserUploadUrl : "${ctp}/imageUpload", /* 파일(이미지)업로드시 처리 */
							height:500
						});
					</script>
				</tr>
				<tr>
					<td style="text-align:center;">
						<input type="button" value="수정" onclick="fCheck()" class="btn btn-outline-dark">&nbsp;
						<input type="button" value="취소" onclick="location.href='${ctp}/board/boardContent?idx=${vo.idx}&pag=${pag}&pageSize=${pageSize}&lately=${lately}';" class="btn btn-outline-dark">
					</td>
				</tr>
			</table>
			<input type="hidden" name="hostIp" value="${pageContext.request.remoteAddr}"/>
			<input type="hidden" name="idx" value="${vo.idx}"/>
			<input type="hidden" name="pag" value="${pag}"/>
			<input type="hidden" name="pageSize" value="${pageSize}"/>
			<input type="hidden" name="lately" value="${lately}"/>
			<input type="hidden" name="oriContent"/>
			<div id="oriContent" style="display:none;">${vo.content}</div>
		</form>
	</div>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>