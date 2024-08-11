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

import com.sist.common.util.StringUtil;
import com.sist.web.model.Admin;
import com.sist.web.model.Board;
import com.sist.web.model.Paging;
import com.sist.web.model.Response;
import com.sist.web.model.User;
import com.sist.web.service.AdminService;
import com.sist.web.service.BoardService;
import com.sist.web.service.UserService;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;

@Controller("adminController")
public class AdminController {
	private static Logger logger = LoggerFactory.getLogger(AdminController.class);
	
	@Autowired
	private AdminService adminService;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private BoardService boardService;
	
	// 관리자의 회원관리 페이징 처리
	private static final int UMLIST_COUNT = 10;   
	private static final int UMPAGE_COUNT = 10;
	
	// 관리자의 게시물관리 페이징 처리
	private static final int BMLIST_COUNT = 15;
	private static final int BMPAGE_COUNT = 10;
	
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	// 업로드 저장 경로
	@Value("#{env['upload.save.dir']}")
	private String UPLOAD_SAVE_DIR;

	// 회원가입 화면
	@RequestMapping(value="/admin/signUp")
	public String signUp(HttpServletRequest Request, HttpServletResponse repsonse) {
		String cookieUserId = CookieUtil.getHexValue(Request, AUTH_COOKIE_NAME);
		
		if(!StringUtil.isEmpty(cookieUserId)) {
			// 쿠키유저아이디가 비어있지 않으면
			CookieUtil.deleteCookie(Request, repsonse, "/", AUTH_COOKIE_NAME);
			return "redirect:/";
		} else {
			return "/admin/signUp";
		}
	}
	
	// 아이디 중복 체크 (회원가입)
	@RequestMapping(value="/admin/idCheck", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> idCheck(HttpServletRequest request, HttpServletResponse response){
		Response<Object> ajaxResponse = new Response<Object>();
		
		String admId = HttpUtil.get(request, "admId");
		
		if(!StringUtil.isEmpty(admId)) {
			if(adminService.adminSelect(admId) == null) {
				ajaxResponse.setResponse(0, "Success");
			} else {
				// 중복된 아이디일 경우
				ajaxResponse.setResponse(404, "userId is duplicated");
			}
		} else {
			// 아이디 값이 넘어오지 않은 경우
			ajaxResponse.setResponse(400, "Bad Request");
		}
		
		return ajaxResponse;
		
	}
	
	// 회원가입 성공 ajax
	@RequestMapping(value="/admin/adminReg", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> adminReg(HttpServletRequest request, HttpServletResponse response){
		Response<Object> ajaxResponse = new Response<Object>();
			
		String admId = HttpUtil.get(request, "admId");
		String admPwd = HttpUtil.get(request, "admPwd");
		String admName = HttpUtil.get(request, "admName");
		
		if(!StringUtil.isEmpty(admId) && !StringUtil.isEmpty(admPwd) &&
					!StringUtil.isEmpty(admName)) {
			if(adminService.adminSelect(admId) == null) {
				Admin admin = new Admin();
				
				// 파라미터 값 세팅
				admin.setAdmId(admId);
				admin.setAdmPwd(admPwd);
				admin.setAdmName(admName);
				
				// 관리자 등록
				if(adminService.adminInsert(admin) > 0) {
					ajaxResponse.setResponse(0, "Success");
				} else {
					// 등록 처리가 되지 않은 경우
					ajaxResponse.setResponse(500, "server error");
				}
			} else {
				// 조회한 아이디가 있는 경우
				ajaxResponse.setResponse(100, "Duplicate Id");
			}
		} else {
			// 하나라도 값이 안 넘어온 경우
			ajaxResponse.setResponse(400, "Bad Request");
		}
			
		return ajaxResponse;
			
	}
	
	// 로그인 성공
	@RequestMapping(value="/admin/login", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> login(HttpServletRequest request, HttpServletResponse response){
		Response<Object> ajaxResponse = new Response<Object>();
		
		String admId = HttpUtil.get(request, "admId");
		String admPwd = HttpUtil.get(request, "admPwd");
		
		if(!StringUtil.isEmpty(admId) && !StringUtil.isEmpty(admPwd)) {
			Admin admin = adminService.adminSelect(admId);
			
			if(admin != null) {
				// 관리자 정보가 있을 경우
				if(StringUtil.equals(admPwd, admin.getAdmPwd())) {
					// 입력한 비번과 DB에 있는 비번 값과 같을 경우
					if(StringUtil.equals(admin.getStatus(), "Y")) {  // Y : 정상
						CookieUtil.addCookie(response, "/", -1, AUTH_COOKIE_NAME, CookieUtil.stringToHex(admId));
						ajaxResponse.setResponse(0, "Success");
					} else if(StringUtil.equals(admin.getStatus(), "N")) {  // N : 탈퇴
						ajaxResponse.setResponse(-2, "Leave the Account");
					} else if(StringUtil.equals(admin.getStatus(), "S")){ // S : 정지
						ajaxResponse.setResponse(-3, "stop");
					}
				} else {
					// 로그인한 비번이 DB에 있는 비번과 다를 경우
					ajaxResponse.setResponse(403, "inter server error");
				}
			} else {
				//  관리자 정보가 없을 경우
				ajaxResponse.setResponse(404, "Not Found");
			}
		} else {
			// 관리자 아이디나 비번 파라미터 값이 올바르지 않을 경우
			ajaxResponse.setResponse(400, "Bad Request");
		}
		
		return ajaxResponse;
		
	}
	
	// 관리자 페이지 
	@RequestMapping(value="/admin")
	public String admin(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		User user = userService.userSelect(cookieUserId);
		
		List<Board> list = null;
		
		long totalCount = 0;
		
		Board board = new Board();
		
		totalCount = boardService.boardListCount(board);
		
		if(totalCount > 0) {
			board.setStartRow(1);
			board.setEndRow(BMLIST_COUNT);
	
			list = boardService.boardList(board);
		}
		
		model.addAttribute("list", list);
		model.addAttribute("cookieUserId", cookieUserId);
		
		return "/admin";
	}
	
	// 관리자 프로필 
	@RequestMapping(value="/admin/adminProfile")
	public String adminProfile(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		Admin admin = adminService.adminSelect(cookieUserId);

		model.addAttribute("admin", admin);
		
		return "/admin/adminProfile";
	}
	
	// 로그아웃 처리
	@RequestMapping(value="/admin/logOut")
	public String logOut(HttpServletRequest request, HttpServletResponse response) {
		if(CookieUtil.getCookie(request, AUTH_COOKIE_NAME) != null) { 
			// 쿠키 있을 경우
			CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
		}
			
		return "redirect:/"; // 재접속
	}
	
	
	// 회원 관리
	@RequestMapping(value="/admin/userMgt")
	public String userMgt(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		List<User> umList = null;
		User user = new User();
		Paging paging = null;
			
		int totalCount = 0;    // 회원관리 리스트의 총 건 수 
		int curPage = HttpUtil.get(request, "curPage", 1);
		String status = HttpUtil.get(request, "status", "");
		String searchType = HttpUtil.get(request, "searchType", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");
			
		if(!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue)) {
			// 검색조건과 검색 값이 있다면
			if(StringUtil.equals(searchType, "1")) {
				// 작성자의 아이디
				user.setUserId(searchValue);
			} else if(StringUtil.equals(searchType, "2")) {
				// 작성자 이름
				user.setUserName(searchValue);
			} else if(StringUtil.equals(searchType, "3")) {
				// 권한 부여
				user.setStatus(searchValue);
			} else {
				searchType = "";
				searchValue = "";
			}
		}
			
		totalCount = userService.userMgtListCount(user);
			
		if(totalCount > 0) {
			// 페이징 처리
			paging = new Paging("/admin/userMgt", totalCount, UMLIST_COUNT, UMPAGE_COUNT, curPage, "curPage");
				
			user.setStartRow(paging.getStartRow());
			user.setEndRow(paging.getEndRow());
				
			umList = userService.userMgtList(user);  // 회원관리 리스트에 담기
		}
			
		model.addAttribute("umList", umList);
		model.addAttribute("paging", paging);
		model.addAttribute("curPage", curPage);
		model.addAttribute("status", status);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
			
		return "/admin/userMgt";
	}
	
	// 게시물 관리
	@RequestMapping(value="/admin/boardMgt")
	public String boardMgt(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		List<Board> bmList = null;
		Board board = new Board();
		Paging paging = null;
			
		int totalCount = 0;
		int curPage = HttpUtil.get(request, "curPage", 1);
		String status = HttpUtil.get(request, "status", "");
		String searchType = HttpUtil.get(request, "searchType", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");
			
		if(!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue)) {
			// 검색조건과 검색 값이 있다면
			if(StringUtil.equals(searchType, "1")) {
				// 작성자의 아이디
				board.setUserId(searchValue);
			} else if(StringUtil.equals(searchType, "2")) {
				// 작성자의 이름 
				board.setUserName(searchValue);
			} else if(StringUtil.equals(searchType, "3")) {
				// 권란 부여
				board.setBoardContent(searchValue);
			} else {
				searchType = "";
				searchValue = "";
			}
		}
			
		totalCount = boardService.boardMgtListCount(board);
			
		if(totalCount > 0) {
			// 페이징 처리
			paging = new Paging("/admin/boardMgt", totalCount, BMLIST_COUNT, BMPAGE_COUNT, curPage, "curPage");
			
			board.setStartRow(paging.getStartRow());
			board.setEndRow(paging.getEndRow());
				
			bmList = boardService.boardMgtList(board);  // 게시물관리 리스트에 담기
		}
			
		model.addAttribute("bmList", bmList);
		model.addAttribute("paging", paging);
		model.addAttribute("curPage", curPage);
		model.addAttribute("status", status);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
			
		return "/admin/boardMgt";
	}
		
	// 게시물 신고 관리
	@RequestMapping(value="/admin/boardReport")
	public String boardReport(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		List<Board> bmList = null;
		Board board = new Board();
		Paging paging = null;
			
		int totalCount = 0;
		int curPage = HttpUtil.get(request, "curPage", 1);
		String status = HttpUtil.get(request, "status", "");
		String searchType = HttpUtil.get(request, "searchType", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");
			
		if(!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue)) {
			// 검색조건과 검색 값이 있다면
			if(StringUtil.equals(searchType, "1")) {
				// 작성자의 아이디
				board.setUserId(searchValue);
			} else if(StringUtil.equals(searchType, "2")) {
				// 작성자의 이름 
				board.setUserName(searchValue);
			} else if(StringUtil.equals(searchType, "3")) {
				// 권란 부여
				board.setBoardContent(searchValue);
			} else {
				searchType = "";
				searchValue = "";
			}
		}
			
		totalCount = boardService.boardMgtListCount(board);
			
		if(totalCount > 0) {
			// 페이징 처리
			paging = new Paging("/admin/boardMgt", totalCount, BMLIST_COUNT, BMPAGE_COUNT, curPage, "curPage");
			
			board.setStartRow(paging.getStartRow());
			board.setEndRow(paging.getEndRow());
				
			bmList = boardService.boardMgtList(board);  // 게시물관리 리스트에 담기
		}
			
		model.addAttribute("bmList", bmList);
		model.addAttribute("paging", paging);
		model.addAttribute("curPage", curPage);
		model.addAttribute("status", status);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);		
				
		return "/admin/boardReport";
	}
		
	// 관리자에 의한 게시물 삭제 처리
	@RequestMapping(value="/admin/deleteBoard", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> deleteBoard(HttpServletRequest request, HttpServletResponse response){
		Response<Object> ajaxResponse = new Response<Object>();
		
		long boardNum = HttpUtil.get(request, "boardNum", (long)0);
		
		if(boardNum > 0) {
			// 게시물 번호가 넘어온 경우
			Board board = boardService.boardView(boardNum);  // 게시물 건 수 하나
			
			if(board != null) {
				// 게시물 정보가 존재하는 경우
				try {
					if(boardService.boardDelete(boardNum) > 0) {
						// 게시물 삭제 처리 건 수가 들어온 경우
						ajaxResponse.setResponse(0, "Success");
					} else {
						// 삭제 건 수가 없을 경우
						ajaxResponse.setResponse(500, "internal server error");
					}
				} catch (Exception e) {
					logger.error("[AdminController] deleteBoard Exception", e);
					ajaxResponse.setResponse(500, "server error!!!");
				} 
			} else {
				// 게시물 정보가 안 넘어온 경우
				ajaxResponse.setResponse(404, "Not Found");
			}
		} else {
			// 게시물 번호가 안 넘어온 경우
			ajaxResponse.setResponse(400, "Bad Request");
		}
				
		return ajaxResponse;
			
	}
}
