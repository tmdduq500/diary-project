<%@page import="java.util.Calendar"%>
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


	//0. 로그인(인증) 분기
	String loginMember = (String)(session.getAttribute("loginMember"));
	if(loginMember == null) {
		String errMsg = URLEncoder.encode("잘못된 접근 입니다. 로그인 먼저 해주세요", "utf-8");
		response.sendRedirect("/diary/login/loginForm.jsp?errMsg="+errMsg);
		return;
	}

	// DB 연결 및 초기화
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3307/diary", "root", "java1234");
	// errMsg출력
	String errMsg = request.getParameter("errMsg");
	
%>

<%
	// 달력
	
	// 1. 요청 분석
	// 출력할 달력의 년도와 월을 넘겨 받기
	String targetYear = request.getParameter("targetYear");
	String targetMonth = request.getParameter("targetMonth");
	
	System.out.println("diaryListOfMonth - targetYear = " + targetYear);
	System.out.println("diaryListOfMonth - targetMonth = " + targetMonth);
	
	Calendar target = Calendar.getInstance();
		
	if(targetYear != null && targetMonth != null) {
		target.set(Calendar.YEAR, Integer.parseInt(targetYear));
		target.set(Calendar.MONTH, Integer.parseInt(targetMonth));
	}
	
	// 타이틀에 출력할 달력 년 월 변수
	int titleYear = target.get(Calendar.YEAR);
	int titleMonth = target.get(Calendar.MONTH);
	
	System.out.println("diaryListOfMonth - titleYear = " + titleYear);
	System.out.println("diaryListOfMonth - titleMonth = " + titleMonth);
	
	// 달력 1일 시작 전 공백 개수 -> 1일의 요일이 필요 -> target의 날짜를 1일로 변경
	target.set(Calendar.DATE, 1);
	int firstDateNum = target.get(Calendar.DAY_OF_WEEK);	//1일의 요일 (일 : 1 / 월 : 2 / ... / 토 : 7)
	
	System.out.println("diaryListOfMonth - firstDateNum = " + firstDateNum);
	
	int startBlank = firstDateNum - 1;	// 1일 시작 전 공백 개수 Ex) 1일이 일요일 -> 0개 / 1일이 월요일 -> 1개 / .... / 1일이 토요일 -> 6개
	System.out.println("startBlank = " + startBlank);
	int lastDate = target.getActualMaximum(Calendar.DATE);	// target달의 마지막 날짜 반환
	System.out.println("lastDate = "+lastDate);
	int diaryDiv = 42;	// 달력 칸의 개수
	
	// 이전달 공백 칸의 날짜
	Calendar beforeTarget = Calendar.getInstance();
	beforeTarget.set(titleYear, titleMonth - 1, 1);
	int beforeMonthLastDay = beforeTarget.getActualMaximum(Calendar.DATE);
	System.out.println("beforeMonthLastDay = " + beforeMonthLastDay);
	
	// [DB]에서 targetYear와 targetMonth에 해당하는 diary 목록 추출하기
	String getDiaryListSql = "SELECT diary_date diaryDate, day(diary_date) day, feeling, LEFT(title,4) title FROM diary WHERE YEAR(diary_date) = ? AND MONTH(diary_date) = ?";
	PreparedStatement getDiaryListStmt = null;
	ResultSet getDiaryListRs = null;
	
	getDiaryListStmt = conn.prepareStatement(getDiaryListSql);
	getDiaryListStmt.setInt(1, titleYear);
	getDiaryListStmt.setInt(2, titleMonth + 1);
	System.out.println(getDiaryListStmt);
	
	getDiaryListRs = getDiaryListStmt.executeQuery();
%>

<%
	// 점심 투표했는지 표시하기
	String getLunchSql = "SELECT menu FROM lunch WHERE lunch_date = ?";
	PreparedStatement getLunchStmt = null;
	ResultSet getLunchRs = null;
	getLunchStmt = conn.prepareStatement(getLunchSql);
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>diaryListOfMonth</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Orbit&display=swap" rel="stylesheet">
	<style>
		a {
			display: block; text-decoration: none;
			font-size: 16px;
		}
		
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
			font-family: "Orbit", sans-serif;
			font-weight: 300;
			font-style: normal;
		}

		.week {
			border:1px solid #000000;
			width: 100px; height: 80px;
			float: left;
			background-color: rgba(90, 113, 127, 0.5)
		}
		
		.cell {
			float: left;
			border:1px solid #000000;
			width: 100px; height: 80px;
			background-color: rgba(147, 164, 171, 0.5);
		}
		
		.sat {
			clear: right;
			color: #0000FF;
		}
		
		.sun {
			clear: both;
			color: #FF0000;
		}
		
		.button {
			color: black;
		}
	</style>
</head>
<body style="background-image: url('/diary/img/img5.jpg'); background-size: 100%; background-repeat: no-repeat; background-position: center;">

	
	
	<div class="row ">
		<div class="col"></div>
		
		<div class="col-6 mt-5 border border-light-subtle shadow p-3 rounded-2" style="text-align: center;  background-color: rgba(248, 249, 250, 0.5);">
		<div style="text-align: left;">
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
			
			<div class="col-4"><h1 style="font-size: 60px;">일기장</h1></div>
			
			<div class="col-4" style="text-align: right;">
				<form action="/diary/login/logoutAction.jsp" method="post">
					<button class="btn btn-outline-secondary" type="submit">로그아웃</button>
				</form>
			</div>
			
		</div>
			
			<div class="row">
				<div class="col">
					<a href="/diary/diaryListOfMonth.jsp?targetYear=<%=titleYear%>&targetMonth=<%=titleMonth - 1%>" style="margin-top: 15px;">
						이전 달
					</a>
				</div>
				
				<div class="col">
					<h2><%=titleYear%>년 <%=titleMonth + 1%>월 달력</h2>
				</div>
				
				<div class="col">
					<a href="/diary/diaryListOfMonth.jsp?targetYear=<%=titleYear%>&targetMonth=<%=titleMonth + 1%>" style="margin-top: 15px;">
						다음 달
					</a>
				</div>
			</div>
			
			<hr>
			
			
			
			<!-- 달력 시작 -->
			<div class="rounded-3" style="margin-left: 120px; opacity: 0.8; ">
				<!-- 요일 -->
				<div class="week rounded-1" style="color: red;">일</div>
				<div class="week rounded-1">월</div>
				<div class="week rounded-1">화</div>
				<div class="week rounded-1">수</div>
				<div class="week rounded-1">목</div>
				<div class="week rounded-1">금</div>
				<div class="week rounded-1" style="color: blue;">토</div>
				<div style="clear: both;"></div>
				<%
					for(int i = 1; i <= diaryDiv; i++) {
						if(i - startBlank > 0 && i - startBlank <= lastDate) {
							if(i % 7 == 1) {
				%>
								<div class="cell sun rounded-1">
									<div style="text-align: left; margin-left: 5px;">
										<%=i - startBlank%>
									</div>
									
				<%
									// 현재날짜(i-startBlank)의 일기가 getDiaryListRs 목록에 있는지 비교
									while(getDiaryListRs.next()) {
										// 날짜에 일기가 존재한다면
										if(getDiaryListRs.getInt("day") == (i-startBlank)) {
				%>
											<%
												getLunchStmt.setString(1, getDiaryListRs.getString("diaryDate"));
												getLunchRs = getLunchStmt.executeQuery();
												if(getLunchRs.next()) {
											%>
													<div style="display: flex; margin-left: 5px;">
														<a href="/diary/lunch/lunchOne.jsp?year=<%=titleYear%>&month=<%=titleMonth+1%>&day=<%=i - startBlank%>">&#127835;점심</a>
													</div>
											<%
												} else{
											%>
													<div>&nbsp;</div>
											<%
												}
											%>
											<div>
												<a href='/diary/diaryOne.jsp?diaryDate=<%=getDiaryListRs.getString("diaryDate")%>'>
													<%=getDiaryListRs.getString("feeling") %>
													<%=getDiaryListRs.getString("title")%>...
												</a>
											</div>
				<%
										}
									}
									getDiaryListRs.beforeFirst();
				%>
								</div>
				<%
							} else if(i % 7 == 0){
				%>
								<div class="cell sat rounded-1">
									<div style="text-align: left; margin-left: 5px;">
										<%=i - startBlank%>
									</div>
				<%
									// 현재날짜(i-startBlank)의 일기가 getDiaryListRs 목록에 있는지 비교
									while(getDiaryListRs.next()) {
										// 날짜에 일기가 존재한다면
										if(getDiaryListRs.getInt("day") == (i-startBlank)) {
				%>
											<%
												getLunchStmt.setString(1, getDiaryListRs.getString("diaryDate"));
												getLunchRs = getLunchStmt.executeQuery();
												if(getLunchRs.next()) {
											%>
													<div style="display: flex; margin-left: 5px;">
														<a href="/diary/lunch/lunchOne.jsp?year=<%=titleYear%>&month=<%=titleMonth+1%>&day=<%=i - startBlank%>">&#127835;점심</a>
													</div>
											<%
												} else{
											%>
													<div>&nbsp;</div>
											<%
												}
											%>
											<div>
												<a href='/diary/diaryOne.jsp?diaryDate=<%=getDiaryListRs.getString("diaryDate")%>'>
													<%=getDiaryListRs.getString("feeling") %>
													<%=getDiaryListRs.getString("title")%>...
												</a>
											</div>
				<%
										}
									}
									getDiaryListRs.beforeFirst();
				%>
								</div>
				<%
							} else {
				%>
								<div class="cell rounded-1">
									<div style="text-align: left; margin-left: 5px;">
										<%=i - startBlank%>
									</div>
									
				<%
									// 현재날짜(i-startBlank)의 일기가 getDiaryListRs 목록에 있는지 비교
									while(getDiaryListRs.next()) {
										// 날짜에 일기가 존재한다면
										if(getDiaryListRs.getInt("day") == (i - startBlank)) {
				%>							
											<%
												getLunchStmt.setString(1, getDiaryListRs.getString("diaryDate"));
												getLunchRs = getLunchStmt.executeQuery();
												if(getLunchRs.next()) {
											%>
													<div style="display: flex; margin-left: 5px;">
														<a href="/diary/lunch/lunchOne.jsp?year=<%=titleYear%>&month=<%=titleMonth+1%>&day=<%=i - startBlank%>">&#127835;점심</a>
													</div>
											<%
												} else{
											%>
													<div>&nbsp;</div>
											<%
												}
											%>
											<div>
												<a href='/diary/diaryOne.jsp?diaryDate=<%=getDiaryListRs.getString("diaryDate")%>'>
													<%=getDiaryListRs.getString("feeling") %>
													<%=getDiaryListRs.getString("title")%>...
												</a>
											</div>
				<%
										}
									}
									getDiaryListRs.beforeFirst();
				%>
								</div>
				<%
							}
						} else if(i - startBlank <= 0) {
				%>
							<div class="cell rounded-1" style="color: gray; text-align: left;">
								<%=i - startBlank + beforeMonthLastDay%>
							</div>
				<%
						} else {
							if(i % 7 == 1) {
				%>
								<div class="cell rounded-1"  style="clear: both; text-align: left;">
									<%=i - startBlank - lastDate%>
								</div>
				<%
							} else {
				%>
								<div class="cell rounded-1" style="color: gray; text-align: left;">
									<%=i - startBlank - lastDate%>
								</div>
				<%
							}
						}
					}
				%>
			</div>
			
			<div style="clear: both; text-align: center;">
				<form action="/diary/add/addDiaryForm.jsp">
					<button class="btn btn-outline-secondary" style="width: 50%; height: 40px; margin-top: 10px;" type="submit">글쓰기</button>
				</form>
			</div>
			
		</div>
		
		<div class="col"></div>
		
	</div>

</body>
</html>