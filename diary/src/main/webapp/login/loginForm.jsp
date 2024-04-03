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
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Orbit&display=swap" rel="stylesheet">
	<style>
		body {
			background-image: url('/diary/img/img5.jpg');
			background-size: 100%;
			background-repeat: no-repeat; 
			background-position: center;
			font-family: "Orbit", sans-serif;
			font-weight: 300;
			font-style: normal;
			min-height: 100vh;
		}
	</style>
</head>
<body>	
	<div class="row" style="min-height: 100vh;">
		<div class="col"></div>
		
		<div class="col-6 mt-5 border border-light-subtle shadow p-2 rounded-2" style="background-color: rgba(248, 249, 250, 0.7); height: 400px; width: 600px;">


			<div class="row">
				
				<div class="col-3" style="display: flex;">

				</div>
				
				<div class="col-6">
					<h1 style="text-align: center; font-size: 60px;">로그인</h1>
					<div>
						<%
							if(errMsg != null) {
						%>
								<%=errMsg%>
						<%
							}
						%>
					</div>
					
					
				</div>

				<div class="col-3" style="text-align: right;">
					
				</div>
				
			</div>

			<hr>
			
			<div style="margin-top: 50px;">
				<form action="/diary/login/loginAction.jsp" method="post">
					<div style="text-align: center;">			
						id
						<input type="text" name="memberId">
					</div>
					
					<div style="text-align: center; margin-top: 10px;">
						pw
						<input type="password" name="memberPw">
					</div>
					
					<div style="text-align: center; margin-top: 20px;">
						<button class="btn btn-outline-secondary" type="submit">로그인</button>	
					</div>
					
				</form>
			</div>
				
		</div>
		<div class="col"></div>
	</div>
</body>
</html>