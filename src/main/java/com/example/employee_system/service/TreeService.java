package com.example.employee_system.service;

import com.example.employee_system.bean.dto.TreeDto;
import com.example.employee_system.mapper.TreeMapper;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
public class TreeService {
    private TreeMapper mapper;

    public List<TreeDto> getTree(){
        return mapper.getTree();
    }
}
