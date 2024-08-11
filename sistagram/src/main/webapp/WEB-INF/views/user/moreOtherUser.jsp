<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Sistagram</title>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<link rel="stylesheet" href="/resources/css/reset.css">
<style>
.profile-image {
      width: 55px; /* 수정: 프로필 이미지 크기 조정 */
      height: 55px; /* 수정: 프로필 이미지 크기 조정 */
      object-fit: cover;
      border-radius: 50%;
      margin-bottom: 10px;
      margin-right: 10px; /* 수정: 마진 추가 */
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

.user-list-table {
	padding-left: 690px;
}

.btn button {
	background-color: #5299f7;
	border: none;
	border-radius: 10px; /* 둥근 테두리 */
	color: white;
	width: 97px;
    height: 40px;
	font-size: 15px;
	margin-left: 400px; 
	margin-top:-30px;
}
       
</style>
<script>
	$(document).ready(function() {
		// 검색 이미지 버튼 눌렀을 때 
		$("#searchBtn").on("click", function() {
			// searchValue 값 넘기기
			document.searchForm.action = "/search/userSearch";
			document.searchForm.submit();
			
		});
		
		// 검색 결과가 있을 때만 사용자 리스트 표시
        var userList = document.getElementById("userList");
		
        if (userList.rows.length > 1) {
            $(".user-list-table").show();
        }
        
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
					 <div class="user-list-table">
					 <br /><br /><br />
					 <h1 style="font-weight:bold; font-size:20px;">추천</h1>
					 <br /><br /><br />
					  <!-- 사용자 리스트 --> 
					  <table>
					    <tbody>			    
		<c:if test="${!empty list}">		
			   <c:forEach var="user" items="${list}"> 			    
					      <!-- 첫 번째 행 -->
					      <tr>
					        <td style="text-align: center;"> <!-- 프로필 사진 이미지 -->
					          <a href="/board/searchProfile?userId=${user.userId}">
					            <img src="/resources/upload/${user.userFile.fileName}" class="profile-image"> 
					          </a>
					          <br /><br />						        
					        </td> 
					        <td style="text-align: left; vertical-align: top;">
					          <!-- 아이디 -->  
					          <a href="/board/searchProfile?userId=${user.userId}" style="font-weight:bold; color:black; display: block; margin-top:3px; margin-bottom: 4px;">${user.userId}</a>
					          <!-- 이름 -->
					          <a href="/board/searchProfile?userId=${user.userId}" style="color:gray; margin-top: 10px;">
					          	${user.userName}
					          </a>  <!-- 사용자 프로필로 이동 -->
					          <p style="font-weight:light; font-size:16px; color:gray; margin-top:5px;">회원님을 위한 추천</p>					          
					        </td>
					        <td class="btn">
					        	<button type="button" id="followBtn">팔로우</button>
					        </td>   					    
					      </tr>  			          
		       </c:forEach>  		       
		 </c:if>
					  <!-- 테이블 종료 -->
					   </tbody>
					  </table>	
					</div>  
	      
               </div>
            </div>
        </div>
      </div>
   </div>
</div>
</div>          
</body>
</html>