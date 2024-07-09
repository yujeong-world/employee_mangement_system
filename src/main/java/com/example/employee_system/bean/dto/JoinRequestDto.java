package com.example.employee_system.bean.dto;

import com.example.employee_system.vo.EmployeeVo;
import com.example.employee_system.vo.FileVo;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.apache.ibatis.type.Alias;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@ToString
@Alias("JoinRequestDto")
public class JoinRequestDto {
    private EmployeeVo employeeVo;
    private List<FileVo> fileVo;
    private List<Integer> deleteList;
}
