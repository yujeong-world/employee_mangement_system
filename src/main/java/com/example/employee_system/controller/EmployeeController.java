package com.example.employee_system.controller;

import com.example.employee_system.bean.dto.EmployeeDto;
import com.example.employee_system.bean.dto.FileDto;
import com.example.employee_system.bean.dto.JoinRequestDto;
import com.example.employee_system.bean.dto.RequestDto;
import com.example.employee_system.page.PageInfo;
import com.example.employee_system.service.EmployeeService;
//import jakarta.servlet.http.HttpServletRequest;
import com.example.employee_system.service.FileService;
import com.example.employee_system.vo.PageInfoVo;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

@Controller
public class EmployeeController {

    private final EmployeeService employeeService;
    private final FileService fileService;


    public EmployeeController(EmployeeService employeeService, FileService fileService) {
        this.employeeService = employeeService;
        this.fileService = fileService;
    }

    @GetMapping("/")
    public ModelAndView employeeList(@ModelAttribute PageInfoVo pageInfoVo) {
        ModelAndView mav = new ModelAndView("index"); // 뷰 이름 설정

        PageInfo<EmployeeDto> pageInfo;

        if(pageInfoVo.getPageSize() == 0){
            pageInfoVo.setPageSize(10);
        }

        if(pageInfoVo.getPageIndex() == 0){
            pageInfoVo.setPageIndex(1);
        }

        if (pageInfoVo.getCategory() != null && pageInfoVo.getKeyword() != null &&
                !pageInfoVo.getCategory().isEmpty() && !pageInfoVo.getKeyword().isEmpty()) {
            // 검색 기능 활성화
            pageInfo = employeeService.getEmployeeBySearch(
                    pageInfoVo.getCategory(), pageInfoVo.getKeyword(),
                    pageInfoVo.getPageIndex(), pageInfoVo.getPageSize());
        } else {
            // 기본 목록 조회
            pageInfo = employeeService.getAllEmployee(pageInfoVo.getPageIndex(), pageInfoVo.getPageSize());
        }

        mav.addObject("employeeList", pageInfo.getData());
        mav.addObject("totalCount", pageInfo.getTotalCount());
        mav.addObject("pageBar", pageInfo.getTotalPages());
        mav.addObject("pageInfoVo", pageInfoVo); // Front-end에서 페이지 정보 유지를 위해 전달

        mav.addObject("pageInfo", pageInfoVo);
        System.out.println(pageInfo.getData());
        return mav;
    }



    //직원 상세 조회
    @GetMapping("/employeeDetail/{id}")
    @ResponseBody
    public ModelAndView employeeDetail(@PathVariable("id") int id) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("employeeDetail");

        // 직원 파일 조회
        FileDto fileDto = fileService.getFileByEmployId(id);
        mav.addObject("file", fileDto);
        EmployeeDto employee = employeeService.employee(id);
        mav.addObject("employee", employee);

        return mav;
    }

    @PostMapping("/addEmployee")
    @ResponseBody
    public ResponseEntity<String> enrollEmployee(@RequestBody JoinRequestDto request) {
        try {
            // 직원 정보 저장
            employeeService.addEmployee(request.getEmployeeVo());

            // 직원 정보를 저장한 후에 직원 ID를 가져옵니다.
            //int id = fileService.getFileById(request.get)
            EmployeeDto employeeDto = employeeService.employee(request.getEmployeeVo().getEmployId());
            Long id = employeeDto.getId();
            //Long id = request.getEmployeeVo().getId();
            int employId = request.getEmployeeVo().getEmployId();

            // 파일 정보에 직원 ID를 설정합니다.
            request.getFileVo().setEmployId(id);
            //request.getFileVo().setEmployId(employId);

            // 파일을 저장
            fileService.fileSave(request.getFileVo());

            return ResponseEntity.ok("Employee created successfully");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Internal Server Error: " + e.getMessage());
        }
    }

    @GetMapping("/idCheck")
    @ResponseBody
    public String idCheck(@RequestParam int id) {
        String checkMsg = employeeService.idCheck(id);
        return checkMsg;
    }

    //직원 삭제 기능 업그레이드 - 다중 삭제 기능
    @PostMapping("/deleteEmploy")
    @ResponseBody
    public ModelAndView deleteMultipleEmployees(@RequestBody List<Integer> employIds) {
        ModelAndView mav = new ModelAndView();

        for (Integer id : employIds) {
            employeeService.deleteEmployee(id);
        }

        return new ModelAndView("redirect:/");
    }

    //직원 수정
    @PostMapping("/modifyEmploy/{employId}")
    @ResponseBody
    public String modifyEmployee(@PathVariable("employId") int employId, @RequestBody JoinRequestDto joinRequestDto) throws Exception {
        //기본 정보 수정
        employeeService.modifyEmployee(joinRequestDto.getEmployeeVo());

        // 파일 수정
        Long id = joinRequestDto.getEmployeeVo().getId();
        joinRequestDto.getFileVo().setEmployId(id);
        fileService.fileModify(joinRequestDto.getFileVo());

        return "success";
    }

    // 수정할 직원 조회하기
    @GetMapping("/modifyEmploy/{id}")
    public ResponseEntity<RequestDto> modifyEmployInfo(@PathVariable("id") int id) {
/*

        EmployeeDto employee = employeeService.employee(id);
        System.out.println("콘솔 테스트"+employee);


        //수정할 직원 조회 - 파일 리스트 조회
        FileDto fileDto = fileService.getFileById(id);

        return new ResponseEntity<>(employee, HttpStatus.OK);*/
        EmployeeDto employee = employeeService.employee(id);
        System.out.println("콘솔 테스트" + employee);

        // 수정할 직원 조회 - 파일 조회
        FileDto fileDto = fileService.getFileByEmployId(id);

        // JoinRequestDto 객체 생성
        RequestDto response = new RequestDto();
        response.setEmployee(employee);
        response.setFile(fileDto);

        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    //게시판 검색 기능
    @GetMapping("/search")
    public ModelAndView getEmployeeListBySearch(
            @RequestParam String category,
            @RequestParam String keyword,
            @RequestParam(defaultValue = "1") int pageIndex,
            @RequestParam(defaultValue = "10") int pageSize) {
        ModelAndView mav = new ModelAndView("index");  // 검색 결과를 보여줄 뷰 지정
        PageInfo<EmployeeDto> searchResults = employeeService.getEmployeeBySearch(category, keyword, pageIndex, pageSize);
        mav.addObject("employeeList", searchResults);
        mav.addObject("totalCount", searchResults.getTotalCount());  // 혹은 적절한 토탈 카운트 메소드 사용
        return mav;
    }


}
