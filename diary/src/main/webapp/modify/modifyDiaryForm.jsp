<%@page import="java.net.URLEncoder"%>
<%@page import="java.sql.*"%>
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
	System.out.println("diaryOne - diaryDate = " + diaryDate);
	
	if(diaryDate == null) {
		response.sendRedirect("/diary/diaryListOfMonth.jsp");
	}

	// [DB]diary.diary에서 diaryDate에 해당하는 일기 내용 추출
	String getDiarySql = "SELECT diary_date diaryDate, title, weather, feeling, content FROM diary WHERE diary_date = ?";
	PreparedStatement getDiaryStmt = null;
	ResultSet getDiaryRs = null;
	
	getDiaryStmt = conn.prepareStatement(getDiarySql);
	getDiaryStmt.setString(1, diaryDate);
	getDiaryRs = getDiaryStmt.executeQuery();
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>diaryOne</title>
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
				
	</style>
</head>
<body>
	
	<div class="row" style="min-height: 100vh;">
		<div class="col"></div>
		
		<div class="col-6 mt-5 border border-light-subtle shadow p-2 rounded-2" style="background-color: rgba(248, 249, 250, 0.7); height: 800px;">

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
					<h1 style="text-align: center; font-size: 55px;">일기 수정</h1>
				</div>
				
				<div class="col-4" style="text-align: right;">
					<form action="/diary/login/logoutAction.jsp" method="post">
						<button class="btn btn-outline-secondary" type="submit">로그아웃</button>
					</form>
				</div>
			</div>

			<hr>
			
			<form action="/diary/modify/modifyDiaryAction.jsp" method="post">
				<%
					if(getDiaryRs.next()) {
				%>
						<div style="display: flex; justify-content: center;">
							<table style="background-color: rgba(255, 255, 255, 0);">
								<tr>
									<th>날짜</th>
									<td>
										<input type="text" name="diaryDate" value="<%=getDiaryRs.getString("diaryDate")%>" style="background-color: rgba(0,0,0,0);" readonly="readonly">
									</td>
								</tr>
								<tr>
									<th>제목</th>
									<td>
										<div>
											<input type="text" name="title" value="<%=getDiaryRs.getString("title")%>" style="background-color: rgba(0,0,0,0);">
										</div>
									</td>
								</tr>
								<tr>
									<th>pw 확인</th>
									<td>
										<div>
											<input type="password" name="memberPw" style="background-color: rgba(0,0,0,0);">
										</div>
									</td>
								<tr>
									<th>날씨</th>
									<td>
										<div>
											<select name="weather" style="background-color: rgba(0,0,0,0);">
											<%
												if(getDiaryRs.getString("weather").equals("맑음")) {
											%>
													<option value="맑음" selected="selected">맑음</option>
													<option value="흐림">흐림</option>
													<option value="비">비</option>
													<option value="눈">눈</option>
											<%
												} else if(getDiaryRs.getString("weather").equals("흐림")) {
											%>
													<option value="맑음">맑음</option>
													<option value="흐림" selected="selected">흐림</option>
													<option value="비">비</option>
													<option value="눈">눈</option>
											<%
												} else if(getDiaryRs.getString("weather").equals("비")) {
											%>
													<option value="맑음">맑음</option>
													<option value="흐림">흐림</option>
													<option value="비" selected="selected">비</option>
													<option value="눈">눈</option>
											<%
												} else {
											%>
													<option value="맑음">맑음</option>
													<option value="흐림">흐림</option>
													<option value="비">비</option>
													<option value="눈" selected="selected">눈</option>
											<%
												}
											%>

											</select>
										</div>
									</td>
								</tr>
								<tr>
									<th>기분</th>
									<td>
										<div>
											<%
												System.out.println("feeling = " + getDiaryRs.getString("feeling"));
												if(getDiaryRs.getString("feeling").equals("&#128516")) {
											%>
													<label for="&#128516;">
														<input type="radio" name="feeling" value="&#128516;" id="&#128516;" checked="checked">&#128516;
													</label>
													<label for="&#128528;">
														<input type="radio" name="feeling" value="&#128528;" id="&#128528;">&#128528;
													</label>
													<label for="&#128533;">
														<input type="radio" name="feeling" value="&#128533;" id="&#128533;">&#128533;
													</label>
													<label for="&#128557;">
														<input type="radio" name="feeling" value="&#128557;" id="&#128557;">&#128557;
													</label>
													<label for="&#128127;">
														<input type="radio" name="feeling" value="&#128127;" id="&#128127;">&#128127;
													</label>
											<% 
												} else if(getDiaryRs.getString("feeling").equals("&#128528")) {
											%>
													<label for="&#128516;">
														<input type="radio" name="feeling" value="&#128516;" id="&#128516;">&#128516;
													</label>
													<label for="&#128528;">
														<input type="radio" name="feeling" value="&#128528;" id="&#128528;" checked="checked">&#128528;
													</label>
													<label for="&#128533;">
														<input type="radio" name="feeling" value="&#128533;" id="&#128533;">&#128533;
													</label>
													<label for="&#128557;">
														<input type="radio" name="feeling" value="&#128557;" id="&#128557;">&#128557;
													</label>
													<label for="&#128127;">
														<input type="radio" name="feeling" value="&#128127;" id="&#128127;">&#128127;
													</label>
											<%
												} else if(getDiaryRs.getString("feeling").equals("&#128533")) {
											%>
													<label for="&#128516;">
														<input type="radio" name="feeling" value="&#128516;" id="&#128516;">&#128516;
													</label>
													<label for="&#128528;">
														<input type="radio" name="feeling" value="&#128528;" id="&#128528;">&#128528;
													</label>
													<label for="&#128533;">
														<input type="radio" name="feeling" value="&#128533;" id="&#128533;" checked="checked">&#128533;
													</label>
													<label for="&#128557;">
														<input type="radio" name="feeling" value="&#128557;" id="&#128557;">&#128557;
													</label>
													<label for="&#128127;">
														<input type="radio" name="feeling" value="&#128127;" id="&#128127;">&#128127;
													</label>
											<%
												} else if(getDiaryRs.getString("feeling").equals("&#128557")) {
											%>
													<label for="&#128516;">
														<input type="radio" name="feeling" value="&#128516;" id="&#128516;">&#128516;
													</label>
													<label for="&#128528;">
														<input type="radio" name="feeling" value="&#128528;" id="&#128528;">&#128528;
													</label>
													<label for="&#128533;">
														<input type="radio" name="feeling" value="&#128533;" id="&#128533;">&#128533;
													</label>
													<label for="&#128557;">
														<input type="radio" name="feeling" value="&#128557;" id="&#128557;" checked="checked">&#128557;
													</label>
													<label for="&#128127;">
														<input type="radio" name="feeling" value="&#128127;" id="&#128127;">&#128127;
													</label>
											<%
												} else {
											%>
													<label for="&#128516;">
														<input type="radio" name="feeling" value="&#128516;" id="&#128516;">&#128516;
													</label>
													<label for="&#128528;">
														<input type="radio" name="feeling" value="&#128528;" id="&#128528;">&#128528;
													</label>
													<label for="&#128533;">
														<input type="radio" name="feeling" value="&#128533;" id="&#128533;">&#128533;
													</label>
													<label for="&#128557;">
														<input type="radio" name="feeling" value="&#128557;" id="&#128557;">&#128557;
													</label>
													<label for="&#128127;">
														<input type="radio" name="feeling" value="&#128127;" id="&#128127;" checked="checked">&#128127;
													</label>
											<%
												}
											%>
										</div>
									</td>
								</tr>
								<tr>
									<th>내용</th>
									<td>
										<div>
											<textarea style="background-color: rgba(0,0,0,0);" rows="5" cols="50" name="content">
												<%=getDiaryRs.getString("title") %>
											</textarea>	
										</div>
									</td>
								</tr>
							</table>
						</div>	
				<%
					}
				%>
				
				<div style="display: flex; margin-left:400px; margin-top: 50px; align-item : middle; text-align: center;">
					<button type="submit" class="btn btn-outline-secondary" style="color: black; margin-right: 10px;">
						일기 수정 완료
					</button>
				</div>
			</form>

		</div>
		<div class="col"></div>
	</div>
	
</body>
</html>