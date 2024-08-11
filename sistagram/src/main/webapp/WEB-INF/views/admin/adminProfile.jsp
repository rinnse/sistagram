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
$(document).ready(function() {
	
  
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
               <%@ include file="/WEB-INF/views/include/navigation2.jsp" %>
               <br />                            
                 <section style="width:100%">              
                   <b style="display: block; text-align:center; font-weight: bold;">프로필</b>
	               <section class="profile-section" style="display: flex; align-items: center;">             
	                   <div>
	                     <b style="font-weight: bold; font-size: 25px;">${admin.admId}</b>
	                     <h5 style="font-weight:lighter;">${admin.admName}</h5>
	                  </div>                                           			
                   </section>
                   
<form id="updateForm">       
		<label for="admId" style="font-weight:normal; font-weight: bold;">아이디</label>
        <input type="text" id="admId" name="admId" value="${admin.admId}" style="color:gray;" required autocomplete="off" readonly>			                           
    	
    	<label for="admPwd" style="font-weight:normal; font-weight: bold;">비밀번호</label>
        <input type="text" id="admPwd" name="admPwd" value="${admin.admPwd}" style="color:gray;" required autocomplete="off" readonly>
        
        <label for="admName" style="font-weight:normal; font-weight: bold;">관리자 이름</label>
        <input type="text" id="admName" name="admName" value="${admin.admName}" required readonly>

        <br /><br />
        <button type="button" id="saveBtn" style="margin-top:-30px; padding: 5px 15px; right:30px;">저장</button>
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