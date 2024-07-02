package com.example.employee_system.controller;

import com.example.employee_system.bean.dto.FileDto;
import com.example.employee_system.service.FileService;
import com.example.employee_system.vo.FileVo;
import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@Controller
public class FileController {

    private final FileService fileService;

    public FileController(FileService fileService) {
        this.fileService = fileService;
    }


    //파일 저장하기
    @PostMapping("/saveFile")
    public ModelAndView saveFile(@RequestBody FileVo fileVo) {
        ModelAndView modelAndView = new ModelAndView();

        fileService.fileSave(fileVo);
        //
        // fileService.
        return new ModelAndView("redirect:/");
    }

    // 파일 삭제하기
    @PostMapping("/fileDelete")
    public ModelAndView fileDelete(@RequestBody FileDto fileDto) {
        ModelAndView modelAndView = new ModelAndView();

        //fileService.deleteFile(int id);

        return new ModelAndView("redirect:/");
    }

    //파일 저장하기
    @GetMapping("/download/{fileId}")
    public ModelAndView download(@PathVariable("fileId") Long fileId) {
        //파일의 정보를 가지고 온다.
        FileDto fileDto = fileService.getFileById(fileId);

        ModelAndView mav = new ModelAndView();


        return mav;
    }

//    @GetMapping("/download/{filename:.+}")
//    public ResponseEntity<Resource> downloadFile(@PathVariable String filename) {
//
//    }


    private final Path fileStorageLocation = Paths.get("C:/dev/").toAbsolutePath().normalize();

   /* @GetMapping("/download/{filename:.+}")
    public ResponseEntity<Resource> downloadFile(@PathVariable String filename) {
        try {
            Path filePath = fileStorageLocation.resolve(filename).normalize();
            Resource resource = new UrlResource(filePath.toUri());

            if (resource.exists()) {
                return ResponseEntity.ok()
                        .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + resource.getFilename() + "\"")
                        .body(resource);
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }*/

   /* @GetMapping("/download/{fileName:.+}")
    public ResponseEntity<Resource> downloadFile(@PathVariable String fileName) {
        try {
            // 파일명 URL 디코딩
            String decodedFileName = URLDecoder.decode(fileName, StandardCharsets.UTF_8.toString());
            Path filePath = fileStorageLocation.resolve(decodedFileName).normalize();
            Resource resource = new UrlResource(filePath.toUri());

            if (resource.exists() && resource.isReadable()) {
                String contentType = Files.probeContentType(filePath);
                if (contentType == null) {
                    contentType = "application/octet-stream";
                }

                return ResponseEntity.ok()
                        .contentType(org.springframework.http.MediaType.parseMediaType(contentType))
                        .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + resource.getFilename() + "\"")
                        .body(resource);
            } else {
                throw new RuntimeException("파일을 찾을 수 없거나 읽을 수 없습니다: " + decodedFileName);
            }
        } catch (MalformedURLException ex) {
            throw new RuntimeException("파일 경로가 잘못되었습니다: " + fileName, ex);
        } catch (Exception ex) {
            throw new RuntimeException("파일을 다운로드하는 동안 오류가 발생했습니다: " + fileName, ex);
        }
    }*/

    private final String FILE_DIRECTORY = "C:\\dev";

    @GetMapping("/files/download/{fileName}")
    public ResponseEntity<Resource> downloadFile(@PathVariable("fileName") String fileName) throws IOException {
        File file = new File(FILE_DIRECTORY + fileName);
        if (!file.exists()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }

        InputStreamResource resource = new InputStreamResource(new FileInputStream(file));
        HttpHeaders headers = new HttpHeaders();
        headers.add(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=" + fileName);

        return ResponseEntity.ok()
                .headers(headers)
                .contentLength(file.length())
                .body(resource);
    }




}
