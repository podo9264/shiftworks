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
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}" />
<title>결재문서 상세보기</title>
</head>
<body>
<div class = "container">
<h2>결재 문서 상세보기</h2>
   <a class = "btn btn-default" href="/approval/list">결재문서 내역</a>
            <div class="form-group">
               <label>결재번호</label> <input class="form-control" name='apr_id'
                  value='<c:out value="${approval.apr_id }"/>' readonly="readonly">
            </div>
            <div class="form-group">
               <label>작성 일자</label> <input class="form-control" name='apr_receivedate'
                  value='<fmt:formatDate pattern="yyyy-MM-dd" 
                   value="${approval.apr_receivedate }"/>' readonly="readonly">
            </div>                        
            <div class="form-group">
               <label>결재 유형</label> <input class="form-control" name='af_id'
                  value='<c:out value="${approval.af_id }"/>' readonly="readonly">
            </div>
            <div class="form-group">
               <label>결재 상태</label> <input class="form-control" name='apr_status'
                  value='<c:out value="${approval.apr_status }" />' readonly="readonly">
            </div>            

            <div class="form-group">
               <label>결재명</label> <input class="form-control" name='apr_title'
                  value='<c:out value="${approval.apr_title }"/>' readonly="readonly">
            </div>
            <div class="form-group">
               <label for="formFileSm" class="form-label file">첨부파일</label>
				<input class="form-control form-control-sm" id="formFileSm" type="file" readonly>
				<ul class="approvalFiles">
					<c:forEach items="${ approval.fileList }" var="f">
						<li data-uuid="${ f.uuid }" data-file_name="${ f.file_name }"
							data-file_src="${ f.file_src }">
							<a><c:out value="${ f.file_name }"/></a>
					</li>
				</c:forEach>
			</ul>
            </div>
            <div class="form-group">
               <label>작성자</label> <input class="form-control" name='emp_id'
                  value='<c:out value="${approval.emp_id }"/>' readonly="readonly">
            </div>
            <div class="form-group">
               <label>결재 내용</label>
               <textarea class="form-control" rows="3" name='apr_content'
                  readonly="readonly"><c:out value="${approval.apr_content}" /></textarea>
            </div>
            
            
            <button id = 'aprHandleBtn' data-oper='' class="btn btn-outline-secondary">결재 처리</button>
            <a class = "btn btn-outline-secondary" href="/approval/list">취소</a>
            
            <!-- 결재 처리 모달 구현 -->
            <div class="modal fade" id="myModal" tabindex="-1" role="dialog"
                 aria-labelledby="myModalLabel" aria-hidden="true">
              <div class="modal-dialog">
                <div class="modal-content">
                  <div class="modal-header">
                  <button type="button" class="close" data-dismiss="modal"
                  aria-hidden="true">&times;</button>
                    <h4 class="modal-title" id="myModalLabel">결재 의견 입력</h4>
                  </div>
                  <div class="modal-body">
                    <div class="form-group">
                      <label>결재 의견</label>
                      <textarea id="apr_comment" class="form-control" rows="3" name='apr_content'></textarea>
                    </div>
            
                  </div>
                  <div class="modal-footer">
                    <button id ='signBtn' data-oper='1' class="btn btn-default update-status">승인</button>
                  <button id = 'rejectBtn' data-oper='2' class="btn btn-default update-status">반려</button>
                  <button id = 'modalCloseBtn' data-oper='' class="btn btn-default">취소</button>
                  </div>  
                          
                 </div>
                <!-- /.modal-content -->
              </div>
              <!-- /.modal-dialog -->
            </div>
            <!-- /.modal -->
            
            
            
                        
            <script type="text/javascript">
            
             
             $(document).ready(function () {
                
                var csrf_token = $("meta[name='_csrf']").attr("content");
                var csrf_header = $("meta[name='_csrf_header']").attr("content");
               
               // 승인, 반려 버튼 선택 시 결재 문서 상태 변경하고 전체 문서 리스트로 이동
               $(".update-status").on("click",function(e){
                  e.preventDefault();
                  var status = $(this).data('oper');
                  var approval = {'apr_comment': $('#apr_comment').val(),
                              'apr_status' : status+"",
                               csrf_token:csrf_token,
                                  csrf_header:csrf_header}
                  
                  
                  $.ajax({
                     url: "/approval/sign/" + ${approval.apr_id },
                     type: 'put',
                     data: JSON.stringify(approval),
                     contentType:"application/json; charset=UTF-8",
                     beforeSend : function(xhr){
                            xhr.setRequestHeader(approval.csrf_header, approval.csrf_token);
                        },
                     success: function(data){
                        alert("처리가 완료되었습니다.");
                        self.location="/approval/list"
                     },error: function(err){
                        alert("잘못된 요청입니다.")
                     }
                  })
               });
                
               var modal = $(".modal");
                $("#aprHandleBtn").on("click", function (e) {
                    modal.find("input").val("");
                    $(".modal").modal("show")
                  });
                
                  // 모달창 닫기 이벤트
                $("#modalCloseBtn").on("click", function(e){
                    $('.modal').modal("hide");
                });
                $(".close").on("click", function(e){
                    $('.modal').modal("hide");
                }); 
                
                // end onclick event
                
                // 첨부파일 클릭 시 다운로드/삭제할 수 있도록 하는 url
			/* $('.approvalFiles li').each(function(i, obj){
				var file = {
						uuid: $(obj).data('uuid'),
						file_name: $(obj).data('file_name'),
						file_src: $(obj).data('file_src'),
					};
				var filePath = encodeURIComponent(file.file_src + "/" + file.uuid + "_" + file.file_name);
				$(obj).attr("class", "file");
				$(obj).children('a').attr("href", "/approval/download?fileName=" + filePath);
				$(obj).append("<span class='fileDelete' data-file=\'" + filePath + "\'> [x] </span>");
				$('.fileDelete').hide();
			}); // end li each
			
			
			// 업로드 파일을 x 버튼으로 삭제
			$('.approvalFiles').on("click", "span", function(e) {
				// 토큰 정보 받아오기
				var csrf_token = $("meta[name='_csrf']").attr("content");
				var csrf_header = $("meta[name='_csrf_header']").attr("content");
				
				var fileName = $(this).data("file");
				var selectedLi = $(this).parent("li");
				var uuid = selectedLi.data("uuid");
				
				console.log(fileName);
				$.ajax({
					url: '/approval/deleteFile',
					beforeSend : function(xhr){ // csrf 토큰 전달
		                xhr.setRequestHeader(csrf_header, csrf_token);
		            },
		            type: 'delete',
		            data: {file_name: fileName,
		            		uuid: uuid},
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
			});  */// 삭제 버튼 함수
                
                

             })// end of document ready function
             

            
             
                   
            
            
            </script>
</div>            
</body>
<%@include file="/WEB-INF/views/includes/footer.jsp"%>
</html>