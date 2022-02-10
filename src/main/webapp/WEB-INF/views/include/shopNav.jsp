<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<style>
	.shopTitle{
		font-family : 'pretendard';
		color : white;
		position : absolute;
		font-size : 2rem;
		top : 43%;
		left : 15%;
		
	}
	.shopTitle2{
		font-family : 'pretendard';
		color : white;
		position : absolute;
		font-size : 2rem;
		top : 40%;
		left : 15%;
		
	}
	#liliadiv{
		width:124px;
	}
</style>
<body style="background-color : #171721;">
<div class="container" style="margin-top:70px;">
	<div id="demo" class="carousel slide" data-ride="carousel">
	
		<!-- Indicators -->
		<ul class="carousel-indicators">
		  <li data-target="#demo" data-slide-to="0" class="active"></li>
		  <li data-target="#demo" data-slide-to="1"></li>
		</ul>
		
		<!-- The slideshow -->
		<div class="carousel-inner">
		  <div class="carousel-item active">
		  	<div class="shopTitle">스파이더맨: 뉴 유니버스<br/>
		  		<p style="font-size:1rem;">감각적인 OST를 LP로 소장하세요</p>
		  	</div>
		  	<a href="${ctp}/shop/shopContent?idx=4">
		    	<img style="height:400px; width:100%;" src="${ctp}/image/shopList_carousel1.jpg" alt="SpiderMan">
		    </a>
		  </div>
		  <div class="carousel-item">
		  	<div class="shopTitle2">해리포터<br/>신상품 출시!<br/>
		  		<p style="font-size:1rem;">개봉 20주년 기념 한정판 굿즈</p>
		  	</div>
		  	<a href="${ctp}/shop/shopContent?idx=27">
		    	<img style="height:400px; width:100%;" src="${ctp}/image/shopList_carousel2.jpg" alt="HarryPotter">
		  	</a>
		  </div>
		</div>
		
		<!-- Left and right controls -->
		<a class="carousel-control-prev" href="#demo" data-slide="prev">
		  <span class="carousel-control-prev-icon"></span>
		</a>
		<a class="carousel-control-next" href="#demo" data-slide="next">
		  <span class="carousel-control-next-icon"></span>
		</a>
	</div>
	
	<ul class="nav justify-content-center" style="background-color:#2a9d8f; font-family:'pretendard'">
		<li class="nav-item" id="lili">
			<a class="nav-link" href="${ctp}/shop/productList" style="color:white;">전체</a>
		</li>
		<li class="nav-item" id="lili">
			<a class="nav-link" href="${ctp}/shop/productList?mainCate=BD%26DVD" style="color:white;">BD & DVD</a>
		</li>
		<li class="w3-dropdown-hover" id="lili" style="background-color:#2a9d8f;">
			<a class="nav-link dropdown" href="${ctp}/shop/productList?mainCate=음반" style="height:100%; color:white;">음반 <i class="fas fa-angle-down"></i></a>
			<div class="w3-dropdown-content w3-bar-block" style="background-color:#2a9d8f;">
				<div id="liliadiv">
					<a class="w3-bar-item" id="lilia" style="color:white;" href="${ctp}/shop/productList?mainCate=음반&midCate=CD">CD</a>
					<a class="w3-bar-item" id="lilia" style="color:white;" href="${ctp}/shop/productList?mainCate=음반&midCate=LP">LP</a>
				</div>
			</div>
		</li>
		<li class="w3-dropdown-hover" id="lili" style="background-color:#2a9d8f;">
			<a class="nav-link dropdown" href="${ctp}/shop/productList?mainCate=포스터" style="height:100%; color:white;">포스터 <i class="fas fa-angle-down"></i></a>
			<div class="w3-dropdown-content w3-bar-block" style="background-color:#2a9d8f;">
				<div id="liliadiv">
					<a class="w3-bar-item" id="lilia" style="color:white;" href="${ctp}/shop/productList?mainCate=포스터&midCate=대형">대형</a>
					<a class="w3-bar-item" id="lilia" style="color:white;" href="${ctp}/shop/productList?mainCate=포스터&midCate=미니">미니</a>
				</div>
			</div>
		</li>
		<li class="w3-dropdown-hover" id="lili" style="background-color:#2a9d8f;">
			<a class="nav-link dropdown" href="${ctp}/shop/productList?mainCate=기타" style="height:100%; color:white;">기타 <i class="fas fa-angle-down"></i></a>
			<div class="w3-dropdown-content w3-bar-block" style="background-color:#2a9d8f;">
				<div id="liliadiv">
					<a class="w3-bar-item" id="lilia" style="color:white;" href="${ctp}/shop/productList?mainCate=기타&midCate=뱃지">뱃지</a>
					<a class="w3-bar-item" id="lilia" style="color:white;" href="${ctp}/shop/productList?mainCate=기타&midCate=문구">문구</a>
				</div>
			</div>
		</li>
		<c:if test="${sEmail != null}">
			<li class="nav-item" id="lili">
				<a class="nav-link" href="${ctp}/shop/myGoods" style="color:white; font-family:pretendard;">찜 목록</a>
			</li>
		</c:if>
	</ul>
	
</div>
