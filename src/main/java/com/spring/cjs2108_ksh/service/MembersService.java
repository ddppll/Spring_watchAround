package com.spring.cjs2108_ksh.service;

import com.spring.cjs2108_ksh.vo.MembersVO;

public interface MembersService {

	public MembersVO getEmailCheck(String email);

	public MembersVO getNickNameCheck(String nickName);

	public int memberJoin(MembersVO vo);

	public void visitUpdate(String email);

	public int setMemEdit(MembersVO vo);

	public void setMemDelete(String email);

	public MembersVO getPwdConfirm(String toMail);

	public void setPwdChange(String toMail, String encode);

}
