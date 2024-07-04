package com.example.employee_system;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@EnableScheduling
@SpringBootApplication
public class EmployeeSystemApplication {

    public static void main(String[] args) {
        System.setProperty("server.servlet.context-path", "/emp");
        SpringApplication.run(EmployeeSystemApplication.class, args);
    }

}
