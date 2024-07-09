package com.example.employee_system.controller;

import com.example.employee_system.bean.dto.*;
import com.example.employee_system.page.PageInfo;
import com.example.employee_system.service.EmployeeService;
import com.example.employee_system.service.FileService;
import com.example.employee_system.service.TreeService;
import com.example.employee_system.vo.FileVo;
import com.example.employee_system.vo.PageInfoVo;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.util.Base64;
import java.util.List;

@Controller
@AllArgsConstructor
public class EmployeeController {

    private final EmployeeService employeeService;
    private final FileService fileService;
    private final TreeService treeService;


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

/*        List<TreeDto> trees = treeService.getTree();
        return trees;*/
        pageInfo = employeeService.getEmployeeBySearch(pageInfoVo.getCategory(), pageInfoVo.getKeyword(),
                pageInfoVo.getPageIndex(), pageInfoVo.getPageSize());

        mav.addObject("employeeList", pageInfo.getData());
        mav.addObject("totalCount", pageInfo.getTotalCount());
        mav.addObject("pageBar", pageInfo.getTotalPages());
        mav.addObject("pageInfoVo", pageInfoVo); // Front-end에서 페이지 정보 유지를 위해 전달

        mav.addObject("pageInfo", pageInfoVo);
        System.out.println(pageInfo.getData());
        return mav;
    }



    //직원 상세 조회
    @GetMapping("/employeeDetail/{employId}")
    @ResponseBody
    public ModelAndView employeeDetail(@PathVariable("employId") int employId) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("employeeDetail");

        // 직원 파일 조회
        //1. 직원 조회
        EmployeeDto employee = employeeService.employee(employId);
        mav.addObject("employee", employee);

        // 2. 직원 파일 정보 조회
        //파일이 없는 경우도 고려,
        Long id = employee.getId();
        //FileDto file = fileService.getFileByEmployId(id);
        List<FileDto> fileList = fileService.getFileListByEmployId(id);
        //먼저 파일이 있는지 조회하고, 있으면 파일을 넘김
        if(fileList != null){
            mav.addObject("fileList", fileList);
        }
        //System.out.println("직원 상세 조회 test: "+file.toString());
        System.out.println("직원 상세 조회 test employee: "+employee);


        return mav;
    }

    //직원 등록
    @PostMapping("/addEmployee")
    @ResponseBody
    public ResponseEntity<String> enrollEmployee(@RequestBody JoinRequestDto request) {
        try {
            // 직원 정보 저장
            employeeService.addEmployee(request.getEmployeeVo());

            // 직원 정보를 저장한 후에 직원 ID를 가져옵니다.
            EmployeeDto employeeDto = employeeService.employee(request.getEmployeeVo().getEmployId());

            Long id = employeeDto.getId();
            int employId = request.getEmployeeVo().getEmployId();

            // 파일을 저장
            // 리스트
            for(FileVo file : request.getFileVo()){
                byte[] fileBytes = Base64.getDecoder().decode(file.getFileData());
                file.setEmployId(id);
                fileService.fileSave(file, fileBytes);
            }

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

    // 수정할 직원 조회하기
    @GetMapping("/modifyEmploy/{id}")
    public ResponseEntity<RequestDto> modifyEmployInfo(@PathVariable("id") int id) {

        EmployeeDto employee = employeeService.employee(id);
        System.out.println("콘솔 테스트 : 직원 수정" + employee);

        // 수정할 직원 조회 - 파일 조회
        Long eid = employee.getId();
        List<FileDto> file = fileService.getFileListByEmployId(eid);
        System.out.println("콘솔 테스트 : 직원 수정" + file);

        // JoinRequestDto 객체 생성
        RequestDto response = new RequestDto();

        response.setEmployee(employee);
        //먼저 파일이 있는지 조회하고, 있으면 파일을 넘김
        if(file != null ){
            response.setFile((List<FileDto>) file);
        }
        return new ResponseEntity<>(response, HttpStatus.OK);
    }


    @PostMapping("/modifyEmploy/{employId}")
    @ResponseBody
    public ResponseEntity<String> modifyEmployee(@PathVariable("employId") int employId, @RequestBody JoinRequestDto joinRequestDto) {
        try {
            // 기본 정보 수정
            employeeService.modifyEmployee(joinRequestDto.getEmployeeVo());

            //pk 받기
            EmployeeDto employeeDto = employeeService.employee(employId);
            Long id = employeeDto.getId();

            //파일 저장
            for(FileVo file : joinRequestDto.getFileVo()){
                byte[] fileBytes = Base64.getDecoder().decode(file.getFileData());
                file.setEmployId(id);
                fileService.fileSave(file, fileBytes);
            }


            return ResponseEntity.ok("success");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Internal Server Error: " + e.getMessage());
        }

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
