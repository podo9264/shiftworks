<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
 <%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>
	<%@include file="/WEB-INF/views/includes/header.jsp"%>
<html>

<head></head>
<body>

	<div class="container">
	<div class="row">
		<div class="col-lg-12">
			<h1 class="page-header">사원 등록</h1>
		</div>
		<!-- /.col-lg-12 -->
	</div>
	<!-- /.row -->

	<div class="row">
		<div class="col-lg-12">
			<div class="panel panel-default">

				<div class="panel-heading">계정 등록</div>
				<!-- /.panel-heading -->
				<div class="panel-body">

				<form role="form" action="/manager/new" method="post">
					<input type="hidden" name="${_csrf.parameterName}"
						value="${_csrf.token}" />
					<div class="form-group">
						<label>이름</label> <input class="form-control" name='name'>
					</div>
					<div class="form-group">
						<label>입사일</label> <input class="form-control" name='entry_date'>
					</div>
					<div class="form-group">
					<label>사번</label> <input class="form-control" name='emp_id'>
				</div>
				<div class="form-group">
					<label>부서번호</label> <input class="form-control" name='dept_id'>
				</div>
				<div class="form-group">
					<label>비밀번호</label> <input class="form-control" name='password'>
				</div>
				<div class="form-group">
					<label>직급</label> <input class="form-control" name='position'>
				</div>
				<div class="form-group">
					<label>생년월일</label> <input class="form-control" name='birthday'>
				</div>
				<div class="form-group">
					<label>주소</label> <input class="form-control" name='address'>
				</div>
				<div class="form-group">
					<label>모바일</label> <input class="form-control" name='mobile'>
				</div>
				<div class="form-group">
					<label>사내망 번호</label> <input class="form-control" name='internal'>
				</div>
				<div class="form-group">
					<label>이메일</label> <input class="form-control" name='email'>
			 </div>


					<!--  <div class="form-group">
            <label>Text area</label>
            <textarea class="form-control" rows="3" name='content'></textarea>
          </div> -->

					<button type="submit" class="btn btn-default">등록</button>
					<button type="reset" class="btn btn-default">초기화</button>
					
				</form>
			</div>
				<!--  end panel-body -->

			</div>
			<!--  end panel-body -->
		</div>
		<!-- end panel -->
	</div>
	<!-- /.row -->
	
	<script>
/* 
$(document).ready(function(e){

	var formObj = $("form[role='form']");
  
  	$("button[type='submit']").on("click", function(e){
    
    	e.preventDefault();
    
    	console.log("submit clicked");
    
    	formObj.append.submit();    
  });

});
 */
</script>
</div>
</body>
</html>

<%@include file="/WEB-INF/views/includes/footer.jsp"%>
