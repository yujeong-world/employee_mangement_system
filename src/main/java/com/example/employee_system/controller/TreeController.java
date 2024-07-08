package com.example.employee_system.controller;

import com.example.employee_system.bean.dto.TreeDto;
import com.example.employee_system.service.TreeService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@RequestMapping("/tree")
@AllArgsConstructor
public class TreeController {
    private TreeService treeService;
    @GetMapping("/list")
    @ResponseBody
    public List<TreeDto> tree(TreeDto treeDto, Model model) throws Exception{
        List<TreeDto> trees = treeService.getTree();
        return trees;
    }
}
