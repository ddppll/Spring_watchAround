# [Spring 프로젝트] watchAround.

<details>
<summary>Contents</summary>

  
1. 개요
2. DB 설계
3. 구현 기능
  + 사용자 페이지
    + 가입 / 로그인 
    + 메인
      + 크롤링
      + Top 3
    + 상품
      + 상품 목록
      + 상품 상세보기
      + 장바구니
      + 바로 구매
      + 결제
      + 주문 확인
      + 구매 내역
      + 찜하기
    + 게시판
</details>

## 1. 개요
+ 프로젝트명 : watchAround.
+ 일정 : 2022. 01. 01 ~ 2022. 02. 07
+ 개발 목적 : OTT 사이트 통합 검색 및 영화&드라마 관련 상품을 구매할 수 있는 사이트 제작
+ 개발 환경
  + 서버 : Apache tomcat 9.0.54
  + 데이터베이스 : MySQL 5.1.49
  + Framework : Spring Tool Suite 4
  + JAVA 1.8 / HTML5 / CSS / JavaScript / SQL / jQuery 3.6.0 / Bootstrap 4.5.2 / Selenium
  + 크롬 드라이버 97.0.4692.71

## 2. DB 설계

![erd_cut](https://user-images.githubusercontent.com/93955871/155093683-769fd2f1-d426-48f3-b5fe-02a4d3d71dee.png)

## 3. 주요 기능
+ 회원 가입 / 회원 정보 수정 / 회원 탈퇴 / 로그인 & 로그아웃 / 아이디 저장
+ 상품 목록 / 상품 찜하기 / 장바구니 담기 / 바로 구매 / 구매 내역 확인
+ 회원 관리 / 상품 관리(상품 등록/수정/삭제, 상품 옵션 등록, 상품 분류 등록) / 구매 관리(구매내역 조회, 상품 상태 변경 처리)
+ 크롤링을 통한 작품 검색

