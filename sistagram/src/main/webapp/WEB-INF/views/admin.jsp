<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>검색 • Sistagram</title>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link rel="stylesheet" href="/resources/css/reset.css">
<style>
/* 이미지에 마우스를 갖다 대었을 때 커서 모양 변경 */
img:hover {
    cursor: pointer;
}
.search_form input {
	width: 550px; /* 수정: 가로 길이 조정 */
	height: 50px; /* 수정: 높이 조정 */
	font-size: 1rem; /* 수정: 폰트 크기 조정 */
	font-weight: 300;
	text-align: left;
	font-family: 'Arial', sans-serif;
	color: #8e8e8e;
	padding: 3px 10px 3px 26px;
	border: 1px solid #dbdbdb;
	border-radius: 3px;
	background-color: #fafafa;
}

.search-bar {
	width: 400px;
	height: 45px;
	border-radius: 5px;
	border: solid 1px rgba(0, 0, 0, 0.3);
	display: flex;
	justify-content: center;
	align-items: center;
	z-index: 1;
	opacity: 1;
	margin-top: 5px;
}

.search-bar_input {
	width: 300px; /* 수정: 검색창 가로 길이 조정 */
	border: none;
	-webkit-appearance: none;
	text-align: center;
	margin-left: 10px;
	overflow: auto;
	z-index: -1;
	font-size: 25px;
	margin-top: 4px;
}

.search-bar_input:focus {
	outline: none;
	text-align: left;
	background-image: none;
}

.search_form {
    display: flex; /* Flexbox 레이아웃을 사용 */
    align-items: center; /* 항목들을 세로 방향으로 중앙에 배치 */
    justify-content: start; /* 항목들을 컨테이너의 시작 부분에서 정렬 */
    gap: 10px; /* 항목들 사이의 간격 설정 */
    cursor: pointer;
}

.search_form select, .search_form input, .search_form img {
    height: 40px; /* 통일된 높이 설정 */
    align-self: center; /* 각 요소를 세로 방향으로 중앙에 배치 */
    cursor: pointer;
}

.search-bar_input, .searchBtn {
    border: none; /* 테두리 제거 */
    background-color: transparent; /* 배경색 투명하게 설정 */
    cursor: pointer;
}

.searchBtn {
    cursor: pointer; /* 마우스 커서를 포인터로 변경 */
    margin-left: -5px; /* 검색 이미지 버튼 위치 조정 */
    margin-top: 1.5%; /* 검색 이미지 버튼을 약간 위로 이동 */
}

body {
	font-family: Arial, sans-serif;
	margin: 0;
	padding: 0;
}

header {
	background-color: #333;
	color: #fff;
	padding: 10px;
	text-align: center;
}

section {
	max-width: 900px; /* 수정: 섹션의 최대 너비 조정 */
	margin: 8px auto 20px;
	padding: 20px;
	border-radius: 8px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	position: relative;
}

*, ::after, ::before {
   box-sizing: unset;
}
.table-hover th, td{
   border: 1px solid #c4c2c2;
   text-align: center;
}

.table-thead-main th {
	background-color: black; 
	color: white;
	border: 1px solid #c4c2c2;
}

.table-thead-side th {
	background-color: black; 
	color: white;
	border: 1px solid #c4c2c2;
}

/* 페이지 버튼 스타일 조정 */
.btn2.btn-primary {
    background-color: black;
    color: white;
    border: none;
    font-size: 12px;
    padding: 10px 10px; /* 버튼의 크기를 조절하고 싶으면 이 값을 조정하세요 */
    text-decoration: none; /* 링크의 밑줄 제거 */
    display: inline-block; /* 버튼을 inline-block 요소로 만들어 너비와 높이를 조절할 수 있게 함 */
}

/* 게시물 이미지 */
.post-image-container {
    display: flex; /* Flexbox 레이아웃을 사용합니다 */
    justify-content: center; /* 가로 방향으로 중앙 정렬 */
    align-items: center; /* 세로 방향으로 중앙 정렬 */
    height: 90vh; /* 컨테이너의 높이를 화면 높이의 100%로 설정 */
    margin-bottom: -15%; /* 각 게시물 사이의 간격 조정 */
    /*padding-bottom: -12%; /* 내부 간격 조정 */ 
    margin-top: 15%;
}

.modal_btn {
	 margin-left:95%;
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
			  <div style="margin-top: -0.5%;">
				<%@ include file="/WEB-INF/views/include/navigation2.jsp"%>
				<br /><br /><br />
		        <div style="margin-top: 2%;">
					<h2 style="text-align: center;">관리자(@${cookieUserId})님. 안녕하세요! </h2>
				</div>
			    <!-- 관리자가 보는 게시물 리스트(보기만 가능) -->
			    <c:if test="${!empty list}">
                    <div style="width: 100%;">
                      <c:forEach var="board" items="${list}">
                         <div style="display: flex; flex-direction: column;" class="post-image-container">
                           <div>
                            <div style="width: 100%; height: 100%; display: center; flex-direction: column; padding-bottom: 10px; margin-bottom: 10px; border-bottom-width: 1px; border-bottom-style: solid;">
                              <div style="padding-bottom: 10px;">
                                 <div style="width: 90%; display: flex; flex-direction: row;">
                                   <div style="margin-right: 10px;">              
                                      <div style="cursor: pointer;"> 
                                        <!-- 게시물을 작성한 회원의 프로필 -->                                        
                                        <img src="/resources/upload/${board.userFileName}" onerror="this.src='/resources/images/prof.png'" style="width: 35px; height: 35px; border-radius: 50%;">
                                      </div>                  
                                   </div>
                                   <div style="width: 100%; display: flex; align-items: center;">
                                     <div style="display: flex; flex-direction: row;">
                                       <div style="cursor: pointer;">
                                          <span style="font-weight: bold;">${board.userId}</span>
                                       </div>
                                     <div style="display: flex; flex-direction: row;">
                                        <div>
                                          <span style="margin: 0px 4px;">•</span>
                                        </div>
                                     </div>
                                    </div>
                                  </div>
                                  <div style="display: flex; align-items: center;">                                         
                                     <!-- 더보기 메뉴 -->
                                     <img src="/resources/images/more.png" class="modal_btn"> 
                                  </div>                                                  
                                 </div>
                               </div>          
                               <div style="cursor: pointer;"> 
                                 <!-- 게시물 상세 보기 -->                                  
                                 <img src="/resources/upload/${board.boardFile.fileName}" onerror="this.src='/resources/upload/default.png'" style="width: 450px; height: 100%;">                              
                               </div>           
                               <div style="display: flex; flex-direction: column;">
                                   <div style="display: grid; margin: 0px 5px; align-items: center; grid-template-columns: 1fr 1fr;">
                                     <div style="display: flex; margin-left: -10px;">
                                       <div style="padding: 8px; cursor: pointer;">
                                         <a><img src="/resources/images/heart.png" alt="img"></a>
                                       </div>
                                       <div style="padding: 8px; cursor: pointer;">
                                          <a><img src="/resources/images/reply.png" alt="img"></a>
                                       </div>
                                     </div>
                                     <div style="margin-left: auto; cursor: pointer;">
                                         <a><img src="/resources/images/mark.png" alt="img"></a>
                                     </div>
                                   </div>
                                   <div style="margin-top: 10px;">
                                     <div style="display: inline-block; margin-right: 5px;">
                                         <span style="font-weight: bold;">${board.userId}</span>
                                     </div>
                                     <c:if test="${not empty board.boardContent}">
                                        <div style="margin-top: 10px; overflow-wrap: break-word;">
                                           <span>${board.boardContent}</span>
                                        </div>
                                     </c:if>
                                   </div>
                                 </div>
                              </div>
                           </div>
                         </div>
                      </c:forEach>
                   </div>
                 <!-- list -->
                </c:if>
                <br /><br />          
		   </div>
	   </div>
	</div>
  </div>
</div>
</body>
</html>