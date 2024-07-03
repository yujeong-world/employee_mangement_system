
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<html lang="ko">
<head>

    <meta charset="UTF-8">
    <title>Home</title>
    <link rel="stylesheet" type="text/css" href="${contextPath}/static/css/main.css">
<%--      제이쿼리 --%>
    <script type="text/javascript" src="${contextPath}/static/lib/jquery-3.6.3.min.js"></script>

    <script type="text/javascript">

        //직원 번호 중복 체크
        function idCheck(event){
            event.preventDefault(); // 폼의 기본 제출 이벤트 막기
            let employIdForm = $("#employId").val();
            if(employIdForm != employId){

            }
            $.ajax({
                type: 'GET',
                url: '${contextPath}/idCheck',
                data: { id: employIdForm },
                dataType: 'text',
                contentType: 'application/json; charset=utf-8',
            }).done(function(response) {
                console.log(response + ' 리턴 체크');
                if (response === 'Vaild') {

                    alert('사용 가능한 직원번호입니다.');
                    $("#checkResult").text('사용가능');
                } else {
                    if(employIdForm == employId){
                        alert('사용 가능한 직원번호입니다.');
                        $("#checkResult").text('사용가능');
                    }else {
                        alert('이미 사용 중인 직원번호입니다.');
                        $("#checkResult").text('사용불가');
                    }

                }
            }).fail(function(error) {
                alert('오류가 발생하였습니다.');
                console.error(JSON.stringify(error));
            });

            // 기본 이벤트 동작 막기
            return false;
        }

        function validateEmail(email) {
            var regEmail = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
            return regEmail.test(email);
        }

        function validateName(name) {
            var regName = /^[a-z|A-Z|ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/;
            return regName.test(name);
        }

        function validatePhone(phone) {
            var regName = /^[0-9]{2,3}-[0-9]{3,4}-[0-9]{4}$/;
            return regName.test(phone);
        }


        function addMember(){
            var employId = Number($("#employId").val());
            var employName = $("#employName").val();
            var employRank = $("#employRank").val();
            var phone = $("#phone").val();
            var email = assembleEmail();
            var saveName = $("#saveName").val();
            var originalName = $("#originalName")[0].files[0].name;
            var fileInput = $("#originalName")[0];
            var file = fileInput.files[0];
            var reader = new FileReader();

            //유효성 검사
            //1. 이름
            var regExpName = /^[a-z|A-Z|ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/;

            //2. 휴대폰 번호
            var regPhone = /^[0-9]{2,3}-[0-9]{3,4}-[0-9]{4}$/;

            //사용 불가 혹은 인증을 하지 않은 경우에...
            if($("#checkResult").text() == '사용불가' ||$("#checkResult").text() == ''){
                alert("직원 번호를 확인해주세요");
                return;
            }

            if (!validateEmail(email)) {
                alert("이메일을 올바르게 입력해주세요.");
                return;
            }

            if(!regExpName.test(employName)){
                alert("이름을 올바르게 입력해주세요");
                return;
            }
            if(!regPhone.test(phone)){
                alert("휴대폰 번호를 올바르게 입력해주세요");
                return;
            }

            reader.onload = function(e) {
                var arrayBuffer = e.target.result;
                var bytes = new Uint8Array(arrayBuffer);
                var binaryString = Array.from(bytes).map(byte => String.fromCharCode(byte)).join('');
                var encodedFile = btoa(binaryString); // Base64 인코딩

                var data = {
                    "employeeVo": {
                        "employId": employId,
                        "employName": employName,
                        "employRank": employRank,
                        "phone": phone,
                        "email": email
                    },
                    "fileVo": {
                        "saveName": saveName,
                        "originalName": originalName,
                        "fileData": encodedFile // Base64 인코딩된 파일 데이터
                    }
                };

                $.ajax({
                    anyne:true,
                    type:'POST',
                    data:JSON.stringify(data),
                    url: "${contextPath}/addEmployee",
                    dataType : "text",
                    contentType : 'application/json; charset=utf-8',
                }).done(function(){
                    console.log("성공");
                    window.location.href = "${contextPath}/employeeDetail/"+employId;
                }).fail(function(error){
                    alert("실패하였습니다.");
                    alert(JSON.stringify(error));
                });
            };

            reader.readAsArrayBuffer(file); // 파일을 읽고 Base64 인코딩
        }

        //직원 번호 입력 창 값이 변경 될 때마다 초기화 작업
        function employeeIdChange(){
            $("#checkResult").text('');
        }

        function assembleEmail() {
            var emailUser = $("#email").val();
            var domain = $("#email_option").val();
            if (domain === "user_input") {
                domain = $("#email2").val();
            }
            return emailUser + domain;
        }


        $(document).ready(function() {
            $("#email_option").change(function() {
                if ($(this).val() == "user_input") {
                    $("#email2").show();
                } else {
                    $("#email2").hide();
                }
            });
        });


        let employId = '';

        //여러개의 체크박스 값들의 상태값을 가져오는 방법
        var chk_arr = [];
        $("input[name=option]:checked").each(function (){
            var chk = $(this).val();
            chk_arr.push(chk);
        })

        // 수정 --------
        var check_set = new Set();
        function getCheckValue(event){

            $("input[name=option]:checked").each(function (){
                var chk = $(this).val();
                check_set.add(chk);
            })

            if(!event.target.checked) {
                check_set.delete(event.target.value);
            }

            employId = event.target.value;
            console.log("현재 선택한 체크박스는 : "+employId);
            console.log(check_set+": 집합 /// 체크리스트 배열 확인용, set의 길이:"+check_set.size);
        }

        function checkBox(currentCheckBox){
            const checkBoxs = document.getElementsByName("option");

            console.log(checkBoxs.length+'체크박스 길이 테스트');
            let checkedCount = 0;
            employId = currentCheckBox.value
            for(let i =0; i<checkBoxs.length; i++){
                if(checkBoxs[i].checked){
                    checkedCount++;
                    if(checkBoxs[i] !== currentCheckBox){
                        checkBoxs[i].checked =
                            false;
                        employId = currentCheckBox.value
                        console.log("체크박스 이벤트테스트", employId)
                    }
                }
            }

            if (checkedCount === 0) {
                currentCheckbox.checked = true;

            }

            console.log("체크박스 이벤트테스트", employId)
        }


        function deleteemploy() {
            var checkedIds = Array.from(check_set);

            if (checkedIds.length === 0) {
                alert("삭제할 직원을 최소 한 명 이상 선택해주세요.");
                return;
            }

            $.ajax({
                type: 'POST',
                url: "${contextPath}/deleteEmploy",
                data: JSON.stringify(checkedIds),
                contentType: 'application/json; charset=utf-8',
            }).done(function() {
                alert("성공적으로 삭제되었습니다.");
                location.reload();
            }).fail(function(error) {
                alert("실패하였습니다.");
                console.log(checkedIds + "체크 아이디 확인용")
                console.error(JSON.stringify(error));
            });
        }

        // 수정 버튼 클릭 이벤트 연결
        $('.modify_btn').click(function() {
            var employId = $(this).data('employId'); // 버튼에 데이터 속성으로 저장된 직원 ID를 가져옵니다.
            modifyEmployInfo(employId); // 직원 정보 수정 함수 호출
        });

        //직원 수정
        function modifyEmployInfo(){
            console.log(employId+"직원 아이디 테스트 입니다.")

            var checkedIds = Array.from(check_set);

            if (checkedIds.length === 0) {
                alert("수정할 직원을 한명만 선택해주세요.");
                return;
            }else if(checkedIds.length > 1){
                alert("수정할 직원을 최소 한명만 선택해주세요.");
                return;
            }else{
               //location.href = '/modifyEmploy/'+employId;
                $(".title").text("직원 수정")
                $("#add_modal").show()
                $('#modifyMember').show()
                $('#addMember').hide();
                $(".saved_file").show();

                //수정할 직원 정보를 가져오기.
                $.ajax({
                    anyne:true,
                    type:'GET',
                    data: JSON.stringify(employId),
                    url: "${contextPath}/modifyEmploy/"+employId,
                    dataType : "json",
                    contentType : 'application/json; charset=utf-8',
                }).done(function(data){
                    console.log(data.employee.employName+"데이터 확인용==============")
                    console.log(data+"데이터 확인용==============")
                    console.log(data.file+"데이터 확인용==============")
                    //console.log(data.file.originalName+"데이터 확인용")

                    // 모달창의 input 필드에 값 설정
                    $("#employId").val(data.employee.employId);
                    $("#employName").val(data.employee.employName);
                    $("#employRank").val(data.employee.employRank);
                    $("#phone").val(data.employee.phone);
                    //파일 데이터가 존재하는 경우에
                    if(data.file != null){
                        $("#file_id").text(data.file.id);
                        $("#save_originalName").text(data.file.originalName);
                        $("#save_saveName").text(data.file.saveName);
                        $("#save_createAt").text(data.file.createAt);
                        //파일 데이터가 있는 경우에 UI
                        $(".file_list").show();
                    }else{
                        //파일 데이터가 없는 경우에 UI
                        $(".file_list").hide();
                        $(".saved_file > h3").text("저장된 파일 데이터가 없습니다.");
                    }

                    // 이메일 주소에서 '@' 이전의 부분만 추출하여 입력 필드에 설정 - 앞부분
                    var emailUserFront = data.employee.email.split('@')[0];
                    $("#email").val(emailUserFront);

                    //이메일 뒷 부분
                    var emailUserBack = data.employee.email.split('@')[1];
                    console.log(emailUserBack+"이메일 뒷부분?")
                    // 이메일 뒷부분 자동 세팅
                    // 만약 select에 해당 요소가 있으면..
                    const emailList = ["naver.com", "gmail.com", "nate.com"];
                    if (emailList.includes(emailUserBack)) {
                        $("#email_option").val('@' + emailUserBack).prop("selected", true);
                        $("#email2").hide();
                    } else {
                        $("#email_option").val("user_input").prop("selected", true);
                        $("#email2").val(emailUserBack).show();
                    }

                    //이메일 옵션 변경 이벤트 처리
                    $('#email_option').change(function () {
                        if ($(this).val() == "user_input") {
                            $("#email2").show();
                        } else {
                            $("#email2").hide();
                        }
                    });

                }).fail(function(error){
                    alert("실패하였습니다.")
                    alert(JSON.stringify(error));
                })

            }

        }
        function getFileName(originalName) {
            // 파일 경로를 분리하여 배열로 만든 후, 마지막 요소를 반환하여 파일 이름만 추출
            return originalName.split('\\').pop().split('/').pop();
        }
        // 직원 수정 모달 - 수정 버튼
        function modifyMember(){
            var employId = Number($("#employId").val());
            var employName = $("#employName").val();
            var employRank = $("#employRank").val();
            var phone = $("#phone").val();
            var email = assembleEmail();
            var saveName = $("#saveName").val();
            var originalName = $("#originalName").val();
            originalName = getFileName(originalName);
            var fileInput = $("#originalName")[0];
            var file = fileInput.files[0];
            var reader = new FileReader();



            //사용 불가 혹은 인증을 하지 않은 경우에...
            if($("#checkResult").text() == '사용불가' ||$("#checkResult").text() == ''){
                alert("직원 번호를 확인해주세요");
                return;
            }

            if (!validateEmail(email)) {
                alert("이메일을 올바르게 입력해주세요.");
                return;
            }

            if (!validateName(employName)) {
                alert("이름을 올바르게 입력해주세요.");
                return;
            }

            if (!validatePhone(phone)) {
                alert("휴대폰번호를 올바르게 입력해주세요.");
                return;
            }


            reader.onload = function(e) {
                var arrayBuffer = e.target.result;
                var bytes = new Uint8Array(arrayBuffer);
                var binaryString = Array.from(bytes).map(byte => String.fromCharCode(byte)).join('');
                var encodedFile = btoa(binaryString); // Base64 인코딩

                var data = {
                    "employeeVo": {
                        "employId": employId,
                        "employName": employName,
                        "employRank": employRank,
                        "phone": phone,
                        "email": email
                    },
                    "fileVo": {
                        "saveName": saveName,
                        "originalName": originalName,
                        "fileData": encodedFile // Base64 인코딩된 파일 데이터
                    }
                };
                $.ajax({
                    anyne:true,
                    type:'POST',
                    data:JSON.stringify(data),
                    url: "${contextPath}/modifyEmploy/"+employId,
                    dataType : "text",
                    contentType : 'application/json; charset=utf-8',
                }).done(function(){
                    console.log("성공");
                    location.href='${contextPath}/';


                }).fail(function(error){
                    alert("실패하였습니다.")
                    alert(JSON.stringify(error));
                })

            };

            reader.readAsArrayBuffer(file);

        }

        //직원 수정 모달 - 파일 삭제
        function deleteFile(){
            let id = $("#file_id").text();
            $.ajax({
                url: "${contextPath}/fileDelete/"+id,
                type: 'POST',
                async: false,
                success: function (data){
                    console.log(data)
                    $("#file_id").text("");
                    $("#save_originalName").text("");
                    $("#save_saveName").text("");
                    $("#save_createAt").text("");
                    alert("파일이 삭제되었습니다.")
                },
                error: function (e){
                    alert(e);
                }
            })
        }

        //검색
        function submitForm(){
            $.ajax({
                url: "${contextPath}/",
                type: 'get',
                data: $('#searchForm').serialize(),
                async: false,
                success: function (data){
                    console.log(data)
                    $('input[name="pageIndex"]').val(1); // 페이지 넘버는 1로 세팅
                    $('#listInfo').html(data);
                },
                error: function (e){
                    alert(e);
                }
            })
        }



    </script>
</head>

<body>
<div id="listInfo">
    <h3><a href="${contextPath}">직원 리스트</a></h3>
    <div class="btn_area">
        <button id="add_btn">등록</button>
        <button id="modify_btn" onclick="modifyEmployInfo()">수정</button>
        <button onclick="deleteemploy()">삭제</button>
    </div>

    <div class="form_area">


            <form id="searchForm" action="${contextPath}" method="GET">
                <select name="category" id="category">
                    <option value="name">직원명</option>
                    <option value="id">직원 번호</option>
                    <option value="rank">직급</option>
                    <option value="phone">전화번호</option>
                    <option value="email">이메일</option>
                </select>

                <select name="pageSize" id="pageSize">
                    <option value="10">10개씩 보기</option>
                    <option value="5">5개씩 보기</option>
                    <option value="15">15개씩 보기</option>
                    <option value="20">20개씩 보기</option>
                    <option value="50">50개씩 보기</option>
                </select>
                <input id="keyword" type="text" name="keyword" placeholder="검색어를 입력하세요." value="${param.keyword}" required>
                <input readonly name="pageIndex" type="hidden">
                <input readonly name="pageSize" type="hidden">
                <button type="submit">검색</button>
            </form>

    </div>
    <div>

        <div>
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


                <c:forEach items="${employeeList}" var="list">
                    <tr>
                        <td>
                            <input type="checkbox" name="option" value="${list.employId}" id="check"
                                   onclick="getCheckValue(event)">
                        </td>

                        <td>${list.employId}</td>

                        <td>
                            <a onclick="detail(${list.employId})">${list.employName}</a>
                        </td>

                        <td>${list.employRank}</td>
                        <td>${list.phone}</td>
                        <td>${list.email}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>


        <div>
            총 ${totalCount} 건
        </div>

        <div class="page_area">
            <p>페이지 바</p>

            <ul>
                <c:forEach begin="1" end="${pageBar}" var="pageNum">
                    <li><a href="javascript:void(0);" class="page-link" data-page="${pageNum}">${pageNum}</a></li>
                </c:forEach>
            </ul>

        </div>


        <div class="background">

        </div>

        <div id="add_modal">
            <div class="inner">
                <p class="title"> </p>
                <div>
                    <form >
                        <div>
                            <label>직원번호</label>
                            <input type="number" id="employId" placeholder="직원번호를 입력하세요" onchange="employeeIdChange()">
                            <button id="phone_check" onclick="idCheck(event)">중복체크</button>
                            <span id="checkResult"></span>
                        </div>
                        <div>
                            <label>직원명</label>
                            <input type="text" id="employName" placeholder="직원이름을 입력하세요">
                        </div>
                        <div>
                            <label>직급</label>
                            <input type="text" id="employRank" placeholder="직급을 입력하세요">
                        </div>
                        <div>
                            <label>전화번호</label>
                            <input type="text" id="phone" placeholder="전화번호을 입력하세요">
                        </div>
                        <div>
                            <label>이메일</label>
                            <input type="text" id="email" placeholder="이메일을 입력하세요">
                            <span>@</span>
                            <select name="email_option" id="email_option">
                                <option value="none">=== 메일 선택 ===</option>
                                <option value="@naver.com">naver.com</option>
                                <option value="@gmail.com">gmail.com</option>
                                <option value="@nate.com">nate.com</option>
                                <option value="user_input">직접입력</option>
                            </select>
                            <input type="text" id="email2" placeholder="이메일 직접입력">

                        </div>
                    </form>

                    <%--파일 업로드 영역--%>
                    <div class="file_upload">
                        <p>직원 파일 업로드</p>
                        <form>
                            <%--<label>파일 이름 : </label>
                            <input id="saveName" type="text" placeholder="저장할 파일명을 입력해주세요" required>--%>

                            <label> 업로드할 파일 : </label>
                            <input id="originalName" type="file" placeholder="저장할 파일명을 올려주세요" value="original_name" required>
                        </form>
                    </div>

                    <%--저장된 파일 출력--%>
                    <div class="saved_file">
                        <h3>저장된 파일</h3>
                        <div class="file_list">
                            <p>파일 아이디 : <span id="file_id"></span></p>
                            <p>파일 이름 : <span id="save_saveName"></span></p>
                            <p>파일 원본이름 : <span id="save_originalName"></span></p>
                            <p>파일 등록일 : <span id="save_createAt"></span></p>
                        </div>

                        <button class="deleteFile" onclick="deleteFile()">파일삭제</button>
                    </div>

                    <button type="button" id="addMember" onclick="addMember()">직원등록</button>
                    <button type="button" id="modifyMember" onclick="modifyMember()">직원수정</button>
                </div>

                <button class="close">창 닫기</button>




            </div>
        </div>


    </div>
</div>

<script>
    $(document).ready(function() {
        // 페이지 로드 시 URL 파라미터를 읽어와서 폼 필드에 설정
        function setFormFieldsFromURL() {
            const urlParams = new URLSearchParams(window.location.search);
            const category = urlParams.get('category');
            const pageSize = urlParams.get('pageSize');
            const keyword = urlParams.get('keyword');
            const pageIndex = urlParams.get('pageIndex');

            if (category) {
                $('#category').val(category);
            }
            if (pageSize) {
                $('#pageSize').val(pageSize);
                $('#pageSize').val(pageSize).prop("selected",true);
                var test =  $('#pageSize').val(pageSize);
                console.log("페이징 사이즈"+test);
            }
            if (keyword) {
                $('#keyword').val(keyword);
            }
            if (pageIndex) {
                $('input[name="pageIndex"]').val(pageIndex);
            }
        }
        // 모달창 초기 숨기기
        $("#add_modal").hide();
        $("#modify_modal").hide();

        // 등록 버튼 클릭 이벤트
        $('#add_btn').click(function() {
            $("#employId").val("");
            $("#employName").val("");
            $("#employRank").val("");
            $("#phone").val("");
            $("#email").val("");
            $(".title").text("직원 등록")
            $('#modifyMember').hide()
            $('#addMember').show();
            $("#add_modal").show();
            $(".saved_file").hide();
        });

        // 등록 모달 닫기 버튼 클릭 이벤트
        $('.close').click(function() {
            $("#add_modal").hide();
        });


        // 수정 모달 닫기 버튼 클릭 이벤트
        $('.modify_close').click(function() {
            $("#modify_modal").hide();
        });

        //직접 입력창 숨김
        $("#email2").hide();
        //이메일 직접 입력
        $('#email_option').change(function (){
            let value = $(this).val();
            if(value == "user_input"){
                $("#email2").show();
            }else {
                $("#email2").hide();
                $('#email_option').show();
            }
        })


        //검색 - 조건 설정
        $('#search_option').change(function (){
            let value =  $(this).val();
            console.log("선택한 검색 조건"+value)
        });

        function pageChange(pageNum) {
            $('input[name="pageIndex"]').val(pageNum);

            console.log($('input[name="pageSize"]').val())
            $('#searchForm').submit();
        }

        $('.page-link').click(function() {
            var pageNum = $(this).attr('data-page'); // 각 페이지 링크에 data-page 속성을 추가해야 함
            pageChange(pageNum);
        });

        // 페이지 사이즈 선택 이벤트 처리
        $('#pageSize').change(function() {
            var selectedSize = $(this).val();  // 선택된 페이지 크기
            $('input[name="pageSize"]').val(selectedSize);  // 폼의 hidden input 업데이트
            $('input[name="pageIndex"]').val(1); // 페이지 넘버는 1로 세팅
            $('#searchForm').submit();  // 변경된 페이지 크기로 폼 제출
        });

        $('#keyword, #category').change(function (){
            $('input[name="pageIndex"]').val(1); // 페이지 넘버는 1로 세팅
        })
        // 페이지 로드 시 폼 필드를 설정
        setFormFieldsFromURL();

    });

    // 카테고리에 따른 패턴 설정
    $('#category').change(function() {
        var category = $(this).val();
        var keywordInput = $('#keyword');
        keywordInput.val(''); // 변경 시 기존 입력값 초기화

        if (category === 'id') {
            keywordInput.attr('type', 'number');
            keywordInput.attr('pattern', '\\d+');
            keywordInput.attr('title', '직원 번호는 숫자만 입력 가능합니다.');
        } else {
            keywordInput.attr('type', 'text');
            keywordInput.removeAttr('pattern');
            keywordInput.removeAttr('title');
        }

        // 패턴 초기화
        keywordInput.removeAttr('pattern');

        switch(category) {
            case 'name':
            case 'rank':
                // 한글만 허용
                keywordInput.attr('pattern', '^[가-힣]+$');
                keywordInput.attr('title', '직원명과 직급은 한글만 입력 가능합니다.');
                break;
            /*case 'phone':
                // 전화번호 형식
                keywordInput.attr('pattern', '^[0-9]{2,3}-[0-9]{3,4}-[0-9]{4}$');
                keywordInput.attr('title', '전화번호는 유효한 형식(000-0000-0000)으로 입력해주세요.');
                break;
            case 'email':
                // 이메일 형식
                keywordInput.attr('pattern', '^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,6}$');
                keywordInput.attr('title', '이메일은 유효한 형식으로 입력해주세요.');
                break;*/
        }

        // 초기 카테고리에 따라 패턴 설정
        $('#category').trigger('change');

    });

    // 직원 상세 조회
    function detail(id){
        $.ajax({
            anyne:true,
            type:'GET',
            url: "${contextPath}/employeeDetail/"+id,
        }).done(function(){
            console.log("성공");
            window.location.href = "${contextPath}/employeeDetail/"+id;
        }).fail(function(error){
            console.log(id, "아이디")
            alert("실패하였습니다.", id)
            alert(JSON.stringify(error));
        })

    }




</script>
</body>
</html>