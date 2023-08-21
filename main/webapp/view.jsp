<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="java.io.PrintWriter, bbs.Bbs, bbs.BbsDAO"%>
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
<!-- Optional theme -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap-theme.min.css"
	integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp"
	crossorigin="anonymous">
	<link rel="stylesheet" href="css/custom.css">
<!-- Latest compiled and minified JavaScript -->
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js"
	integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
	crossorigin="anonymous"></script>
</head>

<body>
	<%
	String userID = null;
	if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID"); //로그인한 사람들은 해당아이디가 userID에 저장
	}

	int bbsID = 0;
	if (request.getParameter("bbsID") != null) {
		bbsID = Integer.parseInt(request.getParameter("bbsID"));//게시글 번호 받아오기
	}
	if (bbsID == 0) {//번호가 반드시 존재하는지 확인
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('유효하지 않은 글입니다.')");
		script.println("location.href = 'bbs.jsp'"); // 다시 게시글 페이지로 이동
		script.println("</script>");
	}
	Bbs bbs = new BbsDAO().getBbs(bbsID); // 유효한 글이라면 구체적인 정보를 bbs에 담음
	%>


	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false">
				<span class="icon-bar"></span> <span class="icon-bar"></span> <span
					class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="main.jsp">JSP 게시판 웹 사이트</a>
		</div>
		<div class="collapse navbar-collapse"
			id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="main.jsp">메인</a></li>
				<!-- 현재 페이지가 메인임을 알려줌 -->
				<li class="active"><a href="bbs.jsp">게시판</a></li>
			</ul>

			<%
			// 로그인이 되어있지 않은 사람들만 로그인 회원가입 보이게
			if (userID == null) {
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
			//로그인이 되어있다면
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
	<!-- 여기까지 상단 nav -->



	<!-- 테이블 -->
	<div class="container">
		<div class="row">

			<table class="table table-striped"
				style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<!-- 테이블의 행, 한줄 -->
						<th colspan="3"
							style="background-color: #eeeeee; text-align: center;">게시판
							글보기</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style="width: 20%;">글 제목</td>
						<td colspan="2"><%=bbs.getBbsTitle().replaceAll(" ", "&nbsp;")
		.replaceAll("                                                                                  <", "&lt;")
		.replaceAll(">", "&gt;").replaceAll("\n", "<br>;")%>
						</td>
					</tr>
					<tr>
						<td>작성자</td>
						<td colspan="2"><%=bbs.getUserID()%></td>
					</tr>
					<tr>
						<td>작성일자</td>
						<td colspan="2"><%=bbs.getBbsDate().substring(0, 11) + bbs.getBbsDate().substring(11, 13) + "시"
		+ bbs.getBbsDate().substring(14, 16) + "분"%></td>
					</tr>
					<tr>
						<td>내용</td>
						<!-- 특수문자 변경 -->
						<td colspan="2" style="height: 350px; text-align: left;">
							<%=bbs.getBbsContent().replaceAll(" ", "&nbsp;")
		.replaceAll("<", "&lt;")
		.replaceAll(">", "&gt;").replaceAll("\n", "<br>;")%>
						</td>
					</tr>
				</tbody>
			</table>
			<a href="bbs.jsp" class="btn btn-primary">목록</a>

			<!-- 게시판 목록으로 돌아가는 버튼 -->
			<%
			if (userID != null && userID.equals(bbs.getUserID())) { //해당글의 작성자가 본인이라면 수정버튼 보임
			%>
			<!-- 수정버튼을 누르면 수정 가능하게끔 -->
			<a href="update.jsp?bbsID=<%=bbsID%>" class="btn btn-primary">수정</a>
			<a onclick="return confirm('삭제하시겠습니까?')" href="deleteAction.jsp?bbsID=<%=bbsID%>" class="btn btn-primary">삭제</a>
			<%
			}
			%>

		</div>

	</div>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>