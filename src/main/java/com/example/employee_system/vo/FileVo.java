package com.example.employee_system.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;
@Getter
@Setter
@ToString
public class FileVo {
    private Long id;
    private Long employId;
    private String originalName;
    private String saveName;
    private LocalDateTime createAt;
}
