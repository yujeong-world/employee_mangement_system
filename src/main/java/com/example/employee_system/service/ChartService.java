package com.example.employee_system.service;

import com.example.employee_system.mapper.ChartMapper;
import com.example.employee_system.vo.ChartVo;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
public class ChartService {
    public final ChartMapper chartMapper;
    public List<ChartVo> getGroupByDepartment(){
        return chartMapper.selectGroupByDepartment();
    }

    public List<ChartVo> getGroupByRank(){
        return chartMapper.selectGroupByRank();
    }
}
