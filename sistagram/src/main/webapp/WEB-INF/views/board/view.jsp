<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>(@${board.userId})님의 게시물 • Sistagram</title>
<link rel="stylesheet" href="/resources/css/reset.css">
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<link rel="stylesheet" type="text/css" href="/resources/css/boardDetail.css">
<style>
	a {
		text-decoration: none;
	}
	
	/* 모달창의 ... 더보기 디자인 */
	.modal_btn {
		border: none;
		display: block;
		cursor: pointer;
		background-color: white;		
	}
	
	.btn {
	    display: flex;
	    justify-content: flex-end;
	    margin-top: 3px; /* 이미지 아래 여백 조정 */
	    margin-left: 400px;
	    margin-right: 10px;
	}	

	.btn button {
	    background-color: white;
	    border: none;
	    border-radius: 5px; /* 둥근 테두리 */
	    color: white;
	    width: 80px;
	    height: 40px;
	    font-size: 15px;
	    margin-left: 10px; 
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
    width: 350px;
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
</style>
<script>
$(document).ready(function() {

<c:if test="${boardMe eq 'Y'}">		
		// 수정 버튼 클릭 시
		$("#btnUpdate").on("click", function() {
			var boardNum = ${board.boardNum};  // 게시물 상세 화면의 boardNum 파라미터를 updateForm으로 넘김
		    location.href = "/board/updateForm?boardNum=" + boardNum; 
		});
		
		// 삭제 버튼 클릭 시
		$("#btnDelete").on("click", function() {
			if(confirm("게시물을 삭제하시겠습니까?") == true){
				// ajax로 서버 전송
				$.ajax({
					type:"POST",
					url:"/board/delete",
					data:{
						boardNum:$("#boardNum").val()
					},
					datatype:"JSON",
					beforeSend:function(xhr){
						xhr.setRequestHeader("AJAX", "true");
					},
					success:function(res){
						if(res.code == 0){
							alert("게시물이 삭제되었습니다.");
							location.href = "/main";
						} else if(res.code == 400){
							alert("파라미터 값이 올바르지 않습니다.");
						} else if(res.code == 404){
							alert("게시물 정보가 존재하지 않습니다.");
						} else if(res.code == 403){
							alert("사용자의 게시물이 아닙니다.");
						} else {
							alert("게시물 삭제 처리 중 오류가 발생하였습니다.");
						}
					},
					error:function(xhr, status, error){
						icia.common.error(error);
						alert("오류가 발생하였습니다.");
					}
				});
				
			}
		});
		
</c:if>		

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

	const copyLink = document.querySelector('#copyLink');
	
	// '링크 복사' 란 클릭 시 현재 페이지 링크를 복사하고 모달창 닫기
    copyLink.addEventListener('click', function() {
        var copyText = window.location.href;
        navigator.clipboard.writeText(copyText)
            .then(function() {
                alert("링크가 복사되었습니다.");
                modal.style.display = 'none'; // 모달창 닫기
            })
            .catch(function(error) {
                console.error('복사 실패: ', error);
            });
    });
});
</script>
</head>
<body>
<div>
    <div>
        <div>
            <div class="main">
                <div class="container">
                    <div>
                        <div style="margin-left:-250px;">
                            <%@ include file="/WEB-INF/views/include/navigation.jsp"%>
                            <br />
                  <c:if test="${!empty board}"> 
                            <section class="section-submit">
                                <div style="display: flex; justify-content: space-between;">
                                    <!-- 왼쪽에 이미지 넣기 -->
                                    <div class="boardDetail-img" style="flex-grow: 0; display: flex; align-items: center; background-color:black; border-radius: 5px;">
                                        <img src="/resources/upload/${board.boardFile.fileName}" onerror="this.src='/resources/images/prof.png';" style="width: 450px; height:auto;">
                                    </div>
                                    <!-- 오른쪽에 댓글 넣기 -->
                                    <div style="flex-grow: 1; overflow-y: auto; margin-left:30px;">
					<!-- 게시글 작성자 + 게시글 내용 -->                                        
                               <div class="user-list" style="padding: 10px; ">
                                   <div style="display: flex; flex-direction: row; justify-content: space-between;">
                                       <div style="margin-right: 10px;">
                                           <div style="cursor: pointer;">
                                              <a href="/board/searchProfile?userId=${board.userId}" style="color: black;"> 
                                               <img src="/resources/upload/${board.userFileName}" onerror="this.src='/resources/images/prof.png';" alt="img" style="width: 42px; height: 42px; border-radius: 50%;">
                                           	  </a>
                                           </div>
                                       </div>
                                       <div style="width: 100%; display: flex;">
                                           <div style="display: flex; flex-direction: column; justify-content: center; flex-grow: 1;">
                                               <div>
                                                   <div>
                                                     <a href="/board/searchProfile?userId=${board.userId}" style="color: black;"> 
                                                       <span style="font-weight: bold;">${board.userId}</span>
                                                    </a>
                                                   </div>
                                               </div>                                             
                                           </div>
                                           <button type="button" id="moreBtn" class="modal_btn">•••</button>
                                       </div>
			<!-- 나의 게시물일 경우, 수정/삭제 가능 -->
			<c:if test="${boardMe eq 'Y'}">		
					<!--모달 팝업-->
					<div class="modal">
					    <div class="modal_popup">
						    <p id="btnUpdate" style="text-align:center; cursor: pointer;">수정</p>
						    <hr />
						    <p id="btnDelete" style="text-align:center; cursor: pointer;">삭제</p>
						    <hr />
						    <div style="text-align: center;">
						        <button type="button" id="close_btn" class="close_btn">취소</button>
						    </div>
						</div>
					</div>
            </c:if>                
            
            <!-- 모든 사용자의 게시물일 경우 -->
            <div class="modal">
				<div class="modal_popup">
					<p id="report" style="text-align:center; cursor: pointer; color: red;">신고</p>
					<hr />
					<p id="notFollow" style="text-align:center; cursor: pointer; color: red;">팔로우 취소</p>
					<hr />
					<p id="copyLink" style="text-align:center; cursor: pointer;">링크 복사</p>
					<hr />
					<div style="text-align: center;">
						<button type="button" id="close_btn" class="close_btn">취소</button>
					</div>
				</div>
		    </div>
                      
                                   </div>
                               </div>
                                        
                                        <p></p><hr />
						<!-- 댓글 박스 시작 -->                
                                        <div style="height: 500px; width:450px; overflow-y: auto;">
                                            <!-- 댓글이 많을 경우 스크롤이 생성됩니다 -->
                                            <ul>
   						<!--글 작성자 + 글내용 시작-->
                                     <div class="comment-list" >
                                      <div style="display: flex; flex-direction: row; justify-content: space-between;">
                                          <div style="margin-right: 10px;">
                                              <div style="cursor: pointer;">
                                                  <img src="/resources/upload/${board.userFileName}" onerror="this.src='/resources/images/prof.png';" alt="img" style="width: 42px; height: 42px; border-radius: 50%;">
                                              </div>
                                          </div>
                                          <div style="width: 100%; display: flex;">
                                              <div style="display: flex; flex-direction: column; justify-content: center; flex-grow: 1;">
                                                  <div>
                                                      <p style="font-size: 15px; margin-top:3px;"><b style="font-weight:bold">${board.userId}</b>&nbsp;&nbsp;${board.boardContent}</p>
                                                  </div>
                                              </div>
                                          </div>
                                      </div>
                                  </div>
   				<!--글 작성자 + 글내용 끝-->
   				<!--댓글 시작-->
                                <c:forEach begin="1" end="50" varStatus="loop2">
                                  <div class="comment-list" >
                                      <div style="display: flex; flex-direction: row; justify-content: space-between;">
                                          <div style="margin-right: 10px;">
                                              <div style="cursor: pointer;">
                                                  <img src="/resources/upload/${board.userFile.fileName}" onerror="this.src='/resources/images/prof.png';" alt="img" style="width: 42px; height: 42px; border-radius: 50%;">
                                              </div>
                                          </div>
                                          <div style="width: 100%; display: flex;">
                                              <div style="display: flex; flex-direction: column; justify-content: center; flex-grow: 1;">
                                                  <div>
                                                     <p style="font-size: 15px;"><b style="font-weight:bold;">댓글 아이디</b>&nbsp;&nbsp;댓글 내용</p>
                                                     <span style="font-size: 12px; color:gray;">
                                                        <b style="margin-left:15px;font-weight:bold; ">좋아요 5개</b>
                                                        <b style="margin-left:15px;font-weight:bold; ">답글달기</b>
                                                        <b style="margin-left:15px; font-weight: thin;">1일</b>
                                                     </span>
                                                  </div>
                                              </div>
                                          </div>
                                      </div>
                                  </div>
                                </c:forEach>
   						<!--댓글 끝-->
                               <!-- 댓글이 많아질 경우 추가 -->
                                            </ul>
                                        </div>
						<!-- 댓글 박스 끝 -->
										<div>
                                          <b style="text-align: left; font-weight: normal;"> ${board.regDate}</b>
                                        </div>
                                        <!-- 여기에 댓글 관련 코드를 넣으세요 -->
                                        <form><br />
                                            <input type="text" id="comment" name="comment" style="outline: none;"><br>
                                            <button class="btn-comment" id="btnComment">게시</button>
                                        </form>
                                    </div>
                                </div>
                            </section>
                        </c:if>
                            
                            <br />
			<input type="hidden" id="boardNum" name="boardNum" value="${board.boardNum}" />
			<input type="hidden" id="userId" name="userId" value="${board.userId}" />
			<!-- 본인 글일 경우에 수정/삭제 가능 -->
			<c:if test="${boardMe eq 'Y'}">				
				   <div class="btn">
				       <button type="button" id="btnUpdate">수정</button>&nbsp;
				       <button type="button" id="btnDelete">삭제</button>
			       </div>
			</c:if>             
                            
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>