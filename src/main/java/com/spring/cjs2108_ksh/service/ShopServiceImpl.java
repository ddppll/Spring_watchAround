package com.spring.cjs2108_ksh.service;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;

import com.spring.cjs2108_ksh.dao.ShopDAO;
import com.spring.cjs2108_ksh.vo.GoodsVO;
import com.spring.cjs2108_ksh.vo.PdCartListVO;
import com.spring.cjs2108_ksh.vo.PdDeliverVO;
import com.spring.cjs2108_ksh.vo.PdOrderVO;
import com.spring.cjs2108_ksh.vo.PdReviewVO;
import com.spring.cjs2108_ksh.vo.ProductVO;

@Service
public class ShopServiceImpl implements ShopService{
	@Autowired
	ShopDAO shopDAO;

	/*@Override
	public List<ProductVO> getProductList(String categoryMainCode, String categoryMiddleCode,int startIndexNo, int pageSize) {
		return shopDAO.getProductList(categoryMiddleCode, categoryMiddleCode, startIndexNo, pageSize);
	}*/
	
	@Override
	public List<ProductVO> getProductList(int startIndexNo, int pageSize) {
		return shopDAO.getProductList(startIndexNo, pageSize);
	}

	@Override
	public ProductVO getProductContent(int idx) {
		return shopDAO.getProductContent(idx);
	}

	@Override
	public PdCartListVO cartListPdOptionSearch(String productName, String optionName, String email) {
		return shopDAO.cartListPdOptionSearch(productName, optionName, email);
	}

	@Override
	public void cartListUpdate(PdCartListVO vo) {
		shopDAO.cartListUpdate(vo);
	}

	@Override
	public void cartListInput(PdCartListVO vo) {
		shopDAO.cartListInput(vo);
	}

	@Override
	public List<PdCartListVO> getPdCartList(String email) {
		return shopDAO.getPdCartList(email);
	}

	@Override
	public void cartAllDel(String email) {
		shopDAO.cartAllDel(email);
	}

	@Override
	public void cartDel(int idx) {
		shopDAO.cartDel(idx);
	}

	@Override
	public PdCartListVO getCartIdx(String idx) {
		return shopDAO.getCartIdx(idx);
	}

	@Override
	public PdOrderVO getOrderMaxIdx() {
		return shopDAO.getOrderMaxIdx();
	}

	@Override
	public void cartPdNumChange(int idx, int num, String totalPrice, String email) {
		shopDAO.cartPdNumChange(idx, num, totalPrice, email);
	}

	@Override
	public void setPdOrder(PdOrderVO vo) {
		shopDAO.setPdOrder(vo);
	}

	@Override
	public void delCartList(int cartIdx) {
		shopDAO.delCartList(cartIdx);
	}

	@Override
	public int getOrderOIdx(String orderIdx) {
		return shopDAO.getOrderOIdx(orderIdx);
	}

	@Override
	public void setDbDeliver(PdDeliverVO deliverVo) {
		shopDAO.setDbDeliver(deliverVo);
	}

	@Override
	public List<PdDeliverVO> getDelivery(String email) {
		return shopDAO.getDelivery(email);
	}

	@Override
	public int getMainPrice(int productIdx) {
		return shopDAO.getMainPrice(productIdx);
	}

	@Override
	public PdDeliverVO getDeliveryImme(String email) {
		return shopDAO.getDeliveryImme(email);
	}

	@Override
	public int totRecCnt(String email) {
		return shopDAO.totRecCnt(email);
	}

	@Override
	public List<PdDeliverVO> getMyOrder(int startIndexNo, int pageSize, String email) {
		return shopDAO.getMyOrder(startIndexNo, pageSize, email);
	}

	@Override
	public String getSaleInfo(int productIdx) {
		return shopDAO.getSaleInfo(productIdx);
	}

	@Override
	public Integer getCostPrice1(int productIdx) {
		return shopDAO.getCostPrice1(productIdx);
	}

	@Override
	public List<PdDeliverVO> getOrderDeliveryInfo(String orderIdx) {
		return shopDAO.getOrderDeliveryInfo(orderIdx);
	}

	@Override
	public List<PdOrderVO> getOrderStatus1(String email) {
		return shopDAO.getOrderStatus1(email);
	}

	@Override
	public int totRecCntStatus(String email, String orderStatus) {
		return shopDAO.totRecCntStatus(email, orderStatus);
	}

	@Override
	public List<PdDeliverVO> getOrderStatus(int startIndexNo, int pageSize, String email, String orderStatus) {
		return shopDAO.getOrderStatus(email, orderStatus, startIndexNo, pageSize);
	}

	@Override
	public int totRecCntStatusDate(String email, String startJumun, String endJumun) {
		return shopDAO.totRecCntStatusDate(email, startJumun, endJumun);
	}

	@Override
	public List<PdDeliverVO> getOrderByDate(int startIndexNo, int pageSize, String email, String startJumun, String endJumun) {
		return shopDAO.getOrderByDate(email, startJumun, endJumun,startIndexNo, pageSize);
	}

	@Override
	public PdOrderVO orderCheck(String email, int productIdx) {
		return shopDAO.orderCheck(email, productIdx);
	}
	
	//리뷰 입력처리 - 파일 업로드 + DB 등록
	@Override
	public int reviewInput(MultipartFile fName, PdReviewVO vo) {
		int res = 0;
		try {
			String oFileName = fName.getOriginalFilename();
			if(oFileName != "" && oFileName != null) {
				//회원 사진을 업로드 처리하기 위해 중복파일명 처리와 db업로드처리
				UUID uid = UUID.randomUUID();
				String saveFileName = uid + "_" + oFileName;
				writeFile(fName, saveFileName);
				vo.setPhoto(saveFileName);
			}
			
			// DB에 넣어준다
			//System.out.println("1.serviceimpl vo : " + vo);
			shopDAO.reviewInput(vo);
			//System.out.println("2.serviceimpl vo : " + vo);
			res = 1;
		} catch (IOException e) {
			e.printStackTrace();
		}
		return res;
	}
	
	//리뷰 사진 업로드
	private void writeFile(MultipartFile fName, String saveFileName) throws IOException {
		byte[] data = fName.getBytes();
		
		HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
		String uploadPath = request.getSession().getServletContext().getRealPath("/resources/data/review/");
		
		FileOutputStream fos = new FileOutputStream(uploadPath + saveFileName);
		fos.write(data);
		fos.close();
	}

	@Override
	public int totRecCntPdList() {
		return shopDAO.totRecCntPdList();
	}

	@Override
	public int totRecCntMainPd(String categoryMainCode) {
		return shopDAO.totRecCntMainPd(categoryMainCode);
	}

	@Override
	public int totRecCntMidPd(String categoryMiddleCode) {
		return shopDAO.totRecCntMidPd(categoryMiddleCode);
	}

	@Override
	public List<ProductVO> getProductListMidAd(String categoryMainCode, String categoryMiddleCode, int startIndexNo, int pageSize) {
		return shopDAO.getProductListMidAd(categoryMainCode, categoryMiddleCode, startIndexNo, pageSize);
	}

	@Override
	public List<ProductVO> getProductListAdMain(String categoryMainCode, int startIndexNo, int pageSize) {
		return shopDAO.getProductListAdMain(categoryMainCode, startIndexNo, pageSize);
	}

	@Override
	public List<ProductVO> getCateMainName() {
		return shopDAO.getCateMainName();
	}

	@Override
	public int totRecCntPdListCate(String mainCate, String midCate) {
		return shopDAO.totRecCntPdListCate(mainCate, midCate);
	}

	@Override
	public List<ProductVO> getProductListCate(int startIndexNo, int pageSize, String mainCate,  String midCate) {
		return shopDAO.getProductListCate(startIndexNo, pageSize, mainCate, midCate);
	}

	@Override
	public List<PdReviewVO> getReview(int idx) {
		return shopDAO.getReview(idx);
	}

	@Override
	public int totRecCntReview(int idx) {
		return shopDAO.totRecCntReview(idx);
	}

	@Override
	public GoodsVO getGoods(int idx, String email) {
		return shopDAO.getGoods(idx, email);
	}

	@Override
	public void resetLike(int idx, String email) {
		shopDAO.resetLike(idx, email);
	}

	@Override
	public void plusLike(int idx, String email) {
		shopDAO.plusLike(idx, email);
	}
	
	@Override
	public PdReviewVO getReviewContent(int idx) {
		return shopDAO.getReviewContent(idx);
	}

	@Override
	public void reviewDelete(int idx) {
		shopDAO.reviewDelete(idx);
	}

	//리뷰 사진 파일 삭제
	@Override
	public void imgDelete(String content) {
		if(content.indexOf("src=\"/") == -1) return; //처리할 이미지가 없을 때
		HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
		String uploadPath = request.getRealPath("/resources/data/review/");
		
			   //      0         1         2         3       3 4         5
		//             012345678901234567890123456789012345678901234567890
		// <img alt="" src="/cjs2108_ksh/data/review/211229124318_4.jpg"
		
		int position = 30;
		String nextImg = content.substring(content.indexOf("src=\"/") + position);
		boolean sw = true;
		
		while(sw) {
			String imgFile = nextImg.substring(0,nextImg.indexOf("\""));
			String oriFilePath = uploadPath + imgFile; 	// 원본 그림이 들어있는 경로명 + 파일명
			
			fileDelete(oriFilePath);	// 원본그림을 삭제처리하는 메소드
			
			if(nextImg.indexOf("src=\"/") == -1) { //복사한다음에 그 뒤에 이미지 또 없을 때
				sw = false;
			}
			else {
				nextImg = nextImg.substring(nextImg.indexOf("src=\"/") + position);
			}
		}
	}

	private void fileDelete(String oriFilePath) {
		File delFile = new File(oriFilePath);
		if(delFile.exists()) delFile.delete();
	}

	@Override
	public int goodsCnt(int idx) {
		return shopDAO.goodsCnt(idx);
	}

	@Override
	public List<ProductVO> getGoodProduct(String email) {
		return shopDAO.getGoodProduct(email);
	}

	@Override
	public int[] getBest3Idx() {
		return shopDAO.getBest3Idx();
	}

	@Override
	public ProductVO getBest3Product(int idx) {
		return shopDAO.getBest3Product(idx);
	}

	@Override
	public int[] getBest3SellIdx() {
		return shopDAO.getBest3SellIdx();
	}

	@Override
	public ProductVO getBest3SellProduct(int idx) {
		return shopDAO.getBest3SellProduct(idx);
	}

	@Override
	public int totRecCntBasic(String email) {
		return shopDAO.totRecCntBasic(email);
	}

	@Override
	public List<PdDeliverVO> getOrderBasic(int startIndexNo, int pageSize, String email) {
		return shopDAO.getOrderBasic(startIndexNo, pageSize, email);
	}




}
