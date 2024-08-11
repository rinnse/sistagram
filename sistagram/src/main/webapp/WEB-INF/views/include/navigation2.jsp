<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<style>
/* 기본 버튼 스타일 */
.nav_button {
  width: 87%; /* 버튼의 너비 (예: 150px) */
  height: 50px; /* 버튼의 높이 (예: 40px) */
  background-color: #ffffff; /* 초기 배경색 (흰색) */
  color: #000000; /* 초기 텍스트 색상 (검은색) */
  padding: 10px 20px; /* 내부 여백 */
  text-align: center;
  text-decoration: none;
  display: inline-block;
  font-size: 16px;
  cursor: pointer;
  border: none; /* 테두리 없음 */
  border-radius: 5px; /* 둥근 모서리 */
  transition: background-color 0.3s ease; /* 변화가 부드럽게 일어나도록 설정 */
  display: flex; /* 플렉스 컨테이너로 설정 */
  flex-direction: column; /* 수직으로 쌓도록 설정 */
  justify-content: center; /* 수직 가운데 정렬 */
  position: relative; /* 포지션 추가 */
}

/* 마우스 호버 시의 버튼 스타일 */
.nav_button:hover {
  background-color: #dddddd; /* 호버 시 배경색 (옅은 회색) */
  color: #000000; /* 호버 시 텍스트 색상 (검은색) */
}
.ectMenue {
      display: none;
      bottom: 10vh; /* 더보기 버튼 아래로 내리기 위해 'bottom' 속성 사용 */
      left: 10px;
      width: 185px;
      background-color: #ffffff;
      border: 1px solid #dddddd;
      border-radius: 5px;
      padding: 10px;
      position: absolute;
      z-index: 1;
      box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
      font-size: 5px;
      color: #d1d1d1;
  }

  .ectMenue a {
      display: block;
      padding: 10px;
      text-decoration: none;
      color: #333;
  }

</style>

<nav> 

<div style="width: 15%; height: 100vh; padding: 8px 12px 20px; display: flex; flex-direction: column; position: fixed; border-right: 1px solid #dbdbdb;">
    <div style="width: 100%; height: 90px;">
        <div class="logo" style="padding: 25px 10px 0px; margin-bottom: 20px;">
            <a href="/admin"><img src="/resources/images/Sistagram.png" alt="Sistagram" class="brand_logo" style="width: 10rem;"></a>
        </div>
    </div>
    <br /><br />
    <div style="width: 100%; flex-grow: 1;">
        <div> 
        <button class="nav_button" onclick="window.location.href='/admin'">
            <span>
               <div style="width: 100%; padding: 10px; display: inline-flex; align-items: center; vertical-align: middle; ">
                 <div style="vertical-align: middle; margin-bottom: -5px;">
                    <img src="/resources/images/home.png" alt="home">
                 </div>
                 <div style="width: 100%; height: 24px; display: flex; align-items: center; padding-left: 10px;">
                     홈
                 </div>
               </div>
            </span>
        </button>
        <br />
        </div>
        <div>
       
         <button class="nav_button" onclick="window.location.href='/admin/userMgt'">
            <span>
               <div style="width: 100%; padding: 10px; margin-bottom: 5px; display: inline-flex; align-items: center;">
                 <div style="vertical-align: middle; margin-bottom: -5px;">
                   <img src="/resources/images/search.png" alt="search">
                 </div>
                 <div style="width: 100%; height: 24px; display: flex; align-items: center; padding-left: 10px;">
                   <span>회원관리</span>
                 </div>
               </div>
            </span>
            </button>
        </div>
        
        <div>
         <button class="nav_button" onclick="window.location.href='/admin/boardMgt'">
            <span>
                <div style="width: 100%; padding: 10px; margin-bottom: 5px; display: inline-flex; align-items: center;">
                  <div style="vertical-align: middle; margin-bottom: -5px;">
                    <img src="/resources/images/search.png" alt="msg">
                  </div>
                  <div style="width: 100%; height: 24px; display: flex; align-items: center; padding-left: 10px;">
                    <span>게시물관리</span>
                  </div>
                </div>
            </span>
            </button>
        </div>
        <div>
         <button class="nav_button" id="alarmBtn" onclick="window.location.href='/admin/boardReport'">
            <span>
                <a>
                    <div style="width: 100%; padding: 10px; margin-bottom: 5px; display: inline-flex; align-items: center;">
                        <div style="vertical-align: middle; margin-bottom: -5px;">
                            <img src="/resources/images/msg.png" alt="heart">
                        </div>
                        <div style="width: 100%; height: 24px; display: flex; align-items: center; padding-left: 10px;">
                            <span>신고관리</span>
                        </div>
                    </div>
                </a>
            </span>
            </button>
        </div>
	</div>
<div>
   
<div id="ectMenue" class="ectMenue">
    <button class="nav_button" id="resetUserInfoBtn" onclick="window.location.href='/admin/adminProfile'">관리자 프로필</button>
    <button class="nav_button" id="logOutBtn" onclick="window.location.href='/admin/logOut'">로그아웃</button>
</div>
   
     <button class="nav_button" id="ectBtn" >
        <span>
                <div style="width: 100%; padding: 10px; margin-bottom: 5px; display: inline-flex; align-items: center;">
                    
                    <div style="vertical-align: middle; margin-bottom: -5px;">
                        <img src="/resources/images/menu.png" alt="home">
                    </div>
                    <div style="width: 100%; height: 24px; display: flex; align-items: center; padding-left: 10px;">
                        <span>더보기</span>
                    </div>
                </div>
        </span>
        </button>
    </div>
</div>

</nav>

<script type="text/javascript">
   document.getElementById('ectBtn').addEventListener('click',function(){
      var ectMenue = document.getElementById('ectMenue');
      
      ectMenue.style.display = (ectMenue.style.display === 'block') ? 'none' : 'block';
      
   });
</script>