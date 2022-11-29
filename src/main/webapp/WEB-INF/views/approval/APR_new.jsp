<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/includes/header.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib uri="http://www.springframework.org/security/tags"
   prefix="sec"%>
<!DOCTYPE html>
<html>
<head>
 <!-- <script
   src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"
   integrity="sha384-oBqDVmMz9ATKxIep9tiCxS/Z9fNfEXiDAYTujMAeBAsjFuCZSmKbSSUnQlmh/jp3"
   crossorigin="anonymous"></script>
<script
   src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.min.js"
   integrity="sha384-IDwe1+LCz02ROU9k972gdyvl+AESN10+x7tBKgc9I5HFtuNz0wWnPclzo6p9vxnk"
   crossorigin="anonymous"></script> -->
<link rel="stylesheet" href="/resources/css/approval.css">
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}" />
</head>
<body>
<div class = "container">
<h2>결재문서 작성</h2>
   <form id="insertForm" role="form" action="/approval/new" method="post"> 
          <div class=""></div>
             <div>
                <label>결재 양식</label> 
                   <select name="af_id">
                      <option value="">선택하세요</option>
                      <option value="1">기안서</option>
                      <option value="2">품의서</option>
                      <option value="3">휴가신청서</option>
                   </select>
              </div>     
            
            <!-- 파일 업로드 -->
             <div class="mb-3">
				<label for="formFileSm" class="form-label file">첨부파일</label>
				<input class="form-control form-control-sm" id="formFileSm"
				type="file" name="uploadFile" multiple>
			</div>
			<!-- 첨부파일 업로드 결과 -->
			<div class="uploadResult">
				<ul>
				
				</ul>
			</div>    
                 
                 
                 
                      
             <!-- start /.row (파일 추가) -->      
             <!-- <div class="row">
            <div class="col-lg-12">
                <div class="panel panel-default">
                   <div class="panel-heading"></div>
                        /.panel-heding 
                           <div class="panel-body">
                             <div class="form-group uploadDiv">
                                 <input type="file" name="uploadFile" multiple />
                                </div>
                 <div class="uploadResult"> 
                      <ul>
                
                      </ul>
                 </div>
           
                  </div>
                  end panel body   
             </div>
                end panel body
           </div>
           end panel
         </div>
         /.row -->
         <sec:authentication property="principal" var="pinfo"/>
		<label for="name" class="form-label">작성자</label>
			<input class="form-control" type="text" value='<sec:authentication property="principal.employee.name"/>'
				id="name" readonly>
			<input class="form-control" type="hidden" value='<sec:authentication property="principal.username"/>'
				id="emp_id" name="emp_id">

             <!-- <div >
               <label>작성자</label> 
                  <input class ="form-control" name='emp_id' readonly value="user1" >
             </div> -->
          <div>
            <label>결재명</label> 
               <input class="form-control" name='apr_title'>
          </div>
          
          <div class="form-group">
               <label>결재 내용</label>
                  <textarea class="form-control" rows="3" name='apr_content' ></textarea>
          </div>
          <div>
             <label></label>
                <button id="aprLineBtn" type="button" class="">결재선 추가</button>   
          </div>
          
             <button type="submit" class="btn btn-default">제출하기</button>
             <button id="temporalBtn" type="button" class="btn btn-default">임시저장</button>
             <button id="load" type="button" class="btn btn-default">불러오기</button>
             <a class = "btn btn-default" href="/approval/list" role="button">취소</a>
             
             
             <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        </form>
        
        
        
        <!-- 임시저장 모달 구현 -->
      <!-- Modal -->
         <div class="modal" id="myModal">
           <div class="modal-dialog">
                <div class="modal-content">
                  <div class="modal-header">
                       <h4 class="modal-title" id="myModalLabel">임시저장 목록</h4>
                       </div>
               <div class="modal-body">
                  
               </div>
               <div class="modal-footer">
                  <button type="button" class="close" data-dismiss="modal">닫기</button>
                    <!-- <button id='modalRemoveBtn' type="button" class="btn btn-primary">닫기</button> -->
                  </div>         
                </div>
                <!-- /.modal-content -->
           </div>
           <!-- /.modal-dialog -->
         </div>
         <!-- /.modal -->
        
        
        
        
<script type="text/javascript">
      
        /* * * * * * * * * * * * * * * * * * *
              임시저장 관련
      * * * * * * * * * * * * * * * * * * */
        
        $(document).ready(function(){
           
           //임시저장 버튼 클릭 시 임시저장 db저장하기 
           var form = $('#insertForm')
           var temporalBtn = $("#temporalBtn");
           var csrf_token = $("meta[name='_csrf']").attr("content");
           var csrf_header = $("meta[name='_csrf_header']").attr("content");
           
           temporalBtn.on("click",function(e){
              
              e.preventDefault();
              
               var post = {
                       'af_id': form.find('select[name="af_id"]').val(),
                       'emp_id': form.find('input[name="emp_id"]').val(),
                       'temp_title': form.find('input[name="apr_title"]').val(),
                       'temp_content': form.find('textarea[name="apr_content"]').val(),
                       csrf_token:csrf_token,
                       csrf_header:csrf_header
                     };
               
               $.ajax({
                  url:"/approval/temporory",
                  type:'post',
                  data: JSON.stringify(post),
                  beforeSend : function(xhr){
                      xhr.setRequestHeader(post.csrf_header, post.csrf_token);
                  },
                  contentType: "application/json; charSet=UTF-8",
                  success: function(result){
                     alert("임시저장이 완료되었습니다.");
                     self.location="/approval/list"
                  },error: function(xhr){
                     alert("잘못된 요청입니다.")
                     
                  }
                  
               })
           })
           
           // 임시저장 글 목록 모달창으로 불러오기
           var modal = $(".modal");
           
           $('#load').on('click',function(e){

              e.preventDefault();
              
              $.ajax({
                 url:"/approval/temporory?emp_id=" + form.find('input[name="emp_id"]').val(),
                 type: 'get',
                 success:function(result){
                    console.log(result)
                    
                    var body = $('.modal-body');
                 
                    // 모달 바디 초기화
                    body.empty();
                    // 임시저장 목록(<ul>태그) 반목문으로 출력
                    body.append("<ul>")
                    $.each(result, function(index, item){
                       console.log(item)
                       var str = '<li><a href="/approval/temporory/' +item.temp_id +'" class="tempBtn">' +                    
                        item.temp_title + '</a></li>';
                       body.append(str);
                    })
                    body.append("</ul>")
                 }
              })

             $(".modal").modal("show")

           })
           
            // 임시저장 모달창 닫기 이벤트
          $("#modalCloseBtn").on("click", function(e){
              $('.modal').modal("hide");
          });
           
          $(".close").on("click", function(e){
              $('.modal').modal("hide");
          }); 
          
          //  불러오기 버튼 누르면 임시저장 DB 목록 가져오기
            $(document).on("click", ".tempBtn", function(e) {
               e.preventDefault();
                
               $.ajax({
                  url:$(this).attr('href'),
                  type:'get',
                  success:function(result){
                     console.log(result)
                     form.find('select[name="af_id"]').val(result.af_id)
                       form.find('input[name="emp_id"]').val(result.emp_id)
                       form.find('input[name="apr_title"]').val(result.temp_title)
                       form.find('textarea[name="apr_content"]').val(result.temp_content)
                       alert("불러오기 완료")
                     $('.modal').modal("hide");
                  }
               })
            }); // end of 불러오기 목록 가져오기
            
            
            /* * * * * * * * * * * * * * * * * * *
            		파일 업로드 관련(가져옴)
        	* * * * * * * * * * * * * * * * * * */
        	/* $('#submitBtn').on("click", function(e) {
				e.preventDefault();
				// 업로드 파일 존재 시
				var fileList = [];
				$('.uploadResult ul li').each(function(i, obj) {
					fileList.push({
						uuid: $(obj).data('uuid'),
						file_name: $(obj).data('file_name'),
						file_src: $(obj).data('file_src'),
					});
				}); // end li each
        	}); // end submit click event	 */
        	
        	/* * * * * * * * * * * * * * * * * * *
			첨부파일 업로드
		* * * * * * * * * * * * * * * * * * */
		
		// 첨부파일 확장자, 크기 검증에 쓰이는 변수
		/*var regex = new RegExp("(.*?)\.(exe|zip)$"); // exe, zip 타입인지 확인
		 var maxSize = 5242880; // 5MB 이상인지 확인
		
		// 첨부파일 확장자, 크기를 검증하는 함수
		function checkExtension(fileName, fileSize) {
			
			// 파일 사이즈 검증
			if(fileSize >= maxSize) { //5MB 초과 시 실행
				alert("업로드 가능 최대 크기를 초과하였습니다.");
				return false;
			}
			
			// 파일 확장자 검증
			if (regex.test(fileName)) { // exe, zip 파일의 경우 실행
				alert("업로드 불가능한 파일입니다.");
				return false;
			}
			
			// 위의 검사에 걸리지 않으면 true 리턴
			return true;
		} //end checkExtension()
		
		// 첨부파일 업로드 결과를 출력하는 함수
		function showUploadResult(uploadResultArr) {
			
			// 업로드를 하지 않았거나, 업로드 실패 시 함수 종료
			if(!uploadResultArr || uploadResultArr.length == 0) {
				return;
			}
			
			// 결과물을 출력해야 하는 경우 아래 코드 실행
			var str = "";
			$(uploadResultArr).each(function(i, obj) {
				// 파일 경로와 이름을 저장하는 변수
				var filePath = encodeURIComponent(obj.file_src + "/" + obj.uuid + "_" + obj.file_name);
				
				str += "<li data-uuid='"+ obj.uuid +"' data-file_name='" + obj.file_name + "' ";
				str += "data-file_src='" + obj.file_src + "'>";
				str += obj.file_name;
				str += "<span data-file=\'" + filePath + "\'> [x] </span>";
				str += "</li>";
			});
			
			$('.uploadResult ul').append(str);
			
		} // end showUploadResult()
		
		// 파일 업로드 후 file 태그 내용 초기화를 위해 빈 상태에서 clone
		var cloneObj = $('.uploadDiv').clone();
		
		// 첨부파일 input 태그에 생기는 변화 감지
		$('input[type="file"]').change(function(e){
			// 토큰 정보 받아오기
			var csrf_token = $("meta[name='_csrf']").attr("content");
			var csrf_header = $("meta[name='_csrf_header']").attr("content");
			
			// 파일 전송을 위한 객체 생성
			var formData = new FormData();
			var inputFile = $('input[name="uploadFile"]');
			var files = inputFile[0].files;
			
			// 업로드 파일 개수만큼 객체 생성
			for(let i=0; i<files.length; i++) {
				
				// 파일 확장자가 exe, zip이거나 파일크기가 5MB를 넘으면 false 리턴
				if(!checkExtension(files[i].name, files[i].size)) {
					return false;
				}
				
				// 조건에 맞는 파일인 경우 파일 객체 생성
				formData.append("uploadFile", files[i]);
				
			}// end for
			
			
			// 파일 업로드 Ajax
			$.ajax({
				url: '/approval/uploadFile',
				processData: false,	// 객체를 String으로 변환하지 않도록 설정
				contentType: false,	// Multipart data로 전송되도록 설정
				data: formData,
				beforeSend : function(xhr){ // csrf 토큰 전달
		            xhr.setRequestHeader(csrf_header, csrf_token);
		        },
				type: 'post',
				dataType: 'JSON',
				success: function(result) {
					console.log('file');
					showUploadResult(result);
					$('.uploadDiv').html(cloneObj.html());
				}
			}); // end ajax
			
		}); // end input file - change()
		
		
		// 업로드 파일을 x 버튼으로 삭제
		$('.uploadResult').on("click", "span", function(e) {
			// 토큰 정보 받아오기
			var csrf_token = $("meta[name='_csrf']").attr("content");
			var csrf_header = $("meta[name='_csrf_header']").attr("content");
			
			var fileName = $(this).data("file");
			var selectedLi = $(this).parent("li");
			
			console.log(fileName);
			$.ajax({
				url: '/approval/deleteFile',
				beforeSend : function(xhr){ // csrf 토큰 전달
		            xhr.setRequestHeader(csrf_header, csrf_token);
		        },
		        type: 'delete',
		        data: fileName,
		        dataType: 'text',
				success: function(result) {
					console.log(this);
					// 업로드 파일 삭제 성공 시 li 삭제
					selectedLi.remove();
				},
				error : function(xhr, status, er) {
					console.log(er);
				}
			})
		}); */ // 삭제 버튼 함수
						
            
            
            
            
              
         
    }); // end document ready function
        
        
    
    
    
    
    
    
        /* * * * * * * * * * * * * * * * * * *
             파일 업로드 관련(내가 작성)
         * * * * * * * * * * * * * * * * * * */
       /*  $(document).ready(function(e){
        
           var formObj = $("form[role='form']");
           
           $("button[type='submit']").on("click", function(e){
              
              e.preventDefault();
              console.log("submit clicked");
              
           });
        });
        
        var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
         var maxSize = 5242880; //5MB
      
       function checkExtension(fileName, fileSize){
        
           if(fileSize >= maxSize){
              alert("파일 사이즈 초과");
                return false;
           }
        
           if(regex.test(fileName)){
                alert("해당 종류의 파일은 업로드할 수 없습니다.");
                return false;
           }
        
           return true;
         }
         
       var csrfHeaderName = "${_csrf.headerName}"; 
       var csrfTokenValue = "${_csrf.token}";
      
       
       $("input[type='file']").change(function(e){

           var formData = new FormData();
        
           var inputFile = $("input[name='uploadFile']");
        
           var files = inputFile[0].files;
        
          for(var i=0; i < files.length; i++){

                if(!checkExtension(files[i].name, files[i].size)){
                  return false;
                }
                
                formData.append("uploadFile", files[i]);         
          }
        
          $.ajax({
              url: "/uploadAjaxAction",
                processData: false, 
                contentType: false,
                beforeSend: function(xhr) {
                    xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
                },
                data:formData,
                type: "POST",
                dataType:"json",
               success: function(result){
                  console.log(result); 
                  //showUploadResult(result);
                }
           });  // $.ajax  
         });   */
        
        
        
        
        
        
        /* * * * * * * * * * * * * * * * * * *
             결재선 추가 관련
      * * * * * * * * * * * * * * * * * * */
        
       
        <!-- 결재선 모달 구현 -->
      <!-- Modal -->
         /* <div class="modal" id="myModal">
           <div class="modal-dialog">
                <div class="modal-content">
                  <div class="modal-header">
                       <h4 class="modal-title" id="myModalLabel">결재선 선택</h4>
                       </div>
               <div class="modal-body">
                  
               </div>
               <div class="modal-footer">
                  <button id='modalaprLineBtn' type="button" class="btn btn-primary">선택 완료</button>
                  <button type="button" class="close" data-dismiss="modal">닫기</button>
                  </div>         
                </div>
                <!-- /.modal-content -->
           </div>
           <!-- /.modal-dialog -->
         </div>
         <!-- /.modal --> */
        
        
         
         
         
         
        
        
        
        /* * * * * * * * * * * * * * * * * * *
              입력창 유효성 검사
      * * * * * * * * * * * * * * * * * * */
        
      // 결재양식 ,결재명, 결재내용 미선택 시 멘트 출력
      /* $(function(){
         
         $('.check','.form-control').on('change', function(){
            
            var checkText = "";
            var thisVal = $(this).val();   
            
            switch ($(this).attr("name")) {
               case "af_id":
                  if (thisVal == '선택') {
                     checkText = "결재양식을 선택해주세요.";
                  }
                  break;

               case "apr_title":
                  if (thisVal.lengh == 0) {
                     checkText = "결재명을 작성하세요.";
                  } else if (Space_Check.test(thisVal) == true) {
                     checkText = "공백이 들어갈 수 없습니다.";
                  } else if (thisVal.length > 10) {
                     checkText = "10글자 내로 입력해주세요.";
                  }
                  break;
               case "apr_content":   
                  if (thisVal.lengh == 0) {
                     checkText = "결재 내용을 작성하세요.";
                  } else if (Space_Check.test(thisVal) == true) {
                     checkText = "공백이 들어갈 수 없습니다.";
                  } 
                  break;                  
        
                          
               if(checkText != ""){
                  $(this).siblings("p").html(checkText);
                  $(this).siblings("p").addClass("vali");
                  $(this).siblings("p").slideDown();
               } else {
                  $(this).siblings("p").slideUp(function(){
                  $(this).removeClass("vali");
                     });
                   }
                      });
                      
                      
                  });   
               
                 // 유효성 모두 만족
               if($("check").length == 0) {}            
        
            }
             */
            
         
           
           
   
</script>
        
</div>
</body>
<%@include file="/WEB-INF/views/includes/footer.jsp"%>
</html>