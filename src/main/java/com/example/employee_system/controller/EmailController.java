package com.example.employee_system.controller;

import com.example.employee_system.bean.dto.EmailDto;
import com.example.employee_system.bean.dto.EmployeeDto;
import com.example.employee_system.service.Emailservice;
import com.example.employee_system.service.EmployeeService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class EmailController {
    private final Emailservice emailService;
    private final EmployeeService employeeService;

    public EmailController(Emailservice emailservice, EmployeeService employeeService) {
        this.emailService = emailservice;
        this.employeeService = employeeService;
    }
    // 직원 정보 이메일 발송
    @PostMapping("/email")
    @ResponseBody
    public String sendEmail(@RequestParam int employId) {
        EmployeeDto employeeDto = employeeService.getEmployById(employId);

        String emailContent = "직원 정보\n" +
                "\n" +
                "이름 : " + employeeDto.getEmployName() + "\n" +
                "사번 : " + employeeDto.getEmployId() + "\n" +
                "계급 : " + employeeDto.getEmployRank() + "\n" +
                "이메일 : " + employeeDto.getEmail() + "\n" +
                "전화번호 : " + employeeDto.getPhone();

        EmailDto emailDto = new EmailDto();
        emailDto.setToEmail("yjgwon.comtrue@gmail.com"); //메일 ID
        emailDto.setSubject(employeeDto.getEmployName()+"님의 정보 내역입니다."); //메일 제목
        emailDto.setText(emailContent); // 메일 내용
        emailDto.setEmployeeId(employId); // 직원 번호

        emailService.sendEmployeeInfo(emailDto);
        //emailService.saveMailHistory(employeeId, employeeDto.getEmail());

        //int emailCount = emailService.countMailHistoryByEmployeeId(employeeId);
       //emailDto.setEmailCount(emailCount);

//        return "메일을 성공적으로 보냈습니다 : " + "총 "+emailCount+"건";
        return "메일을 성공적으로 보냈습니다";


      /*  try {
            System.out.println("이메일 발송 test");
            emailservice.sendMail(*//*emailDto*//*);
        } catch (MessagingException e) {
            throw new RuntimeException(e);
        }
*/
    }
}
