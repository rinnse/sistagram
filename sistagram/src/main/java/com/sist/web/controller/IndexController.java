/**
 * <pre>
 * 프로젝트명 : Manager
 * 패키지명   : com.icia.manager.controller
 * 파일명     : IndexController.java
 * 작성일     : 2021. 7. 30.
 * 작성자     : mslim
 * </pre>
 */
package com.sist.web.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;


/**
 * <pre>
 * 패키지명   : com.icia.sistagram.controller
 * 파일명     : IndexController.java
 * 작성일     : 2021. 7. 30.
 * 작성자     : daekk
 * 설명       : 인덱스 컨트롤러
 * </pre>
 */
@Controller("indexController")
public class IndexController
{
	private static Logger logger = LoggerFactory.getLogger(IndexController.class);

	// 쿠키명
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	/**
	 * <pre>
	 * 메소드명   : index
	 * 작성일     : 2021. 7. 30.
	 * 작성자     : daekk
	 * 설명       : 인덱스
	 * </pre>
	 * @param request  HttpServletRequest
	 * @param response HttpServletResponse
	 * @return String
	 */
	// 회원용 로그인
	@RequestMapping(value="/index")
	public String index(Model model, HttpServletRequest request, HttpServletResponse response)
	{
		return "/index";
	}

	// 관리자용 로그인
	@RequestMapping(value="/index2")
	public String index2(Model model, HttpServletRequest request, HttpServletResponse response)
	{
		return "/index2";
	}
}
