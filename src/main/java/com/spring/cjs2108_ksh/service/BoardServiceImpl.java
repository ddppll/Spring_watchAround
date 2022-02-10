package com.spring.cjs2108_ksh.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.spring.cjs2108_ksh.dao.BoardDAO;
import com.spring.cjs2108_ksh.vo.BoardReplyVO;
import com.spring.cjs2108_ksh.vo.BoardVO;

@Service
public class BoardServiceImpl implements BoardService {
	@Autowired
	BoardDAO boardDAO;
	
	// ckeditor 폴더의 그림을 board 폴더로 복사
	@Override
	public void imgCheck(String content) {
		//             0         1         2         3       3 4         5
		//             012345678901234567890123456789012345678901234567890
		// <img alt="" src="/cjs2108_ksh/data/ckeditor/board/211229124318_4.jpg"
		//01234567890123456789012345678901234567890
					// src="/spring2108_ksh/data/ckeditor/board/220112174154_dog9.jpg
		if(content.indexOf("src=\"/") == -1) return; //처리할 이미지가 없을 때
		
		HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
		String uploadPath = request.getRealPath("/resources/data/ckeditor/");
		
		int position = 32;
		String nextImg = content.substring(content.indexOf("src=\"/") + position);
		boolean sw = true;
		
		while(sw) {
			String imgFile = nextImg.substring(0,nextImg.indexOf("\""));
			String copyFilePath = "";
			String oriFilePath = uploadPath + imgFile; 	// 원본 그림이 들어있는 경로명 + 파일명
			
			copyFilePath = uploadPath + "board/" + imgFile; // 복사가 될 경로명 + 파일명
			
			fileCopyCheck(oriFilePath, copyFilePath);	// 원본그림이 복사될 위치로 복사 작업 처리하는 메소드
			
			if(nextImg.indexOf("src=\"/") == -1) { //복사한다음에 그 뒤에 이미지 또 없을 때
				sw = false;
			}
			else {
				nextImg = nextImg.substring(nextImg.indexOf("src=\"/") + position);
			}
		}
	}

	//실제 파일(ckeditor폴더)을 board폴더로 복사처리하는 곳
	private void fileCopyCheck(String oriFilePath, String copyFilePath) {
		File oriFile = new File(oriFilePath);
		File copyFile = new File(copyFilePath);
		
		try {
			FileInputStream fis;
			fis = new FileInputStream(oriFile);
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

	//글 내용 최종 DB 저장
	@Override
	public void setBoardWrite(BoardVO vo) {
		//System.out.println(vo);
		boardDAO.setBoardWrite(vo);
	}

	// 게시글 전체 개수 검색
	@Override
	public int totRecCnt() {
		return boardDAO.totRecCnt();
	}

	@Override
	public List<BoardVO> getBoardList(int startIndexNo, int pageSize, int category) {
		return boardDAO.getBoardList(startIndexNo, pageSize, category);
	}

	@Override
	public void addReadNum(int idx) {
		boardDAO.addReadNum(idx);
	}

	@Override
	public BoardVO getBoardContent(int idx) {
		return boardDAO.getBoardContent(idx);
	}

	@Override
	public List<BoardVO> getPreNext(int idx) {
		return boardDAO.getPreNext(idx);
	}

	@Override
	public void setGoodUpdate(int idx) {
		boardDAO.setGoodUpdate(idx);
	}

	@Override
	public String maxLevelOrder(int boardIdx) {
		return boardDAO.maxLevelOrder(boardIdx);
	}

	@Override
	public void setReplyWrite(BoardReplyVO rVo) {
		boardDAO.setReplyWrite(rVo);
	}

	@Override
	public List<BoardReplyVO> getBoardReply(int idx) {
		return boardDAO.getBoardReply(idx);
	}

	@Override
	public void levelOrderPlusUpdate(BoardReplyVO rVo) {
		boardDAO.levelOrderPlusUpdate(rVo);
	}

	@Override
	public void setReplyWrite2(BoardReplyVO rVo) {
		boardDAO.setReplyWrite2(rVo);
	}

	@Override
	public void setReplyDelete(int replyIdx) {
		boardDAO.setReplyDelete(replyIdx);
	}

	@Override
	public String getReply(int replyIdx) {
		return boardDAO.getReply(replyIdx);
	}

	@Override
	public void boardReplyEdit(int replyIdx, String content) {
		boardDAO.boardReplyEdit(replyIdx, content);
	}

	@Override //원본파일삭제처리
	public void imgDelete(String content) {
		if(content.indexOf("src=\"/") == -1) return; //처리할 이미지가 없을 때
		
			   //      0         1         2         3       3 4         5
		//             012345678901234567890123456789012345678901234567890
		// <img alt="" src="/cjs2108_ksh/data/ckeditor/board/211229124318_4.jpg"
		//01234567890123456789012345678901234567890
				// src="/spring2108_ksh/data/ckeditor/board/220112174154_dog9.jpg
		
		HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
		String uploadPath = request.getRealPath("/resources/data/ckeditor/board/");
		
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
	
	//원본이미지 삭제 메소드(board폴더에서 삭제)
	private void fileDelete(String oriFilePath) {
		File delFile = new File(oriFilePath);
		if(delFile.exists()) delFile.delete();
	}

	@Override
	public void imgCheckUpdate(String content) {
		if(content.indexOf("src=\"/") == -1) return; //처리할 이미지가 없을 때
		
		HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
		String uploadPath = request.getRealPath("/resources/data/ckeditor/board/");
		
		//01234567890123456789012345678901234567890
		//src="/cjs2108_ksh/data/ckeditor/board/220112174154_dog9.jpg
		
		int position = 38;
		String nextImg = content.substring(content.indexOf("src=\"/") + position);
		boolean sw = true;
		
		while(sw) {
			String imgFile = nextImg.substring(0,nextImg.indexOf("\""));
			String oriFilePath = uploadPath + imgFile; 	// 원본 그림이 들어있는 경로명 + 파일명
			String copyFilePath = request.getRealPath("/resources/data/ckeditor/" + imgFile);	// 복사가 될 '경로명+파일명'
			
			fileCopyCheck(oriFilePath, copyFilePath);	// 원본그림이 복사될 위치로 복사 작업 처리하는 메소드
			
			if(nextImg.indexOf("src=\"/") == -1) { //복사한다음에 그 뒤에 이미지 또 없을 때
				sw = false;
			}
			else {
				nextImg = nextImg.substring(nextImg.indexOf("src=\"/") + position);
			}
		}
		
	}
	
	//수정처리 db업데이트
	@Override
	public void setBoardEdit(BoardVO vo) {
		boardDAO.setBoardEdit(vo);
	}

	@Override
	public void setBoardDelete(int idx) {
		boardDAO.setBoardDelete(idx);
	}

	//글삭제시 딸린 댓글 전부 삭제
	@Override
	public void replyAllDel(int idx) {
		boardDAO.replyAllDel(idx);
	}

	@Override
	public int totRecCntSearch(String search_target, String searchString) {
		return boardDAO.totRecCntSearch(search_target, searchString);
	}

	@Override
	public List<BoardVO> getBoardListSearch(int startIndexNo, int pageSize, int category, String search_target,
			String searchString) {
		//System.out.println("search_target : "+ search_target);
		//System.out.println("searchString : "+ searchString);
		return boardDAO.getBoardListSearch(startIndexNo, pageSize, category, search_target,	searchString);
	}

}
