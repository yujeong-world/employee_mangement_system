
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>직원상세페이지</title>
    <link rel="stylesheet" type="text/css" href="${contextPath}/static/css/main.css">
    <%--      제이쿼리 --%>
    <script type="text/javascript" src="${contextPath}/static/lib/jquery-3.6.3.min.js"></script>


    <script>
        // originalName 변수에서 경로를 제거하고 파일 이름만 추출하는 함수
        function getFileName(originalName) {
            // 파일 경로를 분리하여 배열로 만든 후, 마지막 요소를 반환하여 파일 이름만 추출
            return originalName.split('\\').pop().split('/').pop();
        }


        function saveFile() {
            let originalName = $("#original_name").val();
            originalName = getFileName(originalName);

            let employId = $("#employId").text();

            let fileInput = $("#original_name")[0];
            let file = fileInput.files[0];
            let reader = new FileReader();
            reader.onload = function(e) {
                let arrayBuffer = e.target.result;
                let bytes = new Uint8Array(arrayBuffer);
                let binaryString = Array.from(bytes).map(byte => String.fromCharCode(byte)).join('');
                let encodedFile = btoa(binaryString); // base64 인코딩

                let data = JSON.stringify({
                    employId: employId,
                    originalName: originalName,
                    fileData: encodedFile
                });

                $.ajax({
                    type: 'POST',
                    url: "${contextPath}/saveFile",
                    data: data,
                    contentType: 'application/json',
                    success: function() {
                        console.log("성공");
                        window.location.href = "${contextPath}/employeeDetail/" + employId;
                    },
                    error: function(error) {
                        alert("실패하였습니다.");
                        alert(JSON.stringify(error));
                    }
                });
            };
            reader.readAsArrayBuffer(file);
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
                부서 <span>${employee.department}</span>
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
        <c:forEach items="${fileList}" var="file">
            <p>파일 이름 : <span>${file.originalName}</span></p>
            <p>파일 등록일 : <span>${file.createAt}</span></p>
            <%--파일 다운로드--%>
            <a href="${pageContext.request.contextPath}/download/${file.id}">${file.originalName}</a>
        </c:forEach>

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