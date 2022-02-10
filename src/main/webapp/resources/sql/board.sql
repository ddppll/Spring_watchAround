show tables;
create table board(
	idx int not null auto_increment, 	 /* 게시글 고유번호 */
	category int not null,		 		/* 게시글 카테고리 - 0(공지) 1(정보) 2(잡담) 3(리뷰) */	
	nickName varchar(20) not null,		 /* 게시글 올린이 닉네임 */
	title varchar(100) not null,		 /* 게시글 제목 */
	content text not null,				 /* 글 내용 */
	wDate datetime not null default now(), /* 작성 날짜(기본값 : 현재 날짜/시간)*/
	readNum int default 0,				 /* 조회수 */
	hostIp varchar(50) not null,		 /* 접속 IP 주소 */
	good int default 0,				 /* 좋아요 횟수 */
	email varchar(50) not null,			 /* 회원 이메일(게시글 조회시 사용) */
	notice int default 0,
	primary key(idx)					 /* 기본키 : 글 고유번호 */
);

desc board;
select * from board;

select * from members;

drop table board;

/*-----------------------------------댓글처리---------------------------------*/
create table boardReply(
	idx int not null auto_increment primary key,	/* 댓글의 고유번호 */
	boardIdx int not null,			/* 원본글의 고유번호(외래키 지정) */
	email varchar(50) not null,		/* 올린이의 이메일 */
	nickName varchar(20) not null,	/* 올린이의 닉네임 */
	wDate datetime default now(),	/* 댓글 기록 날짜 */
	hostIp varchar(50) not null,	/* 댓글 쓴 PC의 IP */
	content text not null,			/* 댓글 내용 */
	level int not null default 0,	/* 댓글 레벨 - 부모댓글 레벨은 0 */
	levelOrder int not null default 0, /* 댓글 순서 - 부모댓글의 levelOrder는 0 */
	foreign key(boardIdx) references board(idx) on update cascade on delete restrict 
); 
desc boardReply;
select * from boardReply order by idx desc;

select count(*) from replyBoard where boardIdx = 34;