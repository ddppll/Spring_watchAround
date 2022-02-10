package com.spring.cjs2108_ksh.service;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.spring.cjs2108_ksh.vo.GoodsVO;
import com.spring.cjs2108_ksh.vo.PdCartListVO;
import com.spring.cjs2108_ksh.vo.PdDeliverVO;
import com.spring.cjs2108_ksh.vo.PdOrderVO;
import com.spring.cjs2108_ksh.vo.PdReviewVO;
import com.spring.cjs2108_ksh.vo.ProductVO;

public interface ShopService {

	public List<ProductVO> getProductList(int startIndexNo, int pageSize);
	//public List<ProductVO> getProductList(String categoryMainCode, String categoryMiddleCode, int startIndexNo, int pageSize);

	public ProductVO getProductContent(int idx);

	public PdCartListVO cartListPdOptionSearch(String productName, String optionName, String email);

	public void cartListUpdate(PdCartListVO vo);

	public void cartListInput(PdCartListVO vo);

	public List<PdCartListVO> getPdCartList(String email);

	public void cartAllDel(String email);

	public void cartDel(int idx);

	public PdCartListVO getCartIdx(String idx);

	public PdOrderVO getOrderMaxIdx();

	public void cartPdNumChange(int idx, int num, String totalPrice, String email);

	public void setPdOrder(PdOrderVO vo);

	public void delCartList(int cartIdx);

	public int getOrderOIdx(String orderIdx);

	public void setDbDeliver(PdDeliverVO deliverVo);

	public List<PdDeliverVO> getDelivery(String email);

	public int getMainPrice(int productIdx);

	public PdDeliverVO getDeliveryImme(String email);

	public int totRecCnt(String email);

	public List<PdDeliverVO> getMyOrder(int startIndexNo, int pageSize, String email);

	public String getSaleInfo(int productIdx);

	public Integer getCostPrice1(int productIdx);

	public List<PdDeliverVO> getOrderDeliveryInfo(String orderIdx);

	public List<PdOrderVO> getOrderStatus1(String email);

	public int totRecCntStatus(String email, String orderStatus);

	public List<PdDeliverVO> getOrderStatus(int startIndexNo, int pageSize, String email, String orderStatus);

	public int totRecCntStatusDate(String email, String startJumun, String endJumun);

	public List<PdDeliverVO> getOrderByDate(int startIndexNo, int pageSize, String email, String startJumun, String endJumun);

	public PdOrderVO orderCheck(String email, int productIdx);

	public int reviewInput(MultipartFile fName, PdReviewVO vo);

	public int totRecCntPdList();

	public int totRecCntMainPd(String categoryMainCode);

	public int totRecCntMidPd(String categoryMiddleCode);

	public List<ProductVO> getProductListMidAd(String categoryMainCode, String categoryMiddleCode, int startIndexNo,
			int pageSize);

	public List<ProductVO> getProductListAdMain(String categoryMainCode, int startIndexNo, int pageSize);

	public List<ProductVO> getCateMainName();

	public int totRecCntPdListCate(String mainCate, String midCate);

	public List<ProductVO> getProductListCate(int startIndexNo, int pageSize, String mainCate, String midCate);

	public List<PdReviewVO> getReview(int idx);

	public int totRecCntReview(int idx);

	public GoodsVO getGoods(int idx, String email);

	public void resetLike(int idx, String email);

	public void plusLike(int idx, String email);

	public void reviewDelete(int idx);

	public PdReviewVO getReviewContent(int idx);

	public void imgDelete(String content);

	public int goodsCnt(int idx);

	public List<ProductVO> getGoodProduct(String email);

	public int[] getBest3Idx();

	public ProductVO getBest3Product(int idx);

	public int[] getBest3SellIdx();

	public ProductVO getBest3SellProduct(int idx);

	public int totRecCntBasic(String email);

	public List<PdDeliverVO> getOrderBasic(int startIndexNo, int pageSize, String email);

	//public ProductVO getBest3SellProduct(int idx);








}
