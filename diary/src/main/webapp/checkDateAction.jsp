<%@page import="java.sql.*"%>
<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//로그인(인증) 분기
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

	// diary테이블에 날짜가 이미 존재하는지 확인하기 -> 존재하지 않아야 글쓰기 가능
	// 요청 값 분석
	String checkDate = request.getParameter("checkDate");
	if(checkDate == null) {
		checkDate = "";
	}
	
	System.out.println("checkDateAction - checkDate = " + checkDate);	// checkDate 값 확인
	
	String checkDateSql = "SELECT diary_date diaryDate from diary where diary_date = ?";
	PreparedStatement checkDateStmt = conn.prepareStatement(checkDateSql);
	checkDateStmt.setString(1, checkDate);
	ResultSet checkDateRs = checkDateStmt.executeQuery();
		
	if(checkDateRs.next()) {
		// 해당 날짜는 일기 작성 불가능(이미 해당 날짜의 일기 존재함)
		response.sendRedirect("/diary/add/addDiaryForm.jsp?checkDate=" + checkDate + "&write=N");
	} else {
		// 아무 날짜도 선택하지 않고 날짜 가능 확인 버튼을 눌렀을 때 작성 불가능
		if(checkDate.equals("")) {
			response.sendRedirect("/diary/add/addDiaryForm.jsp?checkDate=" + checkDate + "&write=N");
		} else {
			// 해당 날짜는 일기 기록 가능
			response.sendRedirect("/diary/add/addDiaryForm.jsp?checkDate=" + checkDate + "&write=Y");
		}
	}
%>