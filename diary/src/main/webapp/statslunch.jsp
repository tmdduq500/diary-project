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
	// 메뉴당 몇번 먹었는지 추출하는 sql
	/*
		SELECT menu, COUNT(*) cnt FROM lunch
		GROUP BY menu;
	*/
	
	String getMenuStatSql = "SELECT menu, COUNT(*) cnt FROM lunch GROUP BY menu";
	PreparedStatement getMenuStatStmt = null;
	ResultSet getMenuStatRs = null;
	
	getMenuStatStmt = conn.prepareStatement(getMenuStatSql);
	getMenuStatRs = getMenuStatStmt.executeQuery();
	
%>
<%
	int maxHeight = 300;
	double totalCnt = 0;	//
	while(getMenuStatRs.next()) {
		totalCnt = totalCnt + getMenuStatRs.getInt("cnt");
	}
	System.out.println(totalCnt);
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>statsLunch</title>
</head>
<body>
	<h1>statsLunch</h1>
		
	<div>
		전체 투표수 : <%=(int)totalCnt %>
	</div>
	<table border="1" style="border-collapse : collapse;">
		<tr>	
			<%
				getMenuStatRs.beforeFirst();
			
				String[] color = {"#FF0000", "rgb(0, 79, 167)", "rgb(167, 79, 0)", "#00FF00", "#0000FF"};
				int colorIndex = 0;
				
				while(getMenuStatRs.next()) {
					int height =(int)(maxHeight * (getMenuStatRs.getInt("cnt") / totalCnt));
					System.out.println(height);
			%>
					<td style="vertical-align: bottom;">
						<div style="height: <%=height%>px;
									background-color: <%=color[colorIndex]%>;
									text-align: center;">
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
					<td><%=getMenuStatRs.getString("menu")%></td>
			<%
				}
			%>
		</tr>
	</table>
</body>
</html>