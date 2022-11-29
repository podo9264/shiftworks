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

<!--  <script
	src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"
	integrity="sha384-oBqDVmMz9ATKxIep9tiCxS/Z9fNfEXiDAYTujMAeBAsjFuCZSmKbSSUnQlmh/jp3"
	crossorigin="anonymous"></script>
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.min.js"
	integrity="sha384-IDwe1+LCz02ROU9k972gdyvl+AESN10+x7tBKgc9I5HFtuNz0wWnPclzo6p9vxnk"
	crossorigin="anonymous"></script> -->

<meta charset="UTF-8">
</head>
<body>
<div class = "container">
	<h2>전체 결재 문서 목록</h2>
	<a class = "btn btn-default" href="/approval/main" role="button">메인</a>
	<a class = "btn btn-default" href="/approval/new" role="button">결재문서작성</a>
	<a class ="btn btn-default" href="/approval/receivedList" role ="button">결재할 문서함</a>

	<table class="table table-hover" >
		<tr>
			<th>결재 번호</th>
			<th>결재 유형</th>
			<th>작성자</th>
			<th>작성일</th>
			<th>결재명</th>
			<th>결재 내용</th>
			<th>결재 상태</th>
			<th>결재 의견</th>
			<th>결재 날짜</th>
		</tr>

		<c:forEach var="approval" items="${list }">

			<tr>
				<td><c:out value="${approval.apr_id }" /></td>
				<td><c:out value="${approval.af_id }" /></td>
				<td><c:out value="${approval.emp_id }" /></td>
				<td><fmt:formatDate pattern="yyyy-MM-dd"
						value="${approval.apr_receivedate }" /></td>
				<td><a class='move' href='<c:out value ="${approval.apr_id}"/>'>
						<c:out value="${approval.apr_title}" />
				</a></td>
				<td><c:out value="${approval.apr_content }" /></td>
				<td><c:out value="${approval.apr_status }" /></td>
				<td><c:out value="${approval.apr_comment }" /></td>
				<td><fmt:formatDate pattern="yyyy-MM-dd"
						value="${approval.apr_signdate }" /></td>
			</tr>
		</c:forEach>
	</table>
	

	<!-- 페이징 처리 뷰-->
	<nav aria-label="Page navigation">
		<ul class="pagination justify-content-center">
			<c:if test="${pageMaker.prev}">
		 		<li class="page-item">
		 			<a class="page-link" href="${pageMaker.startPage -1}" aria-label="Previous">
		 					<span aria-hidden="true">&laquo;</span> 
						</a>						
							</li>
								</c:if>
			<c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
				<li class="page-item"  ${pageMaker.cri.pageNum == num ? "active":""} ">
					<a class = "page-link" href="${num}">${num}</a>
							</li>
								</c:forEach>
			<c:if test="${pageMaker.next}">
				<li class="page-item">
					<a class = "page-link" href="${pageMaker.endPage +1 }" aria-label="Next">
						<span aria-hidden="true">&raquo;</span>
     				 		</a>
								</li>
									</c:if>
		</ul>
	</nav>
	<!--  end Pagination -->

	<form id='actionForm' action='/approval/list' method='get'>
		<input type='hidden' name='pageNum' value='${pageMaker.cri.pageNum}'>
		<input type='hidden' name='amount' value='${pageMaker.cri.amount}'>
		
	</form>



	<script type="text/javascript">
		var actionForm = $("#actionForm");

		$(".page-item a").on(
				"click",
				function(e) {
					e.preventDefault();
					console.log('click');
					$("#actionForm").find("input[name='pageNum']").val(
							$(this).attr("href"));
					$("#actionForm").submit();
				});

		// 결재 상세 내역 보기(결제명 누르면 상세보기)
		$(".move").on(
				"click",
				function(e) {
					e.preventDefault();
					actionForm.append("<input type='hidden' name='apr_id' value='"
							+ $(this).attr("href") + "'>");
					actionForm.attr("action", "/approval/" + + $(this).attr("href"));
					actionForm.submit();
				});
	</script>
</div>
</body>
<%@include file="/WEB-INF/views/includes/footer.jsp"%>
</html>