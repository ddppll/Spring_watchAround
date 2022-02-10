package com.spring.cjs2108_ksh.vo;

import lombok.Data;

@Data
public class PdDeliverVO {
	private int idx;
	private int oIdx;
	private String orderIdx;
	private int orderTotalPrice;
	private String email;
	private String deliverName;
	private String name;
	private String address;
	private String tel;
	private String message;
	private String payment;
	private String payMethod;
	private String orderStatus;
	
	//주문테이블에서 쓴 필드
	private int productIdx;
	private String orderDate;
	private String productName;
	private int mainPrice;
	private String thumbImg;
	private String optionName;
	private String optionPrice;
	private String optionNum;
	private int totalPrice;
	
	private int payEnd;
	private int deliver;
	private int deliverEnd;
}
