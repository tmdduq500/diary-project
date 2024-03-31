<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
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
	/*
		SELECT menu,COUNT(*)
		FROM lunch
		GROUP BY menu

	*/
	String getMenuStatSql = "select menu, count(*) cnt from lunch group by menu";
	PreparedStatement getMenuStatStmt = null;
	ResultSet getMenuStatRs = null;
	getMenuStatStmt = conn.prepareStatement(getMenuStatSql);
	getMenuStatRs = getMenuStatStmt.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>statsLunch</title>
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
		
		table {
			border-collapse: collapse;
			width: 500px;
			height: 400px;
			margin: 0rem auto;
			box-shadow: 4px 4px 10px 0 rgba(0, 0, 0, 0.1);
			background-color: white;
		}
		
		th, td {
		  padding: 10px;
		  text-align: left;
		  border-bottom: 1px solid #ddd;
		  text-align: center;
		  color: #000000;
		}
		
		th {
		  background-color: rgba(92, 138, 153, 0.5);
		  height: 20px;
		  color: #000000;
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
	</style>
</head>
<body>
		
	<div class="row" style="min-height: 100vh;">
			<div class="col"></div>
			
			<div class="col-6 mt-5 border border-light-subtle shadow p-2 rounded-2" style="background-color: rgba(248, 249, 250, 0.7); height: 600px; width: 800px;">

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
					
					<div class="col-4" style="text-align: center;">
						<h1 style=" font-size: 55px;">점심 투표</h1>
					</div>
	
					<div class="col-4" style="text-align: right;">

					</div>
					
				</div>
	
				<hr>
				
				<div>
				
					<div style="text-align: center;">
					
						<%
							double maxHeight = 500;
							double totalCnt = 0; //
							while(getMenuStatRs.next()) {
								totalCnt = totalCnt + getMenuStatRs.getInt("cnt");
							}
						%>
						
						<div>
							전체 투표수 : <%=(int)totalCnt%>
						</div>
						
						<table style="background-color: rgba(255, 255, 255, 0); margin-top: 20px;">
							<tr>
								<th colspan="5">투표결과</th>
							</tr>
														
							<tr>
								<%	
									String[] color = {"#8697B3", "#B9C0D0", "#E3DFC2", "#CFC1C0", "#7A7A7A"};
									int colorIndex = 0;
									
									getMenuStatRs.beforeFirst();
									while(getMenuStatRs.next()) {
										int height = (int)(maxHeight * (getMenuStatRs.getInt("cnt")/totalCnt));
								%>
										<td style="vertical-align: bottom;">
											<div style="height: <%=height%>px; 
														background-color:<%=color[colorIndex]%>;
														text-align: center">
												<%=getMenuStatRs.getInt("cnt")%>
											</div>
										</td>
								<%		
										colorIndex++;
									}
								%>
							</tr>
							<tr>
								<%
									// 커서의 위치를 처음 행으로
									getMenuStatRs.beforeFirst();
												
									while(getMenuStatRs.next()) {
								%>
										<th>
											<%=getMenuStatRs.getString("menu")%>
										</th>
								<%		
									}
								%>
							</tr>
						</table>
					</div>
					
				</div>
					
			</div>
			
			<div class="col"></div>
			
		</div>
	
</body>
</html>