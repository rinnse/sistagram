<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>새 게시물 만들기 • Sistagram</title>
<link rel="stylesheet" href="/resources/css/reset.css">
<link rel="stylesheet" href="/resources/css/updateProfile.css">
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<style>
	input[type="file"] {
  		width: 70%; /* 원하는 너비로 조절 */
  		padding: 10px; /* 원하는 패딩값으로 조절 */
  		font-size: 15px;
	}
</style>
<script type="text/javascript">
	$(document).ready(function() {
		
		$("#btnWrite").on("click", function() {  // [업로드] 클릭 시
			// 내용 입력
			if($.trim($("#boardContent").val()).length <= 0){
				alert("내용을 작성해주세요!");
				$("#boardContent").focus();
				return;
			}
			
			// form(파일 및 내용) -> 서버로 보내기
			var form = $("#writeForm")[0];
			var formData = new FormData(form);
			
			$.ajax({
				type:"POST",
				enctype:"multipart/form-data",
				url:"/board/writeProc",
				data:formData,
				dataType:"JSON",
	   			processData:false,      // formData를 string으로 변환하지 않음
	   			contentType:false,      // content-type 헤더가 multipart/form-data로 전송
	   			cache:false,
	   			beforeSend:function(xhr){
	   				xhr.setRequestHeader("AJAX", "true");
	   			},
				success:function(res){
					if(res.code == 0){
						alert("게시물이 등록되었습니다! ദ്ദി*ˊᗜˋ*)");
						location.href = "/main";   // 게시물 리스트가 있는 메인 페이지로 이동
					} else if(res.code == 400){
						alert("파라미터 값이 올바르지 않습니다.");
						$("#boardContent").focus();
					} else {
						alert("오류가 발생했습니다..");
						$("#boardContent").focus();
					}
				},
				error:function(xhr, status, error){
					icia.common.error(error);
					alert("게시물 등록 처리 중 오류가 발생했습니다.");
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
                 	<b style="display: block; text-align:center; font-weight: bold;">게시물 작성</b>
                 	<br /><br />
                 	
    <form name="writeForm" id="writeForm" method="post" enctype="multipart/form-data">  
		<input type="file" id="boardFile" name="boardFile" placeholder="파일을 선택하세요." />
        <br /><br />
        <label for="boardContent" style="font-weight:normal; font-weight: bold;">내용</label>
        <textarea id="boardContent" name="boardContent" style="width: 100%; height: 200px; border: 1px solid #ccc; border-radius: 10px; padding: 10px; box-sizing: border-box; overflow-y: auto; 
			font-size:15px; resize: none;" required autocomplete="off">
       		
       </textarea> 
    	<br /><br />
    	<div class="form-group row">
         <div class="col-sm-12">
            <button type="button" id="btnWrite" class="btn btn-primary" title="등록" style="background-color: #5299f7; border:none;">업로드</button>
         </div>
      </div>
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