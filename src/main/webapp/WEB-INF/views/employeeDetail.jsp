
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>직원상세페이지</title>
    <link rel="stylesheet" type="text/css" href="${contextPath}/static/css/main.css">
    <%--      제이쿼리 --%>
    <script type="text/javascript" src="${contextPath}/static/lib/jquery-3.6.3.min.js"></script>


    <script>

        function saveFile(){
            debugger
            //let employId = employId;
            let originalName= $("#original_name").val();
            console.log(originalName+"파일명 테스트")
            debugger
            let saveName= $("#save_name").val();

            //이름 입력 안했을 경우

            //파일 입력 안했을 경우

            let data = {
                "employId": employId,
                "originalName": originalName,
                "saveName" : saveName
            }

            console.log(typeof originalName);
            debugger


            console.log(data + "데이터 로그")
            debugger

            $.ajax({
                anyne:true,
                type:'POST',
                data:JSON.stringify(data),
                url: "${contextPath}/saveFile",
                dataType : "text",
                contentType : 'application/json; charset=utf-8',
            }).done(function(){
                console.log("성공");
                debugger
                window.location.href = "${contextPath}/employeeDetail/"+employId;
            }).fail(function(error){
                alert("실패하였습니다.")
                alert(JSON.stringify(error));
            })
        }
    </script>
</head>
<body>
<div class="container">
    <h3>직원 상세 페이지</h3>

    <div>
        <ul>
            <li>
                직원번호 <span id="employId">${employee.employId}</span>
            </li>
            <li>
                직원이름 <span>${employee.employName}</span>
            </li>
            <li>
                 직급 <span>${employee.employRank}</span>
            </li>
            <li>
                전화번호 <span>${employee.phone}</span>
            </li>
            <li>
                이메일 <span>${employee.email}</span>
            </li>
        </ul>
    </div>

    <div>
        <h3>저장된 파일</h3>
        <div>
            <p>파일 이름 : <span>${file.saveName}</span></p>
            <p>파일 원본이름 : <span>${file.originalName}</span></p>
            <p>파일 등록일 : <span>${file.createAt}</span></p>
        </div>
    </div>

    <%--파일 업로드 영역--%>
    <div>
        <p>직원 파일 업로드</p>
        <form>
            <label>파일 이름 : </label>
            <input id="save_name" type="text" placeholder="저장할 파일명을 입력해주세요">

            <label> 업로드할 파일 : </label>
            <input id="original_name" type="file" placeholder="저장할 파일명을 올려주세요" value="original_name">

            <button type="submit" onclick="saveFile()">파일 저장하기 버튼</button>
        </form>
    </div>



    <button id="return_main">메인페이지로 돌아가기</button>

</div>
<script type="text/javascript">
    $('document').ready(function (){
        $("#return_main").click(function (){
            window.location.href = "${contextPath}/";
        })

    })

    const employId = Number($('#employId').html());
    console.log(employId+"아이디 출력 테스트 ")
</script>
</body>
</html>