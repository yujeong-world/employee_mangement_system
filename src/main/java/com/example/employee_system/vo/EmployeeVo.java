package com.example.employee_system.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;
@Getter
@Setter
@ToString
public class EmployeeVo {
    private Long id;
    private int employId;
    private String employName;
    private String employRank;
    private String phone;
    private String email;
    private LocalDateTime createAt;
    private LocalDateTime modifyAt;
}
