<%@page import="java.net.URLEncoder"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	/* 로그인(인증) 분기 */
	// [DB] diary.login.my_session -> 'OFF'[로그아웃이 되어있을 경우] -> redirect("loginForm.jsp")
	
	// DB 연결 및 초기화
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3307/diary", "root", "java1234");
	
	// mySession 값을 가져오는 SQL 쿼리 실행
	String getMySessionSql = "SELECT my_session AS mySession FROM login";
	PreparedStatement getMySessionStmt = null;
	ResultSet getMySessionRs = null;
	getMySessionStmt = conn.prepareStatement(getMySessionSql);
	getMySessionRs = getMySessionStmt.executeQuery();
	
	// mySession 값
	String mySession = null;
	if(getMySessionRs.next()) {
		mySession = getMySessionRs.getString("mySession");
	}
	System.out.println("diaryListOfMonth - mySession = " + mySession);	// mySession 값 확인
	
	// mySession이 OFF일 경우(로그아웃 상태)
	if(mySession.equals("OFF")) {
		String errMsg = URLEncoder.encode("잘못된 접근입니다. 로그인 먼저 해주세요.", "UTF-8");
		response.sendRedirect("/diary/login/loginForm.jsp?errMsg=" + errMsg);
		
		// DB 반납
		getMySessionRs.close();
		getMySessionStmt.close();
		conn.close();
		
		return ;	// 코드의 진행을 끝 낼때 사용
	}
%>

<%
	// 요청 값 분석
	String lunchDate = request.getParameter("lunchDate");

	if(lunchDate == null) {
		response.sendRedirect("/diary/diaryListOfMonth.jsp");
		return;
	}

	String menu = request.getParameter("menu");
	if(menu == null) {
		response.sendRedirect("/diary/lunch/lunchOne.jsp?lunchDate=" + lunchDate);
		return;
	}
	//[DB]diary.lunch에 입력하는 sql
	
	String setLunchSql = "INSERT INTO lunch(lunch_date,menu,create_date,update_date) VALUES(?, ?, NOW(), NOW())";
	PreparedStatement setLunchStmt = null;
	ResultSet setLunchRs = null;
	
	setLunchStmt = conn.prepareStatement(setLunchSql);
	setLunchStmt.setString(1, lunchDate);
	setLunchStmt.setString(2, menu);
	
	int row = setLunchStmt.executeUpdate();
	System.out.println("lunchAddAction - lunchDate = " + lunchDate);
	System.out.println("lunchAddAction - row = " + row);
	
	if(row == 1) {
		response.sendRedirect("/diary/lunch/lunchOne.jsp?lunchDate=" + lunchDate);
		return;
	} else {
		response.sendRedirect("/diary/lunch/lunchOne.jsp?lunchDate=" + lunchDate);
		return;
	}

%>