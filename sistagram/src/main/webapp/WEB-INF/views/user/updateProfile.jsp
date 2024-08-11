<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>프로필 편집 • Sistagram</title>
<link rel="stylesheet" href="/resources/css/reset.css">
<link rel="stylesheet" href="/resources/css/updateProfile.css">
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<style>
	button {
        background-color: #5299f7;
        color: #fff;
        padding: 10px 15px;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        position: absolute;
    }

    button:hover {
        background-color: #b7d3f7;
    }
    section.profile-section {
	    background-color: #f2f2f2; /* 연한 회색 배경 색상 지정 */
	    padding: 20px; /* 내부 여백 설정, 필요에 따라 조절 */
	    border: 1px solid #ddd; /* 테두리 추가 */
    	border-radius: 10px; /* 테두리의 굴곡을 둥글게 설정, 필요에 따라 조절 */
    }
    
    /* 모달창 스타일 */
    body.modal_open {
    overflow: hidden;
    }
  	/* 사진 업로드, 현재 사진 삭제 버튼 스타일 */
	.btn {
	  width: 100%; /* 버튼의 너비 (예: 150px) */
	  height: 50px; /* 버튼의 높이 (예: 40px) */
	  background-color: #ffffff; /* 초기 배경색 (흰색) */
	  color: #000000; /* 초기 텍스트 색상 (검은색) */
	  padding-left: 10px; /* 내부 여백 */
	  text-align: center;
	  text-decoration: none;
	  display: inline-block;
	  font-size: 16px;
	  cursor: pointer;
	  border: none; /* 테두리 없음 */
	  border-radius: 5px; /* 둥근 모서리 */
	  transition: background-color 0.3s ease; /* 변화가 부드럽게 일어나도록 설정 */
	  display: flex; /* 플렉스 컨테이너로 설정 */
	  justify-content: center; /* 수직 가운데 정렬 */
	  position: relative; /* 포지션 추가 */
	}
    .modal_overlay {
    	position: absolute;
	    width: 100%;
	    height: 100%;
	    left: 0;
	    top: 100%;
	    display: none;
	    flex-direction: column;
	    align-items: center;
	    justify-content: right;
   }

   .modal_window {
    background: white;
    border-radius: 20px; /* 테두리를 전체적으로 20px로 설정 */
    width: 300px; /* 모달창의 너비를 300px로 조절 */
    height:230px;
    padding: 20px;
    box-shadow: 0 0 80px rgba(0, 0, 0, 0.2);
  }

  .modal_buttons button {
    background-color: white;
    color: #000;
    padding: 10px 15px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    flex-grow: 1;
    margin: 0 10px;
    transition: background-color 0.3s ease;
  }

  .modal_buttons button:hover {
    background-color: #e0e0e0;
  }

  #fileModal {
    display: none;
  }

  .fileModal_content {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
  }
  .modal_title_side {
  	font-weight: bold;
  }
  
  #userTag {
  	width: 240px;
  }
</style>
<script type="text/javascript">

function saveProfile(){
	// 전화번호 정규표현식
	var phone = /^01(?:0|1|[6-9])[.-]?(\\d{3}|\\d{4})[.-]?(\\d{4})$/;
	
	// 값이 다 입력 됐는지 체크
	// 비밀번호
	if($.trim($("#userPwd").val()).length <= 0){
		alert("비밀번호를 입력해주셔야 합니다!");
		$("#userPwd").focus();
		return;
	}
	// 전화번호
	if($.trim($("#userPhone").val()).length <= 0){
		alert("전화번호를 입력해주셔야 합니다!");
		$("#userPhone").focus();
		return;
	}
	if(phone.test($("#userPhone").val())){
		alert("전화번호 형식이 올바르지 않습니다.");
		$("#userPhone").val("");
		$("#userPhone").focus();
		return;
	} 
	
	// 이메일
	if($.trim($("#userEmail").val()).length <= 0){
		alert("이메일을 입력해주셔야 합니다!");
		$("#userEmail").focus();
		return;
	}
	if(!fn_validateEmail($("#userEmail").val())){
		  alert("이메일 형식이 올바르지 않습니다.");
		  $("#userEmail").val("");
		  $("#userEmail").focus();
		  return;
	}
	
	// ajax (값 넘기기) 
	// 수정 폼(updateForm) 전송
	var form = $("#updateForm")[0];  // 수정폼이 객체 타입이니까 배열 0번째 인수
	var formData = new FormData(form);

	$.ajax({
		type:"POST",
		url:"/user/updateProc",
		data:formData,
		dataType:"JSON",
		contentType: false,
		processData: false,
		beforeSend:function(xhr){
			xhr.setRequestHeader("AJAX", "true");
		},
		success:function(res){
			if(res.code == 0){
				alert("프로필이 수정되었습니다!");
				location.href = "/board/userProfile";  // 추후에 사용자 프로필 화면으로 이동
			} else if(res.code == 410){
				alert("사용자는 [Sistagram]의 사용자가 아닙니다.");
				location.href = "/";
			} else if(res.code == 430){
				alert("해당 아이디가 일치하지 않습니다.");
				location.href = "/";
			} else if(res.code == 404){
				alert("사용자 정보가 존재하지 않습니다.");
				location.href = "/";
			} else if(res.code == 400){
				alert("파라미터가 존재하지 않습니다.");
				location.href = "/";
			} else if(res.code == 500){
				alert("프로필 수정 중 오류가 발생하였습니다.");
				$("#userId").focus();
			} else {
				alert("오류가 발생하였습니다.");
				$("#userId").focus();
			}
		},
		error:function(xhr, success, error){
			icia.common.error(error);
			alert("게시물 수정 처리 중 오류가 발생했습니다.");
		}
	});	
}

function fn_validateEmail(value)
{
   var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
   
   return emailReg.test(value);
}

$(document).ready(function() {
	// 소개 작성할 때 글자 수 제한
    $('#intro').on('input', function() {
        $('#intro_count').html("("+$(this).val().length+" / 150)");

        if($(this).val().length > 150) {
            $(this).val($(this).val().substring(0, 150));
            $('#intro_count').html("(150 / 150)");
        }
    });
    
 	// '사진 변경' 버튼 누르면 모달창 띄워짐
    $('#add_feed').on('click', function() {
      $('body').addClass('modal_open');
      $('#fileModal').show();
    });

    // 모달 닫기 버튼 클릭 시 
    $('#closeFileModal').on('click', function() {
      $('body').removeClass('modal_open');
      $('#fileModal').hide();
    });
  
});

</script>
</head>
<body>
<div>
<div>
   <div>
      <div class="main">
         <div class="aaa">
            <div>
              <div>
               <%@ include file="/WEB-INF/views/include/navigation.jsp" %>
               <br />                            
                 <section style="width:100%">              
                   <b style="display: block; text-align:center; font-weight: bold;">프로필 편집</b>
	               <section class="profile-section" style="display: flex; align-items: center;">             
	                 <img src="/resources/upload/${user.userFile.fileName}" onerror="this.src='/resources/images/prof.png'" style="width: 70px; height: 70px;" class="profile-image"/>
	                 &nbsp;&nbsp;
	                   <div>
	                     <b style="font-weight: bold; font-size: 25px;">${user.userId}</b>
	                     <h5 style="font-weight:lighter;">${user.userName}</h5>
	                  </div>                                           
	                  	<button id="add_feed" style="right: 45px;">사진 변경</button>						
						
						<!-- 모달창 내용 -->						
						<div id="fileModal" class="modal_overlay">
						  <div class="modal_window fileModal_content">	  
						    <div class="modal_title">
						      <span class="modal_title_side">프로필 사진 변경</span>
						      <span id="closeFileModal" style="cursor: pointer; padding-left:80px;">X</span>
						       <hr />
						    </div>
						    <div>
						      <label for="fileInput">
								<div class="btn" style="color: #5299f7;">
									<input type="file" id="userFile" name="userFile" placeholder="파일을 선택하세요." style="height:50px;"/>
								</div>
						      </label>				
							  <div class="btn" id="nowDelete">현재 사진 삭제</div>						   
						    </div>
						  </div>
						</div>			
                   </section>
                   
<form id="updateForm" name="updateForm" method="post">       			                           
    	<label for="userPwd" style="font-weight:normal; font-weight: bold;">비밀번호</label>
        <input type="text" id="userPwd" name="userPwd" value="${user.userPwd}" style="color:gray;" required autocomplete="off">
        
        <label for="userName" style="font-weight:normal; font-weight: bold;">사용자 이름</label>
        <input type="text" id="userName" name="userName" value="${user.userName}" required autocomplete="off">
        
		<label for="userPhone" style="font-weight:normal; font-weight: bold;">전화번호</label>
        <input type="text" id="userPhone" name="userPhone" value="${empty user.userPhone ? '' : user.userPhone}" required autocomplete="off">
        
        <label for="userEmail" style="font-weight:normal; font-weight: bold;">이메일</label>
        <input type="email" id="userEmail" name="userEmail" value="${user.userEmail}" required autocomplete="off">
		
        <label for="intro" style="font-weight: normal; margin-bottom: 10px; display: block; padding: 5px; font-weight: bold;">
		    소개
		</label>                      
		<div style="position: relative;">
		    <textarea id="intro" name="intro" style="width: 100%; height: 100px; border: 1px solid #ccc; border-radius: 10px; padding: 10px; box-sizing: border-box; overflow-y: auto; 
		        font-size:17px; resize: none;" required>${empty user.userIntro ? '' : user.userIntro}</textarea>
		    <div id="intro_count" style="position: absolute; bottom: 5px; right: 5px; color: gray;"><span>0</span>/150</div>
		</div>
		<br />

        <label for="userTag" style="font-weight:normal; font-size: 17px;">태그</label>
        <input type="text" id="userTag" name="userTag" value="${user.userTag}" required autocomplete="off">
        
        <br />
        <input type="hidden" id="userId" name="userId" value="${user.userId}" /> <!-- 고정된 아이디 값 넘기기 위함 -->
        <button type="button" onclick="saveProfile()" style="margin-top:-30px; padding: 5px 15px; right:30px;">저장</button>
</form>
</section>
<br />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
    </div>
  </body>
</html>