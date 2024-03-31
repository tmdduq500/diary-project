<%@page import="java.net.URLEncoder"%>
<%@page import="java.sql.*"%>
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
	
	// 요청 값 확인
	String lunchDate = request.getParameter("lunchDate");
	String write = request.getParameter("write");
	
	// 요청 값 확인
	System.out.println("lunchAddForm - lunchDate = " + lunchDate);	
	System.out.println("lunchAddForm - write = " + write);
	
	if(lunchDate == null) {
		lunchDate = "";
	}
	// 선택된 날짜에 점심 투표 가능한지
	if(write == null) {
		write = "";
	}
	
	// 점심 투표가 가능한지 불가능한 날짜인지 알려주는 메시지를 출력
	String writeMsg = "";
	if(write.equals("Y")) {
		writeMsg = "투표 가능한 날짜 입니다.";
	} else if(write.equals("N")){
		writeMsg = "투표 불가능한 날짜 입니다.";
	}
	
	String errMsg = request.getParameter("errMsg");
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>title</title>
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
		
		.button {
			color: black;
		}
	</style>
</head>
<body>
	<div class="row" style="min-height: 100vh;">
			<div class="col"></div>
			
			<div class="col-6 mt-5 border border-light-subtle shadow p-2 rounded-2" style="background-color: rgba(248, 249, 250, 0.7); height: 450px; width: 800px;">
			
				<div>
					<%
						if(errMsg != null) {
					%>
							<%=errMsg%>
					<%
						}
					%>
				</div>
				
				<div class="row">
					
					<div class="col-4">
						<div style="display: flex;">
							<form action="/diary/diaryListOfMonth.jsp">
								<button type="submit" class="btn btn-outline-secondary" style="color: black; margin-right: 10px; padding: 5 10px; width: 115px;">
									&#128214;다이어리
								</button>
							</form>
							
							<form action="/diary/diaryList.jsp">
								<button type="submit" class="btn btn-outline-secondary" style="color: black;">
									&#128214;일기 목록
								</button>
							</form>
						</div>
						<div style="display: flex;">
							
							<form action="/diary/lunch/statsLunch.jsp">
								<button type="submit" class="btn btn-outline-secondary" style="color: black; margin-right: 10px;">
									&#127835;점심 통계
								</button>
							</form>
							<form action="/diary/lunch/lunchAddForm.jsp">
								<button type="submit" class="btn btn-outline-secondary" style="color: black;">
									&#127835;점심 투표
								</button>
							</form>
						</div>
					</div>
					
					<div class="col-4">
						<h1 style="text-align: center; font-size: 55px;">점심 메뉴</h1>
					</div>
	
					<div class="col-4" style="text-align: right;">
						<form action="/diary/diaryListOfMonth.jsp">
							<button type="submit" class="btn-close" aria-label="Close" style="margin: 15px;"></button>
						</form>
					</div>
					
				</div>
	
				<hr>
				
				<div>
				
					<div style="text-align: center;">
						
						<form action="/diary/lunch/checkLunchAction.jsp">
							<input type="date" name="lunchDate">
							<button class="btn btn-outline-secondary" type="submit">투표 가능 확인</button>
						</form>
						
			
						<form action="/diary/lunch/lunchAddAction.jsp" method="post">
							<%
								if(write.equals("Y")) {
							%>
									<input type="date" name="lunchDate" value="<%=lunchDate%>" readonly="readonly" style="width: 150px; background-color: rgba(0,0,0,0);">
									<div><%=writeMsg%></div>

							<%
								} else {
							%>
									<input type="text" name="lunchDate" readonly="readonly" style="width: 150px; background-color: rgba(0,0,0,0);">
									<div><%=writeMsg%></div>
							<%
								}
							%>
							<div style="margin-top: 30px;">
								메뉴를 투표해주세요
							</div>
							
							<div style="margin-top: 30px;">
								<input type="radio" name="menu" value="한식">한식
								<input type="radio" name="menu" value="중식">중식
								<input type="radio" name="menu" value="일식">일식
								<input type="radio" name="menu" value="양식">양식
								<input type="radio" name="menu" value="기타">기타
							</div>
							
							<div>
								<button class="btn btn-outline-secondary" type="submit" style="margin-top: 30px;">투표 하기</button>
							</div>
						</form>

					</div>
					
				</div>
					
			</div>
			<div class="col"></div>
		</div>
</body>
</html>