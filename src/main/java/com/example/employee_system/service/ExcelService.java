package com.example.employee_system.service;

import com.example.employee_system.bean.dto.ExcelDto;
import com.example.employee_system.mapper.ExcelMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@RequiredArgsConstructor
@Service
public class ExcelService {
    private final ExcelMapper excelMapper;

    //엑셀 일괄 직원 추가
    @Transactional
    public void insertExcel(ExcelDto excelDto){
        excelMapper.insertExcel(excelDto);
    }
}
