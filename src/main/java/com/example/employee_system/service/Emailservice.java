package com.example.employee_system.service;

import com.example.employee_system.bean.dto.EmailDto;
import com.example.employee_system.bean.dto.EmployeeDto;
import com.example.employee_system.mapper.EmailMapper;
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
    private final EmailMapper emailMapper;
    private final JavaMailSender mailSender;

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

    // 2. 메일 발송 기록 저장(DB)
    public void saveMailHistory(int employId, String email){
        emailMapper.saveMailHistory(employId, email);
    }

    // 3. 이메일 보낸 횟수
    public int countMailHistoryByEmployeeId(int employId) {
        return emailMapper.countMailHistoryByEmployeeId(employId);
    }


}
