package com.example.employee_system.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.springframework.web.bind.annotation.PathVariable;

@Getter
@Setter
@ToString
public class ChartVo {
    private String department;
    private int count;
    private String employRank;
}
