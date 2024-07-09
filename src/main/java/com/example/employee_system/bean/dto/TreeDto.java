package com.example.employee_system.bean.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class TreeDto {
    private int id;
    private String name;
    private int depth;
    private int parentId;
}
