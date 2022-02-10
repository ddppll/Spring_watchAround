package com.spring.cjs2108_ksh.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.cjs2108_ksh.vo.BoardReplyVO;
import com.spring.cjs2108_ksh.vo.BoardVO;

import lombok.experimental.PackagePrivate;

public interface BoardDAO {

	public void setBoardWrite(@Param("vo") BoardVO vo);

	public int totRecCnt();

	public List<BoardVO> getBoardList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, @Param("category") int category);

	public void addReadNum(@Param("idx") int idx);

	public BoardVO getBoardContent(@Param("idx") int idx);

	public List<BoardVO> getPreNext(@Param("idx") int idx);

	public void setGoodUpdate(@Param("idx") int idx);

	public String maxLevelOrder(@Param("boardIdx") int boardIdx);

	public void setReplyWrite(@Param("rVo") BoardReplyVO rVo);

	public List<BoardReplyVO> getBoardReply(@Param("idx") int idx);

	public void levelOrderPlusUpdate(@Param("rVo") BoardReplyVO rVo);

	public void setReplyWrite2(@Param("rVo") BoardReplyVO rVo);

	public void setReplyDelete(@Param("replyIdx") int replyIdx);

	public String getReply(@Param("replyIdx") int replyIdx);

	public void boardReplyEdit(@Param("replyIdx") int replyIdx, @Param("content") String content);

	public void setBoardEdit(@Param("vo") BoardVO vo);

	public void setBoardDelete(@Param("idx") int idx);

	public void replyAllDel(@Param("idx") int idx);

	public int totRecCntSearch(@Param("search_target") String search_target, @Param("searchString") String searchString);

	public List<BoardVO> getBoardListSearch(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, @Param("category") int category, 
			@Param("search_target") String search_target, @Param("searchString") String searchString);


}
