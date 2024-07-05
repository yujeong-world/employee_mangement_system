package com.example.employee_system.service;

import com.example.employee_system.bean.dto.EmployeeDto;
import com.example.employee_system.bean.dto.FileDto;
import com.example.employee_system.mapper.FileMapper;
import com.example.employee_system.vo.FileVo;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.imageio.IIOException;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class FileService {
    private final FileMapper fileMapper;
    private final EmployeeService employeeService;

    // 직원 파일 조회
    public FileDto getFileByEmployId(Long id) {
        return fileMapper.selectFileByEmployId(id);
    }

    // 직원 파일 리스트 조회
    public List<FileDto> getFileListByEmployId(Long employId) {
        return fileMapper.selectFileListByEmployId(employId);
    }

    //파일 정보 조회(pk를 가지고)
    public FileDto getFileById(Long id){
        return fileMapper.selectFileById(id);
    }

    private final String FILE_DIRECTORY = "C:/dev/";

    //파일명 랜덤 생성 메서드
    private String setFileSaveName() {
        //uuid 생성(범용 고유 식별자)
        UUID uuid = UUID.randomUUID();

        //랜덤 생성 파일이름 저장
        String saveName = uuid.toString();
        return saveName;
    }

    @Transactional
    public void fileSave(FileVo fileVo, byte[] fileBytes) throws IOException {
        //파일 경로? 세팅해주기
        String filePath = fileVo.getSavePath();

        //아이디 조회
        long id = fileVo.getEmployId();
        //파일 경로가 설정되어 있지 않을 경우
        if(filePath == null|| filePath.equals("")){
            String dateFolder = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            Path datePath = Paths.get(FILE_DIRECTORY, dateFolder);
            if (!Files.exists(datePath)) {
                Files.createDirectories(datePath);
            }
            filePath = datePath.toString();
            fileVo.setSavePath(filePath);
        }
        //해당 로컬 경로에 파일 복사

        //파일 saveName 랜덤 파일명 생성하기
        String saveName = setFileSaveName();
        fileVo.setSaveName(saveName);

        // 파일 저장
        Path targetLocation = Paths.get(filePath).resolve(saveName);
        Files.write(targetLocation, fileBytes); // 바이트 배열을 파일로 저장

        fileMapper.saveFile(fileVo);
    }

    //파일 삭제하기
    @Transactional
    public void deleteFile(Long id){
        // 1. 디스크 파일 데이터 삭제
        // 1-1. 파일 데이터의 경로 조회
        FileDto fileDto = getFileById(id);
        String filePath = fileDto.getSavePath()+"/"+fileDto.getSaveName();
        System.out.println("파일 삭제 경로 확인 : "+ filePath);
        deleteFileFromDisk(filePath);

        // 2. db 파일 데이터 삭제
        fileMapper.deleteFileById(id);
    }

    //파일 삭제 (from Disk) - 물리적 삭제
    public void deleteFileFromDisk(String filePath){
        File file = new File(filePath);
        if(file.exists()){
            file.delete();
        }
    }

    //파일 수정하기
    @Transactional
    public void fileModify(FileVo fileVo, byte[] fileBytes) throws IOException{
        // 파일 경로 세팅
        String filePath = fileVo.getSavePath();

        //파일 경로가 설정되어 있지 않을 경우
        if(filePath == null|| filePath.equals("")){
            String dateFolder = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            Path datePath = Paths.get(FILE_DIRECTORY, dateFolder);
            if (!Files.exists(datePath)) {
                Files.createDirectories(datePath);
            }
            filePath = datePath.toString();
            fileVo.setSavePath(filePath);
        }

        // 디렉토리가 존재하지 않으면 생성
        Path directoryPath = Paths.get(filePath);
        if (!Files.exists(directoryPath)) {
            Files.createDirectories(directoryPath);
        }

        String saveName = setFileSaveName();
        fileVo.setSaveName(saveName);

        // 파일 저장
        Path targetLocation = Paths.get(filePath).resolve(saveName);
        Files.write(targetLocation, fileBytes); // 바이트 배열을 파일로 저장

        // 파일 정보 업데이트
        fileMapper.updateFile(fileVo);
    }

    //파일 경로 수정하기
    public void updateFilePath(long id, String filePath) {
        fileMapper.updateFilePath(id, filePath);
    }


}
