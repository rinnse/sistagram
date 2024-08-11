package com.sist.web.model;

import java.io.Serializable;

public class Board implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private long boardNum;   		// 게시물 번호
	private String userId;  		// 회원 아이디
	private String boardContent;    // 게시물 내용
	private int likeCnt;  			// 좋아요
	private String regDate;  		// 등록일
	
	private long startRow;  // 시작 번호
	private long endRow;    // 끝 번호
		
	private BoardFile boardFile;   // 첨부파일(자식)
	
	private UserFile userFile;
	
	private String userFileName;
	
	// 관리자용 게시물관리할 때 쓰임
	private String userName;
	private String status;
	
	public Board() {
		boardNum = 0;
		userId = "";
		boardContent  = "";
		likeCnt = 0;
		regDate = "";
		
		startRow = 0;
		endRow = 0;
		
		boardFile = null;
	
		userFile = null;
		
		userFileName = "";
		
		userName = "";
		status = "";
	}

	public long getBoardNum() {
		return boardNum;
	}

	public void setBoardNum(long boardNum) {
		this.boardNum = boardNum;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getBoardContent() {
		return boardContent;
	}

	public void setBoardContent(String boardContent) {
		this.boardContent = boardContent;
	}

	public int getLikeCnt() {
		return likeCnt;
	}

	public void setLikeCnt(int likeCnt) {
		this.likeCnt = likeCnt;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}

	public long getStartRow() {
		return startRow;
	}

	public void setStartRow(long startRow) {
		this.startRow = startRow;
	}

	public long getEndRow() {
		return endRow;
	}

	public void setEndRow(long endRow) {
		this.endRow = endRow;
	}

	public BoardFile getBoardFile() {
		return boardFile;
	}

	public void setBoardFile(BoardFile boardFile) {
		this.boardFile = boardFile;
	}

	public UserFile getUserFile() {
		return userFile;
	}

	public void setUserFile(UserFile userFile) {
		this.userFile = userFile;
	}

	public String getUserFileName() {
		return userFileName;
	}

	public void setUserFileName(String userFileName) {
		this.userFileName = userFileName;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
}
