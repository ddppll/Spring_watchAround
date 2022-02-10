package com.spring.cjs2108_ksh.vo;

import lombok.Data;

@Data
public class PdReviewVO {
	private int idx;
	private String reviewDate;
	private int productIdx;
	private String productName;
	private String email;
	private String nickName;
	private String content;
	private String photo;
	private int rating;
	
	//리뷰 작성한 상품 정보에 필요한 부분
	private String productCode;
	private String detail;
	private String mainPrice;
	private String salePrice;
	private String saleRate;
	private String fSName;
}
