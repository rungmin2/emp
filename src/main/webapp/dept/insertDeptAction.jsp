<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.net.URLEncoder" %>
<%
	request.setCharacterEncoding("utf-8"); // 인코딩 
	// 안전장치
	if(request.getParameter("deptNo") == null || 
		request.getParameter("deptName") == null) {
		String msg = URLEncoder.encode("부서번호와 부서이름을 입력하세요","utf-8");
		response.sendRedirect(request.getContextPath()+"/dept/insertDeptForm.jsp?msg="+msg);
		return;
	}
	
	// 1. 요청 분석
	String deptNo = request.getParameter("deptNo");
	String deptName = request.getParameter("deptName");
	
	// 2. 요청 처리
	// 이미 존재하는 key(dept_no)값 동일한 값이 입력되면 예외(에러)가 발생한다. -> 동일한 dept_no값이 입력됐을때 예외가 발생하지 않도록
	Class.forName("org.mariadb.jdbc.Driver");	
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1234");
	// 2-1 dept_no 중복검사
	String sql1 = "SELECT dept_no FROM departments WHERE dept_no = ? OR dept_name = ?";
	PreparedStatement stmt1 = conn.prepareStatement(sql1);
	stmt1.setString(1, deptNo);
	stmt1.setString(2, deptName);
	ResultSet rs = stmt1.executeQuery();
	if(rs.next()) { // 같은 dept_no가 이미 존재한다.
		String msg = URLEncoder.encode("부서번호or부서이름이 중복되었습니다.","utf-8");
		response.sendRedirect(request.getContextPath()+"/dept/insertDeptForm.jsp?msg="+msg);
		return;
	}
	
	String sql2 = "insert into departments(dept_no, dept_name) values(?,?)";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, deptNo);
	stmt2.setString(2, deptName);
	
	// 디버깅
	int row = stmt2.executeUpdate();
	   if(row == 1) {
	      System.out.println("입력성공");
	   } else {
	      System.out.println("입력실패");
	   }
	
	   	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
	 
	// 3. 	   	
%>