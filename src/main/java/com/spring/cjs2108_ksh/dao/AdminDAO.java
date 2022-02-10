package com.spring.cjs2108_ksh.dao;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.cjs2108_ksh.vo.MembersVO;
import com.spring.cjs2108_ksh.vo.PdDeliverVO;
import com.spring.cjs2108_ksh.vo.PdOptionVO;
import com.spring.cjs2108_ksh.vo.PdOrderVO;
import com.spring.cjs2108_ksh.vo.PdReviewVO;
import com.spring.cjs2108_ksh.vo.ProductCateVO;
import com.spring.cjs2108_ksh.vo.ProductVO;

public interface AdminDAO {

	public void boardCateChange(@Param("idx") int idx, @Param("selectCategory") String selectCategory);

	public ProductCateVO cateMainSearch(@Param("categoryMainCode") String categoryMainCode, @Param("categoryMainName") String categoryMainName);

	public void cateMainInput(@Param("vo") ProductCateVO vo);

	public List<ProductCateVO> getCategoryMain();

	public List<ProductCateVO> cateMidSearch(@Param("vo") ProductCateVO vo);

	public void cateMidInput(@Param("vo") ProductCateVO vo);

	public List<ProductCateVO> getCategoryMiddle();

	public void cateMainDel(@Param("categoryMainCode") String categoryMainCode);

	public List<ProductVO> productSearch(@Param("categoryMiddleCode") String categoryMiddleCode);

	public void cateMidDel(@Param("categoryMiddleCode") String categoryMiddleCode);

	public List<ProductCateVO> getCategoryMiddleName(@Param("categoryMainCode") String categoryMainCode);

	public List<ProductCateVO> cateMidDelSearch(@Param("vo") ProductCateVO vo);

	public ProductVO getProductMaxIdx();

	public void setProductRegister(@Param("vo") ProductVO vo);

	public void setPdOptionInput(@Param("vo") PdOptionVO vo);

	public List<PdOptionVO> getPdOption(@Param("idx") int idx);

	public int totRecCnt();

	public ArrayList<MembersVO> getMemberList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public int totRecCntKeyword(@Param("search") String search, @Param("keyword") String keyword);

	public ArrayList<MembersVO> getMemberListKeyword(@Param("search") String search, @Param("keyword") String keyword, @Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public void memDbDelete(@Param("idx") int idx);

	public void memChange(@Param("idx") int idx, @Param("selectCategory") String selectCategory);

	public int totRecCntCate(@Param("category") String category);

	public ArrayList<MembersVO> getMemberListCate(@Param("category") String category, @Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public int totRecCntAdminStatus(@Param("startJumun") String startJumun, @Param("endJumun") String endJumun, @Param("orderStatus") String orderStatus);

	public int totRecCntAdminOrder();

	public List<PdDeliverVO> adminOrderList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public void orderStatusChange(@Param("idx") int idx, @Param("changeStatus") String changeStatus);

	public List<PdDeliverVO> adminOrderSearch(@Param("startJumun") String startJumun, @Param("endJumun") String endJumun, @Param("orderStatus") String orderStatus, @Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public List<PdDeliverVO> orderDeliver(@Param("orderIdx") String orderIdx);

	public ProductVO getProduct(@Param("idx") int idx);

	public void setProductEdit(@Param("vo") ProductVO vo);

	public void setProductEditFile(@Param("vo") ProductVO vo);

	public void setPdDelete(@Param("idx") int idx);

	public int totRecCntReview();

	public List<PdReviewVO> getReviewList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public PdReviewVO getReviewContent(@Param("idx") int idx);

	public int getReviewCount(@Param("productIdx") int productIdx);

	public int reviewRateAvg(@Param("productIdx") int productIdx);

	public List<PdOrderVO> saleChart();

	public List<PdOrderVO> amountChart();

}
