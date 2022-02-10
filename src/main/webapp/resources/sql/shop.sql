show tables;
/*
 대분류 : 음반 / BD&DVD / 포스터 / 기타
 중분류 : CD&LP / BD&DVD / 미니 & 대형 / 뱃지&문구(cgv샵 마블볼펜 예시 ㄱㅊ, 달력도 ㄱㅊ)
 */

/*대분류*/
create table categoryMain (
	categoryMainCode char(1) not null,			/* 대분류코드(영대문자)*/
	categoryMainName varchar(20) not null,		/* 대분류명 - 음반 / BD & DVD / 포스터 / 기타 */
	primary key(categoryMainCode)
);
select * from categoryMain;

/*중분류*/
create table categoryMiddle(
	categoryMainCode char(1) not null,			/* 대분류코드(외래키) */
	categoryMiddleCode char(2) not null,		/* 중분류코드(숫자2개) */
	categoryMiddleName varchar(20) not null,	/* 중분류명 - CD,LP / BD&DVD / 미니, 대형 / 뱃지, 문구 */
	primary key(categoryMiddleCode),
	foreign key(categoryMainCode) references categoryMain(categoryMainCode) on update cascade on delete restrict
);

/* 상품 테이블 */
create table product(
	idx int not null auto_increment,			/* 상품 고유번호 */
	productCode varchar(20) not null,			/* 상품 고유 코드 (대분류+중분류+고유번호) */
	productName varchar(50) not null,			/* 상품명 */
	detail varchar(100) not null,				/* 상품 간단 설명(초기화면 출력) */
	mainPrice int not null,						/* 상품 기본 가격 */
	salePrice int not null default 0,			/* 상품 할인 가격 */
	saleRate varchar(5) not null,						/* 할인율 */
	fName varchar(50) not null,					/* 상품 기본 사진 - 필수 입력 */
	fSName varchar(100) not null,				/* 서버에 저장될 상품 고유 이름 */
	content text not null,						/* 상품 상세 설명 - ckeditor 사용해서 이미지 넣기 */
	primary key(idx, productCode)
);
insert into product values (default, 'a','test', 'test',1000,1000,'0.1','test','test','test');
select * from product;
desc product;
desc pdOption;


create table pdOption(
	idx int not null auto_increment primary key,/* 옵션 고유번호 */
	productIdx int not null,					/* product 테이블 고유번호 */
	optionName varchar(50) not null,			/* 옵션 이름 */
	optionPrice int not null default 0,			/* 옵션 가격 */
	foreign key(productIdx) references product(idx) on update cascade on delete restrict
);
show tables;
substring ('A010',2,2);
select * from product where substring(productCode,2,2) = '01';
select * from categoryMiddle where categoryMiddleCode = 07 or (categoryMainCode = 'D' and categoryMiddleName = '뱃지') or (categoryMainCode = 'D');
/*delete from categoryMiddle where categoryMiddleCode = '08';*/

/*drop table product;*/

select * from product.*, mid.categoryMiddleName from product product, categoryMiddle mid where mid.categoryMiddleName = 'CD'
			and substring(product.productCode,1,3) = mid.categoryMiddleCode order by idx desc;
			

/* 장바구니 */
create table pdCartList(
  idx   int not null auto_increment,			/* 장바구니 고유번호 */
  cartDate datetime default now(),				/* 장바구니에 상품을 담은 날짜 */
  email   varchar(50) not null,					/* 장바구니를 사용한 사용자의 이메일 - 로그인한 회원 아이디=이메일 */
  productIdx  int not null,						/* 장바구니에 구입한 상품의 고유번호 */
  productName varchar(50) not null,				/* 장바구니에 담은 구입한 상품명 */
  mainPrice   int not null,						/* 메인상품의 기본 가격 */
  thumbImg		varchar(100) not null,			/* 서버에 저장된 상품의 메인 이미지 */
  optionIdx	  varchar(50)	 not null,			/* 옵션의 고유번호리스트(여러개가 될수 있기에 문자열 배열로 처리한다.) */
  optionName  varchar(100) not null,			/* 옵션명 리스트(배열처리) */
  optionPrice varchar(100) not null,			/* 옵션가격 리스트(배열처리) */
  optionNum		varchar(50)  not null,			/* 옵션수량 리스트(배열처리) */
  totalPrice  int not null,						/* 구매한 모든 항목(상품과 옵션포함)에 따른 총 가격 */
  primary key(idx, email),
  foreign key(productIdx) references product(idx) on update cascade on delete restrict,
  foreign key(email) references members(email) on update cascade on delete cascade
);


create table pdCartList(
	idx int not null auto_increment,
	cartDate datetime default now(),
	email varchar(50) not null,
	productIdx int not null,
	productName varchar(50) not null,
	mainPrice int not null,
	thumbImg varchar(100) not null,
	optionIdx varchar(50) not null,
	optionName varchar(100) not null,
	optionPrice varchar(100) not null,
	optionNum varchar(50) not null,/* 옵션수량 리스트(배열처리) */
	totalPrice int not null,
	primary key(idx, email),
	foreign key(productIdx) references product(idx) on update cascade on delete restrict
	/*foreign key(email) references members(email) on update cascade on delete cascade */
);
desc pdCartList;
show create table members;

select *, (select saleRate from product where idx = pdCartList.productIdx) as saleRate from pdCartList where email = 'llclllm@naver.com';
select *, (select saleRate from product where idx = pdCartList.productIdx) as saleRate,
(select mainPrice from product where idx = pdCartList.productIdx) as costPrice from pdCartList where idx = 10;

select optionNum, totalPrice from pdCartList where productIdx=10 and email='llclllm@naver.com';

/* 주문 테이블 */
create table pdOrder (
  idx         int not null auto_increment, /* 고유번호 */
  orderIdx    varchar(15) not null,   /* 주문 고유번호(새롭게 만들어 주어야 한다.) */
  email       varchar(50) not null,   /* 주문자 ID */
  productIdx  int not null,           /* 상품 고유번호 */
  orderDate   datetime default now(), /* 실제 주문을 한 날짜 */
  productName varchar(50) not null,   /* 상품명 */
  mainPrice   int not null,			  /* 메인 상품 가격 */
  thumbImg    varchar(60) not null,   /* 썸네일(서버에 저장된 메인상품 이미지) */
  optionName  varchar(100) not null,  /* 옵션명    리스트 -배열로 넘어온다- */
  optionPrice varchar(100) not null,  /* 옵션가격  리스트 -배열로 넘어온다- */
  optionNum   varchar(50)  not null,  /* 옵션수량  리스트 -배열로 넘어온다- */
  totalPrice  int not null,				/* 구매한 상품 항목(상품과 옵션포함)에 따른 총 가격 */
  primary key(idx, orderIdx),
  foreign key(productIdx) references product(idx)  on update cascade on delete cascade
);

desc pdOrder;

/* 배송 테이블 */
create table pdDeliver(
	idx int not null auto_increment,	/* 배송 고유번호 */
	oIdx int not null,					/* 외래키 - 주문테이블 idx */
	orderIdx varchar(15) not null, 		/* 주문 고유번호 */
	orderTotalPrice int not null,		/* 주문 상품 총 가격 */
	email varchar(50) not null,			/* 회원 아이디 - 이메일 */
	name varchar(20) not null,			/* 배송받는사람 이름 */
	address varchar(100) not null,		/* 배송지 주소 */
	tel varchar(15),					/* 받는사람 전화번호 */
	message varchar(100),				/* 배송시 요청사항 */
	payment varchar(20) not null,		/* 결제방법 - 카드, 무통장, 폰결제 */
	payMethod varchar(50) not null,		/* 카드번호, 계좌번호, 연락처 */
	orderStatus varchar(10) not null default '결제완료', /* 결제완료->상품준비->배송중->배송완료->구매완료 */
	primary key(idx),
	foreign key(oIdx) references pdOrder(idx) on update cascade on delete cascade
);

/* 리뷰 테이블 */
create table pdReview(
	idx int not null auto_increment,	/* 리뷰 고유번호 */
	reviewDate datetime default now(),  /* 리뷰 작성 날짜 */
	productIdx int not null,			/* 외래키 - 상품 테이블 idx */
	productName varchar(50) not null,   /* 상품명 */
	email varchar(50) not null,			/* 회원 아이디 - 이메일 */
	nickName varchar(20) not null,			/* 리뷰 작성자 이름 */
	content text not null,				/* 리뷰 본문 */
	photo varchar(100), 				/* 리뷰 사진 */ 
	rating int not null default 0,		/* 별점 */
	primary key(idx),
	foreign key(productIdx) references product(idx) on update cascade on delete cascade
);

drop table pdReview;

select * from pdDeliver where email = 'llclllm@naver.com';

select oder.*,delivery.* 
from pdOrder oder join pdDeliver delivery using(orderIdx) 
where delivery.email='hiheadline@hanmail.net' order by delivery.idx desc limit 0,5;

select oder.*,
delivery.*, 
saleRate from product where idx = pdOrder.productIdx as saleRate, 
mainPrice from product where idx = pdOrder.productIdx as costPrice
from pdOrder oder join pdDeliver delivery using(orderIdx) 
where delivery.email='hiheadline@hanmail.net' order by delivery.idx desc limit 0,5;

select saleRate from product where productIdx = pdOrder.productIdx as saleRate and email = 'llclllm@naver.com';


select oder.*,delivery.* from pdOrder oder join pdDeliver delivery using(orderIdx) where delivery.email=#{email} order by delivery.idx desc limit #{startIndexNo},#{pageSize};

select a.*,b.* from pdOrder a join pdDeliver b using(orderIdx)  where a.email='hiheadline@hanmail.net';

select * from pdOrder where email = 'seohyun412@hanmail.net' and productIdx = 12;