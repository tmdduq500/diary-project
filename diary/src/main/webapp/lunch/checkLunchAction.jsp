<%@page import="java.sql.*"%>
<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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

	// diary테이블에 날짜가 이미 존재하는지 확인하기 -> 존재하지 않아야 글쓰기 가능
	// 요청 값 분석
	String checkLunchDate = request.getParameter("lunchDate");
	if(checkLunchDate == null) {
		checkLunchDate = "";
	}
	
	System.out.println("checkDateAction - checkLunchDate = " + checkLunchDate);	// checkLunchDate 값 확인
	
	String checkLunchSql = "SELECT lunch_date lunchDate from lunch where lunch_date = ?";
	PreparedStatement checkLunchStmt = conn.prepareStatement(checkLunchSql);
	checkLunchStmt.setString(1, checkLunchDate);
	ResultSet checkLunchRs = checkLunchStmt.executeQuery();
		
	if(checkLunchRs.next()) {
		// 해당 날짜는 일기 작성 불가능(이미 해당 날짜의 일기 존재함)
		response.sendRedirect("/diary/lunch/lunchAddForm.jsp?lunchDate=" + checkLunchDate + "&write=N");
	} else {
		// 아무 날짜도 선택하지 않고 날짜 가능 확인 버튼을 눌렀을 때 작성 불가능
		if(checkLunchDate.equals("")) {
			response.sendRedirect("/diary/lunch/lunchAddForm.jsp?lunchDate=" + checkLunchDate + "&write=N");
		} else {
			// 해당 날짜는 일기 기록 가능
			response.sendRedirect("/diary/lunch/lunchAddForm.jsp?lunchDate=" + checkLunchDate + "&write=Y");
		}
	}
%>