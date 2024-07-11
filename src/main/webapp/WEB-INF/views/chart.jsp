
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
    <a href="${contextPath}">메인페이지</a>
    <h3>통계</h3>
    // 차트를 그릴 영역으로 canvas태그를 사용한다.
  <%--  <canvas id="myChart" width="400" height="400"></canvas>--%>
    <h3>각 부서별 직원 비율 (원그래프)</h3>
    <canvas id="logNameChart" width="400" height="400"></canvas>
    <h3>각 직급별 직원 수 (막대 그래프)</h3>
    <canvas id="departmentTable"></canvas>
    <h3>각 직급별 직원 수 (꺽은선 그래프)</h3>
    <canvas id="rankLine"></canvas>

</div>

// 해당 부분은 JS파일을 따로 만들어서 사용해도 된다.
<script>
    //api에서 만든 json 데이터를 받아오자.
    var jsonData = ${json}
    var jsonObject = JSON.stringify(jsonData);
    var jData = JSON.parse(jsonObject);

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
        var r = Math.floor(Math.random()*200);
        var g = Math.floor(Math.random()*200);
        var b = Math.floor(Math.random()*200);
        var color = 'rgba(' + r + ', ' + g + ', ' + b + ', 0.7)';
        return color;
    }


    for(var i = 0; i<jData.length; i++) {
        var d = jData[i];

        console.log(d.department + "넘어온 데이터 ")
        debugger
        labelList.push(d.department);
        valueList.push(d.count);
        colorList.push(colorize());
    }

    for(var i = 0; i<jData1.length; i++) {
        var d = jData1[i];

        console.log(d.employRank + "넘어온 데이터 ")
        debugger
        labelList1.push(d.employRank);
        valueList1.push(d.count);
        colorList1.push(colorize());
    }



    var data = {
        labels: labelList,
        datasets: [{
            backgroundColor: colorList,
            data : valueList
        }],
        options : {
            title : {
                display : true,
                text: '유저별 접속 횟수'
            }
        }
    };

    var data1 = {
        labels: labelList1,
        datasets: [{
            backgroundColor: colorList1,
            data : valueList1
        }],
        options : {
            title : {
                display : true,
                text: '유저별 접속 횟수'
            }
        }
    };

    var ctx1 = document.getElementById('logNameChart').getContext('2d');
    new Chart(ctx1, {
        type: 'pie',
        data: data
    });


    var ctx2 = document.getElementById('departmentTable').getContext('2d');
    new Chart(ctx2, {
        type: 'bar',
        data: data1,
        options:{
            indexAxis : 'y' //이 옵션 추가하여 수평 막대 차트
        }
    });


    var ctx3 = document.getElementById('rankLine').getContext('2d');
    new Chart(ctx3, {
        type: 'line',
        data: data1,
        options:{
            responsive: true,
            plugins: {
                title: {
                    display: true,
                    text: (ctx) => 'Point Style: ' + ctx.chart.data.datasets[0].pointStyle,
                }
            }
        }
    });

   /* // 차트를 그럴 영역을 dom요소로 가져온다.
    var chartArea = document.getElementById('myChart').getContext('2d');
    // 차트를 생성한다.
    var myChart = new Chart(chartArea, {
        // ①차트의 종류(String)
        type: 'pie',
        // ②차트의 데이터(Object)
        data: {
            // ③x축에 들어갈 이름들(Array)
            labels: ['Red', 'Blue', 'Yellow', 'Green', 'Purple', 'Orange'],
            // ④실제 차트에 표시할 데이터들(Array), dataset객체들을 담고 있다.
            datasets: [{
                // ⑤dataset의 이름(String)
                label: '# of Votes',
                // ⑥dataset값(Array)
                data: [12, 19, 3, 5, 2, 3],
                // ⑦dataset의 배경색(rgba값을 String으로 표현)
                backgroundColor: 'rgba(255, 99, 132, 0.2)',
                // ⑧dataset의 선 색(rgba값을 String으로 표현)
                borderColor: 'rgba(255, 99, 132, 1)',
                // ⑨dataset의 선 두께(Number)
                borderWidth: 1
            }]
        },
        // ⑩차트의 설정(Object)
        options: {
            // ⑪축에 관한 설정(Object)
            scales: {
                // ⑫y축에 대한 설정(Object)
                y: {
                    // ⑬시작을 0부터 하게끔 설정(최소값이 0보다 크더라도)(boolean)
                    beginAtZero: true
                }
            }
        }
    });*/
</script>
</body>
</html>