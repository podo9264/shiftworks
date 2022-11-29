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
<link rel="stylesheet" href="/resources/css/approval.css">
<meta charset="UTF-8">
<title>전자결재 메인</title>
</head>
<body>
			<div class="container">
			  <div class="row">
			    <div class="col">결재문서작성
			    	<div class="list-group list-group-flush">
			    		  	<a href="/approval/new" class="list-group-item ">기안서 작성	</a>		    		  	
			    		  	<a href="/approval/new" class="list-group-item ">품의서 작성</a>
			    		  	<a href="/approval/new" class="list-group-item ">휴가신청서 작성</a>
			    		  	<a id="load" href="/approval/temporory" class="list-group-item ">임시저장 목록 불러오기</a>
			    	</div>
			    </div>
			    <!-- end of 결재문서작성  -->
			    
			    <div class="col">
				    <ul class="list-group">				    	
	  					<li class="list-group-item d-flex justify-content-between align-items-center">   					 
	   					 		<a id = "mainAprList" href="/approval/receivedList">결재가 필요한 문서</a>
	    					<span class="badge bg-primary rounded-pill">14</span>
	  					</li>
	  					<li class="list-group-item d-flex justify-content-between align-items-center">
	    						결재 중인 문서
	    					<span class="badge bg-primary rounded-pill">2</span>
	 					</li>
	  					<li class="list-group-item d-flex justify-content-between align-items-center">
	  						 	반려된 문서
	    					<span class="badge bg-primary rounded-pill">1</span>
	 					</li>
					</ul>			    
			    </div>
			    <!-- end of 결재 상태 세부 목록 뷰 -->  			
			  </div>
			  <!-- end of  main 가로 전체 -->
			  
			  <div class="row" id ="row2">
			    <div class="col">결재할 문서
			    	<div class="list-group">
			    		<!-- approval 뒤의 apr_id 불러오는 형태로 수정 필요 -->
	  					<a href="/approval/1" class="list-group-item" aria-current="true">
	   						 <div class="d-flex w-100 justify-content-between">
	     						 <h5 class="mb-1" >휴가 신청서</h5>
	     							 <small>대기중</small>
	   				 		</div>
	    						<p class="mb-1">회계팀 김ㅇㅇ 대리</p>
	    							<small>상기 본인은 11월 11일부터 11월 14일까지 휴가를 신청합니다.</small>
	 					</a>
 					</div>	
 					 <!-- end of list-group -->		    			    
			    </div>
			    <!-- end of row / 결재할 문서 디테일 뷰 -->
			    
			<!--  <div class = "row"> -->
			 <div class="col-sm" id ="row2">
				<lable>내가 작성한 결재 목록</lable>
			    <table class="table"> 
				 	 
				    	<tr>
					      <th scope="col">결재 번호</th>
					      <th scope="col">결재 유형</th>
					      <th scope="col">결재 제목</th>
					      <th scope="col">결재 상태</th>
				   		</tr>
				  
				  
				  		<c:forEach var="approval" items="${list }">

						<tr>
							<td><c:out value="${approval.apr_id }" /></td>
							<td><c:out value="${approval.af_id }" /></td>
							<td><a class='move' href='<c:out value ="${approval.apr_id}"/>'>
									<c:out value="${approval.apr_title}" />
							</a></td>
							<td><c:out value="${approval.apr_status }" /></td>
						</tr>
					</c:forEach>
				  	
				  	
				  	
				    	<!-- <tr>
				      		<th scope="row">1</th>
				     		<td>Mark</td>
				      		<td>Otto</td>
				      		<td>@mdo</td>
				    	</tr>
				    	<tr>
				      		<th scope="row">2</th>
				      		<td>Jacob</td>
				      		<td>Thornton</td>
				     	 	<td>@fat</td>
				   	 	</tr>
				   		 <tr>
				      		<th scope="row">3</th>
				      		<td colspan="2">Larry the Bird</td>
				      		<td>@twitter</td>
				   		 </tr> -->
				  	
					</table>
					</div>
					<!-- end of col-sm -->
			   	 </div> 
			    <!-- end of table -->
			    
			    <!-- 결재진행상태 구현 뷰 -->
			    <!-- <div class="col">
			    	<label for="customRange3" class="form-label">결재 진행 상태</label>
						<input type="range" class="form-range" min="0" max="5" step="0.5" id="customRange3">
			    </div>
			  </div>
			</div>  -->
			
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


<script>

	
	/* * * * * * * * * * * * * * * * * * *
		임시저장 불러오기 관련
	* * * * * * * * * * * * * * * * * * */

	// 로그인한 id에 일치하는 임시저장 목록 모달창으로 열기
	$(document).ready(function(){
		var modal = $(".modal");
        
        $('#load').on('click',function(e){

           e.preventDefault();
           
           $.ajax({
              url:"/approval/temporory?emp_id=user1", //emp_id 추후 수정
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
	})
</script>	
</body>
<%@include file="/WEB-INF/views/includes/footer.jsp"%>
</html>