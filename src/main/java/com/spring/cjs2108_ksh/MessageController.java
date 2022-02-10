package com.spring.cjs2108_ksh;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MessageController {
	@RequestMapping(value="/msg/{msgFlag}")
	public String msgGet(@PathVariable String msgFlag, Model model, HttpSession session) {
		String nickName = session.getAttribute("sNickName") == null? "" : (String) session.getAttribute("sNickName");
		String strLevel = session.getAttribute("sStrLevel") == null? "" : (String) session.getAttribute("sStrLevel"); 
		
		if(msgFlag.equals("memEmailCheckNo")) {
			model.addAttribute("msg", "이미 가입된 이메일입니다.");
		}
		
		else if(msgFlag.equals("memNickNameCheckNo")) {
			model.addAttribute("msg", "이미 가입된 닉네임입니다.");
		}
		
		else if(msgFlag.equals("memberJoinOk")) {
			model.addAttribute("msg", "회원 가입이 완료되었습니다.");
			model.addAttribute("url", "member/memberLogin");
		}
		
		else if(msgFlag.equals("memberJoinNo")) {
			model.addAttribute("msg", "회원 가입이 되지 않았습니다.");
			model.addAttribute("url", "member/memberLogin");
		}
		
		else if(msgFlag.equals("memberLoginOk")) {
			model.addAttribute("msg", nickName + "님("+strLevel+") 로그인 되었습니다.");
			model.addAttribute("url", "main");
		}
		
		else if(msgFlag.equals("memberLoginNo")) {
			model.addAttribute("msg", "이메일과 비밀번호를 확인하세요.");
			model.addAttribute("url", "member/memberLogin");
		}
		
		else if(msgFlag.equals("memberLogout")) {
			session.invalidate();
			model.addAttribute("msg", nickName + "님 로그아웃 되었습니다.");
			model.addAttribute("url", "main");
		}
		
		else if(msgFlag.equals("boardWriteOk")) {
			model.addAttribute("msg", "글이 등록되었습니다.");
			model.addAttribute("url", "board/boardList");
		}
		
		else if(msgFlag.equals("memberNo")) {
			model.addAttribute("msg", "이용 가능한 회원 등급이 아닙니다.");
			model.addAttribute("url", "main");
		}
		
		else if(msgFlag.equals("loginNo")) {
			model.addAttribute("msg", "로그인한 뒤 이용해 주세요.");
			model.addAttribute("url", "member/memberLogin");
		}
		
		else if(msgFlag.equals("productRegiesterOk")) {
			model.addAttribute("msg", "상품이 등록되었습니다.");
			model.addAttribute("url", "admin/productRegister");
		}
		
		else if(msgFlag.equals("setPdOptionInput")) {
			model.addAttribute("msg", "옵션이 등록되었습니다.");
			model.addAttribute("url", "admin/pdOptionRegister");
		}
		
		else if(msgFlag.equals("orderRegisterOk")) {
			model.addAttribute("msg", "주문이 완료되었습니다.");
			model.addAttribute("url", "shop/pdOrderConfirm");
		}
		
		else if(msgFlag.equals("orderRegisterOk2")) {
			model.addAttribute("msg", "주문이 완료되었습니다.");
			model.addAttribute("url", "shop/pdOrderConfirm2");
		}
		
		else if(msgFlag.equals("reviewInputNo")) {
			model.addAttribute("msg", "리뷰 등록 오류");
			model.addAttribute("url", "shop/shopContent");
		}
		
		else if(msgFlag.equals("memUpdateOk")) {
			model.addAttribute("msg", "회원 정보가 수정되었습니다.");
			model.addAttribute("url", "main");
		}
		
		else if(msgFlag.equals("memUpdateNo")) {
			model.addAttribute("msg", "회원 정보 수정 오류");
			model.addAttribute("url", "member/memberEdit");
		}
		
		else if(msgFlag.equals("memDeleteOk")) {
			session.invalidate();
			model.addAttribute("msg", "회원 탈퇴되었습니다.");
			model.addAttribute("url", "main");
		}
		
		else if(msgFlag.equals("productEditOk")) {
			model.addAttribute("msg", "상품이 수정되었습니다");
			model.addAttribute("url", "admin/admin_pdList");
		}
		
		else if(msgFlag.equals("pwdConfirmNo")) {
			model.addAttribute("msg", "이메일을 다시 확인해주세요");
			model.addAttribute("url", "member/pwdConfirm");
		}
		
		else if(msgFlag.equals("pwdConfirmOk")) {
			model.addAttribute("msg", "임시 비밀번호가 메일로 발급되었습니다.\\n해당 비밀번호로 로그인해주세요");
			model.addAttribute("url", "member/memberLogin");
		}

		else if(msgFlag.substring(0,11).equals("boardEditOk")) {
			model.addAttribute("msg", "게시글이 수정되었습니다.");
			model.addAttribute("url", "board/boardContent?" + msgFlag.substring(12));
		}
		
		else if(msgFlag.substring(0,13).equals("boardDeleteOk")) {
			model.addAttribute("msg", "게시글이 삭제되었습니다.");
			model.addAttribute("url", "board/boardList?" + msgFlag.substring(14));
		}
		

		else if(msgFlag.substring(0,13).equals("reviewInputOk")) {
			model.addAttribute("msg", "리뷰가 등록되었습니다.");
			model.addAttribute("url", "shop/shopContent?idx="+msgFlag.substring(13));
			System.out.println(msgFlag.substring(0,13));
			System.out.println(msgFlag.substring(13));
		}
		
		return "include/message";
	}
}
