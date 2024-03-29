<%@page import="java.sql.*"%>
<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
// 	/* 로그인(인증) 분기 */
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
%>


<%
	//0. 로그인(인증) 분기
	String loginMember = (String)(session.getAttribute("loginMember"));
	if(loginMember == null) {
		String errMsg = URLEncoder.encode("잘못된 접근 입니다. 로그인 먼저 해주세요", "utf-8");
		response.sendRedirect("/diary/login/loginForm.jsp?errMsg="+errMsg);
		return;
	}

	//DB 연결 및 초기화
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3307/diary", "root", "java1234");
	// 요청 값 분석
	String diaryDate = request.getParameter("diaryDate");
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	
	System.out.println("removeDiaryAction - diaryDate = " + diaryDate);
	System.out.println("removeDiaryAction - memberId = " + memberId);
	System.out.println("removeDiaryAction - memberPw = " + memberPw);
	
	// [DB]diary.member에서 id와 pw 체크
	// id,pw확인하는 쿼리
	String checkIdSql = "SELECT member_id memberId FROM MEMBER WHERE member_id = ? AND member_pw = ?";
	PreparedStatement checkIdStmt = null;
	ResultSet checkIdRs = null;
	
	checkIdStmt = conn.prepareStatement(checkIdSql);
	checkIdStmt.setString(1, memberId);
	checkIdStmt.setString(2, memberPw);
	checkIdRs = checkIdStmt.executeQuery();
	
	if(checkIdRs.next()) {
		// id,pw가 일치한다면
		
		// 일기를 삭제하는 쿼리
		String removeDiarySql = "DELETE FROM diary WHERE diary_date = ?";
		PreparedStatement removeDiaryStmt = null;
		
		removeDiaryStmt = conn.prepareStatement(removeDiarySql);
		removeDiaryStmt.setString(1, diaryDate);
		int row = removeDiaryStmt.executeUpdate();
		System.out.println("removeDiaryAction - row = " + row);
		
		response.sendRedirect("/diary/diaryListOfMonth.jsp");
		
	} else {
		String errMsg = URLEncoder.encode("삭제 실패했습니다. 다시 삭제해주세요", "UTF-8");
		response.sendRedirect("/diary/diaryOne.jsp?diaryDate=" + diaryDate + "&errMsg=" + errMsg);
	}
%>

