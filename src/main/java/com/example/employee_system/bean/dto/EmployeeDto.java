package com.example.employee_system.bean.dto;

//import com.google.gson.Gson;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.apache.ibatis.type.Alias;

import java.time.LocalDateTime;

@ToString
@Getter
@Setter
@Alias("EmployeeDto")
public class EmployeeDto {
    private Long id;
    private int employId;
    private String employName;
    private String employRank;
    private String phone;
    private String email;
    private LocalDateTime createAt;
    private LocalDateTime modifyAt;
}
