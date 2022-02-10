package com.spring.cjs2108_ksh.vo;

import lombok.Data;

@Data
public class BoardReplyVO {
	private int idx;
	private int boardIdx;
	private String email;
	private String nickName;
	private String wDate;
	private String hostIp;
	private String content;
	private int level;
	private int levelOrder;
	
	private int diffTime;
}
