package com.example.employee_system.mapper;

import com.example.employee_system.bean.dto.ExcelDto;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ExcelMapper {
    //직원 일괄 등록
    public void insertExcel(ExcelDto excelDto);

}
