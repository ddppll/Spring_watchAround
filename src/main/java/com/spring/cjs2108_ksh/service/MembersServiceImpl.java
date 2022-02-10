package com.spring.cjs2108_ksh.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.cjs2108_ksh.dao.MembersDAO;
import com.spring.cjs2108_ksh.vo.MembersVO;

@Service
public class MembersServiceImpl implements MembersService {
	@Autowired
	MembersDAO membersDAO;
	
	@Override
	public MembersVO getEmailCheck(String email) {
		return membersDAO.getEmailCheck(email);
	}

	@Override
	public MembersVO getNickNameCheck(String nickName) {
		return membersDAO.getNickNameCheck(nickName);
	}

	@Override
	public int memberJoin(MembersVO vo) {
		int res = 0;
		membersDAO.memberJoin(vo);
		res = 1;
		return res;
	}

	@Override
	public void visitUpdate(String email) {
		membersDAO.visitUpdate(email);
		
	}

	@Override
	public int setMemEdit(MembersVO vo) {
		int res = 0;
		membersDAO.setMemEdit(vo);
		res = 1;
		return res;
	}

	@Override
	public void setMemDelete(String email) {
		membersDAO.setMemDelete(email);
		
	}

	@Override
	public MembersVO getPwdConfirm(String toMail) {
		return membersDAO.getPwdConfirm(toMail);
	}

	@Override
	public void setPwdChange(String toMail, String pwd) {
		membersDAO.setPwdChange(toMail, pwd);
	}

}
