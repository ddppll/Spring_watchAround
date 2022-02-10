package com.spring.cjs2108_ksh.vo;

import lombok.Data;

@Data
public class MembersVO {
	private int idx;
	private String email;
	private String pwd;
	private String nickName;
	private String tel;
	private String userDel;
	private int level;
	private int visitCnt;
	private String startDate;
	private String lastDate;
}
