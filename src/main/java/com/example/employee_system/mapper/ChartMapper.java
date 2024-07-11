package com.example.employee_system.mapper;

import com.example.employee_system.vo.ChartVo;
import com.example.employee_system.vo.EmployeeVo;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface ChartMapper {
    public List<ChartVo> selectGroupByDepartment();

    public List<ChartVo> selectGroupByRank();
}
