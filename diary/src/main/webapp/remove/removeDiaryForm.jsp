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
	// 요청값 분석
	String diaryDate = request.getParameter("diaryDate");
	
	if(diaryDate == null) {
		response.sendRedirect("/diary/diaryListOfMonth.jsp");
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>removeDiaryForm</title>
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
					<h1 style="text-align: center; font-size: 60px;">일기 삭제</h1>
				</div>

				<div class="col-3" style="text-align: right;">
					<form action="/diary/diaryOne.jsp?diaryDate=<%=diaryDate%>">
						<button type="button" class="btn-close" aria-label="Close" style="margin: 15px;"></button>
					</form>
				</div>
				
			</div>

			<hr>
			
			<div>
			
				<div style="text-align: center;">
					<div>
						<%=diaryDate%>일의 일기를 지우시겠습니까?
					</div>
					
					<div>
						지우시려면 id와 pw를 입력해주세요.
					</div>
				</div>
				
				<div style="text-align: center;">
					<form action="/diary/remove/removeDiaryAction.jsp" method="post">
						<input type="hidden" name="diaryDate" value="<%=diaryDate%>">
						<div class="row" style="padding-top: 20px;">
							<div class="col-3" style="text-align: right;">
								id
							</div>
							
							<div class="col" style="padding-right: 150px;">
								<input type="text" name="memberId" style="width: 250px;">
							</div>
							<div class="col-2"></div>
						</div>
			
						<div class="row" style="padding-top: 20px;">
							<div class="col-3" style="text-align: right;">
								pw
							</div>
							
							<div class="col" style="padding-right: 150px;">
								<input type="password" name="memberPw" style="width: 250px;">
							</div>
							<div class="col-2"></div>
						</div>
						
						<div class="row" style="padding-top: 20px;">
							<div class="col"></div>
							<div class="col">
								<button class="btn btn-outline-secondary" type="submit">입력완료</button>
							</div>
							<div class="col"></div>
						</div>
						
					</form>	
				</div>
				
			</div>
				
		</div>
		<div class="col"></div>
	</div>
</body>
</html>