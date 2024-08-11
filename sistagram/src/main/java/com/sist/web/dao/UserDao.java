package com.sist.web.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.sist.web.model.User;
import com.sist.web.model.UserFile;

@Repository("userDao")
public interface UserDao {
	
	// 사용자 조회
	public User userSelect(String userId);
	
	// 사용자 등록
	public int userInsert(User user);
	
	// 비밀번호 찾기 조회
	public int pwSelect(User user);
	
	// 비밀번호 업데이트
	public int pwUpdate(User user);
	
	// 사용자 프로필 편집
	public int userUpdate(User user);
	
	// 사용자 리스트 
	public List<User> userList(User user);
	
	// 총 사용자 수 조회
	public int userListCount(User user);
	
	// 회원님을 위한 추천 리스트
	public List<User> userRecommendList(User user);
	
	
	// 관리자용
	
	// 회원관리 리스트
	public List<User> userMgtList(User user);
	
	// 회원관리 리스트 건 수
	public int userMgtListCount(User user);
}
