package com.example.employee_system.mapper;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface EmailMapper {
    //이메일 발송 기록
    void saveMailHistory(int employId, String email);

    //이메일 카운트
    int countMailHistoryByEmployeeId(int employId);
}
