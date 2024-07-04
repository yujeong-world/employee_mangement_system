package com.example.employee_system.bean.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.apache.ibatis.type.Alias;

import java.util.List;
@Getter
@Setter
@ToString
@Alias("EmailDto")
public class EmailDto {
    private String toEmail;
    private String subject;
    private String text;
    private int employeeId;
    private int emailCount;
}
