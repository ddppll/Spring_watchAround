<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<% pageContext.setAttribute("newLine", "\n"); %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>myGoods.jsp</title>
<jsp:include page="/WEB-INF/views/include/bs4.jsp"/>
<jsp:include page="/WEB-INF/views/include/nav.jsp"/>
<jsp:include page="/WEB-INF/views/include/shopNav.jsp"/>
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
	
	//선택 찜하기 삭제
	function chkDel(){
		ans = confirm("찜한 상품들을 지우시겠습니까?");
		if(!ans) return false;
		var delItems = "";
		var email = "${sEmail}";
		
		$("input[class=chk]:checked").each(function(){
			delItems += $(this).val() + "/";
		})
		
		//alert(delItems);
  		$.ajax({
  			url : "${ctp}/shop/goodsDel",
  			type : "post",
  			data : {
  				delItems : delItems,
  				email : email	
  			},
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
<body style="background-color : #171721;">

<div class="container pt-5 pb-5 pr-0 pl-0" style="font-family:'pretendard'; width:1110px; background-color:white; border-bottom:solid 1px #171721;">
	<form name="myform">
	<c:set var="cnt" value="0"/>
		<div class="row">
			<div class="col">
				<c:if test="${vos[0] != null}">
					<p class="ml-3 mb-0 mt-3">
						<input type="checkbox" id="checkAll"/>
						<input type="button" class="btn btn-sm btn-outline-dark" value="제거" onclick="chkDel()">
					</p>
				</c:if>
			</div>
			<div class="col">
				<h3 style="text-align:center; font-family: 'pretendard'; color:#264653;" class="mb-0">
					찜한 상품
				</h3>
			</div>
			<div class="col"></div>
		</div><br/><br/>
		<c:if test="${vos[0] == null}">
			<div class="text-center">찜한 상품이 없습니다!</div>
			<div class="text-center"><font size=4 color=#2a9d8f>이런 상품들은 어떨까요?</font></div><br/>
			<br/>
			<div class="text-center">
				현재 회원들에게 인기 많은 상품들
			</div>
			<br/>
			<div class="row text-center">
				<c:forEach var="vo" items="${mostVos}">
				<div class="col-sm">
					<div style="text-align:center;">
						<a href="${ctp}/shop/shopContent?idx=${vo.idx}">
							<img src="${ctp}/dbShop/${vo.FSName}" width="200px" height="200px"/>
							<div class="mt-3">
								<font size="3rem" color="#171721";>
								<b>${vo.productName}</b></font>
							</div>
							<c:if test="${fn:length(vo.detail)>35}">
								<c:set var="detail1" value="${fn:substring(vo.detail, 0, 35)}"/>
								<c:set var="detail2" value="..."/>
								<div><font size="1.5rem" color="#2a9d8f"><b>${detail1}${detail2}</b></font></div>
							</c:if>
							<c:if test="${fn:length(vo.detail)<=35}">
					            <div><font size="1.5rem" color="#2a9d8f"><b>${vo.detail}</b></font></div>
							</c:if>
							<c:if test="${vo.saleRate == '1'}">
					            <div><font size="2rem" color="#f77f00"><b><fmt:formatNumber value="${vo.mainPrice}" pattern="#,###"/>원</b></font></div>
							</c:if>
							<c:if test="${vo.saleRate != '1'}">
					            <div>
					            	<font size="3rem" color="#EA5455"><b><fmt:formatNumber value="${vo.saleRate}" type="percent"/></b></font>
					            	<font size="2rem" color="#f77f00"><b><fmt:formatNumber value="${vo.salePrice}" pattern="#,###"/>원</b></font>
					            	<font size="2rem" color="grey" style="text-decoration:line-through;"><fmt:formatNumber value="${vo.mainPrice}" pattern="#,###"/>원</font>
					            </div>
					            <div></div>
							</c:if>
						</a>
					</div>		
				</div>
				<c:set var="cnt" value="${cnt+1}"/>
				<c:if test="${cnt%3 == 0}">
					</div>
					<div class="row mt-5">
				</c:if>
			</c:forEach>
			
			</div>
		</c:if>
		<div class="row">
			<c:forEach var="vo" items="${vos}">
			<div class="col-md-3">
				<div style="text-align:center;">
					<a href="${ctp}/shop/shopContent?idx=${vo.idx}">
						<img src="${ctp}/dbShop/${vo.FSName}" width="200px" height="200px"/>
						<div class="mt-3">
							<input type="checkbox" id="chk" class="chk" value="${vo.idx}"/>
							<font size="3rem" color="#171721";>
							<b>${vo.productName}</b></font>
						</div>
						<c:if test="${fn:length(vo.detail)>35}">
							<c:set var="detail1" value="${fn:substring(vo.detail, 0, 35)}"/>
							<c:set var="detail2" value="..."/>
							<div><font size="1.5rem" color="#2a9d8f"><b>${detail1}${detail2}</b></font></div>
						</c:if>
						<c:if test="${fn:length(vo.detail)<=35}">
				            <div><font size="1.5rem" color="#2a9d8f"><b>${vo.detail}</b></font></div>
						</c:if>
						<c:if test="${vo.saleRate == '1'}">
				            <div><font size="2rem" color="#f77f00"><b><fmt:formatNumber value="${vo.mainPrice}" pattern="#,###"/>원</b></font></div>
						</c:if>
						<c:if test="${vo.saleRate != '1'}">
				            <div>
				            	<font size="3rem" color="#EA5455"><b><fmt:formatNumber value="${vo.saleRate}" type="percent"/></b></font>
				            	<font size="2rem" color="#f77f00"><b><fmt:formatNumber value="${vo.salePrice}" pattern="#,###"/>원</b></font>
				            	<font size="2rem" color="grey" style="text-decoration:line-through;"><fmt:formatNumber value="${vo.mainPrice}" pattern="#,###"/>원</font>
				            </div>
				            <div></div>
						</c:if>
					</a>
				</div>		
			</div>
			<c:set var="cnt" value="${cnt+1}"/>
			<c:if test="${cnt%4 == 0}">
				</div>
				<div class="row mt-5">
			</c:if>
			</c:forEach>
		</form>	
	</div>
<br/>
<br/>
<br/>
</div>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>