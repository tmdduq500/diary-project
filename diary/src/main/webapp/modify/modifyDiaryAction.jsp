<%@page import="java.net.URLEncoder"%>
<%@page import="java.sql.*"%>
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
	// 요청 값 분석
	String diaryDate = request.getParameter("diaryDate");
	String title = request.getParameter("title");
	String memberPw = request.getParameter("memberPw");
	String weather = request.getParameter("weather");
	String content = request.getParameter("content");
	
	// 요청 값 체크
	System.out.println("modifyDiaryAction - diaryDate = " + diaryDate);	
	System.out.println("modifyDiaryAction - title = " + title);
	System.out.println("modifyDiaryAction - memberPw = " + memberPw);
	System.out.println("modifyDiaryAction - weather = " + weather);
	System.out.println("modifyDiaryAction - content = " + content);
	
	// pw가 맞는지 확인
	String checkPwSql = "SELECT member_id memberId FROM MEMBER WHERE member_pw = ?";
	PreparedStatement checkPwStmt = null;
	ResultSet checkPwRs = null;
	
	checkPwStmt = conn.prepareStatement(checkPwSql);
	checkPwStmt.setString(1, memberPw);
	checkPwRs = checkPwStmt.executeQuery();
	
	// 일기 UPDATE 할지말지 분기
	if(checkPwRs.next()) {
		//pw가 맞다면
		
		// [DB]diary.diary에 UPDATE 쿼리 실행
		String modifyDiarySql = "UPDATE diary SET title = ?, weather = ?, content = ?, update_date = NOW() WHERE diary_date = ?";
		PreparedStatement modifyDiaryStmt = null;
		modifyDiaryStmt = conn.prepareStatement(modifyDiarySql);
		modifyDiaryStmt.setString(1, title);
		modifyDiaryStmt.setString(2, weather);
		modifyDiaryStmt.setString(3, content);
		modifyDiaryStmt.setString(4, diaryDate);
		
		int row = modifyDiaryStmt.executeUpdate();
		System.out.println("modifyDiaryAction - row = " + row);
		
		response.sendRedirect("/diary/diaryOne.jsp?diaryDate=" + diaryDate);
		
	} else {
		String errMsg = URLEncoder.encode("수정 실패했습니다. 다시 수정해주세요", "UTF-8");
		response.sendRedirect("/diary/diaryOne.jsp?diaryDate=" + diaryDate + "&errMsg=" + errMsg);
		
	}
	
	// DB 반납
	conn.close();
	
%>