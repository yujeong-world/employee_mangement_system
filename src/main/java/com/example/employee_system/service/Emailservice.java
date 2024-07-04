package com.example.employee_system.service;

import com.example.employee_system.bean.dto.EmailDto;
import com.example.employee_system.bean.dto.EmployeeDto;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.stereotype.Service;
import org.springframework.mail.javamail.JavaMailSender;
import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

@Service
@RequiredArgsConstructor
public class Emailservice {
    //MimeMessage message = mail

    private final JavaMailSender mailSender;
    //private final EmailRepository emailRepository;

    //private JavaMailSender javaMailSender;
    private static final String senderEmail = "yjgwon.comtrue@gmail.com";
    private static final String recipientsEmail = "yjgwon.comtrue@gmail.com";

    /*public void sendMail(*//*EmailDto emailDto*//*) throws MessagingException {
        // 이메일 폼 생성
        //MimeMessage emailForm = createEmailForm(emailDto);
        //MimeMessage emailForm = createEemailForm(emailDto);

        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(senderEmail); //보낼 사람
        message.setSubject("요청해주신 직원 정보입니다.");
        message.setText("본문 내용 테스트");

        //이메일 발송
        javaMailSender.send(message);

    }*/


/*
    // 이메일 폼 생성
    public MimeMessage createEmailForm(EmailDto emailDto) throws MessagingException {
        MimeMessage message = javaMailSender.createMimeMessage();
        //수신자 설정
        message.addRecipients(MimeMessage.RecipientType.TO, "yjgwon.comtrue@gmail.com");
        message.setSubject("안녕하세요. 요청하신 직원 정보입니다."); //이메일 제목
        message.setFrom(senderEmail); // 발신자 이메일 주소 설정
        //message.setText(setContext(authCode), "utf-8", "html"); // 이메일 본문 설정 (HTML 형식)

        return message;

    }*/


    @Value("${spring.mail.username}")
    private String fromEmail;

    // 1. 메일 발송 내역
    public void sendEmployeeInfo(EmailDto emailDto){
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(fromEmail); // 보내는 사람
        message.setTo(emailDto.getToEmail());      // 받는 사람
        message.setSubject(emailDto.getSubject()); // 제목
        message.setText(emailDto.getText());       // 내용
        mailSender.send(message);                  // 보내기
    }


}
