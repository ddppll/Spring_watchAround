package com.spring.cjs2108_ksh.vo;

import lombok.Data;

@Data
public class ProductVO {
	private int idx;
	private String productCode;
	private String productName;
	private String detail;
	private String mainPrice;
	private String salePrice;
	private String saleRate;
	private String fName;
	private String fSName;
	private String content;
	
	private String categoryMainCode;
	private String categoryMainName;
	private String categoryMiddleCode;
	private String categoryMiddleName;
	
	private String oriContent; //수정시 원본 content 저장시켜두는 필드
	private int productIdx; 
}
