/**
 * <pre>
 * 프로젝트명 : Sistagram
 * 패키지명   : com.icia.web.handler
 * 파일명     : GlobalControllerAdvice.java
 * 작성일     : 2021. 1. 29.
 * 작성자     : daekk
 * </pre>
 */
package com.sist.web.handler;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.NoHandlerFoundException;

import com.sist.web.util.HttpUtil;

/**
 * <pre>
 * 패키지명   : com.icia.web.handler
 * 파일명     : GlobalControllerAdvice.java
 * 작성일     : 2021. 1. 29.
 * 작성자     : daekk
 * 설명       : 전역 예외 처리
 * </pre>
 */
@ControllerAdvice
public class GlobalControllerAdvice
{
	private static Logger logger = LoggerFactory.getLogger(GlobalControllerAdvice.class);
	
	/**
	 * AJAX 헤더 값
	 */
	@Value("#{env['ajax.header.name']}")
	private String AJAX_HEADER_NAME;
	
	/**
	 * 인증 쿠키명
	 */
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	/**
	 * <pre>
	 * 메소드명   : noHandlerFoundException
	 * 작성일     : 2021. 1. 29.
	 * 작성자     : daekk
	 * 설명       : 
	 * </pre>
	 * @param request
	 * @param response
	 * @param exception
	 * @return
	 */
	@ExceptionHandler(NoHandlerFoundException.class)
	public ModelAndView noHandlerFoundException(HttpServletRequest request, HttpServletResponse response, NoHandlerFoundException exception)
	{
		logger.debug("[GlobalControllerAdvice] NoHandlerFoundException");
		return exception(request, response, HttpStatus.NOT_FOUND, exception);
	}
	
	/**
	 * <pre>
	 * 메소드명   : maxUploadSizeExceededException
	 * 작성일     : 2021. 1. 29.
	 * 작성자     : daekk
	 * 설명       :
	 * </pre>
	 * @param request
	 * @param response
	 * @param exception
	 * @return
	 */
	@ExceptionHandler({MaxUploadSizeExceededException.class})
	public ModelAndView maxUploadSizeExceededException(HttpServletRequest request, HttpServletResponse response, MaxUploadSizeExceededException exception) 
	{
		logger.debug("[GlobalControllerAdvice] MaxUploadSizeExceededException");
		return exception(request, response, HttpStatus.INTERNAL_SERVER_ERROR, exception);
	}
	
	/**
	 * <pre>
	 * 메소드명   : runtimeException
	 * 작성일     : 2021. 1. 29.
	 * 작성자     : daekk
	 * 설명       :
	 * </pre>
	 * @param request
	 * @param response
	 * @param exception
	 * @return
	 */
	@ExceptionHandler({RuntimeException.class})
	public ModelAndView runtimeException(HttpServletRequest request, HttpServletResponse response, RuntimeException exception) 
	{
		logger.debug("[GlobalControllerAdvice] MaxUploadSizeExceededException");
		return exception(request, response, HttpStatus.INTERNAL_SERVER_ERROR, exception);
	}
	
	/**
	 * <pre>
	 * 메소드명   : servletException
	 * 작성일     : 2021. 1. 29.
	 * 작성자     : daekk
	 * 설명       :
	 * </pre>
	 * @param request
	 * @param response
	 * @param exception
	 * @return
	 */
	@ExceptionHandler({ServletException.class})
	public ModelAndView servletException(HttpServletRequest request, HttpServletResponse response, ServletException exception) 
	{
		logger.debug("[GlobalControllerAdvice] ServletException");
		return exception(request, response, HttpStatus.INTERNAL_SERVER_ERROR, exception);
	}
	
	/**
	 * <pre>
	 * 메소드명   : exception
	 * 작성일     : 2021. 1. 29.
	 * 작성자     : daekk
	 * 설명       :
	 * </pre>
	 * @param request
	 * @param response
	 * @param exception
	 * @return
	 */
	@ExceptionHandler({Exception.class})
	public ModelAndView exception(HttpServletRequest request, HttpServletResponse response, Exception exception) 
	{
		logger.debug("[GlobalControllerAdvice] Exception");
		return exception(request, response, HttpStatus.INTERNAL_SERVER_ERROR, exception);
	}
	
	/**
	 * <pre>
	 * 메소드명   : error
	 * 작성일     : 2021. 1. 29.
	 * 작성자     : daekk
	 * 설명       :
	 * </pre>
	 * @param request
	 * @param response
	 * @param error
	 * @return
	 */
	@ExceptionHandler({Error.class})
	public ModelAndView error(HttpServletRequest request, HttpServletResponse response, Error error) 
	{
		logger.debug("[GlobalControllerAdvice] Error");
		return exception(request, response, HttpStatus.INTERNAL_SERVER_ERROR, error);
	}
	
	/**
	 * <pre>
	 * 메소드명   : exception
	 * 작성일     : 2021. 1. 29.
	 * 작성자     : daekk
	 * 설명       :
	 * </pre>
	 * @param request
	 * @param response
	 * @param httpStatus
	 * @param throwable
	 * @return
	 */
	private ModelAndView exception(HttpServletRequest request, HttpServletResponse response, HttpStatus httpStatus, Throwable throwable)
	{
		logger.debug(HttpUtil.requestLogString(request));
		
		request.setAttribute("AUTH_COOKIE_NAME", AUTH_COOKIE_NAME);
		
		ModelAndView mav = new ModelAndView();
		
		if(HttpUtil.isAjax(request, AJAX_HEADER_NAME))
		{
			mav.setViewName("jsonView");
			
			int code = 500;
			String msg = "";
			
			if(httpStatus != null)
			{
				code = httpStatus.value();
			}
					
			if( throwable instanceof NoHandlerFoundException )
			{
				msg = "not found url " + request.getRequestURI();
			}
			else
			{
				msg = throwable.toString();
			}
			
			mav.addObject("code", code);
			mav.addObject("msg", msg);
			mav.addObject("data", null);
			
		}
		else
		{
			mav.setViewName("/error/error");
			
			mav.addObject("exception", throwable);
		}
		
		return mav;
	}
}
