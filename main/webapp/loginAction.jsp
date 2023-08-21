<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO"%>
<%@ page import="java.io.PrintWriter"%>
<%
request.setCharacterEncoding("UTF-8");
%>

<%-- 로그인할때 입력받은 정보 셋팅 --%>
<jsp:useBean id="user" class="user.User" scope="page" />
<jsp:setProperty name="user" property="userID" />
<jsp:setProperty name="user" property="userPassword" />


<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>JSP 게시판 만들기</title>
</head>
<body>
	<%
	String userID = null;
	if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}
	if (userID != null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('이미 로그인이 되어있습니다.')");
		script.println("location.href = 'main.jsp'");
		script.println("</script>");
	}

	UserDAO userDAO = new UserDAO(); //UserDAO 객체를 만들어서 데이터베이스와 정보교류
	//UserDAO의 login 함수 만들어서 getUserID()와 getUserPassword()를 받아서 result에 저장
	int result = userDAO.login(user.getUserID(), user.getUserPassword());
	if (result == 1) {
		session.setAttribute("userID", user.getUserID()); // 로그인이 성공했을 때 getUserID() 유저아이디를 겟해서 세션값으로 부여
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href = 'main.jsp'"); //로그인 성공이면 main.jsp로 이동
		script.println("</script>");
	} else if (result == 0) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('비밀번호가 틀립니다.')"); //비밀번호가 틀리면 알림창 띄우고 로그인페이지로 돌려보냄
		script.println("history.back()");
		script.println("</script>");
	} else if (result == -1) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('존재하지 않는 아이디입니다.')");
		script.println("history.back()");
		script.println("</script>");
	} else if (result == -2) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('데이터베이스 오류가 발생했습니다.')");
		script.println("history.back()");
		script.println("</script>");
	}
	%>
</body>
</html>