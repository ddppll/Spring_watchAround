package com.spring.cjs2108_ksh;

import java.util.UUID;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.cjs2108_ksh.service.MembersService;
import com.spring.cjs2108_ksh.vo.MembersVO;

@Controller
@RequestMapping("/member")
public class MembersController {
	String msgFlag = "";
	
	@Autowired
	MembersService membersService;
	
	@Autowired
	BCryptPasswordEncoder passwordEncoder;
	
	//회원 이메일 검색(중복체크)
	@ResponseBody
	@RequestMapping(value="/emailCheck", method = RequestMethod.POST)
	public String emailCheckPost(String email) {
		String res = "0";
		MembersVO vo = membersService.getEmailCheck(email);
		if(vo != null) res = "1";
		return res;
	}
	
	//회원 닉네임 검색(중복체크)
	@ResponseBody
	@RequestMapping(value="/nickNameCheck", method = RequestMethod.POST)
	public String nickNameCheckPost(String nickName) {
		String res = "0";
		MembersVO vo = membersService.getNickNameCheck(nickName);
		if(vo != null) res = "1";
		return res;
	}
	
	//회원 가입 처리
	@RequestMapping(value="/memberJoin", method = RequestMethod.POST)
	public String memberJoinPost(MembersVO vo, HttpServletResponse response, HttpServletRequest request){
		//이메일 중복체크
		if(membersService.getEmailCheck(vo.getEmail()) != null) {
			msgFlag = "memEmailCheckNo";
			return "redirect:/msg/" + msgFlag;
		}
		if(membersService.getNickNameCheck(vo.getNickName()) != null) {
			msgFlag = "memNickNameCheckNo";
			return "redirect:/msg/"+msgFlag;
		}
		
		String cellphone = request.getParameter("cellphone")==null ? "": request.getParameter("cellphone").trim();
		String cellphone2 = request.getParameter("cellphone2")==null ? "": request.getParameter("cellphone2").trim();
		String cellphone3 = request.getParameter("cellphone3")==null ? "": request.getParameter("cellphone3").trim();
		String cellNumber = cellphone + "/" + cellphone2 + "/" + cellphone3;
		
		vo.setTel(cellNumber);
		
		//비밀번호 암호화
		vo.setPwd(passwordEncoder.encode(vo.getPwd()));
		
		//DB에 회원 등록
		int res = membersService.memberJoin(vo);
		
		if(res == 1) msgFlag = "memberJoinOk";
		else msgFlag = "memberJoinNo";
			
		return "redirect:/msg/" + msgFlag;
	}
	
	//로그인폼 호출
	@RequestMapping(value="/memberLogin", method = RequestMethod.GET)
	public String memberLoginGet(HttpServletRequest request) {
		// 로그인폼 호출시 기존에 저장된 쿠키가 있으면 불러올수 있게 한다.
		Cookie[] cookies = request.getCookies();	// 기존에 저장된 현재 사이트의 쿠키를 불러와서 배열로 저장한다.
		String email = "";
		for(int i=0; i<cookies.length; i++) {
			if(cookies[i].getName().equals("cEmail")) {
				email = cookies[i].getValue();
				request.setAttribute("email", email);
				break;
			}
		}
		return "member/memberLogin";
	}
	
	//로그인
	@RequestMapping(value="/memberLogin", method = RequestMethod.POST)
	public String memberLoginPost(String email, String pwd, HttpSession session, HttpServletResponse response, HttpServletRequest request) {
		MembersVO vo = membersService.getEmailCheck(email);
		
		if(vo != null && passwordEncoder.matches(pwd, vo.getPwd()) && vo.getUserDel().equals("NO")) {
			String strLevel = ""; //0레벨 관리자
			if(vo.getLevel() == 0) strLevel = "관리자";
			else if(vo.getLevel() == 1) strLevel = "정회원";
			
			session.setAttribute("sEmail", email);
			session.setAttribute("sNickName", vo.getNickName());
			session.setAttribute("sLevel", vo.getLevel());
			session.setAttribute("sStrLevel", strLevel);
			
			
			//이메일 쿠키 저장
			String emailSave = request.getParameter("emailSave")==null? "" : request.getParameter("emailSave");
			//이메일 쿠키 처리
			if(emailSave.equals("on")) { //이메일 저장 체크시
				Cookie cookie = new Cookie("cEmail", email);
				cookie.setMaxAge(60*60*24*2); // 쿠키 만료 시간 : 2일
				response.addCookie(cookie);
			}
			else {	//이메일 저장 체크 해제시
				Cookie[] cookies = request.getCookies(); 	//기존 쿠키 호출해서 배열에 저장
				for(int i=0; i<cookies.length; i++) {
					if(cookies[i].getName().equals("cEmail")) {
						cookies[i].setMaxAge(0);	// 배열 for문 돌려서 저장된 쿠키명 중 cEmail이 있으면 찾아서 삭제
						response.addCookie(cookies[i]);
						break;
					}
				}
			}
			//로그인한 뒤 방문수/최종방문일자/마지막방문시간 업데이트
			membersService.visitUpdate(email);
			msgFlag = "memberLoginOk";
		}
		else {
			msgFlag = "memberLoginNo";
		}
		return "redirect:/msg/" + msgFlag;
	}
	
	//로그아웃
	@RequestMapping("/memberLogout")
	public String memberLogoutGet() {
		msgFlag = "memberLogout";
		return "redirect:/msg/" + msgFlag;
	}
	
	//비밀번호 찾기 창 호출
	@RequestMapping(value="/pwdConfirm", method = RequestMethod.GET)
	public String pwdConfirmGet(Model model, HttpSession session) {
		String email = (String) session.getAttribute("sEmail");
		
		model.addAttribute("email", email);
		return "member/pwdConfirm";
	}
	
	//회원 정보 수정폼 호출
	@RequestMapping(value="/memberEdit", method = RequestMethod.GET)
	public String memberEditGet(Model model, HttpSession session) {
		String email = (String) session.getAttribute("sEmail");
		MembersVO vo = membersService.getEmailCheck(email);
		//System.out.println(vo);
		model.addAttribute("vo", vo);
		return "member/memberEdit";
	}
	
	//회원 정보 수정
	@RequestMapping(value="/memberEdit")
	public String memberEditPost(MembersVO vo, HttpSession session, HttpServletResponse response, HttpServletRequest request) {
		
		String cellphone = request.getParameter("cellphone")==null ? "": request.getParameter("cellphone").trim();
		String cellphone2 = request.getParameter("cellphone2")==null ? "": request.getParameter("cellphone2").trim();
		String cellphone3 = request.getParameter("cellphone3")==null ? "": request.getParameter("cellphone3").trim();
		String cellNumber = cellphone + "/" + cellphone2 + "/" + cellphone3;
		vo.setTel(cellNumber);
		
		String nickName = (String) session.getAttribute("sNickName");
		//닉네임 중복체크하기(닉네임이 변경되었으면 새 닉네임을 세션에 등록)
		if(!nickName.equals(vo.getNickName())) {
			if(membersService.getNickNameCheck(vo.getNickName()) != null) {
				msgFlag = "memNickNameCheckNo";
				return "redirect:/msg/"+msgFlag;
			}
			else {
				session.setAttribute("sNickName", vo.getNickName());
			}
		}
		
		vo.setPwd(passwordEncoder.encode(vo.getPwd()));
		
		int res = membersService.setMemEdit(vo);
		
		if(res==1) {
			msgFlag = "memUpdateOk";
		}
		else {
			msgFlag = "memUpdateNo";
		}
		
		return "redirect:/msg/" + msgFlag;
	}
	
	//탈퇴처리
	@RequestMapping(value="/memDelete", method = RequestMethod.GET)
	public String memDeleteGet(HttpSession session) {
		String email = (String)session.getAttribute("sEmail");
		membersService.setMemDelete(email);
		msgFlag = "memDeleteOk";
		return "redirect:/msg/" + msgFlag;
	}
	
	//임시 비번 발급해서 메일로 보내기
	@RequestMapping("/pwdConfirm")
	public String pwdConfirmPost(String toMail) {
		MembersVO vo = membersService.getPwdConfirm(toMail);
		if(vo != null) {
			//임시 비번 만들기
			UUID uid = UUID.randomUUID();
			String pwd = uid.toString().substring(0,8);
			//pwd = passwordEncoder.encode(pwd);
			membersService.setPwdChange(toMail, passwordEncoder.encode(pwd));
			String content = pwd;
			return "redirect:/mail/pwdConfirmSend/"+toMail+"/"+content+"/";	//mail컨트롤러에 보내서 메일로 비번 보내줌
		} else {
			msgFlag = "pwdConfirmNo";
			return "redirect:/msg/" + msgFlag;
		}
	}
}
