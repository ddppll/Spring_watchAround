package com.spring.cjs2108_ksh.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.spring.cjs2108_ksh.vo.MembersVO;
import com.spring.cjs2108_ksh.vo.PdDeliverVO;
import com.spring.cjs2108_ksh.vo.PdOptionVO;
import com.spring.cjs2108_ksh.vo.PdOrderVO;
import com.spring.cjs2108_ksh.vo.PdReviewVO;
import com.spring.cjs2108_ksh.vo.ProductCateVO;
import com.spring.cjs2108_ksh.vo.ProductVO;

public interface AdminService {

	public void boardCateChange(int idx, String selectCategory);

	public ProductCateVO cateMainSearch(String categoryMainCode, String categoryMainName);

	public void cateMainInput(ProductCateVO vo);

	public List<ProductCateVO> getCategoryMain();

	public List<ProductCateVO> cateMidSearch(ProductCateVO vo);

	public void cateMidInput(ProductCateVO vo);

	public List<ProductCateVO> getCategoryMiddle();

	public void cateMainDel(String categoryMainCode);

	public List<ProductVO> productSearch(String categoryMiddleCode);

	public void cateMidDel(String categoryMiddleCode);

	public List<ProductCateVO> getCategoryMiddleName(String categoryMainCode);

	public List<ProductCateVO> cateMidDelSearch(ProductCateVO vo);

	public void imgCheckProductRegister(MultipartFile file, ProductVO vo);

	public void setPdOptionInput(PdOptionVO vo);

	public List<PdOptionVO> getPdOption(int idx);

	public int totRecCnt();

	public ArrayList<MembersVO> getMemberList(int startIndexNo, int pageSize);

	public int totRecCntKeyword(String search, String keyword);

	public ArrayList<MembersVO> getMemberListKeyword(int startIndexNo, int pageSize, String search, String keyword);

	public void memDbDelete(int idx);

	public void memChange(int idx, String selectCategory);

	public int totRecCntCate(String category);

	public ArrayList<MembersVO> getMemberListCate(int startIndexNo, int pageSize, String category);

	public int totRecCntAdminStatus(String startJumun, String endJumun, String orderStatus);

	public int totRecCntAdminOrder();

	public List<PdDeliverVO> adminOrderList(int startIndexNo, int pageSize);

	public void orderStatusChange(int idx, String changeStatus);

	public List<PdDeliverVO> adminOrderSearch(String startJumun, String endJumun, String orderStatus, int startIndexNo, int pageSize);

	public List<PdDeliverVO> orderDeliver(String orderIdx);

	public ProductVO getProduct(int idx);

	public void imgCheckUpdate(String content);

	public void imgDelete(String content);

	public void imgCheck(String content);

	public void setProductEdit(ProductVO vo);

	public void setProductEditFile(ProductVO vo, MultipartFile file);

	public void setPdDelete(int idx);

	public int totRecCntReview();

	public List<PdReviewVO> getReviewList(int startIndexNo, int pageSize);

	public PdReviewVO getReviewContent(int idx);

	public int getReviewCount(int productIdx);

	public int reviewRateAvg(int productIdx);

	public List<PdOrderVO> saleChart();

	public List<PdOrderVO> amountChart();

}
