package com.spring.cjs2108_ksh.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.cjs2108_ksh.vo.GoodsVO;
import com.spring.cjs2108_ksh.vo.PdCartListVO;
import com.spring.cjs2108_ksh.vo.PdDeliverVO;
import com.spring.cjs2108_ksh.vo.PdOrderVO;
import com.spring.cjs2108_ksh.vo.PdReviewVO;
import com.spring.cjs2108_ksh.vo.ProductVO;

public interface ShopDAO {

	//public List<ProductVO> getProductList( @Param("categoryMainCode")String categoryMainCode,  @Param("categoryMiddleCode")String categoryMiddleCode, @Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);
	public List<ProductVO> getProductList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public ProductVO getProductContent(@Param("idx") int idx);

	public PdCartListVO cartListPdOptionSearch(@Param("productName") String productName, @Param("optionName") String optionName, @Param("email") String email);

	public void cartListUpdate(@Param("vo") PdCartListVO vo);

	public void cartListInput(@Param("vo") PdCartListVO vo);

	public List<PdCartListVO> getPdCartList(@Param("email") String email);

	public void cartAllDel(@Param("email") String email);

	public void cartDel(@Param("idx") int idx);

	public PdCartListVO getCartIdx(@Param("idx") String idx);

	public PdOrderVO getOrderMaxIdx();

	public void cartPdNumChange(@Param("idx") int idx, @Param("num") int num, @Param("totalPrice") String totalPrice, @Param("email") String email);

	public void setPdOrder(@Param("vo") PdOrderVO vo);

	public void delCartList(@Param("cartIdx") int cartIdx);

	public int getOrderOIdx(@Param("orderIdx") String orderIdx);

	public void setDbDeliver(@Param("deliverVo") PdDeliverVO deliverVo);

	public List<PdDeliverVO> getDelivery(@Param("email") String email);

	public int getMainPrice(@Param("productIdx") int productIdx);

	public PdDeliverVO getDeliveryImme(@Param("email") String email);

	public int totRecCnt(@Param("email") String email);

	public List<PdDeliverVO> getMyOrder(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, @Param("email") String email);

	public String getSaleInfo(@Param("productIdx") int productIdx);

	public Integer getCostPrice1(@Param("productIdx") int productIdx);

	public List<PdDeliverVO> getOrderDeliveryInfo(@Param("orderIdx") String orderIdx);

	public List<PdOrderVO> getOrderStatus1(@Param("email") String email);

	public int totRecCntStatus(@Param("email") String email, @Param("orderStatus") String orderStatus);

	public List<PdDeliverVO> getOrderStatus(@Param("email") String email, @Param("orderStatus") String orderStatus, @Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public int totRecCntStatusDate(@Param("email") String email, @Param("startJumun") String startJumun, @Param("endJumun") String endJumun);

	public List<PdDeliverVO> getOrderByDate(@Param("email") String email, @Param("startJumun") String startJumun, @Param("endJumun") String endJumun, @Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public PdOrderVO orderCheck(@Param("email") String email, @Param("productIdx") int productIdx);

	public void reviewInput(@Param("vo") PdReviewVO vo);

	public int totRecCntPdList();

	public int totRecCntMainPd(@Param("categoryMainCode") String categoryMainCode);

	public int totRecCntMidPd(@Param("categoryMiddleCode") String categoryMiddleCode);

	public List<ProductVO> getProductListMidAd(@Param("categoryMainCode") String categoryMainCode, @Param("categoryMiddleCode") String categoryMiddleCode, @Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public List<ProductVO> getProductListAdMain(@Param("categoryMainCode") String categoryMainCode, @Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public List<ProductVO> getCateMainName();

	public int totRecCntPdListCate(@Param("mainCate") String mainCate, @Param("midCate") String midCate);

	public List<ProductVO> getProductListCate(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, @Param("mainCate") String mainCate, @Param("midCate") String midCate);

	public List<PdReviewVO> getReview(@Param("idx") int idx);

	public int totRecCntReview(@Param("idx") int idx);

	public GoodsVO getGoods(@Param("idx") int idx, @Param("email") String email);

	public void resetLike(@Param("idx") int idx, @Param("email") String email);

	public void plusLike(@Param("idx") int idx, @Param("email") String email);

	public PdReviewVO getReviewContent(@Param("idx") int idx);

	public void reviewDelete(@Param("idx") int idx);

	public int goodsCnt(@Param("idx") int idx);

	public List<ProductVO> getGoodProduct(@Param("email") String email);

	public int[] getBest3Idx();

	public ProductVO getBest3Product(@Param("idx") int idx);

	public int[] getBest3SellIdx();

	public ProductVO getBest3SellProduct(@Param("idx") int idx);

	public int totRecCntBasic(@Param("email") String email);

	public List<PdDeliverVO> getOrderBasic(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, @Param("email") String email);

	//public ProductVO getBest3SellProduct(@Param("idx") int idx);





}
