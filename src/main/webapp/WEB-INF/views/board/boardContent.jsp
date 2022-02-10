<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<% pageContext.setAttribute("newLine", "\n"); %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" type="text/css" href="${ctp}/css/boardContent.css">
	<meta charset="UTF-8">
	<title>boardContent.jsp</title>
	<body style="background-color : #171721;">
	<jsp:include page="/WEB-INF/views/include/bs4.jsp"/>
	<jsp:include page="/WEB-INF/views/include/nav.jsp"/>
	<script>
		//좋아요 처리
		function goodCheck(){
			var query={
					idx : ${vo.idx}
			}
			$.ajax({
				type : "post",
				url : "${ctp}/board/boardGood",
				data : query,
				success : function(data){
					if(data == "1"){
						alert("이미 추천했습니다.");	
					}
					else{
						location.reload();
					}
				}
			});
		}
		
		//게시글 삭제
		function delCheck(){
			var ans = confirm("게시글을 삭제하시겠습니까?");
			if(ans) location.href="${ctp}/board/boardDelete?idx=${vo.idx}&pag=${pag}&pageSize=${pageSize}&lately=${lately}";
		}
		
		// 댓글 입력처리
		function replyCheck(){
			var boardIdx = "${vo.idx}";
			var email = "${sEmail}";
			var nickName = "${sNickName}";
			var hostIp = "${pageContext.request.remoteAddr}";
			var content = replyForm.content.value;
			if(content == ""){
				alert("댓글을 입력하세요");
				replyForm.content.focus();
				return false;
			}
			var query = {
				boardIdx : boardIdx,
				email : email,
				nickName : nickName,
				hostIp : hostIp,
				content : content
			}
			$.ajax({
				type : "post",
				url : "${ctp}/board/boardReplyWrite",
				data : query,
				success : function(){
					location.reload();
				}
			});
		}
		
		// 대댓(부모댓글의 댓글)
		function insertReply(idx,level,levelOrder,nickName) {
	    	var insReply = "";
	    	insReply += "<table class='table text-center m-0'>";
	    	insReply += "<tr>";
	    	insReply += "<td>";
	    	insReply += "<div class='form-group'>";
	    	insReply += "<textarea rows='3' class='form-control' name='content' id='content"+idx+"'>@"+nickName+"\n</textarea>";
	    	insReply += "</div>";
	    	insReply += "</td>";
	    	insReply += "<td style='width:10%;'>";
	    	insReply += "<input type='button' class='btn btn-outline-dark btn-sm' value='답글달기' onclick='replyCheck2("+idx+","+level+","+levelOrder+")'/>";
	    	insReply += "</td>";
	    	insReply += "</tr>";
	    	insReply += "</table>";
	    	insReply += "<hr style='margin:0px'/>";
	    	
	    	$("#replyBoxOpenBtn"+idx).hide();
	    	$("#replyBoxCloseBtn"+idx).show();
	    	$("#replyBox"+idx).slideDown(500);
	    	$("#replyBox"+idx).html(insReply);
    	}
		
		//대댓 입력폼 닫기(대댓글에 해당하는 가상 테이블을 보이지 않게 처리)
		function closeReply(idx){
			$("#replyBoxOpenBtn"+idx).show();
	    	$("#replyBoxCloseBtn"+idx).hide();
			$("#replyBox"+idx).slideUp(500);
			$("#rereplyTable"+idx).css('visibility','collapse');
		}
		
		//대댓 저장
		function replyCheck2(idx,level,levelOrder){
			var boardIdx = "${vo.idx}";
			var email = "${sEmail}";
			var nickName = "${sNickName}";
			var hostIp = "${pageContext.request.remoteAddr}";
			var content = "content"+idx;
			var contentVal = $("#"+content).val();
			
			if(content == ""){
				alert("답글을 입력하세요");
				$("#"+content).focus();
				return false;
			}
			var query = {
				boardIdx : boardIdx,
				email : email,
				nickName : nickName,
				hostIp : hostIp,
				content : contentVal,
				level : level,
				levelOrder : levelOrder
			}
			$.ajax({
				type : "post",
				url : "${ctp}/board/boardReplyWrite2",
				data : query,
				success : function(){
					location.reload();
				}
			});
		}
		
		//댓글 삭제
		function replyDelCheck(replyIdx){
			var ans = confirm("선택하신 댓글을 삭제하시겠습니까?");
	    	if(!ans) return false;
			
			$.ajax({
				type : "post",
				url : "${ctp}/board/boardReplyDelete",
				data : {replyIdx : replyIdx},
				success : function(){
					location.reload();
				},
				error : function(){
					alert("전송 오류");
				}
			});
		}
		
		// 댓글 수정처리(ajax처리)
		function replyUpdateCheck(replyIdx){
			var content = $("#content").val();
			query={
				replyIdx : replyIdx,
				content : content
			}
			$.ajax({
				type : "post",
				url : "${ctp}/board/boardReplyEdit",
				data : query,
				success : function(){
					alert("댓글이 수정되었습니다.");
					location.href="${ctp}/board/boardContent?idx=${vo.idx}&pag=${pag}&pageSize=${pageSize}&lately=${lately}";
				}
			});
			
	}
	</script>
</head>
<body>
	<div class="container" id="container">
		<table class="table p-3 m-0">
			<thead>
				<tr>
					<td>
						<input type="button" class="text-left btn btn-sm btn-outline-dark" value="돌아가기" onclick="location.href='${ctp}/board/boardList?pag=${pag}&pageSize=${pageSize}&lately=${lately}';"/>
					</td>
					<td colspan="2" class="text-right">
						<c:if test="${sEmail == vo.email ||sLevel == 0}">
							<input type="button" class="btn-sm btn btn-outline-dark" value="수정" onclick="location.href='${ctp}/board/boardEdit?idx=${vo.idx}&pag=${pag}&pageSize=${pageSize}&lately=${lately}';"/>
							<input type="button" class="btn-sm btn btn-outline-dark" value="삭제" onclick="delCheck()"/>
						</c:if>
					</td>
				</tr>
				<tr>
					<td id="category" class="p-3 col-1 text-center">
						<c:if test="${vo.category == 0}"><font color="#EA5455"><b>공지</b></font></c:if>
						<c:if test="${vo.category == 1}"><font color="#2a9d8f"><b>정보</b></font></c:if>
						<c:if test="${vo.category == 2}"><font color="#f77f00"><b>잡담</b></font></c:if>
						<c:if test="${vo.category == 3}"><font color="#6a4c93"><b>후기</b></font></c:if>
					</td>
					<td class="p-3">${vo.title}</td>
					<td class="text-right p-3"><i class="far fa-eye"></i> ${vo.readNum}</td>
				</tr>
				<tr id="secondRow" class="p-2">
					<td style="height:25px;" class="text-center"><b>${vo.nickName}</b></td>
					<td colspan="2">${fn:substring(vo.WDate,0,19)}</td>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td colspan="3" class="p-3">${fn:replace(vo.content,newLine,'<br/>')}</td>
				</tr>
			</tbody>
			<tfoot>
				<tr>
					<td colspan="3" class="text-center" style="border-top:none;">
						<a href="javascript:goodCheck()"><input type="button" class="btn btn-outline-dark" value="추천 ${vo.good}"></a>
					</td>
				</tr>
				
				<tr><!-- 이전글&다음글 처리 -->
					<td colspan="3">
						<c:if test="${!empty pnVos[1]}">
							<font color="#2a9d8f"><b>다음글</b></font> <a href="${ctp}/board/boardContent?idx=${pnVos[1].idx}&pag=${pag}&pageSize=${pageSize}&lately=${lately}" style="color:black" >${pnVos[1].title}</a><br/>
						</c:if>
						<c:if test="${!empty pnVos[0]}">
							<font color="#2a9d8f"><b>이전글</b></font> <a href="${ctp}/board/boardContent?idx=${pnVos[0].idx}&pag=${pag}&pageSize=${pageSize}&lately=${lately}" style="color:black" >${pnVos[0].title}</a>
						</c:if>
					</td>
				</tr>
			</tfoot>
		</table>
		<!-- 댓글 출력/입력 처리 부분 -->
		<!-- 댓글 출력 -->
		<div id="reply">
				<c:forEach var="rVo" items="${rVos}">
			<table class="table table-hover m-0">
					<tr>
						<c:if test="${rVo.level <= 0}"><!-- 부모댓글은 들여쓰기 ㄴ -->
							<td class="col-2">
								<b>${rVo.nickName}</b>
								<c:if test="${rVo.email == sEmail || sLevel == 0}">
									<a href="${ctp}/board/boardContent?replyIdx=${rVo.idx}&idx=${vo.idx}&pag=${pag}&pageSize=${pageSize}&lately=${lately}"><i style="font-size:0.8rem; color:#2a9d8f;" class="far fa-edit"></i></a>
									<a href="javascript:replyDelCheck(${rVo.idx});"><i style="font-size:0.8rem; color:#e76f51;" class="far fa-window-close"></i></a>
								</c:if>
								<c:if test="${vo.diffTime <= 24}"><font size="1rem">${fn:substring(rVo.WDate,11,19)}</font></c:if> 
	      						<c:if test="${vo.diffTime > 24}"><font size="1rem">${fn:substring(rVo.WDate,0,10)}</font></c:if>
							</td>
						</c:if>
						<c:if test="${rVo.level > 0}"><!-- 하위댓글은 들여쓰기 ㅇ -->
							<td class="col-2">
								<c:forEach var="i" begin="1" end="${rVo.level}">&nbsp;&nbsp; </c:forEach>
								└ <b>${rVo.nickName}</b>
								<c:if test="${rVo.email == sEmail ||sLevel == 0}">
									<a href="${ctp}/board/boardContent?replyIdx=${rVo.idx}&idx=${vo.idx}&pag=${pag}&pageSize=${pageSize}&lately=${lately}"><i style="font-size:0.8rem; color:#2a9d8f;" class="far fa-edit"></i></a>
									<a href="javascript:replyDelCheck(${rVo.idx});"><i style="font-size:0.8rem; color:#e76f51;" class="far fa-window-close"></i></a>
								</c:if>
								<c:if test="${vo.diffTime <= 24}"><font size="1rem">${fn:substring(rVo.WDate,11,19)}</font></c:if> 
	      						<c:if test="${vo.diffTime > 24}"><font size="1rem">${fn:substring(rVo.WDate,0,10)}</font></c:if>
							</td>
						</c:if>
						<td class="text-left col-7">
							${fn:replace(rVo.content,newLine,'<br/>')}
						</td>
						<td class="col-1 text-center">
							<input type="button" class="btn btn-outline-dark btn-sm" value="답글" onclick="insertReply('${rVo.idx}','${rVo.level}','${rVo.levelOrder}','${rVo.nickName}')" id="replyBoxOpenBtn${rVo.idx}" />
		          			<input type="button" class="btn btn-outline-dark btn-sm" value="닫기" onclick="closeReply(${rVo.idx})" id="replyBoxCloseBtn${rVo.idx}" class="replyBoxClose" style="display:none"/>
						</td>
					</tr>
					<tr class="m-0 p-0">
						<td id="rereplyTable" class="m-0 p-0" style="border-top:none;" colspan="5"><div class="m-0" id="replyBox${rVo.idx}"></div></td>
					</tr>
			</table>
				</c:forEach>
		</div>
		<!-- 댓글 입력 -->
		<form name="replyForm">
			<table class="table mb-0">
				<tr id="replyWrite">
					<td style="width:90%">
						<textarea rows="4" name="content" id="content" class="form-control" placeholder="인터넷은 우리가 함께 만들어가는 공간입니다. 댓글 작성 시 타인에 대한 배려와 책임을 담아주세요.">${replyContent}</textarea>
					</td>
					<td style="width:10%">
						<br/>
						<p>
							<c:if test="${empty replyContent}"><input type="button" value="등록" class="btn btn-outline-dark btn-sm" onclick="replyCheck()"/></c:if>
							<c:if test="${!empty replyContent}"><input type="button" value="수정" class="btn btn-outline-dark btn-sm" onclick="replyUpdateCheck(${replyIdx})"/></c:if>
						</p>
					</td>
				</tr>
			</table>
			<input type="hidden" name="boardIdx" value="${vo.idx}"/>
			<input type="hidden" name="email" value="${sEmail}"/>
			<input type="hidden" name="nickName" value="${sNickName}"/>
			<input type="hidden" name="hostIp" value="${pageContext.request.remoteAddr}"/>
			<input type="hidden" name="pag" value="${pag}"/>
			<input type="hidden" name="pageSize" value="${pageSize}"/>
			<input type="hidden" name="lately" value="${lately}"/>
		</form>
	</div>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>