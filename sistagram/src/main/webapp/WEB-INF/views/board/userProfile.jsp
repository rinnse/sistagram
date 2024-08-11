<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>@${user.userId} • Sistagram 사용자 프로필</title>
<link rel="stylesheet" href="/resources/css/reset.css">
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<style>
	.profile {
        max-width: 600px;
        margin: 20px auto;
        padding: 20px;
        border-radius: 8px;
        position: relative;
        margin-left: 25%;  /* 좌측으로 이동 */
    }
    
    .main {
        margin-left: 5px; /* 필요한 만큼 좌측 여백을 조절합니다 */
    }
    
    hr {
    	width: 180%;
    	margin-left: -35px;
    }
    
    .profile-info {
        margin-left: 125px;
        margin-top: 5px;
        align-items: center; /* 텍스트를 버튼과 수평 정렬하기 위해 추가 */
    }
    .profile-container {
        display: flex;
  
        align-items: flex-start;
        justify-content: space-between; /* 프로필과 버튼을 좌우 정렬하기 위해 추가 */
    }
    
    .story-images {
    	margin-left: 3px;
    }
    
    .updateBtn {
    	background-color: #f2f2f2; 
    	font-weight:bold;
    	border: none;
        outline: none;
        padding: 6px 9px;
        margin-top: 25px;
        border-radius: 10px; /* 둥근 테두리 */
        font-weight: bold;
        cursor: pointer;
    }
    
    span {
    	font-weight:bold;
    }
    
    p.intro {
    	font-size: 16px;
    }
    
    p.name {
   		margin-bottom: 2px; /* userName 다음 줄 간격을 조절 */
    	margin-top: 15px;
    	font-weight: bold;
    	font-size: 16px;
    }
    
    /* 설정 이미지 팝업 스타일 */
    .modal_btn {
    	width: 20%;
    	height: 20%;
    	margin-top:-3px;
    }
    
    /* 모달창 스타일 */
	.modal {
	    display: none; /* 평소에는 보이지 않도록 */
	    position: fixed; /* absolute에서 fixed로 변경하여 뷰포트에 고정 */
	    top: 0;
	    left: 0;
	    width: 100%; 
	    height: 100%; /* vh 단위에서 %로 변경 */
	    overflow: auto; /* 필요한 경우 스크롤 허용 */
	    background: rgba(0,0,0,0.5);
	    z-index: 1000; /* z-index 추가하여 모달창이 상위에 위치하도록 함 */
	}
	
	.modal .modal_popup {
	    position: fixed; /* 팝업이 항상 뷰포트 중앙에 위치하도록 fixed로 변경 */
	    top: 50%;
	    left: 50%;
	    width: 500px;
	    transform: translate(-50%, -50%);
	    padding: 20px;
	    background: #ffffff;
	    border-radius: 20px;
	    z-index: 1001; /* 모달 팝업 내부 요소가 더 상위에 위치하도록 z-index 설정 */
	}
	
	.modal.on {
	    display: block;
	}
	
	/* 모달창 닫기 버튼 스타일 */
	#close_btn {
		border: none; /* 테두리 제거 */
	    background-color: white; /* 배경색을 흰색으로 설정 */
	    color: black; /* 글자 색상을 검정색으로 설정 */
	    font-family: inherit; /* 주변 텍스트와 동일한 글꼴 사용 */
	    cursor: pointer; /* 마우스 오버 시 커서 모양 변경 */
	}
	
	p.tag {
		color: navy;
		font-size: 16px;
		margin-top: -17px;
		cursor: pointer;
	}
</style>
<script>
$(document).ready(function() {
	// 모달창 띄우기 !!
	const modal = document.querySelector('.modal');
	const modalOpen = document.querySelector('.modal_btn');
	const modalClose = document.querySelector('.close_btn');
		
	//열기 버튼을 눌렀을 때 모달팝업이 열림
	modalOpen.addEventListener('click',function(){
	    //display 속성을 block로 변경
	    modal.style.display = 'block';
	});
		
	//닫기 버튼을 눌렀을 때 모달팝업이 닫힘
	modalClose.addEventListener('click',function(){
	   //display 속성을 none으로 변경
	    modal.style.display = 'none';   
	});

	// 모달 밖 영역을 클릭했을 때 모달팝업 닫기
	window.addEventListener('click', function(event){
	    if(event.target == modal){
	        modal.style.display = 'none';
	    }
	});	
	
	// 설정 및 개인정보 클릭 시
	$("#btnUpdate").on("click", function() {
		location.href = "/user/updateProfile";
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
                 <div class="profile" style="width:100%">
                  <div class="profile-container">
                    <img src="/resources/upload/${user.userFile.fileName}" onerror="this.src='/resources/images/prof.png'" style="padding-left:10px; width: 180px; height: 160px;"/>
                    <section class="profile-info">
                 		<p style="font-style: thin; margin-top:2px; margin-bottom:2px;">${user.userId}</p>
            <!-- 사용자 본인인 경우에만 프로필 편집 기능 보임 -->
           <c:if test="${profileMe eq 'Y'}">      		
                 		<a href="/user/updateProfile"><button class="updateBtn">프로필 편집</button></a>&nbsp;
                 		<img src="/resources/images/setting.png" class="modal_btn" />
           </c:if>   
	    <!--모달 팝업-->
		<div class="modal">
			<div class="modal_popup">
				<p id="setting" style="text-align:center; cursor: pointer;">설정 및 개인정보</p>
				<hr />
				<p id="director" style="text-align:center; cursor: pointer;">관리감독</p>
				<hr />
				<p id="logOut" style="text-align:center; cursor: pointer;" onclick="window.location.href='/user/logOut'">로그아웃</p>
				<hr />
				<div style="text-align: center;">
				   <button type="button" id="close_btn" class="close_btn">취소</button>
				</div>
			</div>
		</div>
           
           <br /><br />
				        게시물 <span>${myList.size()}</span>&nbsp;
                    	팔로워 <span>0</span>
           				팔로우 <span>0</span>
           <br />		
           			 <p class="name">${user.userName}</p>
                     <p class="intro">${user.userIntro}</p>	
                     <p class="tag" onclick="window.location.href='/board/searchProfile?userId=${userTag.useId}'">${user.userTag}</p>
                    </section> 
                 </div>	
                 	<br />
                 	<div class="story-images">
                 		<img src="/resources/images/story2.png" style="width: 102px; height: 130px;" />&nbsp;&nbsp;&nbsp;&nbsp;
                 		<img src="/resources/images/story.png" style="width: 115px; height: 130px;" />
                 	</div>
                 	<hr />
                 	<br />
             
             <!-- 게시물 리스트 -->
             <c:if test="${!empty myList}"> 
              <div style="width: 175%; margin-left: -27px;" >              	              
                 <c:forEach var="board" items="${myList}" varStatus="loop">
                 	<!-- 게시물 첨부파일 눌렀을 때, 게시물 상세 페이지로 이동 -->
                       <a href="/board/view?boardNum=${board.boardNum}" > 
                 		<img src="/resources/upload/${board.boardFile.fileName}" style="width: 310px; height: 310px; margin-right: 10px; margin-bottom: 10px; 
                 																		object-fit: cover;"/>
                 	   </a>
                 	<%-- 3개마다 줄바꿈 처리 --%>
			        <c:if test="${loop.index % 3 == 2}">
			            <br />
			        </c:if>
                 </c:forEach>
              </div> 
             </c:if>  	
             
                 </div>
             </div>
             
           </div>
        </div>
      </div>
   </div>
</div>
</div>