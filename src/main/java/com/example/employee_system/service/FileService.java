package com.example.employee_system.service;

import com.example.employee_system.bean.dto.FileDto;
import com.example.employee_system.mapper.FileMapper;
import com.example.employee_system.vo.FileVo;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class FileService {
    private final FileMapper fileMapper;

    // 직원 파일 조회
    public FileDto getFileByEmployId(int id) {
        return fileMapper.selectFileByEmployId(id);
    }

    //파일 정보 조회(pk를 가지고)
    public FileDto getFileById(Long id){
        return fileMapper.selectFileById(id);
    }

    @Transactional
    public void fileSave(FileVo fileVo) {

        fileMapper.saveFile(fileVo);
    }

    //파일 삭제하기
    public void deleteFile(int id){
        fileMapper.deleteFileById(id);
    }

    //파일 수정하기
    public void fileModify(FileVo fileVo) {
        fileMapper.updateFile(fileVo);
    }

}
