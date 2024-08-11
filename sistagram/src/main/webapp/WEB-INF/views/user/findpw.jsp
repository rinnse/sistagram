<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>비밀번호 찾기 • Sistagram</title>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<link rel="stylesheet" href="/resources/css/reset.css">
<link rel="stylesheet" href="/resources/css/index.css">
<script src="/resources/js/jquery-3.5.1.min.js"></script>
<script>
   $(document).ready(function() {
		$("#userEmail").focus();
	   
	   // 비밀번호 재설정 버튼을 누르면
	   $("#pwBtn").on("click", function(){
		   if($.trim($("#userEmail").val()).length <= 0){
			   alert("입력란이 비어있습니다!");
			   $("#userEmail").focus();
			   return;
		   }
		   
		   // 값 ajax로 넘기기
		   $.ajax({
			  type:"POST",
			  url:"/user/pwSearch",
			  data:{
				userEmail:$("#userEmail").val()
			  },
			  dataType:"JSON",
			  success:function(res){
				  alert("이메일을 확인해주세요!");
			  },
			  error:function(error){
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
                <img src="/resources/images/Sistagram.png" alt="Sistagram" class="brand_logo">
            </div>
            <div class="centent">
                <form name="findpw_form" method="POST">
                    <div class="content_text">
                        <span style="font-weight: bold;">로그인에 문제가 있나요?</span>
                    </div>
                    <div class="content_text">
                        <span style="font-size: 13px;">이메일 주소 또는 아이디를 입력하시면 계정에 다시 액세스할 수 있는 <br/> 링크를 보내드립니다</span>
                    </div>
                    <div class="input_value">
                        <input type="text" id="userEmail" name="userEmail" placeholder="이메일 또는 아이디" autocomplete="off">
                    </div>  
                    <div class="btn_submit">
                        <button type="button" id="pwBtn">비밀번호 재설정</button>
                    </div>
                </form>
                <div class="or_line">
                    <div class="line"></div>
                    <div class="text">또는</div>
                    <div class="line"></div>
                </div>
                <ul class="find_pw">
                    <li><a href="/user/signup">새 계정 만들기</a></li>
                </ul>
            </div>
        </div>
        <div class="container">
            <span><a href="/index">로그인으로 돌아가기</a></span>
        </div>
    </div>
</body>
</html>