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
	// 요청 값 확인
	// 어떤 날짜가 선택 됐는지
	String checkDate = request.getParameter("checkDate");
	if(checkDate == null) {
		checkDate = "";
	}
	// 선택된 날짜에 일기를 작성 가능한지
	String write = request.getParameter("write");
	if(write == null) {
		write = "";
	}
	
	// 작성이 가능한지 불가능한 날짜인지 알려주는 메시지를 출력
	String writeMsg = "";
	if(write.equals("Y")) {
		writeMsg = "작성 가능한 날짜 입니다.";
	} else if(write.equals("N")){
		writeMsg = "작성 불가능한 날짜 입니다.";
	}
	
	String errMsg = request.getParameter("errMsg");
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>addDiaryForm</title>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Orbit&display=swap" rel="stylesheet">
	<style>
		a:link {
			color: black;
			text-decoration: none;
		}
		
		a:visited {
			color: #003541;
			text-decoration: none;
		}
		
		a:hover {
			color: #3162C7;
			text-decoration: none;
		}
		
		a:active {
			text-decoration: none;
		}
	
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
	
		table {
			border-collapse: collapse;
			width: 800px;
			margin: 0rem auto;
			box-shadow: 4px 4px 10px 0 rgba(0, 0, 0, 0.1);
			background-color: white;
		}

		/* 테이블 행 */
		th, td {
		  padding: 20px;
		  text-align: left;
		  border-bottom: 1px solid #ddd;
		  text-align: center;
		  color: #000000;
		  font-size: 18px;
		}
		
		th {
		  background-color: rgba(92, 138, 153, 0.5);
		  color: #000000;
		}
		
		/* 테이블 올렸을 때 */
		tbody tr:hover {
		  background-color: #d3d3d3;
		  opacity: 0.9;
		  cursor: pointer;
		  color: 
		}
		
		.my-row {
			height: 50px;
		}
		
		input[type=radio] {
			width: 15px;
			height: 15px;
		}
		
		label {
			font-size: 20px;	
		}
				
	</style>
</head>
<body>
	
	<div class="row" style="min-height: 100vh;">
		<div class="col"></div>
		
		<div class="col-6 mt-5 border border-light-subtle shadow p-2 rounded-2" style="background-color: rgba(248, 249, 250, 0.7); height: 650px;">
			<div>
			<%
				if(errMsg != null) {
			%>
					<%=errMsg%>
			<%
				}
			%>
			</div>
			<div>
				
			</div>

			<div class="row">
				
				<div class="col-3" style="display: flex;">
					<form action="/diary/diaryListOfMonth.jsp">
						<button class="btn btn-outline-secondary" type="submit" class="btn btn-outline-secondary" style="color: black; margin-right: 10px;">
							다이어리
						</button>
					</form>
					
					<form action="/diary/diaryList.jsp">
						<button class="btn btn-outline-secondary" type="submit" class="btn btn-outline-secondary" style="color: black;">
							일기 목록
						</button>
					</form>
				</div>
				
				<div class="col-6">
					<h1 style="font-size: 60px; text-align: center;">일기 쓰기</h1>
				</div>
				
				<div class="col-3" style="text-align: right;">
					<form action="/diary/diaryListOfMonth.jsp">
						<button type="submit" class="btn-close" aria-label="Close" style="margin: 15px;"></button>
					</form>
				</div>
				
			</div>

			<hr>
			
			<div class="container text-center">
				<form action="/diary/checkDateAction.jsp" method="post">
					<div class="row my-row">
						<div class="col-2">
							날짜확인
						</div>
						
						<div class="col-2">
							<input type="date" name="checkDate" style="background-color: rgba(0,0,0,0);">
						</div>
						
						<div class="col-3">
							<button class="btn btn-outline-secondary" type="submit" style="background-color: rgba(0,0,0,0);">작성 가능 확인</button>
						</div>
						
						<div class="col">
							<span><%=writeMsg%></span>
						</div>
					</div>
				</form>
		
				<form action="/diary/add/addDiaryAction.jsp" method="post">

					<div class="row my-row">
						<div class="col-2">
							날짜 
						</div>
						<div class="col-1">
							<%
								if(write.equals("Y")) {
							%>
									<input value="<%=checkDate%>" type="text" name="diaryDate" readonly="readonly" style="width: 150px; background-color: rgba(0,0,0,0);">
							<%
								} else {
							%>
									<input type="text" name="diaryDate" readonly="readonly" style="width: 150px; background-color: rgba(0,0,0,0);">
							<%
								}
							%>
						</div>
						<div class="col"></div>
						<div class="col"></div>
					</div>
					
									
					<div class="row my-row">
						<div class="col-2">
							제목
						</div>
						<div class="col-1">
							<input type="text" name="title"  style="width: 150px; background-color: rgba(0,0,0,0);">
						</div>
						<div class="col"></div>
						<div class="col"></div>
					</div>
					
					<div  class="row my-row">
						<div class="col-2">
							날씨
						</div>
						
						<div class="col-1">
							<select name="weather" style="width: 200px; text-align: center; width: 150px; background-color: rgba(0,0,0,0);">
								<option value="맑음">맑음</option>
								<option value="흐림">흐림</option>
								<option value="비">비</option>
								<option value="눈">눈</option>
							</select>
						</div>

						<div class="col"></div>
						<div class="col"></div>
					</div>
					
					<div class="row my-row">
						<div class="col-2">
							기분
						</div>
						<div class="col-1">
							<label for="&#128516;">
								<input type="radio" name="feeling" value="&#128516;" id="&#128516;">&#128516;
							</label>
						</div>
						<div class="col-1">
							<label for="&#128528;">
								<input type="radio" name="feeling" value="&#128528;" id="&#128528;">&#128528;
							</label>
						</div>
						<div class="col-1">
							<label for="&#128533;">
								<input type="radio" name="feeling" value="&#128533;" id="&#128533;">&#128533;
							</label>
						</div>
						<div class="col-1">
							<label for="&#128557;">
								<input type="radio" name="feeling" value="&#128557;" id="&#128557;">&#128557;
							</label>
						</div>
						<div class="col-1">
							<label for="&#128127;">
								<input type="radio" name="feeling" value="&#128127;" id="&#128127;">&#128127;
							</label>
						</div>
					</div>
					
					<div class="row my-row" style="height: 200px;">
						<div class="col-2">
							내용
						</div>
						
						<div class="col">
							<textarea rows="8" cols="60" name="content" style="background-color: rgba(0,0,0,0);"></textarea>
						</div>
						<div class="col"></div>
						<div class="col"></div>
					</div>
					
					<div class="row my-row" style="margin-top: 20px;">
						<div class="col"></div>
						<div class="col">
							<button class="btn btn-outline-secondary" type="submit">작성완료</button>
						</div>
						<div class="col"></div>
					</div>
					

				</form>
			</div>

		</div>
		<div class="col"></div>
	</div>
	
</body>
</html>