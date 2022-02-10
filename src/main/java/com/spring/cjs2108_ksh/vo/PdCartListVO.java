package com.spring.cjs2108_ksh.vo;

import lombok.Data;

@Data
public class PdCartListVO {
	private int idx;
	private String cartDate;
	private String email;
	private int productIdx;
	private String productName;
	private int mainPrice;
	private String thumbImg;
	private String optionIdx;
	private String optionName;
	private String optionPrice;
	private String optionNum;
	private int totalPrice;
	
	private String saleRate;
	private int costPrice;
}
