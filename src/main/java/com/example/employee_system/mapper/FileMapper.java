package com.example.employee_system.mapper;

import com.example.employee_system.bean.dto.FileDto;
import com.example.employee_system.vo.FileVo;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface FileMapper {
    // 파일 정보 조회
    FileDto selectFileByEmployId(Long id);

    //pk를 가지고 파일 정보 조회
    FileDto selectFileById(Long id);

    //파일 정보 저장
    void saveFile(FileVo fileVo);

    //파일 삭제
    void deleteFileById(Long id);

    //파일 수정
    void updateFile(FileVo fileVo);

    //파일 경로 수정하기
    void updateFilePath(long id, String filePath);

    List<FileDto> selectFileListByEmployId(Long employId);
}

