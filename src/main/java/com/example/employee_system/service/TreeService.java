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

    // 2. 부서 추가
    public void addTree(TreeDto treeDto){
        mapper.insertTree(treeDto);
    }

    // 2-1. 부서 추가 - 부서(id) 중복 체크
    public String checkName(String name){
        List<TreeDto> treeDto = mapper.selectTree(name, 0, 0);
        //중복이 아니면
        if(treeDto.size() >0){
            return "이미 사용중";
        }else {
            return "Valid";
        }
    }

    // 2-2. 부서 조회(부모 depth 조회하기 위함)
    public List<TreeDto> getTreeById(int id){
        return mapper.selectTree(null, id, 0);
    }

    // 3. 부서 수정
    public void modifyTree(TreeDto treeDto){
        //부모 요소의 깊이
        // 부모 요소 + 1
        List<TreeDto> treeDtoParentList = getTreeById(treeDto.getParent());
        TreeDto treeDtoParent = treeDtoParentList.get(0);
        treeDto.setDepth(treeDtoParent.getDepth() + 1);

        mapper.updateTree(treeDto);
    }

    // 4. 부서 삭제
    public void deleteTree(int id){
        //삭제 요소의 하위에 존재하는 요소들이 있는지 조회
        List<TreeDto> treeDtos = mapper.selectTree(null, 0, id);
        if(treeDtos != null){
            for(TreeDto treeDto : treeDtos){
                treeDto.setDepth(1);
                treeDto.setParent(1);
                mapper.updateTree(treeDto);
            }
        }
        mapper.deleteTree(id);
    }
}
