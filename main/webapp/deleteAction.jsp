<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDAO"%>
<%@ page import="bbs.Bbs"%>
<%@ page import="java.io.PrintWriter"%>
<%
request.setCharacterEncoding("UTF-8");
%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%
	String userID = null;
	if (session.getAttribute("userID") != null) { //user가 접속이 되어있다면 세션값이 할당되어 있다면
		userID = (String) session.getAttribute("userID");
	}
	if (userID == null) { //로그인 안되있으면 로그인하라고 안내
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 하세요.')");
		script.println("location.href = 'login.jsp'");
		script.println("</script>");
	}

	//글을 수정할 권한이 있는지 확인
	int bbsID = 0; // 게시글 번호
	if (request.getParameter("bbsID") != null) {
		bbsID = Integer.parseInt(request.getParameter("bbsID"));//게시글 번호 받아오기
	}
	if (bbsID == 0) {//게시글이 존재하지 않는 다는 얘기
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('유효하지 않은 글입니다.')");
		script.println("location.href = 'bbs.jsp'"); // 다시 게시글 페이지로 이동
		script.println("</script>");
	}

	//현재 작성한 글이 작성한 본인이 한건지 확인, 수정권한 확인
	Bbs bbs = new BbsDAO().getBbs(bbsID);
	if (!userID.equals(bbs.getUserID())) { // !userID세션값과 bbs.getUserID 작성한사람 동일한지
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('권한이 업습니다.')");
		script.println("location.href = 'bbs.jsp'"); // 다시 게시글 페이지로 이동
		script.println("</script>");
	} else {
		BbsDAO bbsDAO = new BbsDAO(); //데이터 베이스에 접근 가능한 객체생성
		int result = bbsDAO.delete(bbsID);
		if (result == -1) { // -1일 경우 데이터베이스 오류
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('글삭제에 실패했습니다.')");
			script.println("history.back()");
			script.println("</script>");
		} else { // 삭제성공
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("location.href = 'bbs.jsp'");
			script.println("</script>");
		}
	}
	%>
</body>
</html>