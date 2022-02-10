<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="EUC-KR">
	<title>enter.jsp</title>
	<%@ include file ="/WEB-INF/views/include/bs4.jsp" %>
</head>
<style>
	body{
		font-family: 'pretendard';
	}
	span{
		color:white;
	}	
	.inner{
		background-color:rgba(0,0,0,0.4);
		position : absolute;
		width: 100vw;
        height:100vh;
	  }
	.title{
            z-index: 1;
            font-size:200%;
            color:white;
            position:absolute;
            z-index: 999;
            top: 50%;
            left:40%;
            transform: (-50%,-50%);
        }
    video{
    	position : fixed;
    	min-width:100%;
    	min-height:100%;
		width:100%;
		height : auto;
		object-fit : cover;
		overflow:hidden;
		z-index:-1;
	}  
</style>
<body>
	<div class="wrap">
		<video src="${ctp}/video/enter.mp4" muted autoplay loop></video> 
			<div class="inner" style="z-index:15;"><br/>
				<span style="margin-left:15px; margin-top:1%;">Logo</span>
				<span class="title">더 넓은 컨텐츠의 바다를 향해<br/>
				<a href="${ctp}/main" class="btn btn-light" style="margin-left:40%">시작하기</a>
				</span>
				<br/>
				
			</div>
	</div>
</body>
</html>