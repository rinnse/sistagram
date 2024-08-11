package com.sist.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.sist.common.util.FileUtil;
import com.sist.web.dao.BoardDao;
import com.sist.web.model.Board;
import com.sist.web.model.BoardFile;

@Service("boardService")
public class BoardService {
	private static Logger logger = LoggerFactory.getLogger(BoardService.class);
	
	@Autowired
	private BoardDao boardDao;
	
	// 업로드 저장 경로
	@Value("#{env['upload.save.dir']}")
	private String UPLOAD_SAVE_DIR;
	
	// 게시물 리스트
	public List<Board> boardList(Board board){
		List<Board> list = null;
		
		try {
			list = boardDao.boardList(board);
		} catch(Exception e) {
			logger.error("[BoardServie] boardList Exception", e);
		}
		
		return list;
	}
	
	// 총 게시물 수 조회
	public long boardListCount(Board board) {
		long count = 0;
		
		try {
			count = boardDao.boardListCount(board);
		} catch(Exception e) {
			logger.error("[BoardServie] boardListCount Exception", e);
		}
		
		return count;
	}
	
	// 첨부파일 조회
	public BoardFile boardFileSelect(long boardNum) {
		BoardFile boardFile = null;
		
		try {
			boardFile = boardDao.boardFileSelect(boardNum);
		} catch(Exception e) {
			logger.error("[BoardServie] boardFileSelect Exception", e);
		}
		
		return boardFile;
	}
	
	// 게시물 등록 & 첨부파일도 등록
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public int boardInsert(Board board) throws Exception {
		int count = 0;
		
		count = boardDao.boardInsert(board);
		
		if(count > 0 && board.getBoardFile() != null) {
			// 등록 건 수가 있고 첨부파일이 있는 경우
			BoardFile boardFile = board.getBoardFile();
			
			boardFile.setBoardNum(board.getBoardNum());
			boardFile.setFileNum(board.getBoardFile().getFileNum()); 
			// or  boardFile.setFileNum((short)1);
			
			boardDao.boardFileInsert(boardFile);  // 등록할 때 첨부파일도 등록
		}
		
		return count;
	}
	
	// 로그인 사용자가 작성한 게시물 리스트 조회
	public List<Board> userBoardList(String userId){
		List<Board> myList = null;
		
		try {
			myList = boardDao.userBoardList(userId);
		} catch(Exception e) {
			logger.error("[BoardServie] myBoardList Exception", e);
		}
		
		return myList;
	}
	
	// 로그인 사용자가 작성한 게시물에 대한 총 게시물 수
	public long userBoardListCount(String userId) {
		long count = 0;
		
		try {
			count = boardDao.userBoardListCount(userId);
		} catch(Exception e) {
			logger.error("[BoardServie] myBoardListCount Exception", e);
		}
		
		return count;
	}
	
	// 게시물 상세 보기
	public Board boardView(long boardNum) {
		Board board = null;
		
		try {
			board = boardDao.boardView(boardNum);
		} catch(Exception e) {
			logger.error("[BoardServie] boardView Exception", e);
		}
		
		return board;
	}
	
	// 게시물 수정 (첨부파일은 수정 불가)
	public int boardUpdate(Board board) {
		int count = 0;
	
		try {
			count = boardDao.boardUpdate(board);
		} catch(Exception e) {
			logger.error("[BoardServie] boardUpdate Exception", e);
		}
		
		return count;
	}
	
	// 게시물 수정 조회 (첨부파일도) : 게시물 수정 화면 보여줄 때 쓰임
	public Board boardUpdateView(long boardNum) {
		Board board = null;
		
		try {
			board = boardDao.boardView(boardNum); // 게시물 상세 건을 board 객체에 담기
			
			if(board != null) {
				// 게시물 정보가 있을 경우
				BoardFile boardFile = boardDao.boardFileSelect(boardNum);  // 첨부파일 조회
				
				if(boardFile != null) {
					// 첨부파일이 있을 경우
					board.setBoardFile(boardFile);
				}
			}
		} catch(Exception e) {
			logger.error("[BoardService] boardUpdateView Exception", e);
		}

		return board;
	}
	
	// 게시물 삭제 & 첨부파일도 삭제
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public int boardDelete(long boardNum) throws Exception {
		int count = 0;
	
		Board board = boardUpdateView(boardNum);   // 수정된 게시물 폼 조회
		
		if(board != null) {
		    // 게시물 정보가 존재하는 경우
		    BoardFile boardFile = board.getBoardFile();
		    if(boardFile != null) {
		        // 게시물 첨부파일이 존재하는 경우
		        if(boardDao.boardFileDelete(boardNum) > 0) {
		            // 첨부파일이 삭제됐을 경우, 업로드되어 있는 파일 경로도 삭제
		            FileUtil.deleteFile(UPLOAD_SAVE_DIR + FileUtil.getFileSeparator() + boardFile.getFileName());
		        }
		    }
		    // 게시물 삭제
		    count = boardDao.boardDelete(boardNum); 
		}
		
		return count;
	}
	
	
	// 관리자용
	// 게시물 관리
	public List<Board> boardMgtList(Board board){
		List<Board> bmList = null;
		
		try {
			bmList = boardDao.boardMgtList(board);
		} catch(Exception e) {
			logger.error("[BoardServie] boardMgtList Exception", e);
		}
		
		return bmList;
	}
	
	// 게시물관리 리스트 전체 건 수
	public int boardMgtListCount(Board board) {
		int count = 0;
		
		try {
			count = boardDao.boardMgtListCount(board);
		} catch(Exception e) {
			logger.error("[BoardServie] boardMgtListCount Exception", e);
		}
		
		return count;
	}
}
