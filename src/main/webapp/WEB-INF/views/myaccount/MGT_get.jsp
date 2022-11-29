<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>
<%@include file="/WEB-INF/views/includes/header.jsp"%>
<html>
<link rel="stylesheet" href="/resources/css/employee.css">
<body>
	<div class="container">
		<div class="row">
			<div class="col-lg-12">
				<h1 class="page-header">Account detail page</h1>
			</div>
			<!-- /.col-lg-12 -->
		</div>
		<!-- /.row -->

		<div class="row">
			<div class="col-lg-12">
				<div class="panel panel-default">

					<div class="panel-heading">계정 상세 정보</div>
					<!-- /.panel-heading -->
					<div class="panel-body">


						<div class="form-group">
							<label>사번</label> <input class="form-control" name='emp_id'
								value='<c:out value="${employee.emp_id }"/>' readonly="readonly">
						</div>

						<div class="form-group">
							<label>부서번호</label> <input class="form-control" name='dept_id'
								value='<c:out value="${employee.dept_id }"/>'
								readonly="readonly">
						</div>
						<div class="form-group">
							<label>직급</label> <input class="form-control" name='position'
								value='<c:out value="${employee.position }"/>'
								readonly="readonly">
						</div>
						<div class="form-group">
							<label>이름</label> <input class="form-control" name='name'
								value='<c:out value="${employee.name }"/>' readonly="readonly">
						</div>
						<div class="form-group">
							<label>생년월일</label> <input class="form-control" name='birthday'
								value='<c:out value="${employee.birthday }"/>'
								readonly="readonly">
						</div>
						<div class="form-group">
							<label>모바일</label> <input class="form-control" name='mobile'
								value='<c:out value="${employee.mobile }"/>' readonly="readonly">
						</div>
						<div class="form-group">
							<label>사내망</label> <input class="form-control" name='internal'
								value='<c:out value="${employee.internal }"/>'
								readonly="readonly">
						</div>
						<div class="form-group">
							<label>이메일</label> <input class="form-control" name='email'
								value='<c:out value="${employee.email }"/>' readonly="readonly">
						</div>
						<div class="form-group">
							<label>주소</label> <input class="form-control" name='address'
								value='<c:out value="${employee.address }"/>'
								readonly="readonly">
						</div>
						<div class="form-group">
							<label>입사일</label> <input class="form-control" name='entry_date'
								value='<c:out value="${employee.entry_date }"/>'
								readonly="readonly">
						</div>




						<sec:authentication property="principal" var="pinfo" />
						<sec:authorize access="isAuthenticated()">
							<c:if test="${pinfo.username eq employee.emp_id}">
								<button type="submit" data-oper='modify' class="btn btn-default">수정</button>
							</c:if>
						</sec:authorize>


						<button data-oper='list' class="btn btn-default">목록</button>




					</div>
					<!--  end panel-body -->

				</div>
				<!--  end panel-body -->
			</div>
			<!-- end panel -->
		</div>
		</div>
		<!-- /.row -->
		<script type="text/javascript">
			$(document).ready(function() {

				var operForm = $("#operForm");
				$("button[data-oper='modify']").on("click", function(e) {
					operForm.attr("action", "/myaccount/info/change").submit();

				});

			});
		</script>



		<!-- ./ end row -->
</body>
</html>



<%@include file="/WEB-INF/views/includes/footer.jsp"%>
