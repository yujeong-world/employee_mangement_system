package com.example.employee_system.controller;

import com.example.employee_system.bean.dto.FileDto;
import com.example.employee_system.service.FileService;
import com.example.employee_system.vo.FileVo;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

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

}
