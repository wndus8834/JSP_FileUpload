<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP 파일 업로드</title>
</head>
<body>
	<form action="uploadAction.jsp" method="post" enctype="multipart/form-data">
	<!-- multipart리퀘스트와 매칭된다. 실제로 여러개의 파일이 폼태그를 이용해서 서버로 전달될 수 있다. -->
	<!-- 이러한 양식은 jsp뿐 아니라 다른 프로그래밍 언어에서도 거의 동일하게 적용된다. -->	
		파일: <input type="file" name="file1"><br>
		파일: <input type="file" name="file2"><br>
		파일: <input type="file" name="file3"><br>
		<input type="submit" value="업로드">
	</form>
	<br>
	<a href="fileDownload.jsp">파일 다운로드 페이지</a>
</body>
</html>