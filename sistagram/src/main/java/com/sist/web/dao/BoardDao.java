package com.sist.web.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.sist.web.model.Board;
import com.sist.web.model.BoardFile;

@Repository("boardDao")
public interface BoardDao {
	// 게시물 리스트 
	public List<Board> boardList(Board board);
	
	// 총 게시물 수 조회
	public long boardListCount(Board board);
	
	// 게시물 등록
	public int boardInsert(Board board);
	
	// 첨부파일 등록
	public int boardFileInsert(BoardFile boardFile);
	
	// 첨부파일 조회
	public BoardFile boardFileSelect(long boardNum);
	
	// 로그인 사용자가 작성한 게시물 리스트 조회
	public List<Board> userBoardList(String userId);
	
	// 로그인 사용자가 작성한 게시물에 대한 총 게시물 수
	public long userBoardListCount(String userId);
	
	// 게시물 상세 건
	public Board boardView(long boardNum);
	
	// 게시물 수정
	public int boardUpdate(Board board);
	
	// 게시물 첨부파일 삭제
	public int boardFileDelete(long boardNum);
	
	// 게시물 삭제
	public int boardDelete(long boardNum);
	
	
	// 관리자용
	// 게시물 관리
	public List<Board> boardMgtList(Board board);
	
	// 게시물관리 리스트 전체 건 수
	public int boardMgtListCount(Board board);
	
}
