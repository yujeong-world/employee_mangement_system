
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Home</title>
    <script src="https://code.jquery.com/jquery-3.5.1.js"
            integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc="
            crossorigin="anonymous"></script>
    <script type="text/javascript">
       //직원 정보 수정하기
       function modifyEmploy(id){
           var employId = Number($("#employId").val());
           var employName = $("#employName").val();
           var employRank = $("#employRank").val();
           var phone = $("#phone").val();
           var email = $("#email").val();

           //유효성 검사
           //1. 이름
           var regExpName = /^[a-z|A-Z|ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/;

           //2. 휴대폰 번호
           var regPhone = /^[0-9]{2,3}-[0-9]{3,4}-[0-9]{4}$/;

           //3. 이메일
           var regEmail = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
           if(!regExpName.test(employName)){
               alert("이름을 올바르게 입력해주세요")
               return;
           }
           if(!regPhone.test(phone)){
               alert("휴대폰 번호를 올바르게 입력해주세요")
               return;
           }
           if(!regEmail.test(email)){
               alert("이메일을 올바르게 입력해주세요.")
               return;
           }

           var data = {
               "id":id,
               "employId" : employId,
               "employName" : employName,
               "employRank" : employRank,
               "phone" : phone,
               "email" : email
           }
           $.ajax({
               anyne:true,
               type:'POST',
               data:JSON.stringify(data),
               url: "/modifyEmploy/"+id,
               dataType : "text",
               contentType : 'application/json; charset=utf-8',
           }).done(function(){
               console.log("성공");
               location.href='/';


           }).fail(function(error){
               alert("실패하였습니다.")
               alert(JSON.stringify(error));
           })
       }
    </script>
</head>

<body>
<h3>직원 수정 페이지</h3>
<div>
    <div>
        <ul>
            <li>

                <label>직원번호</label>
                <input type="number" id="employId" placeholder="${employee.employ_id}" value="${employee.employ_id}">
            </li>
            <li>

                <label>직원명</label>
                <input type="text" id="employName" placeholder="${employee.employ_name}" value="${employee.employ_name}">
            </li>
            <li>
                <label>직급</label>
                <input type="text" id="employRank" placeholder="${employee.employ_rank}" value="${employee.employ_rank}">
            </li>
            <li>
                <label>전화번호</label>
                <input type="text" id="phone" placeholder="${employee.phone}" value="${employee.phone}">
            </li>
            <li>
                <label>이메일</label>
                <input type="text" id="email" placeholder="${employee.email}" value="${employee.email}">
            </li>
        </ul>
        <button onclick="modifyEmploy(${employee.id})">수정하기</button>
    </div>


</div>
<script>

</script>
</body>
</html>