package com.example.employee_system.controller;

import com.example.employee_system.bean.dto.EmailDto;
import com.example.employee_system.bean.dto.EmployeeDto;
import com.example.employee_system.bean.dto.FileDto;
import com.example.employee_system.service.Emailservice;
import com.example.employee_system.service.EmployeeService;
import com.example.employee_system.service.FileService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.mail.MessagingException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequiredArgsConstructor
public class EmailController {
    private final Emailservice emailService;
    private final EmployeeService employeeService;
    private final FileService fileService;

    public static final String RECEIVED_EMAIL = "hjkim2@comtrue.com";

    // 직원 정보 이메일 발송
    @PostMapping("/email")
    @ResponseBody
    public String sendEmail(@RequestParam int employId) throws IOException {
        //pk로 조회
        EmployeeDto employeeDto = employeeService.getEmploy(0,employId);

        Long employeeId = employeeDto.getId();
        //첨부파일 리스트 가지고 오기
        List<FileDto> fileList = fileService.getFileListByEmployId(employeeId);

        //orginalName을 저장할 리스트 생성
        List<String> originalNames = new ArrayList<>();

        // 첨부 파일 반복문 돌려서 다 가져 오기
        if (fileList != null) {
            for (FileDto fileDto : fileList) {
                originalNames.add(fileDto.getOriginalName());
            }
        }

        // 첨부 파일 내역 (첨부1, 첨부2, 첨부3) 콤마로 나눠줌
        String fileAttachments = String.join(", ", originalNames);

        String emailContent = "직원 정보\n" +
                "\n" +
                "이름 : " + employeeDto.getEmployName() + "\n" +
                "사번 : " + employeeDto.getEmployId() + "\n" +
                "계급 : " + employeeDto.getEmployRank() + "\n" +
                "이메일 : " + employeeDto.getEmail() + "\n" +
                "전화번호 : " + employeeDto.getPhone() + "\n" +
                "파일 첨부 내역 : " + fileAttachments;

        EmailDto emailDto = new EmailDto();
        emailDto.setToEmail(RECEIVED_EMAIL); //메일 ID
        emailDto.setSubject(employeeDto.getEmployName()+"님의 정보 내역입니다."); //메일 제목
        emailDto.setText(emailContent); // 메일 내용
        emailDto.setEmployeeId(employId); // 직원 번호

        try {
            emailService.sendEmployeeInfo(emailDto/*, fileList*/);     // 메일 내용 보내기 (첨부파일 포함)
        } catch (MessagingException e) {
            return "메일 발송에 실패했습니다.";
        }
        emailService.saveMailHistory(employId, RECEIVED_EMAIL);

        int emailCount = emailService.countMailHistoryByEmployeeId(employId);
        emailDto.setEmailCount(emailCount);

        return "메일을 성공적으로 보냈습니다 : " + "총 "+emailCount+"건";


    }
}
