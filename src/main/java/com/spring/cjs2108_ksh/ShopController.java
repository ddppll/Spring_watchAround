package com.spring.cjs2108_ksh;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.spring.cjs2108_ksh.service.AdminService;
import com.spring.cjs2108_ksh.service.MembersService;
import com.spring.cjs2108_ksh.service.ShopService;
import com.spring.cjs2108_ksh.vo.GoodsVO;
import com.spring.cjs2108_ksh.vo.MembersVO;
import com.spring.cjs2108_ksh.vo.PdCartListVO;
import com.spring.cjs2108_ksh.vo.PdDeliverVO;
import com.spring.cjs2108_ksh.vo.PdImmediateOrderVO;
import com.spring.cjs2108_ksh.vo.PdOptionVO;
import com.spring.cjs2108_ksh.vo.PdOrderVO;
import com.spring.cjs2108_ksh.vo.PdReviewVO;
import com.spring.cjs2108_ksh.vo.ProductVO;

@Controller
@RequestMapping("/shop")
public class ShopController {
	String msgFlag = "";
	
	@Autowired
	ShopService shopService;
	
	@Autowired
	AdminService adminService;
	
	@Autowired
	MembersService membersSerivce;
	
	//상품 리스트
	@RequestMapping(value="/productList", method = RequestMethod.GET)
	public String productListGet(@RequestParam(name="mainCate", defaultValue = "", required = false) String mainCate,
			@RequestParam(name="midCate", defaultValue = "", required = false) String midCate,
			@RequestParam(name="pag", defaultValue="1", required=false) int pag,
			@RequestParam(name="pageSize", defaultValue="12", required=false) int pageSize,
			Model model) {
		
		//System.out.println("mainCate : " + mainCate + " / midCate : " + midCate);
		
		int totRecCnt = 0;
		/* 페이징 처리 변수 지정 */
		if(mainCate.equals("")) {
			totRecCnt = shopService.totRecCntPdList();		// 전체자료 갯수 검색
		}
		else {
			totRecCnt = shopService.totRecCntPdListCate(mainCate, midCate);
		}
		int totPage = (totRecCnt % pageSize)==0 ? totRecCnt/pageSize : (totRecCnt/pageSize) + 1;
		int startIndexNo = (pag - 1) * pageSize;
		int curScrStrarNo = totRecCnt - startIndexNo;
		int blockSize = 3;		// 한블록의 크기를 3개의 Page로 본다
		int curBlock = (pag - 1) / blockSize;		// 현재페이지의 블록위치
		int lastBlock = (totPage % blockSize)==0 ? ((totPage / blockSize) - 1) : (totPage / blockSize);
		
		List<ProductVO> vos = new ArrayList<ProductVO>();
		
		if(mainCate.equals("")) {
			vos = shopService.getProductList(startIndexNo, pageSize);
		}
		else {
			vos = shopService.getProductListCate(startIndexNo, pageSize, mainCate, midCate);
		}
		
		List<ProductVO> cateMainVos = shopService.getCateMainName();
		model.addAttribute("cateMainVos",cateMainVos);
		model.addAttribute("vos",vos);
		model.addAttribute("mainCate",mainCate);
		model.addAttribute("pag", pag);
		model.addAttribute("pageSize", pageSize);
		model.addAttribute("totPage", totPage);
		model.addAttribute("curScrStrarNo", curScrStrarNo);
		model.addAttribute("blockSize", blockSize);
		model.addAttribute("curBlock", curBlock);
		model.addAttribute("lastBlock", lastBlock);
		
		return "shop/productList";
	}
	
	//상품 상세보기
	@RequestMapping(value="/shopContent", method = RequestMethod.GET)
	public String shopContentGet(int idx, Model model, HttpSession session,
			@RequestParam(name="pag", defaultValue="1", required=false) int pag,
			@RequestParam(name="pageSize", defaultValue="5", required=false) int pageSize
			) {
		ProductVO productVo = shopService.getProductContent(idx);
		
		String email = (String)session.getAttribute("sEmail");
		int totRecCnt = shopService.totRecCntReview(idx);
		/* 이곳부터 페이징 처리(블록페이지) 변수 지정 시작 */
		/*int totRecCnt = shopService.totRecCntReview(idx);
		int totPage = (totRecCnt % pageSize)==0 ? totRecCnt/pageSize : (totRecCnt/pageSize) + 1;
		int startIndexNo = (pag - 1) * pageSize;
		int curScrStrarNo = totRecCnt - startIndexNo;
		int blockSize = 3;
		int curBlock = (pag - 1) / blockSize;
		int lastBlock = (totPage % blockSize)==0 ? ((totPage / blockSize) - 1) : (totPage / blockSize);*/
		/* 블록페이징처리 끝 */
		List<PdOptionVO> optionVos = adminService.getPdOption(idx);
		//List<PdReviewVO> reviewVos = shopService.getReview(startIndexNo, pageSize, idx);
		List<PdReviewVO> reviewVos = shopService.getReview(idx);
		//System.out.println(idx);
		GoodsVO goodsVo = shopService.getGoods(idx, email);
		
		int goodsCnt = shopService.goodsCnt(idx);
		
		model.addAttribute("reviewVos", reviewVos);
		model.addAttribute("sEmail", email);
		model.addAttribute("optionVos",optionVos);
		model.addAttribute("productVo", productVo);
		model.addAttribute("goodsVo", goodsVo);
		model.addAttribute("totRecCnt", totRecCnt);
		model.addAttribute("goodsCnt", goodsCnt);
		
		return "shop/shopContent";
	}
	
	//장바구니 보내기
	@RequestMapping(value="/shopContent", method = RequestMethod.POST)
	public String shopContentPost(Model model, PdImmediateOrderVO immeVo, String immeOrder, PdCartListVO vo, HttpSession session) {
		String email = (String)session.getAttribute("sEmail");
		
		if(immeOrder.equals("immeOrderOk")) {
			
			String[] voOptionNums = immeVo.getOptionNum().split(",");
			
			int[] nums = new int[99];
			String strNums = "";
			for(int i=0; i<voOptionNums.length; i++) {
				nums[i] += (Integer.parseInt(voOptionNums[i]));
				strNums += nums[i];
				if(i < nums.length - 1) strNums += ",";
			}
			immeVo.setOptionNum(strNums);
			
			PdOrderVO orderVos = new PdOrderVO();
			
			String salerate = shopService.getSaleInfo(immeVo.getProductIdx());
			int mainPrice = shopService.getMainPrice(immeVo.getProductIdx());
			//System.out.println("salerate:" + salerate);
			//System.out.println("mainPrice:" + mainPrice);
			
			orderVos.setProductIdx(immeVo.getProductIdx());
			orderVos.setProductName(immeVo.getProductName());
			orderVos.setMainPrice(immeVo.getMainPrice());
			orderVos.setThumbImg(immeVo.getThumbImg());
			orderVos.setOptionName(immeVo.getOptionName());
			orderVos.setOptionPrice(immeVo.getOptionPrice());
			orderVos.setOptionNum(immeVo.getOptionNum());
			orderVos.setTotalPrice(immeVo.getTotalPrice());
			orderVos.setSaleRate(salerate);
			orderVos.setCostPrice(mainPrice);
			orderVos.setCartIdx(immeVo.getIdx());
			
			session.setAttribute("orderVos", orderVos);
			
			//로그인한 유저 정보 가져와서 vo에 담기
			MembersVO membersVo = membersSerivce.getEmailCheck(session.getAttribute("sEmail").toString());
			model.addAttribute("membersVo", membersVo);
			
			//주문 고유번호 만들기 - 기존 고유번호 최대값 +1
			PdOrderVO maxIdx = shopService.getOrderMaxIdx();
			int idx = 1;
			if(maxIdx != null) idx = maxIdx.getMaxIdx() + 1;
			
			//주문번호 = 날짜_idx
			Date today = new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
			String orderIdx = sdf.format(today) + idx;
			model.addAttribute("orderIdx", orderIdx);
			
			orderVos.setOrderIdx(orderIdx);
			orderVos.setEmail(email);
			
			//System.out.println("orderVos : "+orderVos);
			
			return "shop/pdOrder2";
		}
		
		else {
			//지금 추가하는 게 기존 장바구니에 있었다면 기존 장바구니에 update 시켜줌. 새로운 상품이면 insert 시켜줌
			// 기존 장바구니에 있는지 확인하기 위해 상품명과 옵션명을 넘겨서 장바구니 내용 검색해옴
			PdCartListVO resVo = shopService.cartListPdOptionSearch(vo.getProductName(), vo.getOptionName(), email);
			//System.out.println("resVo : " + resVo);
			if(resVo != null) {	// 기존 장바구니에 뭐 있으면 update 시켜주기
				String[] voOptionNums = vo.getOptionNum().split(",");
				String[] resOptionNums = resVo.getOptionNum().split(",");	// 기존 db에 저장되어있던 장바구니 resVo
				int[] nums = new int[99];
				String strNums = "";
				for(int i=0; i<voOptionNums.length; i++) {
					nums[i] += (Integer.parseInt(voOptionNums[i]) + Integer.parseInt(resOptionNums[i]));
					strNums += nums[i];
					if(i < nums.length - 1) strNums += ",";
				}
				vo.setOptionNum(strNums);
				shopService.cartListUpdate(vo);
			}
			else {	//장바구니에 담긴 게 없을 때 insert 시키기
				shopService.cartListInput(vo);
			}
			return "redirect:/shop/pdCartList";
		}
	}
	
	//장바구니 목록 보기
	@RequestMapping(value="/pdCartList", method = RequestMethod.GET)
	public String PdCartListGet(HttpSession session, PdCartListVO vo, Model model) {
		String email = (String)session.getAttribute("sEmail");
		List<PdCartListVO> vos = shopService.getPdCartList(email);
		model.addAttribute("cartListVos", vos);
		return "shop/pdCartList";
	}
	
	//장바구니 비우기
	@ResponseBody
	@RequestMapping(value="/cartAllDel", method = RequestMethod.GET)
	public String cartAllDelGet(HttpSession session) {
		String email = (String)session.getAttribute("sEmail");
		shopService.cartAllDel(email);
		return "";
	}
	
	// 장바구니 품목 삭제 - 버튼
	@ResponseBody
	@RequestMapping(value="/cartDel", method = RequestMethod.POST)
	public String cartDelPost(int idx) {
		shopService.cartDel(idx);
		return "";
	}
	
	// 장바구니 체크 삭제 - 체크박스
	@ResponseBody
	@RequestMapping(value="/cartSelectDel", method = RequestMethod.POST)
	public String cartSelectDelPost(String delItems) {
		String[] idxs = delItems.split("/");
		for(String idx : idxs) {
			shopService.cartDel(Integer.parseInt(idx));
		}
		return "";
	}
	
	// 장바구니 품목 수량 변경
	@ResponseBody
	@RequestMapping(value="/cartPdNumChange", method = RequestMethod.POST)
	public String cartPdNumChangePost(HttpSession session, int idx, int num, String totalPrice) {
		//System.out.println("num : " + num );
		String email = (String)session.getAttribute("sEmail");
		shopService.cartPdNumChange(idx, num, totalPrice, email);
		
		return "";
	}
	
	//주문 페이지 폼 호출
	@RequestMapping(value="/pdCartList", method = RequestMethod.POST)
	public String PdCartListPost(HttpServletRequest request, Model model, HttpSession session) {
		
		String[] idxChecked = request.getParameterValues("idxChecked");
		PdCartListVO cartVo = new PdCartListVO();
		List<PdOrderVO> orderVos = new ArrayList<PdOrderVO>();
		
		for(String idx : idxChecked) {
			cartVo = shopService.getCartIdx(idx);	//장바구니에 담아둔거 다 가져오기
			PdOrderVO orderVo = new PdOrderVO();
			orderVo.setProductIdx(cartVo.getProductIdx());
			orderVo.setProductName(cartVo.getProductName());
			orderVo.setMainPrice(cartVo.getMainPrice());
			orderVo.setThumbImg(cartVo.getThumbImg());
			orderVo.setOptionName(cartVo.getOptionName());
			orderVo.setOptionPrice(cartVo.getOptionPrice());
			orderVo.setOptionNum(cartVo.getOptionNum());
			orderVo.setTotalPrice(cartVo.getTotalPrice());
			orderVo.setSaleRate(cartVo.getSaleRate());
			orderVo.setCostPrice(cartVo.getCostPrice());
			orderVo.setCartIdx(cartVo.getIdx());
			orderVos.add(orderVo);
		}
		//System.out.println("orderVos : " + orderVos);
		session.setAttribute("orderVos", orderVos);
		
		//로그인한 유저 정보 가져와서 vo에 담기
		MembersVO membersVo = membersSerivce.getEmailCheck(session.getAttribute("sEmail").toString());
		model.addAttribute("membersVo", membersVo);
		
		//주문 고유번호 만들기 - 기존 고유번호 최대값 +1
		PdOrderVO maxIdx = shopService.getOrderMaxIdx();
		int idx = 1;
		if(maxIdx != null) idx = maxIdx.getMaxIdx() + 1;
		
		//주문번호 = 날짜_idx
		Date today = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		String orderIdx = sdf.format(today) + idx;
		model.addAttribute("orderIdx", orderIdx);
		
		return "shop/pdOrder";
	}
	
	//주문 내역 DB 저장
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/orderInput", method = RequestMethod.POST)
	public String orderInputPost(HttpSession session, PdOrderVO orderVo, PdDeliverVO deliverVo) {
		//System.out.println("orderVo : " + orderVo);
		List<PdOrderVO> orderVos = (List<PdOrderVO>) session.getAttribute("orderVos");
		for(PdOrderVO vo : orderVos) {
			vo.setIdx(Integer.parseInt(deliverVo.getOrderIdx().substring(8))); //주문테이블에 고유번호 set
			vo.setOrderIdx(deliverVo.getOrderIdx());	//주문번호 set
			vo.setEmail(deliverVo.getEmail());
			
			shopService.setPdOrder(vo);				  //주문한 내용을 주문 테이블에 저장
			shopService.delCartList(vo.getCartIdx()); //주문 끝나면 장바구니에서 주문 내역 삭제
		}
		deliverVo.setOIdx(shopService.getOrderOIdx(deliverVo.getOrderIdx())); //주문테이블 고유번호 가져와서 배송vo에 set
		//System.out.println("deliverVo : " +deliverVo);
		shopService.setDbDeliver(deliverVo);	//배송 테이블에 배송 내역 저장
		
		msgFlag = "orderRegisterOk";
		
		return "redirect:/msg/" + msgFlag;
	}
	
	//주문 완료 후 확인창
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/pdOrderConfirm")
	public String pdOrderConfirmGet(String orderIdx, HttpSession session, Model model) {
		List<PdOrderVO> vos = (List<PdOrderVO>) session.getAttribute("orderVos");
		
		List<PdDeliverVO> dVos = shopService.getDelivery(vos.get(0).getEmail());
		
		model.addAttribute("vos", vos);
		model.addAttribute("dVo", dVos.get(dVos.size()-1));
		//System.out.println(dVos);
		return "shop/pdOrderConfirm";
	}
	
	//주문 내역 DB 저장 - 바로주문
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/orderInput2", method = RequestMethod.POST)
	public String orderInput2Post(HttpSession session, PdOrderVO orderVo, PdDeliverVO deliverVo) {
		
		PdOrderVO orderVos = (PdOrderVO) session.getAttribute("orderVos");
		//System.out.println("orderVos1 : " + orderVos);
		
		orderVos.setIdx(Integer.parseInt(deliverVo.getOrderIdx().substring(8))); //주문테이블에 고유번호 set
		
		orderVos.setOrderIdx(deliverVo.getOrderIdx());	//주문번호 set
		orderVos.setEmail(deliverVo.getEmail());
			
		shopService.setPdOrder(orderVos);				  //주문한 내용을 주문 테이블에 저장
		//System.out.println("orderVos2 : " + orderVos);
		
		deliverVo.setOIdx(shopService.getOrderOIdx(deliverVo.getOrderIdx())); //주문테이블 고유번호 가져와서 배송vo에 set
		//System.out.println("deliverVo : " +deliverVo);
		shopService.setDbDeliver(deliverVo);	//배송 테이블에 배송 내역 저장
		//System.out.println("deliverVo : " + deliverVo);
		msgFlag = "orderRegisterOk2";
		
		return "redirect:/msg/" + msgFlag;
	}
	
	//주문 완료 후 확인창 - 바로주문
	@RequestMapping(value="/pdOrderConfirm2")
	public String pdOrderConfirm2Get(String orderIdx, Model model, HttpSession session) {
		PdOrderVO vos = (PdOrderVO) session.getAttribute("orderVos");
		List<PdDeliverVO> dVos = shopService.getDelivery(vos.getEmail());
		model.addAttribute("vos", vos);
		model.addAttribute("dVo", dVos.get(dVos.size()-1));
		//System.out.println(vos);
		return "shop/pdOrderConfirm2";
	}
	
	//구매내역
	@RequestMapping(value="/pdMyOrder", method = RequestMethod.GET)
	public String pdMyOrderGet(HttpServletRequest request, HttpSession session, Model model,
			String startJumun, String endJumun, String orderStatus,
			@RequestParam(name="pag", defaultValue="1", required=false) int pag,
			@RequestParam(name="pageSize", defaultValue="5", required=false) int pageSize) {
		
		String email = (String) session.getAttribute("sEmail");
		
		int totRecCnt = shopService.totRecCnt(email);		// 전체자료 갯수 검색
		if(startJumun != null && endJumun != null) {
			totRecCnt = shopService.totRecCntStatusDate(email, startJumun, endJumun);
		}
		else if(startJumun == null && endJumun == null && orderStatus == null) {
			totRecCnt = shopService.totRecCntBasic(email);
		}
		else if(orderStatus != null) {
			totRecCnt = shopService.totRecCntStatus(email, orderStatus);
		}
		int totPage = (totRecCnt % pageSize)==0 ? totRecCnt/pageSize : (totRecCnt/pageSize) + 1;
		int startIndexNo = (pag - 1) * pageSize;
		int curScrStrarNo = totRecCnt - startIndexNo;
		int blockSize = 3;		// 한블록의 크기를 3개의 Page로 본다.(사용자가 지정한다.)
		int curBlock = (pag - 1) / blockSize;		// 현재페이지의 블록위치
		int lastBlock = (totPage % blockSize)==0 ? ((totPage / blockSize) - 1) : (totPage / blockSize);
		
		
		List<PdDeliverVO> myOrderVos = shopService.getMyOrder(startIndexNo, pageSize, email);
		if(startJumun != null && endJumun != null) {
			myOrderVos = shopService.getOrderByDate(startIndexNo, pageSize, email, startJumun, endJumun);
		}
		else if(startJumun == null && endJumun == null && orderStatus == null) {
			myOrderVos = shopService.getOrderBasic(startIndexNo, pageSize, email);
		}
		else if(orderStatus != null) {
			myOrderVos = shopService.getOrderStatus(startIndexNo, pageSize, email, orderStatus);
		}
		
		List<PdOrderVO> statusVos = shopService.getOrderStatus1(email);
		
		model.addAttribute("myOrderVos", myOrderVos);
		model.addAttribute("statusVos", statusVos);
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
		
		return "shop/pdMyOrder";
	}
	
	// 배송지 정보 보여주기
		@RequestMapping(value="/orderDelivery", method=RequestMethod.GET)
		public String orderDeliveryGet(String orderIdx, Model model) {
			List<PdDeliverVO> vos = shopService.getOrderDeliveryInfo(orderIdx);  // 같은 주문번호가 2개 이상 있을수 있기에 List객체로 받아옴
			model.addAttribute("vo", vos.get(0));  // 같은 배송지면 0번째 하나만 vo에 담아서 넘겨주면 됨
			//System.out.println(vos);
			return "shop/orderDelivery";
		}
		
		//구매 이력 확인
		@ResponseBody
		@RequestMapping(value="/orderCheck", method = RequestMethod.POST)
		public String orderCheckPost(String email, int productIdx) {
			String res = "0";
			PdOrderVO vo = shopService.orderCheck(email, productIdx);
			//System.out.println(vo);
			if(vo == null) res = "1";
			
			return res;
		}
		
		//리뷰 입력
		@RequestMapping(value="/reviewInput", method = RequestMethod.POST)
		public String reviewInputPost(MultipartFile fName, PdReviewVO vo) {
			
			int res = shopService.reviewInput(fName, vo);
			int idx = vo.getProductIdx();
			if(res == 1) msgFlag = "reviewInputOk" + idx;
			else msgFlag = "reviewInputNo";
			
			return "redirect:/msg/"+msgFlag;
		}
		
		//리뷰 삭제
		@ResponseBody
		@RequestMapping(value="/reviewDelete", method = RequestMethod.POST)
		public String reviewDeletePost(int idx) {
			//리뷰에 사진 있으면 사진파일도 삭제
			PdReviewVO vo = shopService.getReviewContent(idx);
			if(vo.getContent().indexOf("src=\"/") != -1) shopService.imgDelete(vo.getContent());
			
			//DB에서 리뷰 최종 삭제
			shopService.reviewDelete(idx);
			return "";
		}
		
		//상품 찜하기
		@ResponseBody
		@RequestMapping(value="/shopLike", method = RequestMethod.POST)
		public String shopLikePost(int idx, String email) {
			GoodsVO vo = shopService.getGoods(idx, email);
			//System.out.println(vo);
			//System.out.println(email);
			if(vo != null) shopService.resetLike(idx, email);
			else {
				shopService.plusLike(idx,email);
			}
			
			return "";
		}
		
		//찜목록
		@RequestMapping(value="/myGoods", method = RequestMethod.GET)
		public String myGoodsGet(HttpSession session, Model model) {
			
			String email = (String)session.getAttribute("sEmail");
			
			//전체 목록 가져오기
			List<ProductVO> vos = shopService.getGoodProduct(email);
			
			//좋아요 best 3 productIdx 가져오기
			int[] mostIdx = shopService.getBest3Idx();
			
			//가져온 productIdx의 product 정보 가져오기
			List<ProductVO> mostVos = new ArrayList<ProductVO>();
			for(int idx : mostIdx) {
				mostVos.add(shopService.getBest3Product(idx));
			}
			
			model.addAttribute("vos", vos);
			model.addAttribute("mostVos", mostVos);
			
			return "shop/myGoods";
		}
		
		//선택 찜목록 삭제
		@ResponseBody
		@RequestMapping(value="/goodsDel", method = RequestMethod.POST)
		public String goodsDelPost(String delItems, String email) {
			String[] idxs = delItems.split("/");
			for(String idx : idxs) {
				shopService.resetLike(Integer.parseInt(idx), email);
			}
			return "";
		}
}
