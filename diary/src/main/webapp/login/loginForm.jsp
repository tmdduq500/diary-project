<%@page import="java.net.URLEncoder"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
// 	/* 0. 로그인(인증) 분기 */
	
// 	// [DB] diary.login.my_session -> 'ON'[로그인이 되어있을 경우] -> redirect("diaryListOfMonth.jsp")
	
// 	// DB 연결 및 초기화
// 	Class.forName("org.mariadb.jdbc.Driver");
// 	Connection conn = null;
// 	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3307/diary", "root", "java1234");
	
// 	// mySession 값을 가져오는 SQL 쿼리 실행
// 	String getMySessionSql = "SELECT my_session mySession FROM login";
// 	PreparedStatement getMySessionStmt = null;
// 	ResultSet getMySessionRs = null;
// 	getMySessionStmt = conn.prepareStatement(getMySessionSql);
// 	getMySessionRs = getMySessionStmt.executeQuery();
	
// 	// mySession 값
// 	String mySession = null;
// 	if(getMySessionRs.next()) {
// 		mySession = getMySessionRs.getString("mySession");
// 	}
// 	System.out.println("diaryListOfMonth - mySession = " + mySession);	// mySession 값 확인
	
// 	// mySession이 ON일 경우 -> 이미 로그인이 되어있음 -> diaryListOfMonth.jsp로 이동
// 	if(mySession.equals("ON")) {
// 		response.sendRedirect("/diary/diaryListOfMonth.jsp");
		
// 		// DB 반납
// 		getMySessionRs.close();
// 		getMySessionStmt.close();
// 		conn.close();
		
// 		return ;	// 코드의 진행을 끝 낼때 사용
// 	}
	
	
	/* 0-1) 로그인(인증) 분기 session 사용으로 변경 */

	// 로그인 성공시 세션에 loginMember라는 변수를 만들고 값으로 로그인 아이디를 저장
	String loginMember = (String)(session.getAttribute("loginMember"));
	
	// 사용되는 Session API
	// session.getAttribute(String) : 변수이름으로 변수값을 반환하는 메서도
	// session.getAttribute() 사용해서 찾는 변수가 없다면 null값을 반환
	// null이면 로그아웃 상태, 아니면 로그인 상태
	System.out.println("loginForm - loginMember = " + loginMember);
	
	// loginForm 페이지는 로그아웃 상태에서만 출력되는 페이지
	if(loginMember != null) {
		response.sendRedirect("/diary/diaryListOfMonth.jsp");
		return; // 코드 진행 종료
	}
	
%>

<%

	// 1. 요청값 분석
	String errMsg = request.getParameter("errMsg");
	
// 	// DB 반납
// 	getMySessionRs.close();
// 	getMySessionStmt.close();
// 	conn.close();
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>loginForm</title>
</head>
<body>
	<div>
	<%
		if(errMsg != null) {
	%>
			<%=errMsg%>
	<%
		}
	%>
	</div>
	
	<h1>로그인</h1>
	<form action="/diary/login/loginAction.jsp" method="post">
		id
		<input type="text" name="memberId">
		pw
		<input type="password" name="memberPw">
		
		<button type="submit">로그인</button>
	</form>
</body>
</html>