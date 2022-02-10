package com.spring.cjs2108_ksh;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.spring.cjs2108_ksh.service.AdminService;
import com.spring.cjs2108_ksh.service.BoardService;
import com.spring.cjs2108_ksh.service.ShopService;
import com.spring.cjs2108_ksh.vo.BoardVO;
import com.spring.cjs2108_ksh.vo.MembersVO;
import com.spring.cjs2108_ksh.vo.PdDeliverVO;
import com.spring.cjs2108_ksh.vo.PdOptionVO;
import com.spring.cjs2108_ksh.vo.PdOrderVO;
import com.spring.cjs2108_ksh.vo.PdReviewVO;
import com.spring.cjs2108_ksh.vo.ProductCateVO;
import com.spring.cjs2108_ksh.vo.ProductVO;

@Controller
@RequestMapping("/admin")
public class AdminController {
	String msgFlag="";
	
	@Autowired
	AdminService adminService;
	
	@Autowired
	BoardService boardService;
	
	@Autowired
	ShopService shopService;
	
	//관리자페이지 메인 호출
	@RequestMapping(value="/adminMain", method = RequestMethod.GET)
	public String adminMainGet() {
		return "admin/adminMain";
	}
	
	//관리자페이지 - 게시판관리 - 게시판목록 호출
	@RequestMapping(value="/admin_boardList", method = RequestMethod.GET)
	public String admin_boardListGet(
			@RequestParam(name="pag", defaultValue="1", required=false) int pag,
			@RequestParam(name="pageSize", defaultValue="10", required=false) int pageSize,
			@RequestParam(name="category", defaultValue="99", required=false) int category,
			Model model) {
		
		/* 페이징 처리 변수 지정 */
		int totRecCnt = boardService.totRecCnt();		// 전체자료 갯수 검색
		int totPage = (totRecCnt % pageSize)==0 ? totRecCnt/pageSize : (totRecCnt/pageSize) + 1;
		int startIndexNo = (pag - 1) * pageSize;
		int curScrStrarNo = totRecCnt - startIndexNo;
		int blockSize = 3;		// 한블록의 크기를 3개의 Page로 본다
		int curBlock = (pag - 1) / blockSize;		// 현재페이지의 블록위치
		int lastBlock = (totPage % blockSize)==0 ? ((totPage / blockSize) - 1) : (totPage / blockSize);
		
		List<BoardVO> vos = boardService.getBoardList(startIndexNo, pageSize, category);
		
		model.addAttribute("vos", vos);
		model.addAttribute("pag", pag);
		model.addAttribute("pageSize", pageSize);
		model.addAttribute("totPage", totPage);
		model.addAttribute("curScrStrarNo", curScrStrarNo);
		model.addAttribute("blockSize", blockSize);
		model.addAttribute("curBlock", curBlock);
		model.addAttribute("lastBlock", lastBlock);
		model.addAttribute("totRecCnt", totRecCnt);
		model.addAttribute("category", category);
		
		return "admin/admin_boardList";
	}
	
	//게시판 관리 - 게시글 선택 삭제
	@ResponseBody
	@RequestMapping(value="/admin_boardDel", method = RequestMethod.POST)
	public String admin_boardListPost(String delItems) {
		String[] idxs = delItems.split("/");
		for(String idx : idxs) {
			BoardVO vo = boardService.getBoardContent(Integer.parseInt(idx));
			if(vo.getContent().indexOf("src=\"/") != -1) boardService.imgDelete(vo.getContent());
			boardService.replyAllDel(Integer.parseInt(idx));
			boardService.setBoardDelete(Integer.parseInt(idx));
		}
		return "";
	}
	
	//게시판 관리 - 게시글 카테고리 변경
	@ResponseBody
	@RequestMapping(value="/admin_changeCategory", method = RequestMethod.POST)
	public String admin_changeCategoryPost(String changeItems, String selectCategory) {
		String[] idxs = changeItems.split("/");
		for(String idx : idxs) {
			adminService.boardCateChange(Integer.parseInt(idx), selectCategory);
		}
		
		return "";
	}
	
	//-------------------------상품 관리------------------------------
	
	//상품 분류 등록창 호출 & 분류명 & 분류목록 가져오기
	@RequestMapping(value="/productCateRegister", method = RequestMethod.GET)
	public String productCateRegisterGet(Model model) {
		List<ProductCateVO> mainVos = adminService.getCategoryMain();
		List<ProductCateVO> middleVos = adminService.getCategoryMiddle();
		
		model.addAttribute("mainVos", mainVos);
		model.addAttribute("middleVos", middleVos);
		
		return "admin/productCateRegister";
	}
	
	//대분류 선택시 중분류명 가져오기
	@ResponseBody
	@RequestMapping(value="/categoryMiddleName", method = RequestMethod.POST)
	public List<ProductCateVO> categoryMiddleNamePost(String categoryMainCode) {
		return adminService.getCategoryMiddleName(categoryMainCode);
	}
	
	//중분류 선택시 상품명 가져오기
	@ResponseBody
	@RequestMapping(value="/getPdName", method = RequestMethod.POST)
	public List<ProductVO> getPdNamePost(String categoryMiddleCode){
		List<ProductVO> vos = adminService.productSearch(categoryMiddleCode);
		//System.out.println("vos : " + vos);
		return vos;
	}
	
	//대분류 등록
	@ResponseBody
	@RequestMapping(value="/cateMainInput", method = RequestMethod.POST)
	public String cateMainInputPost(ProductCateVO vo) {
		//기존 db에 중복 분류 있는지 확인
		ProductCateVO imsiVo = adminService.cateMainSearch(vo.getCategoryMainCode(), vo.getCategoryMainName());
		if(imsiVo != null) return "0";
		adminService.cateMainInput(vo);
		return "1";
	}
	
	//중분류 등록
	@ResponseBody
	@RequestMapping(value="/cateMidInput", method = RequestMethod.POST)
	public String cateMidInputPost(ProductCateVO vo) {
		//기존 db에 중복 중분류 있는지 확인
		List<ProductCateVO> vos = adminService.cateMidSearch(vo);
		if(vos.size() != 0) return "0";
		adminService.cateMidInput(vo);
		return "1";
	}
	
	//대분류 삭제
	@ResponseBody
	@RequestMapping(value="/cateMainDel", method = RequestMethod.POST)
	public String cateMainDelPost(ProductCateVO vo, String categoryMainCode) {
		List<ProductCateVO> vos = adminService.cateMidDelSearch(vo);
		if(vos.size() != 0) return "0";
		adminService.cateMainDel(vo.getCategoryMainCode());
		return "1";
	}
	
	//중분류 삭제
	@ResponseBody
	@RequestMapping(value="/cateMidDel", method = RequestMethod.POST)
	public String cateMidDelPost(ProductCateVO vo) {
		List<ProductVO> vos = adminService.productSearch(vo.getCategoryMiddleCode());
		if(vos.size() != 0) return "0";
		adminService.cateMidDel(vo.getCategoryMiddleCode());
		return "1";
	}
	
	//상품 등록창 호출
	@RequestMapping(value="/productRegister", method = RequestMethod.GET)
	public String productRegisterGet(Model model) {
		List<ProductCateVO> mainVos = adminService.getCategoryMain();
		model.addAttribute("mainVos",mainVos);
		return "admin/productRegister";
	}
	
	//상품등록에서 ckeditor로 이미지 처리하는 부분
	@ResponseBody
	@RequestMapping("/imageUpload")
	public void imageUploadGet(HttpServletRequest request, HttpServletResponse response, @RequestParam MultipartFile upload) throws Exception{
		response.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");
		
		String originalFilename = upload.getOriginalFilename();
		
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyMMddHHmmss");
		originalFilename = sdf.format(date) + "_" + originalFilename;
		
		byte[] bytes = upload.getBytes();
		
		// ckeditor에서 올린 파일을 서버 파일시스템에 저장시켜준다.
		String uploadPath = request.getSession().getServletContext().getRealPath("/resources/data/dbShop/");
		OutputStream outStr = new FileOutputStream(new File(uploadPath + originalFilename));
		outStr.write(bytes);		// 서버에 업로드시킨 그림파일이 저장된다.
		
		// 서버 파일시스템에 저장된 파일을 화면(textarea)에 출력하기
		PrintWriter out = response.getWriter();
		String fileUrl = request.getContextPath() + "/data/dbShop/" + originalFilename;
		out.println("{\"originalFilename\":\""+originalFilename+"\",\"uploaded\":1,\"url\":\""+fileUrl+"\"}");       /* "atom":"12.jpg","uploaded":1,"": */
		
		out.flush();
		outStr.close();
	}
	
	//상품 등록하기
	@RequestMapping(value="/productRegister", method = RequestMethod.POST)
	public String productRegisterPost(MultipartFile file, ProductVO vo) {
		//System.out.println("컨트롤러 vo : " + vo);
		//이미지파일 업로드시 ckeditor 폴더에서 board폴더로 복사
		adminService.imgCheckProductRegister(file,vo);
		//System.out.println("컨트롤러 vo2" + vo);
		
		msgFlag = "productRegiesterOk";
		return "redirect:/msg/" + msgFlag;
	}
	
	//옵션 등록창 호츨
	@RequestMapping(value="/pdOptionRegister", method = RequestMethod.GET)
	public String pdOptionRegisterGet(Model model) {
		List<ProductCateVO> mainVos = adminService.getCategoryMain();
		model.addAttribute("mainVos",mainVos);
		
		//System.out.println("mainVos : " + mainVos);
		return "admin/pdOptionRegister";
	}
	
	//옵션 등록
	@RequestMapping(value="/pdOptionRegister", method = RequestMethod.POST)
	public String pdOptionRegisterPost(PdOptionVO vo) {
		//System.out.println("vo : " + vo);
		String[] idxName = vo.getProductName().split("/");
		//System.out.println("idxName[0] : " + idxName[0]);
		vo.setProductIdx(Integer.parseInt(idxName[0]));
		vo.setOptionName(vo.getOptionName());
		vo.setOptionPrice(vo.getOptionPrice());
		adminService.setPdOptionInput(vo);
		//System.out.println("vo : " + vo);
		msgFlag = "setPdOptionInput";
		return "redirect:/msg/" + msgFlag;
	}
	
	//회원 목록 호출
	@RequestMapping(value="/admin_memList", method = RequestMethod.GET)
	public String admin_memListGet(
			@RequestParam(name="pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize", defaultValue="5", required=false) int pageSize,
			@RequestParam(name="search", defaultValue="email", required=false) String search,
			@RequestParam(name="keyword", defaultValue="", required=false) String keyword,
			@RequestParam(name="category", defaultValue="ALL", required=false) String category,
			Model model) {
		
		//System.out.println("keyword : "+keyword);
		//System.out.println("search : "+search);
		
		/* 이곳부터 페이징 처리(블록페이지) 변수 지정 시작 */
		int totRecCnt = 0;
		if(keyword.equals("")) {
			totRecCnt = adminService.totRecCnt();//총 레코드 건수 : dao에서 구해오는 게 아니라 스프링은 서비스에서 구해오는것. 서비스에서 dao로 넘기고 매퍼로 넘어가니까 ㅇㅇ
		}
		else {
			totRecCnt = adminService.totRecCntKeyword(search, keyword);
			//System.out.println(totRecCnt);
		}
		
		if(!category.equals("ALL")) {
			totRecCnt = adminService.totRecCntCate(category);
		}
		
		int totPage = (totRecCnt % pageSize)==0 ? totRecCnt/pageSize : (totRecCnt/pageSize) + 1;
		int startIndexNo = (pag - 1) * pageSize;
		int curScrStrarNo = totRecCnt - startIndexNo;
		int blockSize = 3;		// 한블록의 크기를 3개의 Page로 본다.(사용자가 지정한다.)
		int curBlock = (pag - 1) / blockSize;		// 현재페이지의 블록위치
		int lastBlock = (totPage % blockSize)==0 ? ((totPage / blockSize) - 1) : (totPage / blockSize);
		/* 블록페이징처리 끝 */
		
		ArrayList<MembersVO> vos = new ArrayList<MembersVO>();
		
		if(keyword.equals("")) {
			vos = adminService.getMemberList(startIndexNo, pageSize);
		}
		else {
			vos = adminService.getMemberListKeyword(startIndexNo, pageSize, search, keyword);
		}
		
		if(!category.equals("ALL")) {
			vos = adminService.getMemberListCate(startIndexNo, pageSize,category);
		}
		
		model.addAttribute("vos", vos);
		model.addAttribute("pag", pag);
		model.addAttribute("totPage", totPage);
		model.addAttribute("curScrStrarNo", curScrStrarNo);
		model.addAttribute("blockSize", blockSize);
		model.addAttribute("curBlock", curBlock);
		model.addAttribute("lastBlock", lastBlock);
		model.addAttribute("pageSize", pageSize);
		model.addAttribute("category", category);
		model.addAttribute("search", search);
		model.addAttribute("keyword", keyword);
		
		return "admin/admin_memList";
	}
	
	//선택 회원 삭제
	@ResponseBody
	@RequestMapping(value = "/admin_memDel", method = RequestMethod.POST)
	public String admin_memDelPost(String delItems) {
		String[] idxs = delItems.split("/");
		for(String idx : idxs) {
			adminService.memDbDelete(Integer.parseInt(idx));
		}
		return "";
	}
	
	//선택 회원 활동 상태 변경
	@ResponseBody
	@RequestMapping(value="/admin_memChange", method = RequestMethod.POST)
	public String admin_memChangePost(String changeItems, String selectCategory) {
		String[] idxs = changeItems.split("/");
		for(String idx : idxs) {
			adminService.memChange(Integer.parseInt(idx), selectCategory);
		}
		return "";
	}
	
	// 주문 목록 리스트 호출
	@RequestMapping("/admin_orderList")
	public String admin_orderListGet(Model model, String startJumun, String endJumun,
			@RequestParam(name="orderStatus", defaultValue="전체", required=false) String orderStatus,
			@RequestParam(name="pag", defaultValue="1", required=false) int pag,
			@RequestParam(name="pageSize", defaultValue="5", required=false) int pageSize) {
		
		int totRecCnt = adminService.totRecCntAdminOrder();
		
		if(startJumun != null && endJumun != null) {
			totRecCnt = adminService.totRecCntAdminStatus(startJumun, endJumun, orderStatus);
		}
		
		int totPage = (totRecCnt % pageSize)==0 ? totRecCnt/pageSize : (totRecCnt/pageSize) + 1;
		int startIndexNo = (pag - 1) * pageSize;
		int curScrStrarNo = totRecCnt - startIndexNo;
		int blockSize = 3;
		int curBlock = (pag - 1) / blockSize;
		int lastBlock = (totPage % blockSize)==0 ? ((totPage / blockSize) - 1) : (totPage / blockSize);
		
		List<PdDeliverVO> orderVos = adminService.adminOrderList(startIndexNo,pageSize);
		
		if(startJumun != null && endJumun != null) {
			orderVos = adminService.adminOrderSearch(startJumun, endJumun, orderStatus, startIndexNo, pageSize);
		}
		
		model.addAttribute("orderVos", orderVos);
		model.addAttribute("pag", pag);
		model.addAttribute("pageSize", pageSize);
		model.addAttribute("totPage", totPage);
		model.addAttribute("curScrStrarNo", curScrStrarNo);
		model.addAttribute("blockSize", blockSize);
		model.addAttribute("curBlock", curBlock);
		model.addAttribute("lastBlock", lastBlock);
		model.addAttribute("startJumun", startJumun);
		model.addAttribute("endJumun", endJumun);
		model.addAttribute("orderStatus", orderStatus);
		
		return "admin/admin_orderList";
	}
	
	//선택 상품 주문 처리 상태 변경
	@ResponseBody
	@RequestMapping("/admin_orderChange")
	public String admin_orderChangePost(String changeItems, String changeStatus) {
		String[] idxs = changeItems.split("/");
		for(String idx : idxs) {
			adminService.orderStatusChange(Integer.parseInt(idx), changeStatus);
		}
		return "";
	}
	
	//주문 상세보기
	@RequestMapping(value="/orderDeliver", method = RequestMethod.GET)
	public String orderDeliverGet(String orderIdx, Model model) {
		//System.out.println(orderIdx);
		
		List<PdDeliverVO> orderVos = adminService.orderDeliver(orderIdx);
		//System.out.println(orderVos.get(0));
		//System.out.println(orderVos.get(1));
		model.addAttribute("orderVos", orderVos.get(0));
		model.addAttribute("productInfo", orderVos);
		return "admin/orderDeliver";
	}
	
	//상품 목록보기
	@RequestMapping("/admin_pdList")
	public String admin_pdListGet(Model model,
			@RequestParam(name="pag", defaultValue="1", required=false) int pag,
			@RequestParam(name="categoryMainCode", defaultValue="", required=false) String categoryMainCode,
			@RequestParam(name="categoryMiddleCode", defaultValue="", required=false) String categoryMiddleCode,
			@RequestParam(name="pageSize", defaultValue="5", required=false) int pageSize
			) {
		
		int totRecCnt = 0;
		
		/* 페이징 처리 변수 지정 */
		if(categoryMainCode.equals("") && categoryMiddleCode.equals("") ) {
			totRecCnt = shopService.totRecCntPdList();		// 전체자료 갯수 검색
			
		}
		else if(!categoryMainCode.equals("") && categoryMiddleCode.equals("")) {	//대분류로만 검색
			totRecCnt = shopService.totRecCntMainPd(categoryMainCode);
		}
		else if(!categoryMainCode.equals("") && !categoryMiddleCode.equals("")) {	//중분류로 검색
			totRecCnt = shopService.totRecCntMidPd(categoryMiddleCode);
		}
		
		int totPage = (totRecCnt % pageSize)==0 ? totRecCnt/pageSize : (totRecCnt/pageSize) + 1;
		int startIndexNo = (pag - 1) * pageSize;
		int curScrStrarNo = totRecCnt - startIndexNo;
		int blockSize = 3;		// 한블록의 크기를 3개의 Page로 본다
		int curBlock = (pag - 1) / blockSize;		// 현재페이지의 블록위치
		int lastBlock = (totPage % blockSize)==0 ? ((totPage / blockSize) - 1) : (totPage / blockSize);
		
		List<ProductVO> vos = new ArrayList<ProductVO>();
		
		if(categoryMainCode.equals("") && categoryMiddleCode.equals("") ) {
			vos = shopService.getProductList(startIndexNo, pageSize);
		}
		
		else if(!categoryMainCode.equals("") && categoryMiddleCode.equals("")) {	//대분류로만 검색
			vos = shopService.getProductListAdMain(categoryMainCode,startIndexNo, pageSize);
		}
		else if(!categoryMainCode.equals("") && !categoryMiddleCode.equals("")) {	//중분류로 검색
			vos = shopService.getProductListMidAd(categoryMainCode,categoryMiddleCode,startIndexNo, pageSize);
		}
		
		
		//System.out.println("totRecCnt : " + totRecCnt);
		
		model.addAttribute("vos", vos);
		model.addAttribute("pag", pag);
		model.addAttribute("pageSize", pageSize);
		model.addAttribute("totPage", totPage);
		model.addAttribute("curScrStrarNo", curScrStrarNo);
		model.addAttribute("blockSize", blockSize);
		model.addAttribute("curBlock", curBlock);
		model.addAttribute("lastBlock", lastBlock);
		model.addAttribute("totRecCnt", totRecCnt);
		model.addAttribute("categoryMainCode", categoryMainCode);
		model.addAttribute("categoryMiddleCode", categoryMiddleCode);
		
		List<ProductCateVO> mainVos = adminService.getCategoryMain();
		model.addAttribute("mainVos",mainVos);
		
		return "admin/admin_pdList";
	}
	
	//상품 db 삭제
	@ResponseBody
	@RequestMapping(value="/admin_pdDel", method = RequestMethod.POST)
	public String admin_pdDelPost(String delItems) {
		String[] idxs = delItems.split("/");
		for(String idx : idxs) {
			ProductVO vo = adminService.getProduct(Integer.parseInt(idx));
			if(vo.getContent().indexOf("src=\"/") != -1) adminService.imgDelete(vo.getContent());
			adminService.setPdDelete(Integer.parseInt(idx));
		}
		return "";
	}
	
	//상품 상세보기
	@RequestMapping(value="/adminPdDetail", method = RequestMethod.GET)
	public String adminPdDetailGet(int idx, Model model) {
		ProductVO vo = shopService.getProductContent(idx);
		List<PdOptionVO> optionVos = adminService.getPdOption(idx);
		
		model.addAttribute("optionVos",optionVos);
		model.addAttribute("vo", vo);
		return "admin/adminPdDetail";
	}
	
	//상품 수정폼 호출
	@RequestMapping(value="/productEdit", method = RequestMethod.GET)
	public String productEditGet(Model model, int idx) {
		
		ProductVO vo = adminService.getProduct(idx);
		List<ProductCateVO> mainVos = adminService.getCategoryMain();
		List<ProductCateVO> midVos = adminService.getCategoryMiddle();
		
		// 수정작업 처리전에 그림파일이 존재한다면 원본파일을 dbShop폴더로 복사 시켜둔다.
		if(vo.getContent().indexOf("src=\"/") != -1) adminService.imgCheckUpdate(vo.getContent());
		model.addAttribute("vo",vo);
		model.addAttribute("mainVos",mainVos);
		model.addAttribute("midVos",midVos);
		
		return "admin/productEdit";
	}
	
	//수정 내용 DB에 저장
	@RequestMapping(value="/productEdit", method = RequestMethod.POST)
	public String productEditPost(ProductVO vo, MultipartFile file, String fSName) {
		
		String originalFilename = file.getOriginalFilename();
		
		// 원본파일들을 product폴더에서 삭제처리한다.
		if(vo.getOriContent().indexOf("src=\"/") != -1)	adminService.imgDelete(vo.getOriContent());
		
		// 원본파일이 수정폼에 들어올때 product폴더에서 dbShop폴더로 복사해두고, product폴더의 파일은 지웠기에 
		//아래의 복사처리전에 vo.content안의 파일경로 원본파일위치를 product폴더에서 dbShop폴더로 변경처리해줘야한다.
		vo.setContent(vo.getContent().replace("/data/dbShop/product/", "/data/dbShop/"));
		
		//System.out.println("1.vo" + vo.getContent());
		// 수정된 그림파일을 다시 복사처리한다.(수정된 그림파일의 정보는 content필드에 담겨있다.)('/dbShop'폴더 -> '/dbShop/product'폴더로복사) : 처음파일 입력작업과 같은 작업이기에 아래는 처음 입력시의 메소드를 호출했다.
		adminService.imgCheck(vo.getContent());
		//System.out.println("2.vo" + vo.getContent());
		// 필요한 파일을 product폴더로 복사했기에 vo.content의 내용도 변경한다.
		vo.setContent(vo.getContent().replace("/data/dbShop/", "/data/dbShop/product/"));
		//System.out.println("3.vo" + vo.getContent());
		
		if(originalFilename != "" && originalFilename != null) { //메인이미지(original파일) 있을때
			adminService.setProductEditFile(vo, file);
			//System.out.println("0.vo : " + vo);
		}
		else {
			adminService.setProductEdit(vo);
			//System.out.println("1.vo : " + vo);
			//System.out.println("4.vo" + vo.getContent());
		}
		
		//System.out.println("컨트롤러orifile" + originalFilename);
		
		msgFlag = "productEditOk";
		// 잘 정비된 vo값만을 DB에 저장시킨다.
		//adminService.setProductEdit(vo);
		
		return "redirect:/msg/" + msgFlag;
	}
	
	//리뷰 리스트 출력
	@RequestMapping("/admin_reviewList")
	public String admin_reviewListGet(Model model, 
			@RequestParam(name="pag", defaultValue="1", required=false) int pag,
			@RequestParam(name="pageSize", defaultValue="5", required=false) int pageSize) {
		
		/* 페이징 처리 변수 지정 */
		int totRecCnt = adminService.totRecCntReview();		// 전체자료 갯수 검색
		int totPage = (totRecCnt % pageSize)==0 ? totRecCnt/pageSize : (totRecCnt/pageSize) + 1;
		int startIndexNo = (pag - 1) * pageSize;
		int curScrStrarNo = totRecCnt - startIndexNo;
		int blockSize = 3;		// 한블록의 크기를 3개의 Page로 본다
		int curBlock = (pag - 1) / blockSize;		// 현재페이지의 블록위치
		int lastBlock = (totPage % blockSize)==0 ? ((totPage / blockSize) - 1) : (totPage / blockSize);
		
		List<PdReviewVO> vos = adminService.getReviewList(startIndexNo, pageSize);
		
		//System.out.println(vos);
		
		model.addAttribute("vos", vos);
		model.addAttribute("pag", pag);
		model.addAttribute("pageSize", pageSize);
		model.addAttribute("totPage", totPage);
		model.addAttribute("curScrStrarNo", curScrStrarNo);
		model.addAttribute("blockSize", blockSize);
		model.addAttribute("curBlock", curBlock);
		model.addAttribute("lastBlock", lastBlock);
		model.addAttribute("totRecCnt", totRecCnt);
		
		return "admin/admin_reviewList";
	}
	
	//리뷰 상세보기
	@RequestMapping(value="/admin_review", method = RequestMethod.GET)
	public String admin_reviewGet(Model model, HttpSession session, int idx, int productIdx) {
		
		PdReviewVO vo = adminService.getReviewContent(idx);
		int reviewCnt = adminService.getReviewCount(productIdx);
		int reviewRateAvg = adminService.reviewRateAvg(productIdx);
		
		model.addAttribute("vo", vo);
		model.addAttribute("reviewCnt", reviewCnt);
		model.addAttribute("reviewRateAvg", reviewRateAvg);
		//System.out.println(reviewRateAvg);
		
		return "admin/admin_review";
	}
	
	//리뷰 선택삭제
	@ResponseBody
	@RequestMapping(value="/reviewDel", method = RequestMethod.POST)
	public String reviewDelPost(String delItems){
		String[] idxs = delItems.split("/");
		for(String idx : idxs) {
			PdReviewVO vo = adminService.getReviewContent(Integer.parseInt(idx));
			if(vo.getContent().indexOf("src=\"/") != -1) shopService.imgDelete(vo.getContent());
			shopService.reviewDelete(Integer.parseInt(idx));
		}
		return "";
	}
	
	//메인 차트
	@ResponseBody
	@RequestMapping(value="/saleChart", method = RequestMethod.POST)
	public List<PdOrderVO> saleChart() {
		List<PdOrderVO> vos = adminService.saleChart();
		//System.out.println(vos);
		
		return adminService.saleChart();
	}
	
	//메인 차트
	@ResponseBody
	@RequestMapping(value="/amountChart", method = RequestMethod.POST)
	public List<PdOrderVO> amountChart() {
		List<PdOrderVO> vos = adminService.amountChart();
		//System.out.println(vos);
		
		return adminService.amountChart();
	}
	
	
}
