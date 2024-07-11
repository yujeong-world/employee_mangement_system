package com.example.employee_system.controller;

import com.example.employee_system.service.ChartService;
import com.example.employee_system.vo.ChartVo;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import java.util.Iterator;
import java.util.List;

@Controller
@AllArgsConstructor
public class ChartController {
    private ChartService chartService;

    @GetMapping("/chart")
    public ModelAndView chart(){
        ModelAndView mav = new ModelAndView();
        mav.setViewName("chart");

        List<ChartVo> departmentPie = chartService.getGroupByDepartment();

        Gson gson = new Gson();
        JsonArray jsonArray = new JsonArray();

        Iterator<ChartVo> iterator = departmentPie.iterator();
        while(iterator.hasNext()){
            ChartVo chartVo = iterator.next();
            JsonObject jsonObject = new JsonObject();
            String department = chartVo.getDepartment();
            int count = chartVo.getCount();

            jsonObject.addProperty("department", department);
            jsonObject.addProperty("count", count);
            jsonArray.add(jsonObject);
        }
        String json = gson.toJson(jsonArray);
        mav.addObject("json",json);
        System.out.println(json+"json 출력 테스트 : 그래프 데이터1");

        //그래프 2 (직급별 조회)
        List<ChartVo> rankData = chartService.getGroupByRank();
        Gson gson1 = new Gson();
        JsonArray jsonArray1 = new JsonArray();

        Iterator<ChartVo> iterator1 = rankData.iterator();
        while(iterator1.hasNext()){
            ChartVo chartVo1 = iterator1.next();
            JsonObject jsonObject = new JsonObject();
            String employRank = chartVo1.getEmployRank();
            int count = chartVo1.getCount();
            jsonObject.addProperty("employRank", employRank);
            jsonObject.addProperty("count", count);
            jsonArray1.add(jsonObject);
        }
        String json1 = gson1.toJson(jsonArray1);
        mav.addObject("json1",json1);
        System.out.println(json1+"json1 출력 테스트 : 그래프 데이터2");

        return mav;
    }
}
