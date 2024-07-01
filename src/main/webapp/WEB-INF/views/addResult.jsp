
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="ko">
<head>
    <link href="static/css/index.css" rel="stylesheet" type="text/css">
    <meta charset="UTF-8">
    <title>Home</title>
    <script src="${contextPath}/static/script/jquery-3.6.0.min.js"></script>

    <script type="text/javascript">
    </script>
</head>

<body>
<h3>직원 상세 페이지</h3>
<div>
    ${test}
    <table>
        <thead>
        <tr>
            <th>선택</th>
            <th>직원번호</th>
            <th>직원이름</th>
            <th>직급</th>
            <th>전화번호</th>
            <th>이메일</th>

        </tr>
        </thead>
        <tbody>


        <tr>
            <td>
                <input type="checkbox" name="${employee.employ_id}" value="${employee.employ_id}" id="check">
            <td>
            <td>${employee.employ_id}</td>
            <td>
                <a>${employee.employ_name}</a>
            </td>
            <td>${employee.employ_rank}</td>
            <td>${employee.phone}</td>
            <td>${employee.email}</td>
        </tr>

        </tbody>
    </table>



</div>
<script>

</script>
</body>
</html>