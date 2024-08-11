package com.sist.web.dao;

import org.springframework.stereotype.Repository;

import com.sist.web.model.Admin;

@Repository("adminDao")
public interface AdminDao {
	
	// 관리자 조회
	public Admin adminSelect(String admId);
	
	// 관리자 등록
	public int adminInsert(Admin admin);
}
