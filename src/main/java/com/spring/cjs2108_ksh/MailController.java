package com.spring.cjs2108_ksh;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/mail")
public class MailController {
	@Autowired
	JavaMailSender mailSender;
	
	@RequestMapping(value="/pwdConfirmSend/{toMail}/{content}/", method = RequestMethod.GET)
	public String pwdConfirmPost(@PathVariable String toMail, @PathVariable String content) {
		try {
			String fromMail = "justttup@gmail.com";
			String title = ">>임시 비밀번호 발급";
			String pwd = content;
			content = "아래 임시 비밀번호를 사용해 로그인한 뒤 비밀번호를 변경하세요.\n";
			
			//메세지를 변환시켜 보관함(messageHelper)에 저장하기 위한 준비를 한다
			MimeMessage message = mailSender.createMimeMessage();
			MimeMessageHelper messageHelper = new MimeMessageHelper(message, true, "UTF-8");
		
			//메일보관함에 보낸 메세지를 모두 저장시켜준다
			messageHelper.setFrom(fromMail);
			messageHelper.setTo(toMail);
			messageHelper.setSubject(title);
			
			//메세지 내용 편집 후 보관함에 저장처리
			content = content.replace("\n", "<br/>");
			content += "<br><hr><h3>임시 비밀번호 : <font color='red'>"+pwd+"</font></h3><hr><br>";
			content += "<p>로그인하러 가기 <a href='http://localhost:9090/cjs2108_ksh'>➡➡</a></p><hr>";
			messageHelper.setText(content,true);//이거 true 꼭 써줘야함 안그러면 태그대로 안나옴
			
			mailSender.send(message);
			
		} catch (MessagingException e) {
			e.printStackTrace();
		}
		
		return "redirect:/msg/pwdConfirmOk";
	}

}
