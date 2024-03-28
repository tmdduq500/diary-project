<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
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
	<title></title>
</head>
<body>
	<h1>statsLunch</h1>
	
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
	
	<table border="1" style="width: 400px;">
		<tr>
			<%	
				String[] color = {"#FF0000", "#FF5E00", "#FFE400", "#1DDB16", "#0054FF"};
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
					<td>
						<%=getMenuStatRs.getString("menu")%>
					</td>
			<%		
				}
			%>
		</tr>
	</table>
	
	
	
</body>
</html>