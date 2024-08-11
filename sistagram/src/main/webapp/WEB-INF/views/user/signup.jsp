<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>회원가입 • Sistagram</title>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<link rel="stylesheet" href="/resources/css/reset.css">
<link rel="stylesheet" href="/resources/css/index.css">
<script src="/resources/js/jquery-3.5.1.min.js"></script>
<script>
$(document).ready(function() {
       $("#userId").focus();

       $('#userPwd').on('input', function() {
           if ($('#userPwd').val() == '') {
              $('#showPw').css('visibility', 'hidden');
           } else {
              $('#showPw').css('visibility', 'visible');
           }
       });

      $('#showPw').on('click',function() {
            var pw = $("#userPwd");
            var pwType = pw.attr('type');

            if (pwType == 'password') {
                pw.attr('type', 'text');
                $('#showPw').attr('src', '/resources/images/visibility_off.png');
            } else {
                pw.attr('type', 'password');
                $('#showPw').attr('src', '/resources/images/visibility.png');
            }
       });
      
      $("#btn_signup").on("click", function() {  // 가입 버튼 눌렀을 경우
	      // 공백 체크
	   	  var emptCheck = /\s/g;
		  // 영문 대소문자, 숫자, 언더 비로만 이루어진 4~12자리 정규식
		  var idCheck = /^[a-zA-Z0-9_]{4,20}$/;  	  
		  // 비밀번호 : 영문 대소문자, 숫자로만 이루어진 4~12자리 정규식
		  var pwCheck = /^[a-zA-Z0-9]{4,12}$/;
		   
    	  // 아이디
    	  if($.trim($("#userId").val()).length <= 0){
    		  alert("아이디를 입력하세요.");
    		  $("#userId").focus();
    		  return;
    	  }
      	  if(emptCheck.test($("#userId").val())){
      		  alert("아이디는 공백을 포함할 수 없습니다.");
      		  $("#userId").val("");
      		  $("#userId").focus();
      		  return;
      	  }
      	  // 아이디는 영문과 숫자로만 입력 가능
      	  if(!idCheck.test($("#userId").val())){
      		  alert("아이디는 영문 대소문자, 숫자, '_'로만 입력 가능합니다.");
      		  $("#userId").val("");
      		  $("#userId").focus();
      		  return;
      	  }
    	  
      	  // 비밀번호
      	  if($.trim($("#userPwd").val()).length <= 0){
      		  alert("비밀번호를 입력하세요.");
      		  $("#userPwd").focus();
      		  return;
      	  }
      	  if(emptCheck.test($("#userPwd").val())){
      		  alert("비밀번호는 공백을 포함할 수 없습니다.");
      		  $("#userPwd").val("");
      		  $("#userPwd").focus();
      		  return;
      	  }
      	  if(!pwCheck.test($("#userPwd").val())){
      		  alert("비밀번호는 영문 대소문자, 숫자로만 입력 가능합니다.");
      		  $("#userPwd").val("");
      		  $("#userPwd").focus();
      		  return;
      	  }
      	  
      	  if($.trim($("#userName").val()).length <= 0){
     		  alert("이름을 입력하세요.");
     		  $("#userName").focus();
     		  return;
     	  }
      	  if(emptCheck.test($("#userName").val())){
      		  alert("이름은 공백을 포함할 수 없습니다.");
      		  $("#userName").val("");
      		  $("#userName").focus();
      		  return;
      	  }
     	  // 이름은 특수문자 체크
     	  var specialChar = /[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]/g;
     	  
      	  if(specialChar.test($("#userName").val())){
      		  alert("이름에 특수문자를 입력하실 수 없습니다.");
      		  $("#userName").val("");
      		  $("#userName").focus();
      		  return;
      	  }
      	  
     	  // 이메일
      	  if(!fn_validateEmail($("#userEmail").val())){
			  alert("이메일 형식이 올바르지 않습니다.");
			  $("#userEmail").focus();
			  return;
		  }
      	  
      	  if(!confirm("회원가입을 하시겠습니까?")){
      		  return;
      	  }
  
      	  // 아이디 중복 체크 ajax
      	  $.ajax({
      		  type:"POST",
      		  url:"/user/idCheck",
      		  data:{
      			  userId:$("#userId").val()
      		  },
      		  beforeSend:function(xhr){
      			  xhr.setRequestHeader("AJAX", "true");
      		  },
      		  success:function(res){
      			  if(res.code == 0){
      				  alert("중복된 아이디가 없습니다.");
      				  fn_userReg();
      			  } else if(res.code == 400){
      				  alert("파라미터 값이 올바르지 않습니다.");
      				  $("#userId").focus();
      			  } else if(res.code == 404){
      				  alert("중복된 아이디가 있습니다. 다시 시도해주세요!");
      				  $("#userId").focus();
      			  } else {
      				  alert("회원가입 중 오류가 발생하였습니다.");
      				  $("#userId").focus();
      			  }
      		  },
      		  error:function(error){
      			  icia.common.error(error);
      		  }
      	  });
      });
});
   
// 회원가입 등록
function fn_userReg() {
	$.ajax({
		type:"POST",
		url:"/user/userReg",
		data:{
			userId:$("#userId").val(),
			userPwd:$("#userPwd").val(),
			userName:$("#userName").val(),
			userEmail:$("#userEmail").val()
		},
		datatype:"JSON",
		beforeSend:function(xhr){
			xhr.setRequestHeader("AJAX", "true");
		},
		success:function(res){
			if(res.code == 0){
				alert("회원가입이 성공적으로 처리되었습니다!");
				location.href = "/";
			} else if(res.code == 400){
				alert("파라미터 값이 올바르지 않습니다.");
				$("#userId").focus();
			} else if(res.code == 100){
				alert("존재하는 아이디가 있습니다.");
				$("#userId").focus();
			} else if(res.code == 500){
				alert("등록 중 오류가 발생하였습니다.");
				$("#userId").focus();
			} else {
				alert("오류가 발생하였습니다.");
				$("#userId").focus();
			}
		},
		error:function(xhr, status, error){
			icia.common.error(error);
		}
	});
};

     
function fn_validateEmail(value){
   var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
         
   return emailReg.test(value);
}
</script>
</head>
<body>
    <div class="main">
        <div class="container">
            <div class="logo">
                <img src="/resources/images/Sistagram.png" alt="Sistagram" class="brand_logo">
            </div>
            <div class="centent">
                <form name="signup_form" action="" method="POST">
                    <div class="content_text">
                        <span style="font-weight: bold;">친구들의 사진과 동영상을 보려면 <br/>가입하세요!</span>
                    </div>
                    <div class="input_value">
                        <input type="text" id="userId" name="userId"  placeholder="아이디" autocomplete="off">
                    </div>
                    <div class="input_value">
                        <input type="password" id="userPwd" name="userPwd" placeholder="비밀번호를 입력하세요" autocomplete="off">
                        <img class="showPw" id="showPw" name="showPw" src="/resources/images/visibility.png" style="visibility: hidden;">
                    </div>
                    <div class="input_value">
                        <input type="text" id="userName" name="userName"  placeholder="이름" autocomplete="off">
                    </div>
                    <div class="input_value">
                        <input type="text" id="userEmail" name="userEmail"  placeholder="이메일" autocomplete="off">
                    </div>
                    <br />
                    <div class="btn_submit">
                        <button type="button" id="btn_signup">가입</button>
                    </div>
                </form>
            </div>
        </div>
        <div class="container">
            <span><p style="margin: 15px;">계정이 있으신가요? <a href="/index"><span style="color: #4cb5f9;">로그인</span></a></p></span>
        </div>
    </div>
</body>
</html>