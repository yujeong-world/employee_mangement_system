package com.example.employee_system.service;
import com.example.employee_system.bean.dto.EmailDto;
import com.example.employee_system.mapper.EmailMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.io.IOException;
import java.util.Properties;


@Service
@RequiredArgsConstructor
public class Emailservice {
    private final EmailMapper emailMapper;

    @Value("${spring.mail.username}")
    private String fromEmail;

    @Value("${spring.mail.password}")
    private String emailPassword;

    private final String host = "smtp.gmail.com";
    private final int port = 587;


    // 1. 메일 발송 내역
    public void sendEmployeeInfo(EmailDto emailDto/*, List<FileDto> files*/) throws MessagingException, IOException {
        Properties props = new Properties();
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", port);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.trust", host);

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, emailPassword);
            }
        });

        MimeMessage message = new MimeMessage(session);
        message.setFrom(new InternetAddress(fromEmail));
        message.setRecipient(Message.RecipientType.TO, new InternetAddress("coko131@naver.com"));
        message.setSubject(emailDto.getSubject());
        message.setText(emailDto.getText());

        // 첨부파일 추가
       /* if (files != null) {
            for (FileDto fileDto : files) {
                MimeBodyPart attachmentPart = new MimeBodyPart();
                attachmentPart.attachFile(new File(fileDto.getSavePath() + "/" + fileDto.getSaveName()));
                Multipart multipart = new MimeMultipart();
                multipart.addBodyPart(attachmentPart);
                message.setContent(multipart);
            }
        }*/

        Transport.send(message);

    }

    // 메일 보내기
    public void sendEmail(EmailDto emailDto/*, List<FileDto> files*/) throws MessagingException {
        Properties props = new Properties();
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", port);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.trust", host);

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, emailPassword);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(fromEmail));
        message.setRecipient(Message.RecipientType.TO, new InternetAddress("coko131@naver.com"));
        message.setSubject(emailDto.getSubject());
        message.setText(emailDto.getText());

        Transport.send(message);
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
