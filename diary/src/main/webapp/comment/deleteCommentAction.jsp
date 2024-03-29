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
	
	// 요청 값 분석
	String diaryDate = request.getParameter("diaryDate");
	String commentNo = request.getParameter("commentNo");
	
	// 해당 페이지 바로 실행시
	if(diaryDate == null || commentNo == null) {
		response.sendRedirect("/diary/diaryListOfMonth.jsp");
		return;
	}
	
	// 댓글 추가 INSERT 쿼리
	String deleteCommentSql = "DELETE FROM comment WHERE comment_no = ? AND diary_date = ?";
	PreparedStatement deleteCommentStmt =  null; 
	deleteCommentStmt = conn.prepareStatement(deleteCommentSql);
	deleteCommentStmt.setString(1, commentNo);
	deleteCommentStmt.setString(2, diaryDate);
	
	int row = deleteCommentStmt.executeUpdate();
	System.out.println("deleteCommentAction - row = " + row);
	
	response.sendRedirect("/diary/diaryOne.jsp?diaryDate=" + diaryDate);
%>