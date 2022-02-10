package com.spring.cjs2108_ksh;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.cjs2108_ksh.service.BoardService;
import com.spring.cjs2108_ksh.vo.BoardReplyVO;
import com.spring.cjs2108_ksh.vo.BoardVO;

@Controller
@RequestMapping("/board")
public class BoardController {
	String msgFlag = "";
	
	@Autowired
	BoardService boardService;
	
	//게시판 목록 호출
	@RequestMapping(value="/boardList", method = RequestMethod.GET)
	public String boardListGet(
			@RequestParam(name="pag", defaultValue="1", required=false) int pag,
			@RequestParam(name="pageSize", defaultValue="15", required=false) int pageSize,
			@RequestParam(name="search_target", defaultValue="", required=false) String search_target,
			@RequestParam(name="searchString", defaultValue="", required=false) String searchString,
			@RequestParam(name="category", defaultValue="99", required=false) int category,
			Model model) {
		
		/* 페이징 처리 변수 지정 */
		int totRecCnt = 0;
		if(searchString.equals("")) {
			totRecCnt = boardService.totRecCnt();		// 전체자료 갯수 검색
		}
		else {
			totRecCnt = boardService.totRecCntSearch(search_target, searchString);
		}
		int totPage = (totRecCnt % pageSize)==0 ? totRecCnt/pageSize : (totRecCnt/pageSize) + 1;
		int startIndexNo = (pag - 1) * pageSize;
		int curScrStrarNo = totRecCnt - startIndexNo;
		int blockSize = 3;		// 한블록의 크기를 3개의 Page로 본다
		int curBlock = (pag - 1) / blockSize;		// 현재페이지의 블록위치
		int lastBlock = (totPage % blockSize)==0 ? ((totPage / blockSize) - 1) : (totPage / blockSize);
		
		List<BoardVO> vos = new ArrayList<BoardVO>();

		if(searchString.equals("")) {
			vos = boardService.getBoardList(startIndexNo, pageSize, category);
		}
		else {
			vos = boardService.getBoardListSearch(startIndexNo, pageSize, category, search_target, searchString);
		}
		
		//System.out.println(totRecCnt);
		
		model.addAttribute("vos", vos);
		model.addAttribute("pag", pag);
		model.addAttribute("pageSize", pageSize);
		model.addAttribute("totPage", totPage);
		model.addAttribute("curScrStrarNo", curScrStrarNo);
		model.addAttribute("blockSize", blockSize);
		model.addAttribute("curBlock", curBlock);
		model.addAttribute("lastBlock", lastBlock);
		model.addAttribute("category", category);
		model.addAttribute("search_target", search_target);
		model.addAttribute("searchString", searchString);
		
		return "board/boardList";
	}
	
	//게시판 글쓰기 입력창 호출
	@RequestMapping(value="/boardWrite", method = RequestMethod.GET)
	public String boardWriteGet() {
		return "board/boardWrite";
	}
	
	//게시글 입력 후 DB 저장
	@RequestMapping(value="/boardWrite", method = RequestMethod.POST)
	public String boardWritePost(BoardVO vo) {
		
		//이미지 파일 업로드 시 ckeditor 폴더->board 폴더로 복사
		boardService.imgCheck(vo.getContent());
		
		//이미지 복사 작업 후 실제 저장된 board 폴더명을 DB에 저장
		vo.setContent(vo.getContent().replace("/data/ckeditor/", "/data/ckeditor/board/"));
		
		//이미지 작업과 실제 저장폴더를 set 한 후 vo를 db에 저장
		boardService.setBoardWrite(vo);
		
		return "redirect:/msg/boardWriteOk";
	}
	
	//게시글 내용 보기
	@RequestMapping(value="/boardContent", method = RequestMethod.GET)
	public String boardContentGet(int idx, int pag, int pageSize, Model model, HttpSession session,
			@RequestParam(name="replyIdx", defaultValue="0", required=false) int replyIdx
			) {
		
		// 조회수 증가처리(조회수 중복방지)
		// 세션배열(객체배열:ArrayList()) : 고유세션아이디 + 'board' + '현재글의 고유번호'
		ArrayList<String> contentIdx = (ArrayList)session.getAttribute("sContentIdx");
		if(contentIdx == null) {
			contentIdx = new ArrayList<String>();
			session.setAttribute("sContentIdx", contentIdx);
			//System.out.println("1.contentIdx : " + contentIdx);
		}
		String imsiContentIdx = session.getId() + "board" + idx;
		if(!contentIdx.contains(imsiContentIdx)) {
			boardService.addReadNum(idx);
			contentIdx.add(imsiContentIdx);
		}
		
		//글 가져오기
		BoardVO vo = boardService.getBoardContent(idx);
		
		//이전글 & 다음글 
		List<BoardVO> pnVos = boardService.getPreNext(idx);	//pnVos = previous next VOS
		
		model.addAttribute("pnVos", pnVos);
		model.addAttribute("vo", vo);
		model.addAttribute("pag", pag);
		model.addAttribute("pageSize", pageSize);
		
		//댓글 가져오기
		List<BoardReplyVO> rVos = boardService.getBoardReply(idx);
		model.addAttribute("rVos", rVos);
		
		// 댓글 수정시 처리하는 부분
		if(replyIdx != 0) {
			String replyContent = boardService.getReply(replyIdx);
			model.addAttribute("replyIdx", replyIdx);
			model.addAttribute("replyContent", replyContent);
		}
		
		return "board/boardContent";
	}
	
	//게시글 삭제처리
	@RequestMapping(value="/boardDelete")
	public String boardDeleteGet(int idx, int pag, int pageSize) {
		// 게시글에 사진이 있다면 실제 서버파일시스템에서 사진파일을 삭제처리한다
		BoardVO vo = boardService.getBoardContent(idx);
		if(vo.getContent().indexOf("src=\"/") != -1) boardService.imgDelete(vo.getContent());
		
		//게시글에 댓글 있으면 댓글도 삭제
		boardService.replyAllDel(idx);
		
		// DB에서 실제 게시글을 삭제처리한다
		boardService.setBoardDelete(idx);
		
		msgFlag = "boardDeleteOk$pag="+pag+"&pageSize="+pageSize;
		return "redirect:/msg/" + msgFlag;
	}
	
	// 수정폼 불러오기
	@RequestMapping(value="/boardEdit",method = RequestMethod.GET)
	public String boardEditGet(Model model, int idx, int pag, 
			@RequestParam(name="pageSize", defaultValue = "5", required = false) int pageSize
			) {
		BoardVO vo = boardService.getBoardContent(idx);
		
		// 수정작업 처리전에 그림파일이 존재한다면 원본파일을 ckeditor폴더로 복사 시켜둔다.
		if(vo.getContent().indexOf("src=\"/") != -1)	boardService.imgCheckUpdate(vo.getContent());
		
		model.addAttribute("vo",vo);
		model.addAttribute("pag", pag);
		model.addAttribute("pageSize", pageSize);
		return "board/boardEdit";
	}
	
	// 수정내용 DB에 저장하기
	@RequestMapping(value="/boardEdit", method = RequestMethod.POST)
	public String boardEditPost(BoardVO vo, int pag,
			@RequestParam(name="pageSize", defaultValue = "5", required = false) int pageSize) {
		
			// 원본파일들을 board폴더에서 삭제처리한다.
			if(vo.getOriContent().indexOf("src=\"/") != -1)	boardService.imgDelete(vo.getOriContent());
			
			// 원본파일을 수정폼에 들어올때 board폴더에서 ckeditor폴더로 복사해두고, board폴더의 파일은 지웠기에, 아래의 복사처리전에 원본파일위치를 vo.content안의 파일경로를 board폴더에서 ckeditor폴더로 변경처리해줘야한다.
			vo.setContent(vo.getContent().replace("/data/ckeditor/board/", "/data/ckeditor/"));
			
			// 수정된 그림파일을 다시 복사처리한다.(수정된 그림파일의 정보는 content필드에 담겨있다.)('/ckeditor'폴더 -> '/ckeditor/board'폴더로복사) : 처음파일 입력작업과 같은 작업이기에 아래는 처음 입력시의 메소드를 호출했다.
			boardService.imgCheck(vo.getContent());
			
			// 필요한 파일을 board폴더로 복사했기에 vo.content의 내용도 변경한다.
			vo.setContent(vo.getContent().replace("/data/ckeditor/", "/data/ckeditor/board/"));
			
			// 잘 정비된 vo값만을 DB에 저장시킨다.
			boardService.setBoardEdit(vo);
			
			msgFlag = "boardEditOk$idx="+vo.getIdx()+"&pag="+pag+"&pageSize="+pageSize;
			return "redirect:/msg/" + msgFlag;
		}
	
	//좋아요 증가 처리 (중복 방지)
	@ResponseBody
	@RequestMapping("/boardGood")
	public String boardGoodPost(int idx, HttpSession session, Model model) {
		// 세션배열(객체배열:ArrayList()) : 'good' + '현재글의 고유번호'
		ArrayList<String> goodIdx = (ArrayList)session.getAttribute("sGoodIdx");
		if(goodIdx == null) { 
			goodIdx = new ArrayList<String>();
			session.setAttribute("sGoodIdx", goodIdx);
		}
		String imsiGoodIdx = "good" + idx;
		if(!goodIdx.contains(imsiGoodIdx)) { 
			boardService.setGoodUpdate(idx); 
			goodIdx.add(imsiGoodIdx); // 세션에 지금 만든 imsi를 넣어준다. 이제 세션은 null이 아니기 때문에 다시 위로 들어가서 if goodIdx==null인 부분에서 null이 아니기 때문에 그냥 dao.getboardcontent로 게시글만 그대로 내보냄. 좋아요는 증가하지 않고.
			return "0";
		}
		return "1";
		
	}
	
	//댓글 입력
	@ResponseBody
	@RequestMapping(value="/boardReplyWrite", method = RequestMethod.POST)
	public String boardReplyWritePost(BoardReplyVO rVo) {
		int levelOrder = 0;
		String strLevelOrder = boardService.maxLevelOrder(rVo.getBoardIdx());
		if(strLevelOrder != null) levelOrder = Integer.parseInt(strLevelOrder) + 1;
		rVo.setLevelOrder(levelOrder);
		
		boardService.setReplyWrite(rVo);
		return "";
	}
	
	// 대댓글 입력
	@ResponseBody
	@RequestMapping(value="/boardReplyWrite2", method = RequestMethod.POST)
	public String boardReplyWrite2Post(BoardReplyVO rVo) {
		boardService.levelOrderPlusUpdate(rVo); //부모 댓글의 levelOrder(순서)값보다 큰 모든 댓글의 levelOrder값을 +1 시켜준다
		rVo.setLevel(rVo.getLevel()+1); //자신의 level은 부모 level보다 +1 해준다
		rVo.setLevelOrder(rVo.getLevelOrder()+1); // 자신의 levelOrder는 부모 levelOrder보다 +1 해준다
		
		boardService.setReplyWrite2(rVo);
		return "";
	}
	
	//댓글 삭제처리
	@ResponseBody
	@RequestMapping(value="/boardReplyDelete", method = RequestMethod.POST)
	public String boardReplyDeletePost(int replyIdx) {
		boardService.setReplyDelete(replyIdx);
		return "";
	}
	
	//댓글 수정
	@ResponseBody
	@RequestMapping(value="/boardReplyEdit", method = RequestMethod.POST)
	public String boardReplyEditPost(int replyIdx, String content) {
		boardService.boardReplyEdit(replyIdx, content);
		return "";
	}
}
