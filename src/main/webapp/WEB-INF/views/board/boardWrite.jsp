<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" type="text/css" href="${ctp}/css/boardWrite.css">
	<meta charset="UTF-8">
	<title>boardWrite.jsp</title>
	<body style="background-color : #171721;">
	<jsp:include page="/WEB-INF/views/include/bs4.jsp"/>
	<jsp:include page="/WEB-INF/views/include/nav.jsp"/>
	<script src="${ctp}/ckeditor/ckeditor.js"></script>
	<script>
		function fCheck(){
			var title = document.getElementById("title").value;
			
			if(title.trim() == ""){
				alert("제목을 입력하세요");
				writeForm.title.focus();
			}
			else{
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
						<select id="category" name="category">
							<c:if test="${sLevel == 0}">
								<option value="0">공지</option>
							</c:if>
							<option value="1">정보</option>
							<option value="2">잡담</option>
							<option value="3">후기</option>
						</select>
					</td>
				</tr>
				<tr>
					<td>
						<input type="text" id="title" name="title" placeholder="제목을 입력하세요"/>
						<hr/>
					</td>
				</tr>
				<tr>
					<td><textarea rows="6" name="content" id="CKEDITOR" class="form-control" required ></textarea></td>
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
						<input type="button" value="등록" onclick="fCheck()" class="btn btn-outline-dark">&nbsp;
						<input type="button" value="취소" onclick="location.href='${ctp}/board/boardList';" class="btn btn-outline-dark">
					</td>
				</tr>
			</table>
			<input type="hidden" name="hostIp" value="${pageContext.request.remoteAddr}"/>
			<input type="hidden" name="email" value="${sEmail}"/>
			<input type="hidden" name="nickName" value="${sNickName}"/>
		</form>
	</div>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>