package com.sist.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.sist.web.dao.UserDao;
import com.sist.web.model.User;
import com.sist.web.model.UserFile;

@Service("userService")
public class UserService {
	private static Logger logger = LoggerFactory.getLogger(UserService.class);
	
	@Autowired
	private UserDao userDao;
	
	// 파일 저장 경로
	@Value("#{env['upload.save.dir']}")
	private String UPLOAD_SAVE_DIR;	
	
	
	// 사용자 조회
	public User userSelect(String userId) {
		User user = null;
		
		try {
			user = userDao.userSelect(userId);
		} catch(Exception e) {
			logger.error("[UserService] userSelect Exception", e);
		}
		
		return user;
	}
	
	// 사용자 등록
	public int userInsert(User user) {
		int count = 0;
		
		try {
			count = userDao.userInsert(user);
		} catch(Exception e) {
			logger.error("[UserService] userInsert Exception", e);
		}
		
		return count;
	}

	// 비밀번호 찾기
	public int pwSelect(User user) {
		int count = 0;
		
		try {
			count = userDao.pwSelect(user);
		} catch(Exception e) {
			logger.error("[UserService] pwSelect Exception", e);
		}
		
		return count;
	}
	
	// 비밀번호 압데이트
	public int pwUpdate(User user) {
		int count = 0;
		
		try {
			count = userDao.pwUpdate(user);
		} catch(Exception e) {
			logger.error("[UserService] pwUpdate Exception", e);
		}
		
		return count;
	}
	
	// 사용자 프로필 편집 (회원정보수정)
	public int userUpdate(User user) {
		int count = 0;
		
		try {
			count = userDao.userUpdate(user);
		} catch(Exception e) {
			logger.error("[UserService] userUpdate Exception", e);
		}
		
		return count;
	}
	
	// 사용자 리스트 조회
	public List<User> userList(User user){
		List<User> list = null;
		
		try {
			list = userDao.userList(user);
		} catch(Exception e) {
			logger.error("[UserService] userList Exception", e);
		}
		
		return list;
	}
	
	// 총 사용자 수 조회
	public int userListCount(User user) {
		int count = 0;
		
		try {
			count = userDao.userListCount(user);
		} catch(Exception e) {
			logger.error("[UserService] userListCount Exception", e);
		}
		
		return count;
	}
	
	// 회원님을 위한 추천 리스트
	public List<User> userRecommendList(User user){
		List<User> recomList = null;
		
		try {
			recomList = userDao.userRecommendList(user);
		} catch(Exception e) {
			logger.error("[UserService] userRecommendList Exception", e);
		}
		
		return recomList;
	}
	
	
	// 관리자용
	
	// 회원관리 리스트
	public List<User> userMgtList(User user){
		List<User> umList = null;
		
		try {
			umList = userDao.userMgtList(user);
		} catch(Exception e) {
			logger.error("[UserService] userMgtList Exception", e);
		}
		
		return umList;
	}
	
	// 회원관리 리스트 건 수
	public int userMgtListCount(User user) {
		int count = 0;
		
		try {
			count = userDao.userMgtListCount(user);
		} catch(Exception e) {
			logger.error("[UserService] userMgtListCount Exception", e);
		}
		
		return count;
	}
}
