package com.example.employee_system.service;

import com.example.employee_system.bean.dto.EmailDto;
import com.example.employee_system.bean.dto.EmployeeDto;
import com.example.employee_system.bean.dto.FileDto;
import com.example.employee_system.mapper.EmailMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.mail.javamail.JavaMailSender;
import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import java.io.File;
import java.util.List;

@Service
@RequiredArgsConstructor
public class Emailservice {
    private final EmailMapper emailMapper;
    private final JavaMailSender mailSender;

    @Value("${spring.mail.username}")
    private String fromEmail;

    //private static final String FIXED_FILE_PATH = "C:/Users/USER/Desktop/uploading/";  // 내 로컬에서 파일이 저장된 고정 경로 (자기 환경에 맞게 수정)

    // 1. 메일 발송 내역
    public void sendEmployeeInfo(EmailDto emailDto, List<FileDto> files) throws MessagingException {
       /* SimpleMailMessage message = new SimpleMailMessage();

        message.setTo(fromEmail); // 보내는 사람
        message.setTo(emailDto.getToEmail());      // 받는 사람
        message.setSubject(emailDto.getSubject()); // 제목
        message.setText(emailDto.getText());       // 내용
        mailSender.send(message);                  // 보내기*/
        MimeMessage message = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8"); // 첨부파일 기능

        helper.setFrom(fromEmail);                // 보내는 사람
        helper.setTo(emailDto.getToEmail());      // 받는 사람
        helper.setSubject(emailDto.getSubject()); // 제목
        helper.setText(emailDto.getText(), true); // 내용 (HTML 가능)

        // 첨부파일 추가
        if (files != null) {
            for (FileDto fileDto : files) {
                File file = new File(fileDto.getSavePath()+ "/" + fileDto.getSaveName()); // 고정 경로와 저장된 파일명을 결합하여 File 객체 생성
                helper.addAttachment(fileDto.getOriginalName(), file); // 첨부파일 추가
            }
        }
        mailSender.send(message);
    }

    //메일 보내기
    public void sendEmail(EmailDto emailDto) throws MessagingException {
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
