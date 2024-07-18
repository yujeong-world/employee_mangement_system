package com.example.employee_system.service;

import com.example.employee_system.bean.dto.EmployeeDto;
import com.example.employee_system.mapper.EmployeeMapper;
import com.example.employee_system.page.PageInfo;
import com.example.employee_system.vo.EmployeeVo;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Slf4j
@Service
@AllArgsConstructor
public class EmployeeService {

    private EmployeeMapper employeeMapper;

    //직원 등록
    @Transactional
    public void addEmployee(EmployeeVo employee){
        // 직원 정보 삽입
        employeeMapper.insertEmployee(employee);

    }

    //직원 번호 중복 조회
    public String idCheck(int employId){
        try {
            int idCheck = employeeMapper.idCheck(employId);

            if(idCheck == 0){
                //유효함
                return "Valid";
            }else{
                //유효함
                return "이미 사용중인 아이디입니다.";
            }
        } catch (Exception e){
            log.error(e.getMessage(), e);
            return "error";
        }
    }

    //직원 수정
    public void modifyEmployee(EmployeeVo employee){
        employeeMapper.modifyEmployee(employee);
    }

    //직원 삭제
    public void deleteEmployee(int employeeId){
        employeeMapper.deleteEmployee(employeeId);
    }

    //직원 단건 조회 (조건 : 직원 아이디, pk )
    public EmployeeDto getEmploy(int employId, int id){
        return employeeMapper.selectEmploy(employId,id);
    }

    public List<EmployeeDto> getEmployList(String category, String keyword, int pageIndex, int pageSize, String department){
        return employeeMapper.searchEmployee(category, keyword, pageIndex, pageSize, department);
    }

    //전체 직원 수 조회
    public int getEmployeeCount(){
        return employeeMapper.searchEmployeeCount(null,null, null);
    }


    // 페이징 처리하여 검색된 직원 조회
    public PageInfo<EmployeeDto> getEmployeeBySearch(
            String category,
            String keyword,
            int pageIndex,
            int pageSize,
            String department
    ) {
        int totalCount = employeeMapper.searchEmployeeCount(category, keyword, department); // 검색 결과의 총 개수

        if (totalCount <= pageSize) {
            // 검색 결과가 페이지 크기보다 작거나 같은 경우, 페이징 없이 전체 데이터 반환
            List<EmployeeDto> employees = employeeMapper.searchEmployee(
                    category, keyword, 0, totalCount, department
            );
            return new PageInfo<>(1, totalCount, totalCount, employees);
        } else {
            // 유효한 페이지 범위 확인
            int maxPage = (int) Math.ceil((double) totalCount / pageSize);
            if (pageIndex > maxPage) {
                pageIndex = maxPage;
            }
            if (pageIndex < 1) {
                pageIndex = 1;
            }

            List<EmployeeDto> employees = employeeMapper.searchEmployee(
                    category, keyword, (pageIndex-1) * pageSize, pageSize, department
            );
            return new PageInfo<>(pageIndex, pageSize, totalCount, employees);
        }
    }

}
