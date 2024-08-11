package com.sist.web.controller;

import java.util.List;
import java.util.Random;

import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.sist.common.util.StringUtil;
import com.sist.web.model.Paging;
import com.sist.web.model.Response;
import com.sist.web.model.User;
import com.sist.web.service.UserService;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;
import com.sist.web.util.JsonUtil;

@Controller("userController")
public class UserController {
	private static Logger logger = LoggerFactory.getLogger(UserController.class);
	
	@Autowired
	private UserService userService;
	
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;

	@Autowired
	private JavaMailSender mailSender;
	
	// 페이징 상수 정의
	private static final int LIST_COUNT = 7;   // 한 페이지의 사용자 수
	
	// 업로드 저장 경로
	@Value("#{env['upload.save.dir']}")
	private String UPLOAD_SAVE_DIR;
	
	
	// 로그인 체크
	@RequestMapping(value="/user/login", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> login(HttpServletRequest request, HttpServletResponse response){
		Response<Object> ajaxResponse = new Response<Object>();
		
		String userId = HttpUtil.get(request, "userId");
		String userPwd = HttpUtil.get(request, "userPwd");
		
		// 아이디와 비번 값이 들어왔는지 체크하고 있을 경우 userId로 조회 후 code 체크
		if(!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd)) {
			User user = userService.userSelect(userId);
			
			logger.debug("userId" + userId);
			
			if(user != null) {
				if(StringUtil.equals(userPwd, user.getUserPwd())) {
					if(StringUtil.equals(user.getStatus(), "Y")) {  // Y : 정상
						CookieUtil.addCookie(response, "/", -1, AUTH_COOKIE_NAME, CookieUtil.stringToHex(userId));
						ajaxResponse.setResponse(0, "Success");
					} else if(StringUtil.equals(user.getStatus(), "N")) {  // N : 탈퇴
						ajaxResponse.setResponse(-2, "Leave the Account");
					} else if(StringUtil.equals(user.getStatus(), "S")){ // S : 정지
						ajaxResponse.setResponse(-3, "stop");
					}
				} else {
					// DB에 있는 비밀번호와 입력한 비밀번호 값이 맞지 않은 경우
					ajaxResponse.setResponse(403, "inter server error");
				}
			} else {
				// user객체가 안 넘어온 경우
				ajaxResponse.setResponse(404, "Not Found");
			}
		} else {
			// 파라미터 값이 안 들어온 경우
			ajaxResponse.setResponse(400, "Bad Request");
		}
		
		if(logger.isDebugEnabled()) { // debug모드가 활성화되어 있는 경우
			logger.debug("[UserController] /user/login response\n" + JsonUtil.toJsonPretty(ajaxResponse));
		}
		
		return ajaxResponse;
	}
	
	// 회원가입 화면 띄우기 
	@RequestMapping(value="/user/signup")
	public String signUp(HttpServletRequest request, HttpServletResponse response) {
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		if(!StringUtil.isEmpty(cookieUserId)) {
			// 쿠키유저아이디가 비어있지 않으면
			CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
			return "redirect:/";
		} else {
			return "/user/signup";
		}
	}
	
	// 아이디 중복 체크
	@RequestMapping(value="/user/idCheck", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> idCheck(HttpServletRequest request, HttpServletResponse response){
		Response<Object> ajaxResponse = new Response<Object>();
		
		String userId = HttpUtil.get(request, "userId");
		
		if(!StringUtil.isEmpty(userId)) {
			if(userService.userSelect(userId) == null) {
				// 사용자 아이디로 조회했을 때 null인 경우 = 중복 아님
				ajaxResponse.setResponse(0, "Success");
			} else {
				ajaxResponse.setResponse(404, "userId is duplicated");
			}
		} else {
			// 아이디 값이 넘어오지 않은 경우
			ajaxResponse.setResponse(400, "Bad Request");
		}
		if(logger.isDebugEnabled()) {
			logger.debug("[UserController] /user/idCheck response\n" + 
						JsonUtil.toJsonPretty(ajaxResponse));  
		}

		return ajaxResponse;
	}
	
	// 사용자 등록 (회원가입)
	@RequestMapping(value="/user/userReg", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> userReg(HttpServletRequest request, HttpServletResponse response){
		Response<Object> ajaxResponse = new Response<Object>();
		
		String userId = HttpUtil.get(request, "userId");
		String userPwd = HttpUtil.get(request, "userPwd");
		String userName = HttpUtil.get(request, "userName");
		String userEmail = HttpUtil.get(request, "userEmail");
		
		if(!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd) &&
				!StringUtil.isEmpty(userName) && !StringUtil.isEmpty(userEmail)) {
			if(userService.userSelect(userId) == null) {
				User user = new User();
				
				user.setUserId(userId);
				user.setUserPwd(userPwd);
				user.setUserName(userName);
				user.setUserEmail(userEmail);
				
				// 사용자 등록 처리 건 수가 있을 경우 처리
				if(userService.userInsert(user) > 0) {
					ajaxResponse.setResponse(0, "Success");
				} else {
					// 처리 건 수가 안 들어온 경우
					ajaxResponse.setResponse(500, "server error");
				}
			} else {
				// 조회한 아이디가 있는 경우
				ajaxResponse.setResponse(100, "Duplicate id");
			}
		} else {
			// 값이 하나라도 안 넘어온 경우
			ajaxResponse.setResponse(400, "Bad Request");
		}
		
		if(logger.isDebugEnabled()) {
			logger.debug("[UserController] /user/userReg response\n" + 
						JsonUtil.toJsonPretty(ajaxResponse));  
		}
		
		return ajaxResponse;
	}
	
	// 비밀번호 찾기 화면 띄우기 
	@RequestMapping(value="/user/findpw")
	public String findPw(HttpServletRequest request, HttpServletResponse response) {
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		if(!StringUtil.isEmpty(cookieUserId)) {
			// 쿠키유저아이디가 비어있지 않으면
			CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
			return "redirect:/";
		} else {
			return "/user/findpw";
		}
	}
	
	// 이메일 발송
	@RequestMapping(value="/user/pwSearch", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> pwSearch(HttpServletRequest request, HttpServletResponse response) {
		Response<Object> ajaxResponse = new Response<Object>();
		
		String userId = HttpUtil.get(request, "userId");
		String userEmail = HttpUtil.get(request, "userEmail");
		
		if(!StringUtil.isEmpty(userEmail)) {
			// 이메일 값이 입력됐을 때
			if(userService.userSelect(userId) == null) { // 사용자 조회가 안 되어야 사용자 세팅
				User user = new User();
				
				// jsp엔 userEmail밖에 없기 때문에 이메일이나 아이디 중 하나라도 입력되면 이메일 전송되도록
				user.setUserEmail(userEmail);
				user.setUserId(userId);  
				
				// 비밀번호 찾기 건 수가 들어온 경우
				if(userService.pwSelect(user) > 0) {
					// 이메일 발송
					if(user != null) {
						Random r = new Random();
						int num = r.nextInt(999999);   // 랜덤 난수
					
						StringBuilder sb = new StringBuilder();
						
						if(StringUtil.equals(user.getUserEmail(), userEmail)) {
							String setFrom = "jsdjsr@naver.com";  // 발신자 이메일 (보내는 사람)
							String toMail = user.getUserEmail();  // 수신자 이메일
							String title = "[Sistagram] 비밀번호 변경 인증 이메일입니다.";

							sb.append(String.format("[Sistagram] 비밀번호 찾기 인증번호는 %d입니다!", num)); // 비밀번호 랜덤 난수
							String content = sb.toString();						
							
							try {
								MimeMessage mail = mailSender.createMimeMessage();
								MimeMessageHelper mailHelper = new MimeMessageHelper(mail, true, "UTF-8");

								mailHelper.setFrom(setFrom);
								mailHelper.setTo(toMail);
								mailHelper.setSubject(title);
								mailHelper.setText(content);
				                
				                //메일 전송
				                mailSender.send(mail);
				                
				                // 인증번호를 보냄과 동시에 인증번호를 DB에 업데이트 치기
								if(userService.pwUpdate(user) > 0) {
									ajaxResponse.setResponse(0, "Success");
								} else {
									ajaxResponse.setResponse(-99, "Not send");
								}
				                				         
				            }catch (Exception e) {
				            	e.printStackTrace();
				                logger.error("Exception occurred while sending email: " + e.getMessage());
				            }
							
						}
					}
				} else {
					// 비밀번호 찾을려고 할 때, 처리 건 수가 안 들어온 경우
					ajaxResponse.setResponse(500, "internal server error");
				}
			} else {
				// 사용자가 조회되는 경우
				ajaxResponse.setResponse(100, "You know password!..");
			}
		} else {
			// 하나라도 입력 안 된 경우
			ajaxResponse.setResponse(400, "Bad Request");
		}
		
		return ajaxResponse;
	}
	
	// 회원정보수정 화면
	@RequestMapping(value="/user/updateProfile")
	public String update(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		User user = userService.userSelect(cookieUserId);
		
		model.addAttribute("user", user);
		
		return "/user/updateProfile";
	}
	
	// 회원정보수정 처리
	@RequestMapping(value="/user/updateProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> updateProc(MultipartHttpServletRequest request, HttpServletResponse response){
		Response<Object> ajaxResponse = new Response<Object>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		String userId = HttpUtil.get(request, "userId");
		String userPwd = HttpUtil.get(request, "userPwd");
		String userName = HttpUtil.get(request, "userName");
		String userPhone = HttpUtil.get(request, "userPhone");
		String userEmail = HttpUtil.get(request, "userEmail");
		String intro = HttpUtil.get(request, "intro");
		String userTag = HttpUtil.get(request, "userTag");
	
		if(!StringUtil.isEmpty(cookieUserId)) {  // 로그인 상태
			if(StringUtil.equals(userId, cookieUserId)) {
				// 프로필 편집에서 넘어온 유저아이디와 쿠키유저아이디와 같을 경우
				User user = userService.userSelect(cookieUserId);
				
				if(user != null) {
					// 프로필 사진 수정					
					
					if(!StringUtil.isEmpty(userPhone) && !StringUtil.isEmpty(userPwd)
							&& !StringUtil.isEmpty(userEmail)) {
						// 이름, 전화번호, 이메일, 소개 값이 넘어온 경우
						// (이름, 소개 같은 경우는 값 입력 안 하면 땡땡이 처리 
						user.setUserName(userName);
						user.setUserPwd(userPwd);
						user.setUserPhone(userPhone);
						user.setUserEmail(userEmail);
						user.setUserIntro(intro);
						user.setUserTag(userTag);  // *사용자 태그 추가*

						if(userService.userUpdate(user) > 0) {
							// 사용자 수정 처리 건 수가 있는 경우
							ajaxResponse.setResponse(0, "Success");
						} else {
							// 프로필 수정 처리가 안 되는 경우
							ajaxResponse.setResponse(500, "internal server error");
						}
					} else {
							// 하나라도 안 넘어온 경우
							ajaxResponse.setResponse(400, "Bad Request");
						}
					} else {
						// DB에 사용자 정보가 없는 경우
						CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
						ajaxResponse.setResponse(404, "Not Found");
					}
				} else {
					// 쿠키에 저장된 유저아이디와 프로필 편집에서 넘어온 유저 아이디와 다른 경우
					CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
					ajaxResponse.setResponse(430, "id information is different");
				}
			} else {
				// 로그인되어 있지 않은 경우
				ajaxResponse.setResponse(410, "Login Failed");
			}
		
			return ajaxResponse;
		}
	
	// 로그아웃 처리
	@RequestMapping(value="/user/logOut")
	public String logOut(HttpServletRequest request, HttpServletResponse response) {
		if(CookieUtil.getCookie(request, AUTH_COOKIE_NAME) != null) { 
			// 쿠키 있을 경우
			CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
		}
		
		return "redirect:/"; // 재접속
	}
	
	// 사용자 검색 화면
	@RequestMapping(value="/search/userSearch")
	public String userList(ModelMap model, HttpServletRequest request, HttpServletResponse response) {	
		  List<User> list = null; 
		  User user = new User(); // 매개변수로 보내기 위해 User객체 생성
		  
		  String searchValue = HttpUtil.get(request, "searchValue", "");
		  
		  int totalCount = 0;
		 
		  totalCount = userService.userListCount(user);
		  
		  if(totalCount > 0) {	  // 사용자 리스트 건 수가 있을 경우
			  if(!StringUtil.isEmpty(searchValue)) { 
				  // searchValue 하나에 입력한 아이디, 이름, 소개 값을 세팅
				  user.setUserId(searchValue); 
				  user.setUserName(searchValue);
				  
				  user.setUserIntro(searchValue); 
			  } 
			  
			  user.setStartRow(1);
			  user.setEndRow(LIST_COUNT);  // 사용자 7명씩 보여줌
			  
			  list = userService.userList(user);
		  }
			 
		  model.addAttribute("list", list);
		  model.addAttribute("searchValue", searchValue); 
		
		return "/search/userSearch";
	} 
	
	// 팔로우 추천 리스트 '모두 보기' 화면
	@RequestMapping(value="/user/moreOtherUser")
	public String moreOtherUser(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		List<User> list = null;
		User user = new User();
		
		int totalCount = 0;
		
		totalCount = userService.userListCount(user);
		
		if(totalCount > 0) {
			user.setStartRow(1);
			user.setEndRow(99999999);  // 사용자 리스트 최대치... 하드코딩 설정함
			
			list = userService.userList(user);
		}
		
		model.addAttribute("list", list);
		
		return "/user/moreOtherUser";
	}
	
}
