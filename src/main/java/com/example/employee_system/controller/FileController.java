package com.example.employee_system.controller;

import com.example.employee_system.bean.dto.FileDto;
import com.example.employee_system.service.FileService;
import com.example.employee_system.vo.FileVo;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.imageio.IIOException;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Base64;

@Controller
public class FileController {

    private final FileService fileService;

    public FileController(FileService fileService) {
        this.fileService = fileService;
    }


    //파일 저장하기
    @PostMapping("/saveFile")
    public ModelAndView saveFile(@RequestBody FileVo fileVo) throws IOException {
        ModelAndView modelAndView = new ModelAndView();

        byte[] fileBytes = Base64.getDecoder().decode(fileVo.getFileData());
        fileService.fileSave(fileVo, fileBytes);

        return new ModelAndView("redirect:/");
    }

    // 파일 삭제하기
    @PostMapping("/fileDelete/{id}")
    public ModelAndView fileDelete(@PathVariable String id) {
        //형 변환
        long fileId = Long.parseLong(id);

        ModelAndView modelAndView = new ModelAndView();
        fileService.deleteFile(fileId);
        return new ModelAndView("redirect:/");
    }

    private final Path fileStorageLocation = Paths.get("C:/dev/").toAbsolutePath().normalize();

   private final String FILE_DIRECTORY = "C:/dev/";

   //파일 다운로드
    @GetMapping("/download/{fileId}")
    public ResponseEntity<Resource> downloadFile(@PathVariable("fileId") String fileId) throws IOException {
        //파일 아이디 long 타입으로 변경하기
        long id = Long.parseLong(fileId);

        //경로 확인하기
        FileDto fileDto = fileService.getFileById(id);
        String path = fileDto.getSavePath();
        String fileName = fileDto.getSaveName();

        File file = new File(path + "/"+fileName);
        if (!file.exists()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }

        InputStreamResource resource = new InputStreamResource(new FileInputStream(file));
        HttpHeaders headers = new HttpHeaders();
        String originalName = fileDto.getOriginalName();
        String encodedFileName = URLEncoder.encode(originalName, StandardCharsets.UTF_8.toString()).replaceAll("\\+", "%20");
        headers.add(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename*=UTF-8''" + encodedFileName);


        return ResponseEntity.ok()
                .headers(headers)
                .contentLength(file.length())
                .body(resource);
    }


}
