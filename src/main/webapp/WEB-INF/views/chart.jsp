
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<html lang="ko">
<head>
    <link rel="stylesheet" type="text/css" href="${contextPath}/static/css/main.css">

    <meta charset="UTF-8">
    <title>Home</title>

    <script src="https://cdn.jsdelivr.net/npm/chart.js@3.7.1/dist/chart.min.js"></script>
    <%--      제이쿼리 --%>
    <script type="text/javascript" src="${contextPath}/static/lib/jquery-3.6.3.min.js"></script>
    <script type="text/javascript" src="${contextPath}/static/js/bootstrap.js"></script>
    <script type="text/javascript">
    </script>
</head>

<body>
<div class="chart_Container">
    <div class="w-100">
        <a href="${contextPath}">메인페이지</a>
        <h3>통계</h3>
        <h3>각 부서별 직원 비율 (원그래프)</h3>
    </div>

    <div class="chart_area w-100">
        <div class="chart_box">
            <canvas id="departmentCount"></canvas>
        </div>

        <div class="chart_box">
            <h3>각 부서별 직원 비율 리스트(표)</h3>
            <table id="tableArea">
            </table>
        </div>

        <div class="chart_box">
            <h3>각 직급별 직원 수 (막대 그래프)</h3>
            <canvas id="departmentTable"></canvas>
        </div>

        <div class="chart_box">
            <h3>각 직급별 직원 수 (꺽은선 그래프)</h3>
            <canvas id="rankLine"></canvas>
        </div>
    </div>

</div>

<script>
    //api에서 만든 json 데이터를 받아오자.
    var jsonData = ${json};
    var jsonObject = JSON.stringify(jsonData);
    var jData = JSON.parse(jsonObject);

    var htmlData = "<tr><th>그룹</th><th>직원 수</th></tr>";
    //표 만들기
    for (var i = 0; i < jData.length; i++) {
        htmlData += "<tr><td>" + jData[i].department + "</td>" +
            "<td>" + jData[i].count + "</td></tr>";
    }
    $("#tableArea").html(htmlData);

    //데이터2
    var jsonData1 = ${json1}
    var jsonObject1 = JSON.stringify(jsonData1);
    var jData1 = JSON.parse(jsonObject1);

    var labelList = new Array();
    var valueList = new Array();
    var colorList = new Array();

    var labelList1 = new Array();
    var valueList1 = new Array();
    var colorList1 = new Array();

    function colorize() {
        var r = Math.floor(Math.random() * 200);
        var g = Math.floor(Math.random() * 200);
        var b = Math.floor(Math.random() * 200);
        var color = 'rgba(' + r + ', ' + g + ', ' + b + ', 0.7)';
        return color;
    }

    for (var i = 0; i < jData.length; i++) {
        var d = jData[i];
        labelList.push(d.department);
        valueList.push(d.count);
        colorList.push(colorize());
    }

    for (var i = 0; i < jData1.length; i++) {
        var d = jData1[i];
        labelList1.push(d.employRank);
        valueList1.push(d.count);
        colorList1.push(colorize());
    }


    var data = {
        labels: labelList,
        datasets: [{
            backgroundColor: colorList,
            data: valueList
        }],
        options: {
            title: {
                display: true,
                text: '유저별 접속 횟수'
            }
        }
    };

    var data1 = {
        labels: labelList1,
        datasets: [{
            backgroundColor: colorList1,
            data: valueList1
        }],
        options: {
            title: {
                display: true,
                text: '유저별 접속 횟수'
            }
        }
    };

    var ctx1 = document.getElementById('departmentCount').getContext('2d');
    new Chart(ctx1, {
        type: 'pie',
        data: data
    });


    var ctx2 = document.getElementById('departmentTable').getContext('2d');
    new Chart(ctx2, {
        type: 'bar',
        data: data1,
        options: {
            indexAxis: 'y' //이 옵션 추가하여 수평 막대 차트
        }
    });


    var ctx3 = document.getElementById('rankLine').getContext('2d');
    new Chart(ctx3, {
        type: 'line',
        data: data1,
        options: {
            responsive: true,
            plugins: {
                title: {
                    display: true,
                    text: (ctx) => 'Point Style: ' + ctx.chart.data.datasets[0].pointStyle,
                }
            }
        }
    });

</script>
</body>
</html>