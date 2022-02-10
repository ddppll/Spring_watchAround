package com.spring.cjs2108_ksh.vo;

import lombok.Data;

@Data
public class BoardVO {
	private int idx;
	private int category;
	private String nickName;
	private String title;
	private String content;
	private String wDate;
	private int readNum;
	private String hostIp;
	private int good;
	private String email;
	
	private int diffTime;
	
	private String oriContent; //수정시 원본 content 저장시켜두는 필드
	
	private int replyCount;
}
