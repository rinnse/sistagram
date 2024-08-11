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

.search_form img {
	margin-top: 15px; /* 또는 원하는 만큼의 여백으로 조정 */
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
}

.search-bar_input:focus {
	outline: none;
	text-align: left;
	background-image: none;
}

.profile-image {
	width: 50px; /* 수정: 프로필 이미지 크기 조정 */
	height: 50px; /* 수정: 프로필 이미지 크기 조정 */
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

section {
	max-width: 800px; /* 수정: 섹션의 최대 너비 조정 */
	margin: 8px auto 20px;
	padding: 20px;
	border-radius: 8px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	position: relative;
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
				<%@ include file="/WEB-INF/views/include/navigation.jsp"%>
				<br />
			    <section>
					<b style="display: block; font-weight: bold;">검색</b>
					<section style="display: flex; align-items: center; margin-top: 25px;">
						<form class="search_form" id="searchForm" name="searchForm" method="POST">
						   <!-- 이름이나 아이디를 입력하면 사용자 조회됨 -->
						   <img src="/resources/images/search.png" id="searchBtn" style="margin-top: 12px;" /> 
						   <input class="search-bar_input" type="search" id="searchValue"
								value="${searchValue}" name="searchValue" placeholder="검색" autocomplete="off"
								style="background-color: #f0f0f0; border-radius: 12px;" />
						</form>
						<br />
					</section>
					<br />

					<div class="user-list-table">
					<!-- 사용자 리스트 -->
						<table>
							<tbody>
							   <!-- 사용자(이름, 아이디, 소개) 검색값이 있을 경우 -->
								<c:if test="${!empty searchValue}">
									<c:if test="${!empty list}">
										<c:forEach var="user" items="${list}">
										<!-- 첫 번째 행 -->
											<tr>
											  <td style="text-align: center;">
												<!-- 프로필 사진 이미지 --> 
												<a href="/board/searchProfile?userId=${user.userId}">
												  <img src="/resources/upload/${user.userFile.fileName}" class="profile-image">
												</a>
											  </td>
											  <td style="text-align: left; vertical-align: top;">
												<!-- 아이디 --> 
												<a href="/board/searchProfile?userId=${user.userId}" style="font-weight: bold; color: black; display: block; margin-top: 8px; margin-bottom: 4px;">
												    ${user.userId}
												</a>
												<!-- 이름 --> 
												<a href="/board/searchProfile?userId=${user.userId}" style="color: black; margin-top: 10px;">
													${user.userName}
												</a> <!-- 사용자 프로필로 이동 -->
												</td>
											</tr>
										</c:forEach>
									</c:if>
								</c:if>
							<!-- 테이블 종료 -->
							</tbody>
						</table>
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