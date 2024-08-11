package com.sist.web.model;

import java.io.Serializable;

public class BoardFile implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private long boardNum;   
	private int fileNum;
	private String fileOrgName;
	private String fileName;
	private String fileExt;
	private long fileSize;
	private String regDate; 
	
	public BoardFile() {
		boardNum = 0;   
		fileNum = 0;
		fileOrgName = "";
		fileName = "";
		fileExt = "";
		fileSize = 0; 
		regDate = "";
	}

	public long getBoardNum() {
		return boardNum;
	}

	public void setBoardNum(long boardNum) {
		this.boardNum = boardNum;
	}

	public int getFileNum() {
		return fileNum;
	}

	public void setFileNum(int fileNum) {
		this.fileNum = fileNum;
	}

	public String getFileOrgName() {
		return fileOrgName;
	}

	public void setFileOrgName(String fileOrgName) {
		this.fileOrgName = fileOrgName;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getFileExt() {
		return fileExt;
	}

	public void setFileExt(String fileExt) {
		this.fileExt = fileExt;
	}

	public long getFileSize() {
		return fileSize;
	}

	public void setFileSize(long fileSize) {
		this.fileSize = fileSize;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}
}
