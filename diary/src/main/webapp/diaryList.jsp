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
	/* 현재 페이지 구하기*/
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	System.out.println("diaryList - currentPage = " + currentPage);
	
	// 페이지당 보여줄 일기 개수 구하기
	int rowPerPage = 10;
// 	if(request.getParameter("rowPerPage") == null) {
// 		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
// 	}
	System.out.println("diaryList - rowPerPage = " + rowPerPage);
	
	int startRow = (currentPage-1)*rowPerPage; // 1-0, 2-10, 3-20, 4-30,....
	
	// 일기 제목 검색해서 찾기
	String searchWord = "";
	if(request.getParameter("searchWord") != null ) {
		searchWord = request.getParameter("searchWord");
	}
	System.out.println("diaryList - searchWord = " + searchWord);
	/*
		단어 검색해서 title찾고 data 찾아주는 SQL 쿼리
		SELECT diary_date diaryDate, title
		FROM diary
		WHERE title LIKE ?
		ORDER BY diary_date DESC
		LIMIT ?,?
	*/
	String searchSql = "SELECT diary_date diaryDate, title FROM diary WHERE title LIKE ? ORDER BY diary_date DESC LIMIT ?,?";
	
	PreparedStatement searchStmt = null;
	ResultSet searchRs = null;
	searchStmt = conn.prepareStatement(searchSql);
	searchStmt.setString(1, "%" + searchWord + "%");
	searchStmt.setInt(2, startRow);
	searchStmt.setInt(3, rowPerPage);
	System.out.println("diaryList - searchStmt = " + searchStmt);

	searchRs = searchStmt.executeQuery();
%>

<%
	/* 일기 목록 페이징 */
	
	// sql 쿼리문
	String pagingSql = "SELECT COUNT(*) cnt FROM diary WHERE title like ?";
	PreparedStatement pagingStmt = null;
	ResultSet pagingRs = null;
	
	pagingStmt = conn.prepareStatement(pagingSql);
	pagingStmt.setString(1, "%" + searchWord + "%");
	pagingRs = pagingStmt.executeQuery();
	
	// 검색한 전체 글 목록 개수 구하기
	int totalRow = 0;
	if(pagingRs.next()) {
		totalRow = pagingRs.getInt("cnt");
	}
	
	// 마지막 페이지 구하기
	int lastPage = totalRow / rowPerPage;
	if(totalRow % rowPerPage != 0) {
		lastPage += 1;
	}
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>diaryList</title>
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
		  padding: 10px;
		  text-align: left;
		  border-bottom: 1px solid #ddd;
		  text-align: center;
		  color: #000000;
		}
		
		th {
		  background-color: rgba(92, 138, 153, 0.5);
		  color: #000000;
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
					<h1 style="text-align: center; font-size: 60px;">일기 목록</h1>
				</div>
				
				<div class="col-4" style="text-align: right;">
					<form action="/diary/login/logoutAction.jsp" method="post">
						<button class="btn btn-outline-secondary" type="submit">로그아웃</button>
					</form>
				</div>
			</div>
			
			<hr>
			
			<table style="background-color: rgba(255, 255, 255, 0);">
				<tr>
					<th style="width: 50%;">날짜</th>
					<th>제목</th>
				</tr>
				<%
					while(searchRs.next()) {
				%>
						<tr>
							<td><%=searchRs.getString("diaryDate")%></td>
							<td>
								<a href='/diary/diaryOne.jsp?diaryDate=<%=searchRs.getString("diaryDate")%>'>
									<%=searchRs.getString("title")%>
								</a>
							</td>
						</tr>
				<%
					}
				%>
				
			</table>
			
			<div style="clear: both; text-align: center; margin-right: 80px;">
				<form action="/diary/add/addDiaryForm.jsp" style="text-align: right;">
					<button class="btn btn-outline-secondary" style="height: 40px; margin-top: 10px;" type="submit">글쓰기</button>
				</form>
			</div>
			
			<div>
				<!-- 페이징 버튼 -->
					<nav aria-label="Page navigation example">
						<ul class="pagination pagination-sm" style="margin-left: 300px;">
						<%
							if(currentPage > 1) {
						%>
								<li class="page-item">
									<a class ="page-link" href="/diary/diaryList.jsp?currentPage=1" style="color: #003F4B;">처음페이지</a>
								</li>
								<li class="page-item">
									<a class ="page-link" href="/diary/diaryList.jsp?currentPage=<%=currentPage-1%>" style="color: #003F4B;">이전페이지</a>
								</li>
						<%		
							} else {
						%>
								<li class="page-item disabled">
									<a class ="page-link" href="/diary/diaryList.jsp?currentPage=1">처음페이지</a>
								</li>
								<li class="page-item disabled">
									<a class ="page-link" href="/diary/diaryList.jsp?currentPage=<%=currentPage-1%>">이전페이지</a>
								</li>
						<%		
							}
						
							if(currentPage < lastPage) {
						%>
								<li class="page-item">
									<a class ="page-link" href="/diary/diaryList.jsp?currentPage=<%=currentPage+1%>" style="color: #003F4B;">다음페이지</a>
								</li>
								<li class="page-item">
									<a class ="page-link" href="/diary/diaryList.jsp?currentPage=<%=lastPage%>" style="color: #003F4B;">마지막페이지</a>
								</li>
						<%		
							} else {
						%>
								<li class="page-item disabled">
									<a class ="page-link" href="/diary/diaryList.jsp?currentPage=<%=currentPage+1%>" style="color: #003F4B;">다음페이지</a>
								</li>
								<li class="page-item disabled">
									<a class ="page-link" href="/diary/diaryList.jsp?currentPage=<%=lastPage%>" style="color: #003F4B;">마지막페이지</a>
								</li>
						<%
							}
						%>
						</ul>
					</nav>
				
		
				<div style="text-align: center;  margin-top: 10px;">
					<form action="/diary/diaryList.jsp" method="get">
						<div>
							제목 검색:
							<input type="text" name="searchWord" style="background-color: rgba(0,0,0,0);">
							<button type="submit" class="btn btn-outline-secondary" style="color: black;">검색하기</button>
						</div>
					</form>
				</div>	
				
			</div>
			
		</div>
		<div class="col"></div>
	</div>
</body>
</html>