<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>Sistagram</title>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<link rel="stylesheet" href="/resources/css/reset.css">
<script type="text/javascript">
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

	
	
	// 팔로우 리스트 '모두 보기'를 눌렀을 때
	$(".moreOtherUser").on("click", function() {
		location.href = "/user/moreOtherUser";  
	});

	// 팔로우 기능
	$(".follow").on("click", function() {  
        var $followButton = $(this);
        var isFollowing = $followButton.text().trim() === "팔로잉";

        if (isFollowing) {
            // '팔로잉'에서 '팔로우'로 변경
            var confirmUnfollow = confirm("팔로우를 취소하시겠습니까?");
            if (confirmUnfollow) {
                $followButton.text("팔로우").css("color", "#3498db");
                // 팔로우 취소 처리
            }
        } else {
            // '팔로우'에서 '팔로잉'으로 변경
            $followButton.text("팔로잉").css("color", "black");
            // 팔로우 처리
        }
    });

});

// 게시물 업로드 일자 함수
function timeForToday(value) {
    const today = new Date();
    const timeValue = new Date(value);

    const betweenTime = Math.floor((today.getTime() - timeValue.getTime()) / 1000 / 60);
    if (betweenTime < 1) return '방금전';
    if (betweenTime < 60) {
        return `${betweenTime}분전`;
    }

    const betweenTimeHour = Math.floor(betweenTime / 60);
    if (betweenTimeHour < 24) {
        return `${betweenTimeHour}시간전`;
    }

    const betweenTimeDay = Math.floor(betweenTime / 60 / 24);
    if (betweenTimeDay < 365) {
        return `${betweenTimeDay}일전`;
    }

    return `${Math.floor(betweenTimeDay / 365)}년전`;
}
</script>
<style>
	.user a {
		color: black;
	}
	
	a {
		color: black;
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
	
	/* 이미지에 마우스를 갖다 대었을 때 커서 모양 변경 */
	img:hover {
    	cursor: pointer;
	}	
</style>
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
           <div style="width: 85%; margin-left: auto;">
             <div style="height: 100vh; display: flex; flex-direction: column;">
                <div style="display: flex; flex-direction: column; flex-grow: 1;">
                  <div style="display: flex; flex-direction: row; justify-content: center;">
                    <div style="max-width: 500px; width: 100%;">
                        <div style="margin-top: 20px;">
                             <!-- top -->
                             <div style="margin-bottom: 30px;">
                                <div style="padding: 0 10px;">
                                    <div style="width: 100%; height: 100%; display: flex; flex-direction: row;">
                                        <ul style="display: flex; flex-direction: row; flex-grow: 1;">
                                           <li>
                                              <div style="padding: 0 5px;">
                                                <button style="background-color: transparent; border-style: none; cursor: pointer;">
                                                  <div>
                                                    <img src="/resources/upload/${user.userFile.fileName}" onerror="this.src='/resources/images/prof.png'" style="width: 50px; height: 50px; border-radius: 50%;">
                                                  </div>
                                                  <div>
                                                    <span>${user.userId}</span>
                                                  </div>
                                                </button>
                                               </div>                                                                        
                                            </li>
                                         </ul>
                                     </div>
                                 </div>
                              </div>
                              
                              <!-- list -->
                           <c:if test="${!empty list}">
                              <div style="width: 100%;">
                              <c:forEach var="board" items="${list}">
                                <div style="display: flex; flex-direction: column;">
                                  <div>
                                     <div style="width: 100%; height: 100%; display: flex; flex-direction: column; padding-bottom: 10px; margin-bottom: 20px; border-bottom-width: 1px; border-bottom-style: solid;">
                                       <div style="padding-bottom: 10px;">
                                         <div style="width: 100%; display: flex; flex-direction: row;">
                                           <div style="margin-right: 10px;">              
                                             <div style="cursor: pointer;"> 
                                              <!-- 게시물을 작성한 회원의 프로필 -->   
                                             <a href="/board/searchProfile?userId=${board.userId}" >                                       
                                              <img src="/resources/upload/${board.userFileName}" onerror="this.src='/resources/images/prof.png'" style="width: 35px; height: 35px; border-radius: 50%;">
                                             </a> 
                                             </div>                  
                                           </div>
                                           <div style="width: 100%; display: flex; align-items: center;">
                                             <div style="display: flex; flex-direction: row;">
                                               <div style="cursor: pointer;">
                                               <a href="/board/searchProfile?userId=${board.userId}"><!-- 아이디 클릭 시 게시물을 작성한 회원의 프로필 페이지로 이동 -->
                                                 <span style="font-weight: bold;">${board.userId}</span>
                                               </a>
                                             </div>
                                             <div style="display: flex; flex-direction: row;">
                                               <div>
                                                 <span style="margin: 0px 4px;">•</span>
                                               </div>
                                               <div class="reg-date">
                                                	${board.regDate}
                                               </div>
                                             </div>
                                           </div>
                                         </div>
                                         <div style="display: flex; align-items: center;">                                         
                                           <!-- 더보기 메뉴 -->
                                            <img src="/resources/images/more.png" class="modal_btn"> 
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
            
          <c:if test="${boardMe eq 'N'}">
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
          </c:if>                 
                                         
                                      </div>
                                    </div>          
                                    <div style="cursor: pointer;"> 
                                    <!-- 게시물 상세 보기 -->
                                      <a href="/board/view?boardNum=${board.boardNum}">                                    
                                       <img src="/resources/upload/${board.boardFile.fileName}" onerror="this.src='/resources/upload/default.png'" style="width: 100%; height: 100;">
                                      </a>
                                    </div>           
                                    <div>
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
                                          <!--클릭 시 게시물을 작성한 사람의 프로필 화면 -->
                                            <a  href="/board/searchProfile?userId=${board.userId}"> 
                                             <span style="font-weight: bold;">${board.userId}</span>
                                            </a>
                                          </div>
                                          <c:if test="${not empty board.boardContent}">
                                          <span>
                                            <span>${board.boardContent}</span>
                                          </span>
                                          </c:if>
                                      </div>
                                      <div style="margin-top: 10px;">
                                       <span>댓글..</span> <!-- 댓글 -->
                                      </div>
                                      <div style="margin-top: 10px;">
                                        <a href="/board/view?boardNum=${board.boardNum}"> <!-- 누르면 게시물 상세 페이지 뜨기 -->
                                         <span style="font-size: 13px;">댓글 1개 보기</span>
                                        </a>
                                      </div>
                                      <div style="margin-top: 10px;">
                                       <form name="reply_form" action="" method="POST" style="display: flex; flex-direction: row;">
                                         <div style="display: flex; flex-direction: row; flex-grow: 1; align-items: center;">
                                           <textarea placeholder="댓글달기" style="height: 18px; border-style: none; resize: none; outline: none; flex-grow: 1;"></textarea>
                                          <div>
                                            <span style="font-size: 13px; font-weight: bold;">게시</span>
                                          </div>
                                         </div>
                                       </form>
                                    </div>
                                   </div>
                                  </div>
                                </div>
                              </div>
                             </div>
                            </c:forEach>
                            
        <script>
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
        </script>             
                            </div>
                         <!-- list -->
                         </c:if>  
                        <br /><br />                 
                        <!-- 게시물 더보기 이미지 버튼 클릭 시 -->
                      <a href="/main" style="display: inline-block; margin-left: 200px;">
                        <img src="/resources/images/up.png" style="width:70px; height:70px;" /> 
                      </a>  
                      <br /><br /><br />  
                           </div>
                           </div>
                                                 
                          <!-- right --> 
                           <div style="width: 35%; height: 100vh; padding-left: 200px;">
                             <div style="margin-top: 40px; display: flex; flex-direction: column;">
                               <div style="padding: 0 10px;">
                                 <div style="display: flex; flex-direction: row; justify-content: space-between;">
                                   <div style="margin-right: 10px;">
                                     <div class="user" style="cursor: pointer;">
                                       <a href="/board/userProfile?userId=${user.userId}">
                                       <img src="/resources/upload/${user.userFile.fileName}" onerror="this.src='/resources/images/prof.png'" style="width: 44px; height: 44px; border-radius: 50%;">
                                       </a>
                                     </div>
                                   </div>
                                   <div class="user" style="width: 100%; display: flex;">
                                     <div style="display: flex; flex-direction: column; justify-content: center; flex-grow: 1;">
                                       <div>
                                         <div>
                                           <a href="/board/userProfile">
                                             <span style="font-weight: bold;">${user.userId}</span>
                                           </a>
                                         </div>
                                       </div>
                                     </div>
                                   </div>
                                   <div style="display: flex;">
                                     <div style="display: flex; align-items: center; flex-shrink: 0;">
                                       <span style="font-size: 12px; font-weight:bold; color: #3498db;">전환</span>
                                     </div>
                                   </div>
                                 </div>
                               </div>
                               <div style="margin-top: 25px; margin-bottom: 10px;">
                                <div style="display: flex; flex-direction: column;">
                                  <div style="display: flex; flex-direction: row;">
                                    <div style="display: flex; flex-grow: 1;">
                                     <span style="font-size: 14px;">회원님을 위한 추천</span>
                                    </div>
                                    <div>
                                      <span class="moreOtherUser" style="font-size: 14px; font-weight: bold;">모두보기</span>
                                    </div>
                                  </div>
                                 
                              <!-- 회원님을 위한 추천 리스트 -->
                              <c:if test="${!empty recomList}">     
                                  <div style="width: 100%;">
                                  <c:forEach var="recom" items="${recomList}"> 
                                   <div style="padding: 10px;">
                                     <div style="display: flex; flex-direction: row; justify-content: space-between;">
                                       <div style="margin-right: 10px;">
                                         <div style="cursor: pointer;">
                                          <a href="/board/searchProfile?userId=${recom.userId}" > 
                                           <img src="/resources/upload/${recom.userFile.fileName}" onerror="this.src='/resources/images/prof.png'" style="width: 44px; height: 44px; border-radius: 50%;">
                                          </a>
                                         </div>
                                       </div>
                                       <div style="width: 100%; display: flex;">
                                         <div style="display: flex; flex-direction: column; justify-content: center; flex-grow: 1;">
                                           <div>
                                             <div>
                                               <a href="/board/searchProfile?userId=${recom.userId}" >     
                                                 <span style="font-weight: bold;">${recom.userId}</span>
                                              </a>
                                             </div>
                                           </div>
                                       <div>
                                          <span>${recom.userName}</span>
                                       </div>
                                     </div>
                                      </div>
                                   <div style="display: flex;">
                                     <div style="display: flex; align-items: center; flex-shrink: 0;">
                                       <span class="follow" style="font-size: 12px; font-weight:bold; color: #3498db; cursor: pointer;">팔로우</span>
                                     </div>
                                  </div>
                                 </div>
                                </div>
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
              </div>
            </div>
          </div>
        </div>
     </div>
   </div>   
</div>
 </body>
</html>