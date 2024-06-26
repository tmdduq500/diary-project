<%@page import="java.sql.*"%>
<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
// 	/* 0. 로그인(인증) 분기 */
	
// 	// [DB] diary.login.my_session -> 'ON'(로그인이 되어있을 경우) -> redirect("diaryListOfMonth.jsp")
	
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


	// 0. 로그인(인증) 분기
	String loginMember = (String)(session.getAttribute("loginMember"));
	System.out.println("loginAction - loginMember = " + loginMember);
	// loginForm페이지는 로그아웃상태에서만 출력되는 페이지
	if(loginMember != null) {
		response.sendRedirect("/diary/diaryListOfMonth.jsp");
		return; // 코드 진행을 끝내는 문법 ex) 메서드 끝낼때 return사용
	}
	
	// loginMember가 null 이다 -> session공간에 loginMember변수를 생성...
%>

<%
	//post 인코딩 설정
	request.setCharacterEncoding("utf-8");

	//1. 요청값 분석
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	System.out.println("loginAction - memberID = " + memberId);	//memberId 값 확인
	System.out.println("loginAction - memberPw = " + memberPw);	//memberId 값 확인

	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement getMemberIdStmt = null;
	ResultSet getMemberIdRs = null;
	
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3307/diary", "root", "java1234");

	String getMemberIdSql = "SELECT member_id memberId FROM MEMBER WHERE member_id = ? AND member_pw = ?";
	getMemberIdStmt = conn.prepareStatement(getMemberIdSql);
	getMemberIdStmt.setString(1, memberId);
	getMemberIdStmt.setString(2, memberPw);
	getMemberIdRs = getMemberIdStmt.executeQuery();
	
	if(getMemberIdRs.next()) {
		// 로그인 성공
		System.out.println("로그인 성공");
		
// 		// [DB]diary.login.my_session -> 'ON'으로 변경 해야한다.
// 		// my_session 값을 ON으로 바꾸는 SQL 쿼리
// 		String loginMySessionSql = "UPDATE login SET my_session = 'ON', on_date = NOW() WHERE my_session = 'OFF'";
// 		PreparedStatement loginMySessionStmt = null;
// 		loginMySessionStmt = conn.prepareStatement(loginMySessionSql);
		
// 		int row = loginMySessionStmt.executeUpdate();
// 		System.out.println("loginAction - row = " + row);

		// 로그인 성공 시 DB값 설정에서 session 변수 설정으로 교체
		session.setAttribute("loginMember", getMemberIdRs.getString("memberId"));
	
		response.sendRedirect("/diary/diaryListOfMonth.jsp");
	} else {
		// 로그인 실패
		String errMsg = URLEncoder.encode("아이디와 비밀번호를 확인해주세요.", "UTF-8");
		response.sendRedirect("/diary/login/loginForm.jsp?errMsg=" + errMsg);
		
		// DB 반납
		conn.close();
		
		return ;	// 코드의 진행을 끝 낼때 사용
	}
    	
	// DB 반납
	getMemberIdRs.close();
	getMemberIdStmt.close();	
	conn.close();
%>