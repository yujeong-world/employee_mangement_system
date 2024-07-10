package com.example.employee_system.controller;

import com.example.employee_system.bean.dto.TreeDto;
import com.example.employee_system.service.TreeService;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
@Slf4j
@Controller
@RequestMapping("/tree")
@AllArgsConstructor
public class TreeController {
    private TreeService treeService;

    //1. 부서 조회
    @GetMapping("/list")
    @ResponseBody
    public List<TreeDto> tree(TreeDto treeDto, Model model) throws Exception{
        List<TreeDto> trees = treeService.getTree();
        log.info("trees: {}", trees);
        return trees;
    }

    // 2. 부서 추가
    @PostMapping("/add")
    @ResponseBody
    public ResponseEntity<String> add(@RequestBody TreeDto treeDto) throws Exception{

        //treeDto.setName(name);
        //treeDto.setParent(parent);
        // depth 세팅
        // 부모 요소 + 1
        List<TreeDto> treeDtoParentList = treeService.getTreeById(treeDto.getParent());
        TreeDto treeDtoParent = treeDtoParentList.get(0);
        treeDto.setDepth(treeDtoParent.getDepth() + 1);

        treeService.addTree(treeDto);

        return ResponseEntity.ok("부서 추가에 성공하였습니다.");
    }

    // 2-1. 부서 추가 - 부서(id) 중복 체크
    @GetMapping("/check")
    @ResponseBody
    public String check(@RequestParam String name) throws Exception{
        // 중복 체크
        /*String checkMsg = treeService.checkId(name);*/
        String checkMsg = treeService.checkName(name);

        return checkMsg;
    }

    //3. 부서 수정
    @PostMapping("/modify")
    @ResponseBody
    public ResponseEntity<String> modify(@RequestBody TreeDto treeDto) throws Exception{
        treeService.modifyTree(treeDto);
        return ResponseEntity.ok("부서정보가 수정되었습니다.");
    }

    // 4. 부서 삭제
    @PostMapping("/delete")
    @ResponseBody
    public ResponseEntity<String> delete(@RequestParam int id) throws Exception{
        treeService.deleteTree(id);
        return ResponseEntity.ok("부서 삭제를 완료하였습니다.");
    }

}
