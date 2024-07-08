package com.example.employee_system.service;

import com.example.employee_system.bean.dto.EmployeeDto;
import com.example.employee_system.mapper.EmployeeMapper;
import com.example.employee_system.page.PageInfo;
import com.example.employee_system.vo.EmployeeVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class EmployeeService {

    @Autowired
    private EmployeeMapper employeeMapper;

    //직원 목록 조회
    public List<EmployeeDto> employeeList(){
        return employeeMapper.selectEmployeeList();
    }

    //직원 등록
    @Transactional
    public void addEmployee(EmployeeVo employee){
        // 직원 정보 삽입
        employeeMapper.insertEmployee(employee);

    }

    //직원 번호 중복 조회
    public String idCheck(int id){
        int idCheck = employeeMapper.idCheck(id);

        if(idCheck == 0){
            //유효함
            return "Valid";
        }else{
            //유효함
            return "이미 사용중인 아이디입니다.";
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

    //직원 상세 조회
    public EmployeeDto employee(int id){
        return employeeMapper.selectEmployee(id);
    }

    //직원 조회 pk로
    public EmployeeDto getEmployById(int id){
        return employeeMapper.selectEmployeeById(id);
    }

    //엑셀 직원 조회(카테고리, 검색어) == 삭제 필요
    public List<EmployeeDto> getEmployListByCategoryAndSearch(String category, String keyword){
        return employeeMapper.selectEmployeeListByCategoryAndSearch(category, keyword);
    }


    //전체 직원 수 조회
    public int getEmployeeCount(){
        return employeeMapper.searchEmployeeCount(null,null);
    }

    //삭제?
  // 페이징 처리하여 조회
  /*public PageInfo<EmployeeDto> getAllEmployee(int pageIndex, int pageSize){
      int totalCount = employeeMapper.totalCount(); // 전체 직원 수 조회

      if (totalCount <= pageSize) {
          // 전체 데이터 수가 페이지 크기보다 작거나 같은 경우, 페이징 없이 전체 데이터 반환
          List<EmployeeDto> employeeList = employeeMapper.findEmployee(0, totalCount);
          return new PageInfo<>(1, totalCount, totalCount, employeeList);
      } else {
          // 유효한 페이지 범위 확인
          int maxPage = (int) Math.ceil((double) totalCount / pageSize);
          if (pageIndex > maxPage) {
              pageIndex = maxPage;
          }
          if (pageIndex < 1) {
              pageIndex = 1;
          }

          List<EmployeeDto> employeeList = employeeMapper.findEmployee((pageIndex-1)*pageSize, pageSize);
          return new PageInfo<>(pageIndex, pageSize, totalCount, employeeList);
      }
  }
*/
    // 페이징 처리하여 검색된 직원 조회
    public PageInfo<EmployeeDto> getEmployeeBySearch(
            String category,
            String keyword,
            int pageIndex,
            int pageSize
    ) {
        int totalCount = employeeMapper.searchEmployeeCount(category, keyword); // 검색 결과의 총 개수

        if (totalCount <= pageSize) {
            // 검색 결과가 페이지 크기보다 작거나 같은 경우, 페이징 없이 전체 데이터 반환
            List<EmployeeDto> employees = employeeMapper.searchEmployee(
                    category, keyword, 0, totalCount
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
                    category, keyword, (pageIndex-1) * pageSize, pageSize
            );
            return new PageInfo<>(pageIndex, pageSize, totalCount, employees);
        }
    }

}
