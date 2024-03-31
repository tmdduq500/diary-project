<%@page import="java.net.URLEncoder"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
// 	//로그인(인증) 분기
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

	// 요청값 분석
	String diaryDate = request.getParameter("diaryDate");
	String title = request.getParameter("title");
	String weather = request.getParameter("weather");
	String feeling = request.getParameter("feeling");
	String content = request.getParameter("content");
	
	// 아무것도 입력하지않고 작성완료를 눌렀을 경우
	if(diaryDate.equals("") && title.equals("") && content.equals("") && feeling.equals("")) {
		String errMsg = URLEncoder.encode("일기의 형식에 맞게 작성해주세요", "UTF-8");
		response.sendRedirect("/diary/add/addDiaryForm.jsp?errMsg=" + errMsg);
		
		return ;
	}
	
	System.out.println("addDiaryAction - diaryDate = " + diaryDate);	// diaryDate 값 확인
	System.out.println("addDiaryAction - title = " + title);	// title 값 확인
	System.out.println("addDiaryAction - weather = " + weather);	// weather 값 확인
	System.out.println("addDiaryAction - content = " + content);	// content 값 확인
	System.out.println("addDiaryAction - feeling = " + feeling);	// feeling 값 확인
	
	// [DB] diary.diary에 추가하는 쿼리
	String addDiarySql = "INSERT INTO diary(diary_date, feeling, title, weather, content, update_date, create_date) VALUES (?, ?, ?, ?, ?, NOW(), NOW())";
	PreparedStatement addDiaryStmt = null;
	
	addDiaryStmt = conn.prepareStatement(addDiarySql);
	addDiaryStmt.setString(1, diaryDate);	// ? 값 교체
	addDiaryStmt.setString(2, feeling);	// ? 값 교체
	addDiaryStmt.setString(3, title);	// ? 값 교체
	addDiaryStmt.setString(4, weather);	// ? 값 교체
	addDiaryStmt.setString(5, content);	// ? 값 교체
	System.out.println("addDiaryAction - addDiaryStmt = " + addDiaryStmt);
	
	int row = addDiaryStmt.executeUpdate();
	
	if(row == 1) {
		// 일기 입력 성공
		response.sendRedirect("/diary/diaryListOfMonth.jsp");
	} else {
		// 일기 입력 실패
		response.sendRedirect("/diary/addDiaryForm.jsp");
	}
	
	// DB 자원 반납
	addDiaryStmt.close();
	conn.close();
%>