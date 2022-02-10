package com.spring.cjs2108_ksh.dao;

import org.apache.ibatis.annotations.Param;

import com.spring.cjs2108_ksh.vo.MembersVO;

public interface MembersDAO {

	public MembersVO getEmailCheck(@Param("email") String email);

	public MembersVO getNickNameCheck(@Param("nickName") String nickName);

	public void memberJoin(@Param("vo") MembersVO vo);

	public void visitUpdate(@Param("email") String email);

	public void setMemEdit(@Param("vo") MembersVO vo);

	public void setMemDelete(@Param("email") String email);

	public MembersVO getPwdConfirm(@Param("toMail") String toMail);

	public void setPwdChange(@Param("toMail") String toMail, @Param("pwd") String pwd);

}
