package com.example.employee_system.bean.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.apache.ibatis.type.Alias;

import java.time.LocalDateTime;

@ToString
@Getter
@Setter
@Alias("FileDto")
public class FileDto {
    private int id;
    private int employId;
    private String originalName;
    private String saveName;
    private String savePath;
    private LocalDateTime createAt;
}
