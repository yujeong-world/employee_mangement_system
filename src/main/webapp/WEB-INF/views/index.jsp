
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<html lang="ko">
<head>

    <meta charset="UTF-8">
    <title>Home</title>
    <link rel="stylesheet" type="text/css" href="${contextPath}/static/css/main.css?after">
    <link rel="stylesheet" type="text/css" href="${contextPath}/static/css/bootstrap.css">
    <link rel="stylesheet" type="text/css" href="${contextPath}/static/css/bootstrap-grid.min.css">
    <!-- jsTree 스타일시트 -->
    <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.3.12/themes/default/style.min.css"
    />
<%--      제이쿼리 --%>
    <script type="text/javascript" src="${contextPath}/static/lib/jquery-3.6.3.min.js"></script>
    <script type="text/javascript" src="${contextPath}/static/js/bootstrap.js"></script>
    <%--jstree--%>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.3.12/jstree.min.js"></script>


</head>

<body>


<div id="listInfo">

   <%-- <nav class="navbar navbar-expand-lg bg-body-tertiary">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">직원 관리 시스템</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link active" aria-current="page" href="#">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Features</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Pricing</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link disabled" aria-disabled="true">Disabled</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>--%>
    <div class="tree_contriner">
        <div>
            <p>조직도</p>

            <div id="jstree"></div>

            <div>
                <button id="treeAdd">추가</button>
                <button id="treeModify">수정</button>
                <button id="treeDelete">삭제</button>
            </div>
        </div>

    </div>
    <div>
        <h3><a href="${contextPath}">직원 목록</a></h3>
        <div class="table_top_container">
            <div class="btn_area">
                <button id="add_btn" class="btn btn-outline-primary" >등록</button>
                <button id="modify_btn" onclick="modifyEmployInfo()" class="btn btn-outline-secondary">수정</button>
                <button onclick="deleteemploy()" class="btn btn-outline-dark">삭제</button>
                <button onclick="excelDownload()" class="btn btn-primary btn-sm">엑셀다운</button>
                <button onclick="openExcelModal()" class="btn btn-secondary btn-sm">일괄등록</button>
            </div>

            <div class="form_area">
                <form id="searchForm" action="${contextPath}" method="GET">
                    <%--<select name="category" id="category">
                        <option value="name">직원명</option>
                        <option value="id">직원 번호</option>
                        <option value="rank">직급</option>
                        <option value="phone">전화번호</option>
                        <option value="email">이메일</option>
                    </select>--%>
                    <%--부트스트랩수정--%>
                    <select class="form-select" name="category" id="category" aria-label="Default select example">
                        <option value="name">직원명</option>
                        <option value="id">직원 번호</option>
                        <option value="rank">직급</option>
                        <option value="phone">전화번호</option>
                        <option value="email">이메일</option>
                        <option value="department" hidden>부서</option>
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
                    <button type="submit" class="btn btn-outline-secondary">검색</button>
                </form>
            </div>
        </div>



        <div>

            <div>
                <table>
                    <thead>
                    <tr>
                        <th>선택</th>
                        <th>직원번호</th>
                        <th>직원이름</th>
                        <th>부서</th>
                        <th>직급</th>
                        <th>전화번호</th>
                        <th>이메일</th>
                        <th>직원정보 메일발송</th>

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

                            <td>${list.department}</td>

                            <td>${list.employRank}</td>
                            <td>${list.phone}</td>
                            <td>${list.email}</td>
                            <td><button id="mail_submit" onclick="mailSubmit(${list.employId})">메일 발송하기</button></td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>


            <div>
                총 ${totalCount} 건
            </div>

            <%--페이지 바--%>
            <div class="page_area">
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
                        <form>
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
                                <label>부서</label>
                                <input type="text" id="department" placeholder="부서명을 입력하세요">
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
                            <button class="plus" onclick="plus()">파일추가+</button>
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

                            <%-- <button class="deleteFile" onclick="deleteFile()">파일삭제</button>--%>
                        </div>

                        <button type="button" id="addMember" onclick="addMember()">직원등록</button>
                        <button type="button" id="modifyMember" onclick="modifyMember()">직원수정</button>
                    </div>

                    <button class="close">창 닫기</button>




                </div>
            </div>

            <%--엑셀 일괄등록 모달--%>
            <div id="axcel_modal">
                <div class="inner">
                    <p>직원정보 일괄등록</p>
                    <p>직원정보를 일괄 등록하기 위한 엑셀 파일을 선택해주세요</p>
                    <form>
                        <input type="file" id="file" name="file">
                        <button type="submit" onclick="excelAddBth(event)">등록</button>
                    </form>

                    <div>
                        <button id="close_excel_modal" onclick="closeExcel()">닫기</button>
                    </div>
                </div>
            </div>

            <%--조직도 추가 모달--%>
            <div id="tree_modal">
                <div class="inner">
                    <p>조직 추가창</p>

                    <div class="select_area">
                        <label class="tree_select">상위 부서를 선택해주세요.(선택하지 않을 경우, 최상위)</label>
                        <select id="tree_select" name="tree_select">

                        </select>
                    </div>

                    <div class="treeMod">
                        <label>변경할 부서를 선택해주세요</label>
                        <select id="modify_sel" name="modify_sel">

                        </select>
                    </div>
                    <label>부서명</label>
                    <input type="text" placeholder="부서명을 입력해주세요." class="treeAdd" id="treeId">
                    <button onclick="treeCheck()" class="treeAdd">중복확인</button> <span class="tree_check"></span>
                    <div class="treeMod">
                        <label>상위 부서를 선택해주세요.(선택하지 않을 경우, 최상위)</label>
                        <select id="modify_sel_parent" name="modify_sel_parent">

                        </select>
                    </div>



                    <%--<input type="text" class="treeMod" placeholder="수정할 부서명을 입력해주세요.">--%>


                    <button onclick="treeAdd()" class="treeAdd">추가하기</button>
                    <button onclick="treeModify()" class="treeMod">수정하기</button>
                    <button onclick="treeDelte()" class="treeDel">삭제하기</button>
                    <button id="tree_modal_close">닫기</button>

                </div>
            </div>

            <%--조직 삭제 모달창--%>

        </div>
    </div>

</div>
<script type="text/javascript">
    //일괄등록 모달 오픈
    function openExcelModal(){
        $("#axcel_modal").show();
    }
    //일괄 등록 모달 닫기
    function closeExcel(){
        $("#axcel_modal").hide();
    }
    // 엑셀 다운로드 버튼
    function excelDownload() {
        //url 파라미터 가지고 오기
        let urlSearch = new URLSearchParams(location.search);
        let category = urlSearch.get('category')
        let keyword = urlSearch.get('keyword')
        //var category = encodeURIComponent("yourCategory"); // 카테고리 값을 설정
        //var keyword = encodeURIComponent("yourKeyword"); //  키워드 값을 설정
        var url = "${contextPath}/excel/download?category=" + category + "&keyword=" + keyword;
        //var url = "${contextPath}/excel/download";
        window.location.href = url;
    }

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
            if (response === 'Valid') {

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

    //직원 등록
    function addMember() {
        var employId = Number($("#employId").val());
        var employName = $("#employName").val();
        var employRank = $("#employRank").val();
        var phone = $("#phone").val();
        var email = assembleEmail();
        var saveName = $("#saveName").val();
        var department = $("#department").val();

        // 유효성 검사
        var regExpName = /^[a-z|A-Z|ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/;
        var regPhone = /^[0-9]{2,3}-[0-9]{3,4}-[0-9]{4}$/;

        if ($("#checkResult").text() == '사용불가' || $("#checkResult").text() == '') {
            alert("직원 번호를 확인해주세요");
            return;
        }

        if (!validateEmail(email)) {
            alert("이메일을 올바르게 입력해주세요.");
            return;
        }

        if (!regExpName.test(employName)) {
            alert("이름을 올바르게 입력해주세요");
            return;
        }

        if (!regPhone.test(phone)) {
            alert("휴대폰 번호를 올바르게 입력해주세요");
            return;
        }

        // 파일이 최소 1개 이상 등록되었는지 확인
        var totalFiles = $(".file_upload_form input[type='file']").length;
        if (totalFiles === 0) {
            alert("파일을 최소 1개 이상 등록해주세요.");
            return;
        }

        var formData = {
            "employeeVo": {
                "employId": employId,
                "employName": employName,
                "department": department,
                "employRank": employRank,
                "phone": phone,
                "email": email
            },
            "fileVo": []
        };

        // 파일 데이터 추가
        var filesProcessed = 0;
        var totalFiles = $(".file_upload_form input[type='file']").length;

        $(".file_upload_form input[type='file']").each(function(index, fileInput) {
            var file = fileInput.files[0];
            if (file) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    var arrayBuffer = e.target.result;
                    var bytes = new Uint8Array(arrayBuffer);
                    var binaryString = Array.from(bytes).map(byte => String.fromCharCode(byte)).join('');
                    var encodedFile = btoa(binaryString); // Base64 인코딩

                    formData.fileVo.push({
                        "saveName": saveName,
                        "originalName": file.name,
                        "fileData": encodedFile // Base64 인코딩된 파일 데이터
                    });

                    filesProcessed++;
                    if (filesProcessed === totalFiles) {
                        // 모든 파일이 처리되면 AJAX 요청을 보냅니다.
                        $.ajax({
                            type: 'POST',
                            data: JSON.stringify(formData),
                            url: "${contextPath}/addEmployee",
                            dataType: "text",
                            contentType: 'application/json; charset=utf-8',
                        }).done(function() {
                            console.log("성공");
                            window.location.href = "${contextPath}/employeeDetail/" + employId;
                        }).fail(function(error) {
                            alert("실패하였습니다.");
                            alert(JSON.stringify(error));
                        });
                    }
                };
                reader.readAsArrayBuffer(file); // 파일을 읽고 Base64 인코딩
            } else {
                filesProcessed++;
            }
        });

        // 파일이 없을 경우에도 폼 데이터를 전송합니다.
        if (totalFiles === 0) {
            $.ajax({
                type: 'POST',
                data: JSON.stringify(formData),
                url: "${contextPath}/addEmployee",
                dataType: "text",
                contentType: 'application/json; charset=utf-8',
            }).done(function() {
                console.log("성공");
                window.location.href = "${contextPath}/employeeDetail/" + employId;
            }).fail(function(error) {
                alert("실패하였습니다.");
                alert(JSON.stringify(error));
            });
        }
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

    // 파일 이름을 추출하는 함수
    function getFileName(originalName) {
        if (!originalName) {
            return "";
        }
        return originalName.split('\\').pop().split('/').pop();
    }

    let delete_file_list = [];
    var countClick = 1;

    function deleteFile(id) {
        let visibleFileCount = $(".saved_file .file_list > div").filter(function() {
            return $(this).css('display') !== 'none';
        }).length;

        if (visibleFileCount <= 1) {
            alert("파일을 전부 삭제할 수 없습니다. 최소 1개의 파일이 필요합니다.");
            return;
        }
        let file = ".file_item_" + id;
        delete_file_list.push(Number(id));
        console.log("파일 삭제 ", delete_file_list);
        $(file).hide();
    }

    // 직원 수정 모달 - 수정 버튼
    function modifyMember() {
        var employId = Number($("#employId").val());
        var employName = $("#employName").val();
        var employRank = $("#employRank").val();
        var phone = $("#phone").val();
        var email = assembleEmail();
        var saveName = $("#saveName").val();

        // 유효성 검사
        if ($("#checkResult").text() == '사용불가' || $("#checkResult").text() == '') {
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

        var formData = {
            "employeeVo": {
                "employId": employId,
                "employName": employName,
                "employRank": employRank,
                "phone": phone,
                "email": email
            },
            "fileVo": [],
            "deleteList": delete_file_list,
        };

        // 파일 데이터 추가
        var filesProcessed = 0;
        var totalFiles = $(".file_upload_form input[type='file']").length;

        console.log(formData.deleteList, "삭제 데이터 리스트");

        $(".file_upload_form input[type='file']").each(function(index, fileInput) {
            var file = fileInput.files[0];
            if (file) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    var arrayBuffer = e.target.result;
                    var bytes = new Uint8Array(arrayBuffer);
                    var binaryString = Array.from(bytes).map(byte => String.fromCharCode(byte)).join('');
                    var encodedFile = btoa(binaryString); // Base64 인코딩

                    formData.fileVo.push({
                        "saveName": saveName,
                        "originalName": file.name,
                        "fileData": encodedFile // Base64 인코딩된 파일 데이터
                    });

                    filesProcessed++;
                    if (filesProcessed === totalFiles) {
                        // 모든 파일이 처리되면 AJAX 요청을 보냅니다.
                        sendModifyRequest(formData);
                    }
                };
                reader.readAsArrayBuffer(file); // 파일을 읽고 Base64 인코딩
            } else {
                filesProcessed++;
            }
        });

        // 파일이 없을 경우에도 폼 데이터를 전송합니다.
        if (totalFiles === 0) {
            sendModifyRequest(formData);
        }
    }


    // AJAX 요청을 보내는 함수
    function sendModifyRequest(formData) {
        $.ajax({
            type: 'POST',
            data: JSON.stringify(formData),
            url: "${contextPath}/modifyEmploy/" + formData.employeeVo.employId,
            dataType: "text",
            contentType: 'application/json; charset=utf-8',
        }).done(function() {
            console.log("성공");
            location.href='${contextPath}/';
        }).fail(function(error) {
            alert("실패하였습니다.");
            alert(JSON.stringify(error));
        });
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

    // 직원 등록 모달창 파일 추가 버튼 클릭
    function plus() {
        var fileUploadForm = '<form class="file_upload_form">' +
            '<label> 업로드할 파일 : </label>' +
            '<input class="originalName" type="file" placeholder="저장할 파일명을 올려주세요" required>' +
            '<button type="button" class="remove" onclick="removeForm(this)">X</button>' +
            '</form>';
        $(".file_upload").append(fileUploadForm);
    }
    // 동적으로 추가된 폼 요소를 제거하는 함수
    function removeForm(element) {
        $(element).closest('.file_upload_form').remove();
    }

    //메일 발송하기
    function mailSubmit(employId){

        data = {"employId" : Number(employId)};
        console.log(employId+"메일 발송 test");
        console.log(typeof employId+"메일 발송 test");
        $.ajax({
            url: "${contextPath}/email",
            type: 'POST',
            data:{ employId : Number(employId) },
            async: false,
            success: function (data){
                console.log(data)
                alert("메일을 발송했습니다. 메일을 확인해주세요.");
            },
            error: function (e){
                alert(e);
            }
        })
    }

    // 조직도 영역
    // 1. 트리 추가 버튼

    // 1-1. 조직도 모달창 버튼 눌렀을 때 상위 부서 select 뿌리기


    // 1-2. 부서명 중복 확인
    function treeCheck(){
        let treeName = $('#treeId').val();
        console.log(treeName,"treeId 값")
        // 값을 입력하지 않은 경우 알림
        if(treeName == ""){
            alert("부서명을 입력해주세요.")
            return;
        }
        $.ajax({
            type: 'GET',
            url: '${contextPath}/tree/check',
            data: { name: treeName },
            dataType: 'text',
            //contentType: 'application/json; charset=utf-8',
        }).done(function(response) {
            console.log(response + ' 리턴 체크');
            if (response === 'Valid') {
                alert('사용 가능한 부서명입니다.');
                $('.tree_check').css({"color": "blue"});
                $(".tree_check").text('사용가능');
            } else {
                alert('이미 사용 중인 직원번호입니다.');
                $('.tree_check').css({"color": "red"});
                $(".tree_check").text('사용불가');
            }
        }).fail(function(error) {
            alert('오류가 발생하였습니다.');
            console.error(JSON.stringify(error));
        });
    }

    //1-3 조직 추가하기 버튼
    function treeAdd(){
        //부서명과 상위 부서 선택 확인
        let treeName = $('#treeId').val();
        let parentId = $('select[name = tree_select] option:selected').val();

        //중복 확인
        if($(".tree_check").text() == "사용불가"){
            alert("부서명을 변경해주세요.");
            return;
        }
        if(treeName == ""){
            alert("부서명을 입력해주세요.")
            return;
        }

        $.ajax({
            type: 'POST',
            url: '${contextPath}/tree/add',
            data: JSON.stringify({ name: treeName, parent: parentId }),
            dataType: 'text',
            contentType: 'application/json; charset=utf-8',
        }).done(function(response) {
            console.log(response + ' 리턴 체크');
            location.reload();
        }).fail(function(error) {
            alert('오류가 발생하였습니다.');
            console.error(JSON.stringify(error));
        });

    }

    // 2. 조직도 수정
    function treeModify(){
        //변경할 부서 id 가지고 오기
        let modifyId = $('select[name = modify_sel] option:selected').val();
        modifyId = parseInt(modifyId)
        //변경할 이름 가지고 오기
        let newName = $('#treeId').val();
        //변경할 상위 부서 선택
        let modifyParent = $('select[name = modify_sel_parent] option:selected').val();
        modifyParent = parseInt(modifyParent);

        data = {
            "id" : modifyId,
            "name" : newName,
            "parent": modifyParent
        }

        $.ajax({
            type: 'POST',
            url: "${contextPath}/tree/modify",
            data: JSON.stringify(data),
            dataType: 'text',
            contentType: 'application/json; charset=utf-8',
        }).done(function(response) {
            alert(response);
            location.reload();
        }).fail(function(error) {
            alert('오류가 발생하였습니다.');
            console.error(JSON.stringify(error));
        });

    }

    // 3. 조직도 - 삭제
    function treeDelte(){
        //선택한 부서 id 가지고 오기
        let selectId = $('select[name = tree_select] option:selected').val();
        selectId = parseInt(selectId);
        console.log(selectId, "아이디값입니다.")
        debugger
        $.ajax({
            type: 'POST',
            url: "${contextPath}/tree/delete",
            data: { id: selectId },
            dataType: 'text',
            //contentType: 'application/json; charset=utf-8',
        }).done(function(response) {
            alert(response);
            location.reload();
        }).fail(function(error) {
            alert('오류가 발생하였습니다.');
            console.error(JSON.stringify(error));
        });
    }


</script>
<script>

    // 수정 버튼 클릭 이벤트 연결
    $('.modify_btn').click(function() {
        var employId = $(this).data('employId'); // 버튼에 데이터 속성으로 저장된 직원 ID를 가져옵니다.
        modifyEmployInfo(employId); // 직원 정보 수정 함수 호출
    });

    //직원 수정
    function modifyEmployInfo(){
        console.log(employId + "직원 아이디 테스트 입니다.");

        var checkedIds = Array.from(check_set);

        if (checkedIds.length === 0) {
            alert("수정할 직원을 한명만 선택해주세요.");
            return;
        } else if (checkedIds.length > 1) {
            alert("수정할 직원을 한명만 선택해주세요.");
            return;
        } else {
            $(".title").text("직원 수정");
            $("#add_modal").show();
            $('#modifyMember').show();
            $('#addMember').hide();
            $(".saved_file").show();

            // 수정할 직원 정보를 가져오기.
            $.ajax({
                anyne: true,
                type: 'GET',
                data: JSON.stringify(employId),
                url: "${contextPath}/modifyEmploy/" + employId,
                dataType: "json",
                contentType: 'application/json; charset=utf-8',
            }).done(function(data) {
                console.log(data.employee.employName + "데이터 확인용==============");
                console.log(data + "데이터 확인용==============");
                console.log(data.file + "데이터 확인용==============");

                // 모달창의 input 필드에 값 설정
                $("#employId").val(data.employee.employId);
                $("#employName").val(data.employee.employName);
                $("#department").val(data.employee.department);
                $("#employRank").val(data.employee.employRank);
                $("#phone").val(data.employee.phone);

                // 기존 파일 리스트 초기화
                $(".saved_file .file_list").empty();

                // 파일 데이터가 존재하는 경우에
                if (data.file && data.file.length > 0) {
                    console.log(data.file +'test==')
                    data.file.forEach(function(file) {
                        console.log(file)

                        var fileHtml = `
                        <div class="file_item_`+file.id+`">
                            <p>파일 아이디: <span>`+file.id+`</span></p>
                            <p>파일 원본이름: <span>`+file.originalName+`</span></p>
                            <p>파일 등록일: <span>`+file.createAt+`</span></p>
                            <button class="deleteFile" onclick="deleteFile(`+file.id+`)">-파일삭제-</button>
                        </div>`;
                        $(".saved_file .file_list").append(fileHtml);
                    });

                    // 파일 데이터가 있는 경우에 UI
                    $(".file_list").show();
                } else {
                    // 파일 데이터가 없는 경우에 UI
                    $(".file_list").hide();
                    $(".saved_file > h3").text("저장된 파일 데이터가 없습니다.");
                }

                // 이메일 주소에서 '@' 이전의 부분만 추출하여 입력 필드에 설정 - 앞부분
                var emailUserFront = data.employee.email.split('@')[0];
                $("#email").val(emailUserFront);

                // 이메일 뒷 부분
                var emailUserBack = data.employee.email.split('@')[1];
                console.log(emailUserBack + "이메일 뒷부분?");
                // 이메일 뒷부분 자동 세팅
                const emailList = ["naver.com", "gmail.com", "nate.com"];
                if (emailList.includes(emailUserBack)) {
                    $("#email_option").val('@' + emailUserBack).prop("selected", true);
                    $("#email2").hide();
                } else {
                    $("#email_option").val("user_input").prop("selected", true);
                    $("#email2").val(emailUserBack).show();
                }

                // 이메일 옵션 변경 이벤트 처리
                $('#email_option').change(function() {
                    if ($(this).val() == "user_input") {
                        $("#email2").show();
                    } else {
                        $("#email2").hide();
                    }
                });

            }).fail(function(error) {
                alert("실패하였습니다.");
                alert(JSON.stringify(error));
            });
        }
    }
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
        $('#tree_modal').hide();
        //일괄등록 모달 숨김
        $("#axcel_modal").hide();

        //조직도 모달 - 추가
        $('#treeAdd').click(function (){
            $(".treeDel, .treeMod").hide();
            $(".tree_select").text("상위 부서를 선택해주세요.(선택하지 않을 경우, 최상위)");
            $("#tree_modal, .treeAdd, .select_area").show();
        })

        //조직도 모달 - 수정
        $('#treeModify').click(function (){
            $(".treeDel, .select_area").hide();
            $("#tree_modal").show();
        })

        // 수정 select 박스
        $('#modify_sel').change(function (){
            let selectValue = $('select[name=modify_sel] option:selected').text();
            let selectId = $('select[name=modify_sel] option:selected').val();
            $('#treeId').val(selectValue);

            // 선택한 부서를 제외하고 상위 부서 선택 박스를 업데이트
            $('#modify_sel_parent').empty(); // 기존 옵션을 모두 제거
            $('#modify_sel option').each(function() {
                if ($(this).val() != selectId) {
                    $('#modify_sel_parent').append('<option value="' + $(this).val() + '">' + $(this).text() + '</option>');
                }
            });
        });

        //조직도 모달 - 삭제
        $('#treeDelete').click(function (){
            $(".treeAdd, .treeMod").hide();
            $(".tree_select").text("삭제할 부서를 선택해주세요.");
            $("#tree_modal, .treeDel").show();
        })

        //조직도 모달 닫기
        $('#tree_modal_close').click(function (){
            $('#tree_modal').hide();
        })

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

    //엑셀 직원정보 일괄 등록 - 등록 버튼
    function excelAddBth(event) {
        event.preventDefault(); // 기본 동작을 막음(form 태그)

        let formData = new FormData();
        formData.append("file", $("#file")[0].files[0]);

        $.ajax({
            type: 'POST',
            url: "${contextPath}/excel/save",
            data: formData,
            processData: false,
            contentType: false,
            success: function(response) {
                alert("파일 업로드 결과.\n" + response);
            },
            error: function(jqXHR, textStatus, errorThrown) {
                console.error("업로드에 실패하였습니다:", textStatus, errorThrown);
                alert("업로드에 실패하였습니다: " + textStatus + "\n" + errorThrown);
            }
        });
    }

    //jstree
    /*$('#jstree').jstree({
        'core' : {
            'data' : [
                { "id" : "ajson1", "parent" : "#", "text" : "Simple root node" },
                { "id" : "ajson2", "parent" : "#", "text" : "Root node 2" },
                { "id" : "ajson3", "parent" : "ajson2", "text" : "Child 1" },
                { "id" : "ajson4", "parent" : "ajson2", "text" : "Child 2" },
            ]
        }
    });*/
    //출처: https://mine-it-record.tistory.com/361 [나만의 기록들:티스토리]

    function getTree() {
        debugger
        $.ajax({
            type: 'GET',
            url: '${contextPath}/tree/list',
            dataType: 'json',
            success: function(data) {
                debugger
                var company = new Array();
                // 데이터 받아옴
                $.each(data, function(idx, item) {
                    var idStr = (item.id).toString();
                    var parentStr = (item.parent).toString();
                    //-1인 경우 루트이므로 변환해줌
                    if(parentStr == '-1'){
                        parentStr = '#'
                    }
                    company.push({ id: idStr, parent: parentStr, text: item.name });
                    //조직도 추가 부분 select 옵션 넣어주기
                    let treeHtml = `<option id="`+item.id+`" value="`+item.id+`" >`+item.name+`</option>`;
                    $('#tree_select').append(treeHtml);

                    let treeHtmlModify = `<option id="`+item.id+`" value="`+item.id+`" >`+item.name+`</option>`;
                    $('#modify_sel').append(treeHtmlModify);

                });
                console.log("데이터: ", company);
                console.log("데이터 타입: ", typeof company[0].parent);
                var test = (company[0].id).toString();
                console.log("데이터 타입2: ", typeof test);


                // 트리 생성
                $('#jstree').jstree({
                    'core': {
                        'data': company    // 데이터 연결
                    },
                    'types': {
                        'default': {
                            'icon': 'jstree-folder'
                        }
                    },
                    'plugins': ['wholerow', 'types']
                })
                    .bind('loaded.jstree', function(event, data) {
                        //트리 펼쳐져 있도록
                        $(this).jstree("open_all");
                        // 트리 로딩 완료 이벤트
                        console.log("트리", data)
                        console.log('Tree loaded');
                    })
                    .bind('select_node.jstree', function(event, data) {
                        // 노드 선택 이벤트
                        console.log('Node selected', data.node);

                        let category = "department";
                        let keyword = data.node.text;  // JavaScript에서 인코딩

                        console.log({category, keyword}, "클릭 데이터 확인용");
                        debugger
                        // URL에 파라미터를 추가하여 리다이렉트
                        let url = '${contextPath}/?category='+category+'&keyword='+keyword;
                        $('input[name="category"]').val("depatment").prop("selected", true);
                        console.log("키워드 확인 ", url)
                        debugger
                        window.location.href = url;
                        $('input[name="category"]').val("depatment").prop("selected", true);

                    });
            },
            error: function(data) {
                alert("에러: " + JSON.stringify(data));
            }
        });
    }

    $(document).ready(function() {
        getTree();
    });


</script>
</body>
</html>