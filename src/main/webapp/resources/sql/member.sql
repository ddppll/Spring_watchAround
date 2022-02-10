show tables;

create table members(
	idx int not null auto_increment,	/* 회원 고유번호 */
	email varchar(50) not null,			/* 이메일(아이디/비번 분실시 필요) */
	pwd varchar(100) not null,			/* 비밀번호(입력시 9자로 제한처리할것) */
	nickName varchar(20) not null,		/* 별명(중복불허) */
	tel varchar(15),					/* 연락처 */
	userDel char(2) default 'NO',		/* 회원 탈퇴 신청 여부(OK:탈퇴신청한회원,NO:현재가입중인회원) */
	level int default 1,				/* 회원 레벨 - 1:정회원, 0:관리자 */
	visitCnt int default 0,				/* 방문횟수 */
	startDate datetime default now(), 	/* 최초 가입일 */
	lastDate datetime default now(), 	/* 마지막 접속일 */
	primary key(idx, email)				/* 기본키 : 고유번호, 이메일 */
);

select * from members;

delete from members where email = 'seohyun412@hanmail.net';

update members set level=0 where email='llclllm@naver.com';