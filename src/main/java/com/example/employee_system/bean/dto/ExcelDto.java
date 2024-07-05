package com.example.employee_system.bean.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.apache.ibatis.type.Alias;

@ToString
@Getter
@Setter
@Alias("ExcelDto")
public class ExcelDto {
    private int employId;
    private String employName;
    private String department;
    private String employRank;
    private String phone;
    private String email;
}
