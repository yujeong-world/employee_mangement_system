package com.example.employee_system.controller;

import com.example.employee_system.bean.dto.EmployeeDto;
import com.example.employee_system.bean.dto.FileDto;
import com.example.employee_system.service.Emailservice;
import com.example.employee_system.service.EmployeeService;
import com.example.employee_system.service.FileService;
import lombok.RequiredArgsConstructor;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@RequestMapping("/excel")
@Controller
public class ExcelController {

    private final EmployeeService employeeService;
    private final Emailservice emailservice;
    private final FileService fileService;

    @GetMapping("/download")
    public void downloadExcel(HttpServletResponse response,
                              @RequestParam(required = false) String category,
                              @RequestParam(required = false) String keyword) throws IOException {

        List<EmployeeDto> employees;
        // 검색어가 없을 때
        if (category == null || keyword == null) {
            employees = employeeService.employeeList();
        } else {
            // 검색어가 존재 할 때
            employees = employeeService.getEmployListByCategoryAndSearch(category, keyword);
        }

        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Employees");

        Row headerRow = sheet.createRow(0);
        String[] columns = {"직원코드", "직원명", "직급", "부서", "전화번호", "메일주소", "메일발송횟수", "관련파일"};
        for (int i = 0; i < columns.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(columns[i]);
        }

        int rowNum = 1;
        for (EmployeeDto employee : employees) {
            Row row = sheet.createRow(rowNum++);

            row.createCell(0).setCellValue(employee.getEmployId());
            row.createCell(1).setCellValue(employee.getEmployName());
            row.createCell(2).setCellValue(employee.getEmployRank());
            row.createCell(3).setCellValue(employee.getDepartment());
            row.createCell(4).setCellValue(employee.getPhone());
            row.createCell(5).setCellValue(employee.getEmail());

            // 메일 발송 횟수
            int mailCount = emailservice.countMailHistoryByEmployeeId(employee.getEmployId());
            row.createCell(6).setCellValue(mailCount);

            // 관련 파일
            List<FileDto> fileList = fileService.getFileListByEmployId(employee.getId());
            String fileNames = fileList.stream()
                    .map(FileDto::getOriginalName)
                    .collect(Collectors.joining("\n"));
            Cell fileCell = row.createCell(7);
            fileCell.setCellValue(fileNames);
            // 셀 내 개행을 위해 wrap text 설정
            CellStyle cellStyle = workbook.createCellStyle();
            cellStyle.setWrapText(true);
            fileCell.setCellStyle(cellStyle);
        }

        // 현재 날짜를 "yyyyMMdd" 형식으로 가져오기
        LocalDate currentDate = LocalDate.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
        String formattedDate = currentDate.format(formatter);

        // 파일 이름에 날짜 추가

        String fileName = "직원목록-" + formattedDate + ".xlsx";
        String encodedFileName = URLEncoder.encode(fileName, StandardCharsets.UTF_8.toString());

        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + encodedFileName);

        workbook.write(response.getOutputStream());
        workbook.close();
    }

}
