<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="java.io.PrintWriter, bbs.BbsDAO, bbs.Bbs, java.util.ArrayList"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset="UTF-8">
<meta name="viewport" content="width=device-width" , initial-scale="1">

<title>JSP 게시판 만들기</title>

<!-- jQuery 삽입 -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- 부트스트랩 cdn 삽입 -->
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
	integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u"
	crossorigin="anonymous">
<link rel="stylesheet" href="css/custom.css">
<!-- Optional theme -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap-theme.min.css"
	integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp"
	crossorigin="anonymous">
<!-- Latest compiled and minified JavaScript -->
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js"
	integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
	crossorigin="anonymous"></script>

<style type="text/css">
a, a:hover {
	color: #000000;
	text-decoration: none;
}
</style>
</head>

<body>
	<%
	String userID = null;
	if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}
	int pageNumber = 1; // 페이지번호 기본 1
	if (request.getParameter("pageNumber") != null) { // 파라미터로 페이지 넘버거 넘어오면
		pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
	}
	%>
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false">
				<span class="icon-bar"></span> <span class="icon-bar"></span> <span
					class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="main.jsp">JSP 게시판 만들기</a>
		</div>
		<div class="collapse navbar-collapse"
			id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="main.jsp">메인</a></li>
				<li class="active"><a href="bbs.jsp">게시판</a></li>
			</ul>


			<%
			if (userID == null) { // 로그인이 되어 있지 않은 경우
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="false">접속하기<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="login.jsp">로그인</a></li>
						<li><a href="join.jsp">회원가입</a></li>
					</ul></li>
			</ul>
			<%
			} else {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="false">회원관리<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul></li>
			</ul>
			<%
			}
			%>
		</div>
	</nav>

	<div class="container">
		<table class="table table-striped"
			style="text-align: center; border: 1px solid #dddddd">
			<thead>
				<tr>
					<th style="background-color: #eeeeee; text-align: center;">번호</th>
					<th style="background-color: #eeeeee; text-align: center;">제목</th>
					<th style="background-color: #eeeeee; text-align: center;">작성자</th>
					<th style="background-color: #eeeeee; text-align: center;">작성일</th>
				</tr>
			</thead>
			<tbody>
				<%-- 게시글 출력하는 곳 --%>
				<%
				BbsDAO bbsDAO = new BbsDAO(); // 게시글 가져오기
				ArrayList<Bbs> list = bbsDAO.getList(pageNumber); // 현재 페이지에서 가져온 게시글 목록
				for (int i = 0; i < list.size(); i++) {
				%>
				<tr>
					<td><%=list.get(i).getBbsID()%></td>
					<%--  해당 bbsID를 view 페이지로 보냄 --%>
					<td><a href="view.jsp?bbsID=<%=list.get(i).getBbsID()%>"><%=list.get(i).getBbsTitle()%></a></td>
					<td><%=list.get(i).getUserID()%></td>
					<td><%=list.get(i).getBbsDate().substring(0, 11) + list.get(i).getBbsDate().substring(11, 13) + "시"
		+ list.get(i).getBbsDate().substring(14, 16) + "분"%></td>
				</tr>
				<%
				}
				%>
			</tbody>
		</table>
		<%
		if (pageNumber != 1) {
		%>
		<a href="bbs.jsp?pageNumber=<%=pageNumber - 1%>"
			class="btn btn-success btn-arraw-left">이전</a>
		<%
		}
		if (bbsDAO.nextPage(pageNumber + 1)) {
		%>
		<a href="bbs.jsp?pageNumber=<%=pageNumber + 1%>"
			class="btn btn-success btn-arraw-left">다음</a>
		<%
		}
		%>
		<a href="write.jsp" class="btn btn-primary pull-right">글쓰기</a>
	</div>


</body>
</html>