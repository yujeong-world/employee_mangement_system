package com.example.employee_system.bean.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.apache.ibatis.type.Alias;

import java.util.List;

@Getter
@Setter
@ToString
@Alias("JoinRequestDto")
public class RequestDto {
    private EmployeeDto employee;
    private List<FileDto> file;
}
