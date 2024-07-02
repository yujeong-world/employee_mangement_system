package com.example.employee_system.mapper;

import com.example.employee_system.bean.dto.EmployeeDto;
import com.example.employee_system.vo.EmployeeVo;
import com.example.employee_system.vo.FileVo;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface EmployeeMapper {
    List<EmployeeDto> selectEmployeeList();

    //직원 등록
    void  insertEmployee(EmployeeVo employee);

    //직원 아이디 중복 조회
    int idCheck(int id);

    //직원 수정
    void modifyEmployee(EmployeeVo employee);

    //직원 삭제
    void deleteEmployee(int employeeId);

    //직원 단건 조회
    EmployeeDto selectEmployee(int id);

    //직원 조회 pk로
    EmployeeDto selectEmployeeById(int id);

    //전체 직원 수 조회
    int totalCount();

    //페이징 조회
    List<EmployeeDto> findEmployee(int offset, int limit);

    // 검색어 조회
    List<EmployeeDto> searchEmployee(String category, String keyword, int pageIndex, int pageSize);

    // 검색 필터링 데이터 총 개수
    int searchEmployeeCount(String category, String keyword);




}
