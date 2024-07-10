package com.example.employee_system.mapper;

import com.example.employee_system.bean.dto.TreeDto;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface TreeMapper {
    List<TreeDto> getTree();

    //부서 추가
    void insertTree(TreeDto treeDto);

    // 부서 중복 확인
  /*  TreeDto getTreeByName(String id);

    TreeDto getTreeById(int id);*/

    //트리 조회(조건 : 이름, id)
    List<TreeDto> selectTree(String name, int id, int parent);

    //3. 부서 수정
    void updateTree(TreeDto treeDto);

    //4. 부서 삭제
    void deleteTree(int id);

}
