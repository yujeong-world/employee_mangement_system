package com.example.employee_system.service;

import com.example.employee_system.bean.dto.EmailDto;
import com.example.employee_system.util.NetworkUtil;
import com.example.employee_system.util.SystemUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import javax.mail.MessagingException;
import java.time.LocalDate;

import static com.example.employee_system.controller.EmailController.RECEIVED_EMAIL;

@Service
@RequiredArgsConstructor
public class SchedulerService {
    private final Emailservice emailService;

    /*@Scheduled(fixedDelay = 10000) */// 10초 마다 실행
    // 매일 오후 14시에 실행
    @Scheduled(cron = "0 0 14 * * *")
    public void serverInfoEmail() throws MessagingException {
        //메일 내용
        String emailContent = "서버 정보\n" +
                "\n" +
                "로컬 ip 정보: : " + NetworkUtil.getServerIp() + "\n" +
                "로컬 mac 주소 정보 : " + NetworkUtil.getLocalMacAddress() + "\n" +
                "CPU 사용량 : " + SystemUtil.getCpuUsage() + "\n" +
                "메모리 사용량 : " + SystemUtil.getMemoryUsage() + "\n";

        //오늘 날짜
        LocalDate date = LocalDate.now();

        EmailDto emailDto = new EmailDto();

        emailDto.setToEmail(RECEIVED_EMAIL); //메일 ID
        emailDto.setSubject(date+"서버 정보 리포팅입니다."); //메일 제목
        emailDto.setText(emailContent); // 메일 내용

        emailService.sendEmail(emailDto);
    }


}
