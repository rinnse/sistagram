package com.sist.web.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.sist.common.model.FileData;
import com.sist.common.util.StringUtil;
import com.sist.web.model.Board;
import com.sist.web.model.BoardFile;
import com.sist.web.model.Paging;
import com.sist.web.model.Response;
import com.sist.web.model.User;
import com.sist.web.service.BoardService;
import com.sist.web.service.UserService;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;

@Controller("boardController")
public class BoardController {
	private static Logger logger = LoggerFactory.getLogger(BoardController.class);
	
	@Autowired
	private BoardService boardService;
	
	@Autowired
	private UserService userService;  // 사용자 조회를 위한 쓰임
	
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	// 페이징 상수 정의
	private static final int LIST_COUNT = 7;   // 한 페이지의 게시물 수 
	private static final int USER_LIST_COUNT = 5;   // 회원님을 위한 추천 리스트 수 
	
	// 업로드 저장 경로
	@Value("#{env['upload.save.dir']}")
	private String UPLOAD_SAVE_DIR;

	
	// 메인 화면 (겸 게시물 리스트 조회)
	@RequestMapping(value="/main")
	public String main(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		User user = userService.userSelect(cookieUserId);

		// 본인 글 확인 체크
		String boardMe = "N";
		
		// 게시물 리스트
		List<Board> list = null;
		
		// 회원님을 위한 추천 리스트
		List<User> recomList = null;
		
		long totalCount = 0;   // 게시물 총 건 수 
		int userTotalCount = 0;  // 사용자 총 건 수
		
		Board board = new Board();
		
		totalCount = boardService.boardListCount(board);  // 게시물 총 개수
		
		userTotalCount = userService.userListCount(user);  // 사용자 총 수
	
		// 게시물 리스트
		if(totalCount > 0) {	
			board.setStartRow(1);  // 첫 번째 : 1
			board.setEndRow(LIST_COUNT);  // 위에 정의해둔 상수 : 5	

			list = boardService.boardList(board);  // 조회한 게시물 리스트 담기
		
		}
		
		// 사용자 리스트
		if(userTotalCount > 0) {
			// 사용자 총 인원이 존재할 경우
			user.setStartRow(1); 
			user.setEndRow(USER_LIST_COUNT);  // 사용자 5명만 조회되도록
			
			recomList = userService.userRecommendList(user);  // 로그인 사용자를 제외한 여러 사용자 추천 리스트 담기
		}
		
		// 게시물이 있고 게시물을 작성한 사용자와 쿠키유저아이디가 같을 경우
		if(board != null && StringUtil.equals(board.getUserId(), cookieUserId)) {
			boardMe = "Y";  
		}

		 
		model.addAttribute("list", list);  // 게시물
		model.addAttribute("user", user);
		model.addAttribute("recomList", recomList);  // 회원님을 위한 추천 리스트
		model.addAttribute("boardMe", boardMe);
		
		return "/main";
	}
	
	// 게시물 등록
	@RequestMapping(value="/board/writeForm")
	public String writeForm(HttpServletRequest request, HttpServletResponse response) {
	
		return "/board/writeForm";
	}
	
	// 게시물 등록 처리
	@RequestMapping(value="/board/writeProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> writeProc(MultipartHttpServletRequest request, HttpServletResponse response){
		Response<Object> ajaxResponse = new Response<Object>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		// writeForm.jsp에서 보낸 파라미터 값 세팅
		FileData fileData = HttpUtil.getFile(request, "boardFile", UPLOAD_SAVE_DIR); // 게시물 첨부파일
		String boardContent = HttpUtil.get(request, "boardContent", "");  // 게시물 내용
		
		if(!StringUtil.isEmpty(boardContent)) {
			// 게시물 내용이 입력된 경우
			Board board = new Board();
			
			board.setUserId(cookieUserId);  // 로그인한 사용자를 게시물 작성자의 아이디에 세팅
			board.setBoardContent(boardContent);  // 게시물 내용 
			
			if(fileData != null && fileData.getFileSize() > 0) {
				// 첨부파일 값이 넘어오고 파일 크기가 존재할 경우
				BoardFile boardFile = new BoardFile();
				
				boardFile.setFileName(fileData.getFileName());
				boardFile.setFileOrgName(fileData.getFileOrgName());
				boardFile.setFileExt(fileData.getFileExt());
				boardFile.setFileSize(fileData.getFileSize());
					
				board.setBoardFile(boardFile);

				try {
					if(boardService.boardInsert(board) > 0) {
						// 게시물 등록 처리 건 수가 존재할 경우
						ajaxResponse.setResponse(0, "Success");
					} else {
						ajaxResponse.setResponse(500, "internal server error22");
					}
				} catch (Exception e) {
					logger.error("[BoardController] writeProc Exception", e);
					ajaxResponse.setResponse(500, "internal server error2");
				}
			} else {
				// 파일 값이 안 넘어왔거나 파일 크기가 존재하지 않는 경우
				ajaxResponse.setResponse(500, "internal server error");
			}
		} else {
			// 게시물 입력 값이 안 넘어왔을 경우
			ajaxResponse.setResponse(400, "Bad Request");
		}
		
		return ajaxResponse;		
	}
	
	// 게시물 상세 페이지 조회
	@RequestMapping(value="/board/view")
	public String view(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		User user = userService.userSelect(cookieUserId);
		
		Board board = null;
		
		long boardNum = HttpUtil.get(request, "boardNum", (long)0);
		
		// 본인 글 여부 체크 (게시물 수정, 삭제)
		String boardMe = "N";
		
		if(boardNum > 0) {
			// 게시물 번호가 들어왔을 경우
			board = boardService.boardView(boardNum);

			if(board != null && StringUtil.equals(board.getUserId(), cookieUserId)) {
				boardMe = "Y";
			}
	
			board.setBoardFile(boardService.boardFileSelect(boardNum));  // 게시물 첨부파일 가져오기
		}

		model.addAttribute("user", user);
		model.addAttribute("board", board);
		model.addAttribute("boardMe", boardMe);
		
		return "/board/view";
	}
	
	
	// 게시물 수정
	@RequestMapping(value="/board/updateForm")
	public String update(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		// 쿠키 값
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		long boardNum = HttpUtil.get(request, "boardNum", (long)0);
		
		Board board = null;
		
		if(boardNum > 0) {
			// 게시물 번호가 넘어올 경우
			board = boardService.boardUpdateView(boardNum); // 게시물 번호를 가지고 수정 조회
			
			if(!StringUtil.equals(board.getUserId(), cookieUserId)) {
				// 내 글이 아닌 경우, 수정 불가능하도록 처리 (= 데이터 안 보여주기)
				board = null;
			}
		}
		
		model.addAttribute("board", board);
		
		return "/board/updateForm";
	}
	
	// 게시물 수정 처리
	@RequestMapping(value="/board/updateProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> updateProc(HttpServletRequest request, HttpServletResponse repsonse){
		Response<Object> ajaxResponse = new Response<Object>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long boardNum = HttpUtil.get(request, "boardNum", (long)0);
		String boardContent = HttpUtil.get(request, "boardContent", "");
		
		logger.debug("boardContent : " + boardContent);
		
		if(boardNum > 0 && !StringUtil.isEmpty(boardContent)) {
			// 게시물 번호 파라미터 값이 넘어왔고 게시물 내용이 입력된 경우
			Board board = boardService.boardView(boardNum);  // 게시물 상세 화면 조회
			
			if(board != null) {
				// 게시물 정보가 존재하는 경우
				if(StringUtil.equals(cookieUserId, board.getUserId())) {
					// 쿠키유저아이디와 게시물 작성자가 같을 경우	
					// updateForm.jsp에서 ajax로 받은 값 세팅
					board.setBoardNum(boardNum);   // 게시물 번호
					board.setBoardContent(boardContent); // 게시물 내용
					
					if(boardService.boardUpdate(board) > 0) {
						// 게시물 수정 건 수가 있을 경우
						ajaxResponse.setResponse(0, "Success");
					} else {
						ajaxResponse.setResponse(500, "internal server error");
					} 
				} else {
					ajaxResponse.setResponse(403, "server error");
				}
			} else {
				ajaxResponse.setResponse(404, "Not Found");
			}			
		} else {
			ajaxResponse.setResponse(400, "Bad Request");
		}
		
		
		return ajaxResponse;
	}
	
	// 게시물 삭제
	@RequestMapping(value="/board/delete", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> delete(HttpServletRequest request, HttpServletResponse response){
		Response<Object> ajaxResponse = new Response<Object>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long boardNum = HttpUtil.get(request, "boardNum", (long)0);
		
		if(boardNum > 0) {
			// 게시물 번호가 넘어온 경우
			Board board = boardService.boardView(boardNum);  // 게시물 상세화면 조회
			
			if(board != null) {
				// 게시물 정보가 존재하는 경우
				if(StringUtil.equals(board.getUserId(), cookieUserId)) {
					// 게시물 작성자와 로그인사용자와 같을 경우
					try {
						if(boardService.boardDelete(boardNum) > 0) {
							// 게시물 삭제 처리 건 수가 들어온 경우
							ajaxResponse.setResponse(0, "Success");
						} else {
							// 게시물 처리 건 수가 없을 경우
							ajaxResponse.setResponse(500, "internal server error");
						}
					} catch (Exception e) {
						logger.error("[BoardController] delete Exception", e);
						ajaxResponse.setResponse(500, "server error!!!");
					}
				} else {
					// 게시물 작성자와 쿠키유저아이디가 다를 경우
					ajaxResponse.setResponse(403, "Not your board");
				}
			} else {
				// 게시물 정보가 존재하지 않는 경우
				ajaxResponse.setResponse(404, "Not Found");
			}
		} else {
			// 게시물 번호가 안 넘어온 경우
			ajaxResponse.setResponse(400, "Bad Request");
		}
		
		return ajaxResponse;
	}
	
	
	
	// 로그인한 사용자의 프로필
	@RequestMapping(value="/board/userProfile", method = RequestMethod.GET)
	public String userProfile(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		User user = userService.userSelect(cookieUserId); 
		// null로 잡거나 new생성하면 아래 user를 활용한 if문 이외엔 안 쓰이기 때문에 프로필 편집에 사용자 정보가 사라짐
		
		// 게시물 리스트
		List<Board> myList = null;
		Board board = new Board();
		
		// 로그인한 사용자가 작성한 게시물 수 
		long myTotalCount = 0;
		myTotalCount = boardService.userBoardListCount(cookieUserId);


		if(myTotalCount > 0) {
			// 로그인되어 있는 사용자의 게시물 건 수가 있는 경우	
			board.setUserId(cookieUserId);
				
			myList = boardService.userBoardList(cookieUserId);  // 쿠키유저아이디의 게시물 정보 조회
		}
		
		// 프로필이 본인 프로필일 경우 체크
		String profileMe = "N";
		
		if(user != null && StringUtil.equals(user.getUserId(), cookieUserId)) {
			profileMe = "Y";  
		}

		model.addAttribute("myList", myList);
		model.addAttribute("user", user);
		model.addAttribute("profileMe", profileMe);
		
		return "/board/userProfile";
	}
	
	// 검색한 사용자의 프로필 보기
	@RequestMapping(value="/board/searchProfile")
	public String searchProfile(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		String userId = HttpUtil.get(request, "userId", "");  // jsp에서 파라미터로 보낸 userId 세팅
		
		User user = null;
		Board board = new Board();
		
		// 검색한 사용자의 userId와 쿠키유저아이디가 같을 경우, [프로필 편집]이 보임
		String profileMe = "N";
		
		//  [프로필 편집] 기능
		if(userId != null && !userId.isEmpty()) {
			// userId가 있을 경우
			user = userService.userSelect(userId);  // 파라미터로 받은 userId로 사용자 정보 조회
			
			if(user != null && StringUtil.equals(user.getUserId(), cookieUserId)) {
				// 쿠키유저아이디랑 검색한 사용자의 userId가 같을 경우, [프로필 편집] 기능 보여줌
				profileMe = "Y";
			}
		}
		
		List<Board> list = null; 
		long totalCount = 0;  // 프로필 사용자의 총 게시물 수
		
		// 프로필 화면에서 사용자 정보와 게시물 정보
		if(user != null) {
			// 사용자 정보가 있을 경우
			user = userService.userSelect(userId);  // 사용자 정보 조회
			
			totalCount = boardService.userBoardListCount(userId);  // 조회한 userId가 작성한 게시물 수
			
			if(totalCount > 0) {
				// 로그인되어 있는 사용자의 게시물 건 수가 있는 경우	
				board.setUserId(userId);
				
				list = boardService.userBoardList(userId);
			}
		}
		
		model.addAttribute("user", user);
		model.addAttribute("list", list);
		model.addAttribute("profileMe", profileMe);
		
		return "/board/searchProfile";
	}
	
	
}