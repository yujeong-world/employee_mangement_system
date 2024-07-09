package com.example.employee_system.mapper;

import com.example.employee_system.bean.dto.TreeDto;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface TreeMapper {
    List<TreeDto> getTree();
}
