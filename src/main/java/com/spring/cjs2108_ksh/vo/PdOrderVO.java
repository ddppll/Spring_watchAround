package com.spring.cjs2108_ksh.vo;

import lombok.Data;

@Data
public class PdOrderVO {
	
	private int idx;
	private String orderIdx;
	private String email;
	private int productIdx;
	private String orderDate;
	private String productName;
	private int mainPrice;
	private String thumbImg;
	private String optionName;
	private String optionPrice;
	private String optionNum;
	private int totalPrice;
	  
	private int cartIdx;  // 장바구니 고유번호
	private int maxIdx;   
	
	private String saleRate; //할인률
	private int costPrice;	//원가
	
	private int payEnd;
	private int deliver;
	private int deliverEnd;
	
	private String orderStatus;
	
	private int count; //차트에 사용
	private String wDate;
	private int totalPriceSum;
}
