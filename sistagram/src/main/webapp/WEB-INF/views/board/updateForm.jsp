<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시물 수정 • Sistagram</title>
<link rel="stylesheet" href="/resources/css/reset.css">
<link rel="stylesheet" href="/resources/css/updateProfile.css">
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<style>
	input[type="file"] {
  		width: 70%; /* 원하는 너비로 조절 */
  		padding: 10px; /* 원하는 패딩값으로 조절 */
  		font-size: 15px;
	}
	
	.boardFile {
		width:65%;
		height: 65%;
	}
</style>
<script type="text/javascript">
	$(document).ready(function() {
		
		$("#btnUpdate").on("click", function() {  // 수정 [완료] 클릭 시
			// 내용 입력
			if($.trim($("#boardContent").val()).length <= 0){
				alert("내용을 작성해주세요!");
				$("#boardContent").focus();
				return;
			}
			
			// 내용만 수정 가능하기 때문에 게시물 내용만 ajax로 넘김
			$.ajax({
				type:"POST",
				url:"/board/updateProc",
				data:{
					boardNum:$("#boardNum").val(),    // hidden 값으로 설정한 게시물 글번호
					boardContent:$("#boardContent").val()
				},
				beforeSend:function(xhr){
					xhr.setRequestHeader("AJAX", "true");
				},
				success:function(res){
					if(res.code == 0){
						alert("게시물이 수정되었습니다!");
						location.href = "/board/userProfile";
					} else if(res.code == 404){
						alert("게시물이 존재하지 않습니다.");
						$("#boardContent").focus();
					} else if(res.code == 400){
						alert("파라미터 값이 올바르지 않습니다.");
						$("#boardContent").focus();
					} else if(res.code == 403){
						alert("게시물 작성자가 아닙니다..!");
						$("#boardContent").focus();
					} else {
						alert("게시물 수정 중 오류가 발생하였습니다.");
						$("#boardContent").focus();
					}
				},
				error:function(error){
					icia.common.error(error);
					alert("게시물 수정 중 오류가 발생하였습니다.");
					$("#boardContent").focus();
				}
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
         <div class="aaa">
            <div>
              <div>
               <%@ include file="/WEB-INF/views/include/navigation.jsp" %>
               <br />
                 <section style="width:100%">
                 	<b style="display: block; text-align:center; font-weight: bold;">게시물 수정</b>
                 	<br />         	
    <form name="updateForm">  
		<div style="margin-bottom:0.2em; font-size:17px;">[첨부파일 : ${board.boardFile.fileOrgName}]</div>
		<img class="boardFile" src="/resources/upload/${board.boardFile.fileName}" />
        <br /><br />
        <label for="boardContent" style="font-weight:normal; font-weight: bold;">내용</label>
        <textarea id="boardContent" name="boardContent" style="width: 100%; height: 200px; border: 1px solid #ccc; border-radius: 10px; padding: 10px; box-sizing: border-box; overflow-y: auto; 
			font-size:15px; resize: none;" required autocomplete="off">
       		${board.boardContent}
       </textarea> 
       
    	<br /><br />
    	<div class="form-group row">
         <div class="col-sm-12">
            <button type="button" id="btnUpdate" class="btn btn-primary" title="수정" style="background-color: skyblue; border:none;">수정완료</button>
         </div>
      </div>
      <input type="hidden" id="boardNum" name="boardNum" value="${board.boardNum}" />
   </form>
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