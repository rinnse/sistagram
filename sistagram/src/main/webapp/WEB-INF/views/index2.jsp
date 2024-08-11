<!DOCTYPE html>
<html lang="ko">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<head>
<meta charset="UTF-8">
<title>Admin_ Sistagram</title>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/resources/css/reset.css">
<link rel="stylesheet" type="text/css" href="/resources/css/index.css">
<script type="text/javascript" src="/resources/js/jquery-3.5.1.min.js"></script>
<script>
   $(document).ready(function() {
       $("#admId").focus();

       $('#admPwd').on('input', function() {
            if ($('#admPwd').val() == '') {
                $('#showPw').css('visibility', 'hidden');
            }
            else {
                $('#showPw').css('visibility', 'visible');
            }
       });

       $('#showPw').on('click',function() {
            var pw = $("#admPwd");
            var pwType = pw.attr('type');

            if (pwType == 'password') {
                pw.attr('type', 'text');
                $('#showPw').attr('src', '/resources/images/visibility_off.png');
            }
			else {
                pw.attr('type', 'password');
                $('#showPw').attr('src', '/resources/images/visibility.png');
            }
       });

       // 공백 체크
	   var emptCheck = /\s/g;
	   // 아이디 : 영문 대소문자, 숫자, 언더 비로만 이루어진 4~12자리 정규식
	   var idCheck = /^[a-zA-Z0-9_]{4,20}$/;
	   // 비밀번호 : 영문 대소문자, 숫자로만 이루어진 4~12자리 정규식
	   var pwCheck = /^[a-zA-Z0-9]{4,12}$/;

	   $("#btn_login").on("click", function() {   // 로그인 버튼 눌렀을 경우
		   // 아이디 입력 체크
		   if($.trim($("#admId").val()).length <= 0){
			   alert("아이디를 입력하세요!");
			   $("#admId").focus();
			   return;
		   }
		   if(emptCheck.test($("#admId").val())) {
			   alert("공백을 포함할 수 없습니다.");
			   $("#admId").val("");
			   $("#admId").focus();
			   return;
		   }
		   if(!idCheck.test($("#admId").val())){
			   alert("아이디는 영문 대소문자, 숫자,'_'로만 입력 가능합니다.");
			   $("#admId").val("");
			   $("#admId").focus();
			   return;
		   }
		   
		   // 비밀번호 입력 체크
		   if($.trim($("#admPwd").val()).length <= 0){
			   alert("비밀번호를 입력하세요!");
			   $("#admPwd").focus();
			   return;
		   }
		   if(emptCheck.test($("#admPwd").val())){
			   alert("공백을 포함할 수 없습니다.");
			   $("#admPwd").val("");
			   $("#admPwd").focus();
			   return;
		   }
		   if(!pwCheck.test($("#admPwd").val())){
			   alert("비밀번호는 영문 대소문자, 숫자로만 입력 가능합니다.");
			   $("#admPwd").val("");
			   $("#admPwd").focus();
			   return;
		   }
		   
		   // 로그인 성공 ajax
		   $.ajax({
			   type:"POST",
			   url:"/admin/login",
			   data:{
					admId:$("#admId").val(),
					admPwd:$("#admPwd").val()
			   },
			   dataType:"JSON",
				  beforeSend:function(xhr){
				  xhr.setRequestHeader("AJAX", "true");
			   },
			   success:function(res){
				   if(res.code == 0){
					   alert("관리자님 로그인 성공.");
					   location.href = "/admin";
				   } else if(res.code == 400){
					   alert("파라미터 값이 올바르지 않습니다.");
					   $("#admId").focus();
				   } else if(res.code == 404){
					   alert("관리자 정보를 찾을 수 없습니다.");
					   $("#admId").focus();
				   } else if(res.code == 403){
					   alert("로그인 중 오류가 발생하였습니다.");
					   $("#admId").focus();
				   } else {
					   alert("오류가 발생하였습니다.");
					   $("#admId").focus();
				   }
			   },
			   error:function(xhr, status, error){
				  icia.common.error(error);
			   }
		   });
	   });
	   
});
</script>
</head>
<body>
    <div class="main">
        <div class="container">
            <div class="logo">
                <a href="/index2.jsp"><img src="/resources/images/Sistagram.png" alt="Sistagram" class="brand_logo"></a>
            </div>
            <div class="centent">
                <form name="login_form" action="/admin" method="POST">
                    <div class="input_value">
                        <input type="text" id="admId" name="admId" placeholder="아이디" autocomplete="off">
                    </div>
                    <div class="input_value">
                        <input type="password" id="admPwd" name="admPwd" placeholder="비밀번호를 입력하세요" autocomplete="off">
                        <img class="showPw" id="showPw" name="showPw" src="/resources/images/visibility.png" style="visibility: hidden;">
                    </div>
                    <div class="btn_submit">
                        <button type="button" id="btn_login">로그인</button>
                    </div>
                </form>
                <div>
                    <span id="Check" name="Check"></span>
                </div>
                <div class="or_line">
                    <div class="line"></div>
                    <div class="text">또는</div>
                    <div class="line"></div>
                </div>
                <ul class="find_pw">
                    <li><a href="">비밀번호를 잊으셨나요?</a></li>
                </ul>
            </div>
        </div>
        <div class="container">
            <span><p style="margin: 15px;">계정이 없으신가요? <a href="/admin/signUp"><span style="color: #4cb5f9;">가입하기</span></a></p></span>
        </div>
    </div>
  </body>
</html>