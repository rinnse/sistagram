<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>검색 • Sistagram</title>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link rel="stylesheet" href="/resources/css/reset.css">
<style>
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
	max-width: 1050px; /* 수정: 섹션의 최대 너비 조정 */
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
	width: auto;
	height: 40px;
	text-align: center;
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
    margin: 0 2px; /* 버튼 사이의 간격 조정 */
    text-decoration: none; /* 링크의 밑줄 제거 */
    display: inline-block; /* 버튼을 inline-block 요소로 만들어 너비와 높이를 조절할 수 있게 함 */
}

/* 삭제하기 버튼 스타일 */
.deleteBtn {
	background-color:red; 
	border-radius: 20px;
	border: none;
	color: white;
	height: 30px;
}
</style>
<script type="text/javascript">
$(document).ready(function() {
	// 검색 이미지 버튼 클릭 함수
	$("#searchBtn").on("click", function() {
		// 검색조건을 [검색]으로 해둔 상태에서 검색했을 때 초기화되도록
		if ($("#searchType").val() === "") {
            $("#searchValue").val("");
            $("#searchType").val("");
        }
		
		document.searchForm.curPage.value = "1";
		document.searchForm.action = "/admin/boardMgt";
		document.searchForm.submit();
	});
});

// 페이징 처리
function fn_paging(curPage){
	document.searchForm.curPage.value = curPage;
	document.searchForm.action = "/admin/boardMgt";
	document.searchForm.submit();
}
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
				<%@ include file="/WEB-INF/views/include/navigation2.jsp"%>
				<br />
			    <section>
					<b style="display: block; font-weight: bold;">검색</b>
					<section style="display: flex; align-items: center; margin-top: 30px;">
						<!-- 검색 form -->
						<form class="search_form" id="searchForm" name="searchForm" method="POST">
						   <!-- 검색 조건 -->
						   <select id="searchType" name="searchType" style="font-size: 1rem; width: 5rem; height: 2rem; margin-left:.5rem; ">
				               <option value="">검색</option>
				               <option value="1" <c:if test="${searchType == '1'}">selected</c:if>>아이디</option> <!-- userId -->
				               <option value="2" <c:if test="${searchType == '2'}">selected</c:if>>작성자</option>  <!-- userName -->
				               <option value="3" <c:if test="${searchType == '3'}">selected</c:if>>내용</option>
				            </select>
						   <input type="search" id="searchValue"
								value="${searchValue}" name="searchValue" placeholder="검색" autocomplete="off"
								style="background-color: #f0f0f0; border-radius: 12px;" />
						   <img src="/resources/images/searchCon.jpeg" id="searchBtn" class="searchBtn" /> 	
						   <input type="hidden" name="curPage" value="${curPage}" />
						</form>
						<br />
					</section>
					<br />

					<div class="board_list_table">
					<!-- 사용자 리스트 -->
						<table class="table table-hover" style="border:1px solid #c4c2c2;">
				            <thead style="border-bottom: 1px solid #c4c2c2;">
				            <tr class="table-thead-main">
				               <th scope="col" style="width:15%;">게시물 번호</th>
				               <th scope="col">게시물 내용</th>
				               <th scope="col">아이디</th>
				               <th scope="col">작성자</th>
				               <th scope="col">등록일</th>
				               <th scope="col">작성자 권한</th>
				            </tr>
				            </thead>
				            <tbody>
					<c:if test="${!empty bmList}">
						<c:forEach items="${bmList}" var="board" varStatus="status">
				            <tr>
				                <th scope="row" >${board.boardNum}</th>
				                <td>${board.boardContent}</td>
				                <td>${board.userId}</td>
				                <td>${board.userName}</td>
				                <td>${board.regDate}</td>
				                <td>${board.status}</td>
				            </tr>
				    	</c:forEach>
					</c:if>
					<c:if test="${empty bmList}">
				            <tr>
				                <td colspan="5">등록된 게시물 정보가 없습니다.</td>
				            </tr>   
					</c:if>	
				            </tbody>
				         </table>
				         <div class="paging-center" style="float:center;">
				            <!-- 페이징 샘플 시작 -->
							<c:if test="${!empty paging}">
							   <!--  이전 블럭 시작 -->
							   <c:if test="${paging.prevBlockPage gt 0}">
				                  <a href="javascript:void(0)"  class="btn2 btn-primary" onclick="fn_paging(${paging.prevBlockPage})"  title="이전 블럭">&laquo;</a>
							   </c:if>
				               <!--  이전 블럭 종료 -->
				               <span>
				               <!-- 페이지 시작 -->
							   <c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
							   	   <c:choose>
							   	       <c:when test="${i ne curPage}">
				                        <a href="javascript:void(0)" style="background-color:black; border: none; font-size:14px;" class="btn2 btn-primary" onclick="fn_paging(${i})">${i}</a>
									   </c:when>
									   <c:otherwise>
				                        <h class="btn2 btn-primary" style="background-color:black; border: none;font-size:14px; font-weight:bold;">${i}</h>
							   		   </c:otherwise>
							       </c:choose>
							   </c:forEach>
				               <!-- 페이지 종료 -->
				               </span>
				               <!--  다음 블럭 시작 -->
				      		   <c:if test="${paging.nextBlockPage gt 0}">
				                  <a href="javascript:void(0)" class="btn2 btn-primary" onclick="fn_paging(${paging.nextBlockPage})" title="다음 블럭">&raquo;</a>
							   </c:if>
				               <!--  다음 블럭 종료 -->
							</c:if>
				            <!-- 페이징 샘플 종료 -->
				         </div>
					</div>

				</section>
			</div>
		</div>
	</div>
</div>
</div>
</div>
</div>
</body>
</html>