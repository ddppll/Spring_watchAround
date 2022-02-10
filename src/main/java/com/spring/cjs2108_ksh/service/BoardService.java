package com.spring.cjs2108_ksh.service;

import java.util.List;

import com.spring.cjs2108_ksh.vo.BoardReplyVO;
import com.spring.cjs2108_ksh.vo.BoardVO;

public interface BoardService {

	public void imgCheck(String content);

	public void setBoardWrite(BoardVO vo);

	public int totRecCnt();

	public List<BoardVO> getBoardList(int startIndexNo, int pageSize, int category);

	public void addReadNum(int idx);

	public BoardVO getBoardContent(int idx);

	public List<BoardVO> getPreNext(int idx);

	public void setGoodUpdate(int idx);

	public String maxLevelOrder(int boardIdx);

	public void setReplyWrite(BoardReplyVO rVo);

	public List<BoardReplyVO> getBoardReply(int idx);

	public void levelOrderPlusUpdate(BoardReplyVO rVo);

	public void setReplyWrite2(BoardReplyVO rVo);

	public void setReplyDelete(int replyIdx);

	public String getReply(int replyIdx);

	public void boardReplyEdit(int replyIdx, String content);

	public void imgDelete(String content);

	public void imgCheckUpdate(String content);

	public void setBoardEdit(BoardVO vo);

	public void setBoardDelete(int idx);

	public void replyAllDel(int idx);

	public int totRecCntSearch(String search_target, String searchString);

	public List<BoardVO> getBoardListSearch(int startIndexNo, int pageSize, int category, String search_target,
			String searchString);




}
