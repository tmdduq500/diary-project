<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
// 	/*
// 		로그아웃 -> [DB]diary.login.my_session -> 'OFF'으로 변경 해야한다. & loginForm으로 redirect해줘야 함.
// 	*/

// 	// 로그인(인증) 분기
// 	// [DB] diary.login.my_session -> 'OFF'[로그아웃이 되어있을 경우] -> redirect("loginForm.jsp")
	
// 	// DB 연결 및 초기화
// 	Class.forName("org.mariadb.jdbc.Driver");
// 	Connection conn = null;
// 	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3307/diary", "root", "java1234");
	
// 	// mySession 값을 가져오는 SQL 쿼리 실행
// 	String getMySessionSql = "SELECT my_session AS mySession FROM login";
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
	
// 	// mySession이 OFF일 경우(로그아웃 상태)
// 	if(mySession.equals("OFF")) {
// 		String errMsg = URLEncoder.encode("잘못된 접근입니다. 로그인 먼저 해주세요.", "UTF-8");
// 		response.sendRedirect("/diary/login/loginForm.jsp?errMsg=" + errMsg);
		
// 		// DB 반납
// 		getMySessionRs.close();
// 		getMySessionStmt.close();
// 		conn.close();
		
// 		return ;	// 코드의 진행을 끝 낼때 사용
// 	}
	
// 	// my_session 값을 OFF로 바꾸는 SQL 쿼리	
// 	String logoutMySessionSql = "UPDATE login SET my_session = 'OFF', off_date = NOW() WHERE my_session = 'ON'";
// 	PreparedStatement logoutMySessionStmt = null;
// 	logoutMySessionStmt = conn.prepareStatement(logoutMySessionSql);
	
// 	int row = logoutMySessionStmt.executeUpdate();
// 	System.out.println("logoutMySessionStmt - row = " + row);
	
// 	response.sendRedirect("/diary/login/loginForm.jsp");




	// session.removeAttribute("loginMember");
	
	session.invalidate(); // 세션 공간 초기화(포맷)
	
	response.sendRedirect("/diary/login/loginForm.jsp");
%>