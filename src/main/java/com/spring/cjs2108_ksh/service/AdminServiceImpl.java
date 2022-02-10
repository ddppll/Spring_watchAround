package com.spring.cjs2108_ksh.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;

import com.spring.cjs2108_ksh.dao.AdminDAO;
import com.spring.cjs2108_ksh.vo.MembersVO;
import com.spring.cjs2108_ksh.vo.PdDeliverVO;
import com.spring.cjs2108_ksh.vo.PdOptionVO;
import com.spring.cjs2108_ksh.vo.PdOrderVO;
import com.spring.cjs2108_ksh.vo.PdReviewVO;
import com.spring.cjs2108_ksh.vo.ProductCateVO;
import com.spring.cjs2108_ksh.vo.ProductVO;

@Service
public class AdminServiceImpl implements AdminService{
	@Autowired
	AdminDAO adminDAO;

	@Override
	public void boardCateChange(int idx, String selectCategory) {
		adminDAO.boardCateChange(idx, selectCategory);
	}

	@Override
	public ProductCateVO cateMainSearch(String categoryMainCode, String categoryMainName) {
		return adminDAO.cateMainSearch(categoryMainCode, categoryMainName);
	}

	@Override
	public void cateMainInput(ProductCateVO vo) {
		adminDAO.cateMainInput(vo);
	}

	@Override
	public List<ProductCateVO> getCategoryMain() {
		return adminDAO.getCategoryMain();
	}

	@Override
	public List<ProductCateVO> cateMidSearch(ProductCateVO vo) {
		return adminDAO.cateMidSearch(vo);
	}

	@Override
	public void cateMidInput(ProductCateVO vo) {
		adminDAO.cateMidInput(vo);
	}

	@Override
	public List<ProductCateVO> getCategoryMiddle() {
		return adminDAO.getCategoryMiddle();
	}

	@Override
	public void cateMainDel(String categoryMainCode) {
		adminDAO.cateMainDel(categoryMainCode);
	}

	@Override
	public List<ProductVO> productSearch(String categoryMiddleCode) {
		return adminDAO.productSearch(categoryMiddleCode);
	}

	@Override
	public void cateMidDel(String categoryMiddleCode) {
		adminDAO.cateMidDel(categoryMiddleCode);
	}

	@Override
	public List<ProductCateVO> getCategoryMiddleName(String categoryMainCode) {
		return adminDAO.getCategoryMiddleName(categoryMainCode);
	}

	@Override
	public List<ProductCateVO> cateMidDelSearch(ProductCateVO vo) {
		return adminDAO.cateMidDelSearch(vo);
	}

	@Override
	public void imgCheckProductRegister(MultipartFile file, ProductVO vo) {
		//기본 파일 : dbshop/product에 업로드
		try {
			String originalFilename = file.getOriginalFilename();
			if(originalFilename != "" && originalFilename != null) {
				//중복파일명 방지
				Date date = new Date();
				SimpleDateFormat sdf = new SimpleDateFormat("yyMMddHHmmss");
				String saveFileName = sdf.format(date) + "_" + originalFilename;
				writeFile(file, saveFileName);	//메인 이미지를 서버에 업로드하는 메소드
				vo.setFName(originalFilename);	//업로드시 파일명을 FName에 저장
				vo.setFSName(saveFileName);		//서버에 저장된 파일명을 vo에 저장
			}
			else {
				return;
			}
			
		} catch (IOException e) {
			e.printStackTrace();
		}
		
			   //      0         1         2         3         4         5
		//             012345678901234567890123456789012345678901234567890
		// <img alt="" src="/cjs2108_ksh/data/dbShop/211229124318_4.jpg"
		// <img alt="" src="/spring2108_ksh/data/dbShop/product/211229124318_4.jpg"
		
		// ckeditor에 작성한 상세내용에 이미지 있을 시 이미지를 dbShop/product 폴더로 복사
		String content = vo.getContent();
		if(content.indexOf("src=\"/") == -1) {
			//System.out.println("123123");
			//return;	content 박스에 그림 없으면 그냥 넘어감
		}
		else {
			//System.out.println("sdfasdfsdf");
			HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
			String uploadPath = request.getRealPath("/resources/data/dbShop/");
			
			int position = 30;//파일명만 추출
			String nextImg = content.substring(content.indexOf("src=\"/") + position);
			boolean sw = true;
			
			while(sw) {
				String imgFile = nextImg.substring(0,nextImg.indexOf("\""));
				String copyFilePath = "";
				String oriFilePath = uploadPath + imgFile;	//원본 이미지가 있는 경로+파일명
				
				copyFilePath = uploadPath + "product/" + imgFile;	//복사될 경로+파일명
				
				fileCopyCheck(oriFilePath, copyFilePath);			// 원본그림을 복사위치(dbShop/product)로 복사하는 메소드
				
				if(nextImg.indexOf("src=\"/") == -1) sw = false;
				else nextImg = nextImg.substring(nextImg.indexOf("src=\"/") + position);
			}
			
			//복사 작업 한 뒤 실제 저장된 'dbShop/product'폴더명을 vo에 set
			vo.setContent(vo.getContent().replace("/data/dbShop/", "/data/dbShop/product/"));
		}
		//복사 다 하면 vo에 있는 내용을 db에 저장
		//상품코드를 만들기 위해 지금까지 작업된 dbProduct테이블의 idx필드중 최대값을 읽어온다. 없으면 0으로 처리
		int maxIdx = 0;
		ProductVO maxVo = adminDAO.getProductMaxIdx();
		if(maxVo != null) maxIdx = maxVo.getIdx();
		vo.setProductCode(vo.getCategoryMainCode() + vo.getCategoryMiddleCode() + maxIdx);	// 상품코드 : 대분류코드 + 중분류코드 + 최대값idx
		adminDAO.setProductRegister(vo);
		//System.out.println("서비스vo :" + vo);
	}

	//메인 이미지 서버에 저장하는 메소드
	private void writeFile(MultipartFile fName, String saveFileName) throws IOException{
		byte[] data = fName.getBytes();
		
		HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
		String uploadPath = request.getSession().getServletContext().getRealPath("/resources/data/dbShop/product/");
		
		FileOutputStream fos = new FileOutputStream(uploadPath + saveFileName);
		fos.write(data);
		fos.close();
	}
	
	//실제 파일(dbShop폴더에 있는 이미지)를 'dbShop/product'폴더로 복사하는 메소드
	private void fileCopyCheck(String oriFilePath, String copyFilePath) {
		
		File oriFile = new File(oriFilePath);
		File copyFile = new File(copyFilePath);
		
		try {
			FileInputStream  fis = new FileInputStream(oriFile);
			FileOutputStream fos = new FileOutputStream(copyFile);
			
			byte[] buffer = new byte[2048];
			int count = 0;
			while((count = fis.read(buffer)) != -1) {
				fos.write(buffer, 0, count);
			}
			fos.flush();
			fos.close();
			fis.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	//옵션 등록
	@Override
	public void setPdOptionInput(PdOptionVO vo) {
		adminDAO.setPdOptionInput(vo);
	}

	@Override
	public List<PdOptionVO> getPdOption(int idx) {
		return adminDAO.getPdOption(idx);
	}

	@Override
	public int totRecCnt() {
		return adminDAO.totRecCnt();
	}

	@Override
	public ArrayList<MembersVO> getMemberList(int startIndexNo, int pageSize) {
		return adminDAO.getMemberList(startIndexNo, pageSize);
	}

	@Override
	public int totRecCntKeyword(String search, String keyword) {
		return adminDAO.totRecCntKeyword(search, keyword);
	}

	@Override
	public ArrayList<MembersVO> getMemberListKeyword(int startIndexNo, int pageSize, String search, String keyword) {
		return adminDAO.getMemberListKeyword(search, keyword, startIndexNo, pageSize);
	}

	@Override
	public void memDbDelete(int idx) {
		adminDAO.memDbDelete(idx);
	}

	@Override
	public void memChange(int idx, String selectCategory) {
		adminDAO.memChange(idx, selectCategory);
	}

	@Override
	public int totRecCntCate(String category) {
		return adminDAO.totRecCntCate(category);
	}

	@Override
	public ArrayList<MembersVO> getMemberListCate(int startIndexNo, int pageSize, String category) {
		return adminDAO.getMemberListCate(category, startIndexNo, pageSize);
	}

	@Override
	public int totRecCntAdminStatus(String startJumun, String endJumun, String orderStatus) {
		return adminDAO.totRecCntAdminStatus(startJumun, endJumun, orderStatus);
	}

	@Override
	public int totRecCntAdminOrder() {
		return adminDAO.totRecCntAdminOrder();
	}

	@Override
	public List<PdDeliverVO> adminOrderList(int startIndexNo, int pageSize) {
		return adminDAO.adminOrderList(startIndexNo, pageSize);
	}

	@Override
	public void orderStatusChange(int idx, String changeStatus) {
		adminDAO.orderStatusChange(idx, changeStatus);
		
	}

	@Override
	public List<PdDeliverVO> adminOrderSearch(String startJumun, String endJumun, String orderStatus,  int startIndexNo, int pageSize) {
		return adminDAO.adminOrderSearch(startJumun, endJumun, orderStatus, startIndexNo, pageSize);
	}

	@Override
	public List<PdDeliverVO> orderDeliver(String orderIdx) {
		return adminDAO.orderDeliver(orderIdx);
	}

	@Override
	public ProductVO getProduct(int idx) {
		return adminDAO.getProduct(idx);
	}

	@Override
	public void imgCheckUpdate(String content) {
		if(content.indexOf("src=\"/") == -1) return; //처리할 이미지가 없을 때
		
		HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
		String uploadPath = request.getRealPath("/resources/data/dbShop/product/");
		
		//012345678901234567890123456789012345678901234567890
		//src="/cjs2108_ksh/data/dbShop/product/220112174154_dog9.jpg
		//src="/cjs2108_ksh/data/ckeditor/board/220112174154_dog9.jpg
		
		int position = 38;
		String nextImg = content.substring(content.indexOf("src=\"/") + position);
		boolean sw = true;
		
		while(sw) {
			String imgFile = nextImg.substring(0,nextImg.indexOf("\""));
			//System.out.println(imgFile);
			String oriFilePath = uploadPath + imgFile; 	// 원본 그림이 들어있는 경로명 + 파일명
			String copyFilePath = request.getRealPath("/resources/data/dbShop/" + imgFile);	// 복사가 될 '경로명+파일명'
			
			fileCopyCheck(oriFilePath, copyFilePath);	// 원본그림이 복사될 위치로 복사 작업 처리하는 메소드
			
			if(nextImg.indexOf("src=\"/") == -1) { //복사한다음에 그 뒤에 이미지 또 없을 때
				sw = false;
			}
			else {
				nextImg = nextImg.substring(nextImg.indexOf("src=\"/") + position);
			}
		}
	}

	@Override //원본파일삭제처리
	public void imgDelete(String content) {
		if(content.indexOf("src=\"/") == -1) return; //처리할 이미지가 없을 때
		
		HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
		String uploadPath = request.getRealPath("/resources/data/dbShop/product/");
		
		int position = 38;
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

	// dbShop 폴더의 그림을 product 폴더로 복사
	@Override
	public void imgCheck(String content) {
			   //      0         1         2         3       3 4         5
		//             012345678901234567890123456789012345678901234567890
		// <img alt="" src="/cjs2108_ksh/data/dbShop/product/211229124318_4.jpg"
		// <img alt="" src="/cjs2108_ksh/data/ckeditor/board/211229124318_4.jpg"
		//01234567890123456789012345678901234567890
		// src="/spring2108_ksh/data/ckeditor/board/220112174154_dog9.jpg
	if(content.indexOf("src=\"/") == -1) return; //처리할 이미지가 없을 때
	
	HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
	String uploadPath = request.getRealPath("/resources/data/dbShop/");
	
	int position = 30;
	String nextImg = content.substring(content.indexOf("src=\"/") + position);
	boolean sw = true;
	
	while(sw) {
		String imgFile = nextImg.substring(0,nextImg.indexOf("\""));
		String copyFilePath = "";
		String oriFilePath = uploadPath + imgFile; 	// 원본 그림이 들어있는 경로명 + 파일명
		
		copyFilePath = uploadPath + "product/" + imgFile; // 복사가 될 경로명 + 파일명
		
		fileCopyCheck(oriFilePath, copyFilePath);	// 원본그림이 복사될 위치로 복사 작업 처리하는 메소드
		
		if(nextImg.indexOf("src=\"/") == -1) { //복사한다음에 그 뒤에 이미지 또 없을 때
			sw = false;
		}
		else {
			nextImg = nextImg.substring(nextImg.indexOf("src=\"/") + position);
		}
	}
		
	}

	@Override //메인이미지 변경 없는 상품 수정
	public void setProductEdit(ProductVO vo) {
 				   //      0         1         2         3         4         5
			//             012345678901234567890123456789012345678901234567890
			// <img alt="" src="/cjs2108_ksh/data/dbShop/211229124318_4.jpg"
			// <img alt="" src="/cjs2108_ksh/data/dbShop/product/211229124318_4.jpg"
			
			// ckeditor에 작성한 상세내용에 이미지 있을 시 이미지를 dbShop/product 폴더로 복사
			String content = vo.getContent();
			if(content.indexOf("src=\"/") == -1) {
				//System.out.println("00000");
				//System.out.println("123123");
				//return;	content 박스에 그림 없으면 그냥 넘어감
			}
			else {
				//System.out.println("1111122222");
				HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
				String uploadPath = request.getRealPath("/resources/data/dbShop/");
				
				int position = 38;//파일명만 추출
				String nextImg = content.substring(content.indexOf("src=\"/") + position);
				boolean sw = true;
				
				while(sw) {
					String imgFile = nextImg.substring(0,nextImg.indexOf("\""));
					String copyFilePath = "";
					String oriFilePath = uploadPath + imgFile;	//원본 이미지가 있는 경로+파일명
					
					copyFilePath = uploadPath + "product/" + imgFile;	//복사될 경로+파일명
					//System.out.println("oriFilePath : " + oriFilePath);
					//System.out.println("copyFilePath : " + copyFilePath);
					fileCopyCheck(oriFilePath, copyFilePath);			// 원본그림을 복사위치(dbShop/product)로 복사하는 메소드
					
					if(nextImg.indexOf("src=\"/") == -1) sw = false;
					else nextImg = nextImg.substring(nextImg.indexOf("src=\"/") + position);
				}
				
				//복사 작업 한 뒤 실제 저장된 'dbShop/product'폴더명을 vo에 set
				//vo.setContent(vo.getContent().replace("/data/dbShop/", "/data/dbShop/product/"));
			}
			
			//상품코드를 만들기 위해 지금까지 작업된 dbProduct테이블의 idx필드중 최대값을 읽어온다. 없으면 0으로 처리
			int maxIdx = 0;
			ProductVO maxVo = adminDAO.getProductMaxIdx();
			if(maxVo != null) maxIdx = maxVo.getIdx();
			vo.setProductCode(vo.getCategoryMainCode() + vo.getCategoryMiddleCode() + maxIdx);	// 상품코드 : 대분류코드 + 중분류코드 + 최대값idx
			System.out.println(maxIdx);
			System.out.println(vo.getProductCode());
			
			//복사 다 하면 vo에 있는 내용을 db에 저장
			//System.out.println("서비스vo : "+vo);
			adminDAO.setProductEdit(vo);
			//System.out.println("서비스vo :" + vo);
		
	}

	@Override //메인이미지 변경 있는 상품 수정
	public void setProductEditFile(ProductVO vo, MultipartFile file) {
		//기본 파일 : dbshop/product에 업로드
				try {
					String originalFilename = file.getOriginalFilename();
					if(originalFilename != "" && originalFilename != null) {
						//중복파일명 방지
						Date date = new Date();
						SimpleDateFormat sdf = new SimpleDateFormat("yyMMddHHmmss");
						String saveFileName = sdf.format(date) + "_" + originalFilename;
						writeFile(file, saveFileName);	//메인 이미지를 서버에 업로드하는 메소드
						vo.setFName(originalFilename);	//업로드시 파일명을 FName에 저장
						vo.setFSName(saveFileName);		//서버에 저장된 파일명을 vo에 저장
					}
					else {
						return;
					}
					
				} catch (IOException e) {
					e.printStackTrace();
				}
				
					   //      0         1         2         3         4         5
				//             012345678901234567890123456789012345678901234567890
				// <img alt="" src="/cjs2108_ksh/data/dbShop/211229124318_4.jpg"
				// <img alt="" src="/spring2108_ksh/data/dbShop/product/211229124318_4.jpg"
				
				// ckeditor에 작성한 상세내용에 이미지 있을 시 이미지를 dbShop/product 폴더로 복사
				String content = vo.getContent();
				if(content.indexOf("src=\"/") == -1) {
					//System.out.println("123123");
					//return;	content 박스에 그림 없으면 그냥 넘어감
				}
				else {
					//System.out.println("333344444");
					HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
					String uploadPath = request.getRealPath("/resources/data/dbShop/");
					
					int position = 30;//파일명만 추출
					String nextImg = content.substring(content.indexOf("src=\"/") + position);
					boolean sw = true;
					
					while(sw) {
						String imgFile = nextImg.substring(0,nextImg.indexOf("\""));
						String copyFilePath = "";
						String oriFilePath = uploadPath + imgFile;	//원본 이미지가 있는 경로+파일명
						
						copyFilePath = uploadPath + "product/" + imgFile;	//복사될 경로+파일명
						
						fileCopyCheck(oriFilePath, copyFilePath);			// 원본그림을 복사위치(dbShop/product)로 복사하는 메소드
						
						if(nextImg.indexOf("src=\"/") == -1) sw = false;
						else nextImg = nextImg.substring(nextImg.indexOf("src=\"/") + position);
					}
					
					//복사 작업 한 뒤 실제 저장된 'dbShop/product'폴더명을 vo에 set
					vo.setContent(vo.getContent().replace("/data/dbShop/", "/data/dbShop/product/"));
				}
				
				//상품코드를 만들기 위해 지금까지 작업된 dbProduct테이블의 idx필드중 최대값을 읽어온다. 없으면 0으로 처리
				int maxIdx = 0;
				ProductVO maxVo = adminDAO.getProductMaxIdx();
				if(maxVo != null) maxIdx = maxVo.getIdx();
				vo.setProductCode(vo.getCategoryMainCode() + vo.getCategoryMiddleCode() + maxIdx);	// 상품코드 : 대분류코드 + 중분류코드 + 최대값idx
				
				//복사 다 하면 vo에 있는 내용을 db에 저장
				
				//System.out.println("서비스vo :" + vo);
				adminDAO.setProductEditFile(vo);
	}

	@Override
	public void setPdDelete(int idx) {
		adminDAO.setPdDelete(idx);
	}

	@Override
	public int totRecCntReview() {
		return adminDAO.totRecCntReview();
	}

	@Override
	public List<PdReviewVO> getReviewList(int startIndexNo, int pageSize) {
		return adminDAO.getReviewList(startIndexNo, pageSize);
	}

	@Override
	public PdReviewVO getReviewContent(int idx) {
		return adminDAO.getReviewContent(idx);
	}

	@Override
	public int getReviewCount(int productIdx) {
		return adminDAO.getReviewCount(productIdx);
	}

	@Override
	public int reviewRateAvg(int productIdx) {
		return adminDAO.reviewRateAvg(productIdx);
	}

	@Override
	public List<PdOrderVO> saleChart() {
		return adminDAO.saleChart();
	}

	@Override
	public List<PdOrderVO> amountChart() {
		return adminDAO.amountChart();
	}

}
