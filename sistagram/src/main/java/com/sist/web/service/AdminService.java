package com.sist.web.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sist.web.dao.AdminDao;
import com.sist.web.model.Admin;

@Service("adminService")
public class AdminService {
	private static Logger logger = LoggerFactory.getLogger(AdminService.class);
	
	@Autowired
	private AdminDao adminDao;
	
	// 관리자 조회
	public Admin adminSelect(String admId) {
		Admin admin = null;
		
		try {
			admin = adminDao.adminSelect(admId);
		} catch(Exception e) {
			logger.error("[AdminService] adminSelect Exception", e);
		}
		
		return admin;
	}
	
	// 관리자 등록
	public int adminInsert(Admin admin) {
		int count = 0;
		
		try {
			count = adminDao.adminInsert(admin);
		} catch(Exception e) {
			logger.error("[AdminService] adminInsert Exception", e);
		}
		
		return count;
	}
}
