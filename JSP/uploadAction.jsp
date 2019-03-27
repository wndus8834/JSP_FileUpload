<%@ page import="file.FileDAO" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.Enumeration" %>
<!-- 똑같은 파일이 발견되는 경우 자동으로 파일 이름들을 바꾸어주고 오류가 발생하지 않도록 족용해주는 등
 그러한 전반적인 파일 이름과 관련한 처리들을 도와주는 하나의 클래스 -->
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %> <!-- 파일업로드를 수행할 수 잇도록 -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP 파일 업로드</title>
</head>
<body>
	<%
		//애플리케이션 내장 객체 사용한다.(전체 프로젝트에 대한 자원을 관리하는 객체.)
		//(이것을 이용해서 서버의 실제 프로젝트 경로에서 자원을 찾을 수 있다.)
		// 즉, 만들어놓은 업로드 폴더 안에 실제로 파일을 저장할 수 있도록 만들어준다. ->자원 관련 객체
		//String directory = application.getRealPath("/upload/");
		String directory = "C:/JSP/UploadTest/";//마지막에 "/" 넣어줘야 정해진 확장자가 아닐경우 directory 안에 있는 fileRealName 정상적으로 삭제된다.
		int maxSize = 1024*1024*100; // 총 100메가바이트까지만 저장가능
		String encoding="UTF-8";
		
		//업로드 수행
		MultipartRequest multipartRequest
		= new MultipartRequest(request, directory, maxSize, encoding, 
				new DefaultFileRenamePolicy());
		
		//Enumeration은 for문과 같은 형식으로 사용한다.
		//여러 개의 파일 데이터가 있을 때 그런 파일 데이터들을 한개씩 분석하기 위한 목적으로 사용한다.
		//모든 파일을 다 받아 온 이후에 한개씩 확인해서 처리를 해준다.
		//java util 패키지에 존재한다.
		//while문을 이용해 파일을 하나씩 확인한다.(파일이 존재하는 한 계속해서 1개씩 반복적으로 찾을 수 있도록 만들어준다.)
		Enumeration fileNames = multipartRequest.getFileNames();
		while(fileNames.hasMoreElements()){
			String parameter=(String)fileNames.nextElement();//파일 데이터가 여러개이기 때문에 parameter 변수를 만들어줘서 처리를 한다.
			//index에서 받은 file이라는 객체, 사용자가 업로드 하고자 하는 파일 이름을 fileName에 준다.
			String fileName=multipartRequest.getOriginalFileName(parameter);
			//실제로 서버에 업로드가 된 FilesystemName을 가져올수 있도록
			String fileRealName=multipartRequest.getFilesystemName(parameter);
			
			
			if(fileName == null) continue;//만약 파일을 1,3에만 업로드하고 2에 업로드 하지 않으면 2를 null값으로 줘서 처리가 되지 않도록해준다.
			
			//특정한 확장자인지 확인(보안 문제)
			//사용자가 업로드한 이후에 확장자를 검증한 후, 올바른 확장자가 아니라면 해당 파일을 지운다.
			//그렇지 않고 올바른 파일인 경우에는 해당 파일이 어떻게 올라갔는지 알려준다.
			
			//일단 업로드를 수행한 후에 나중에 업로드할 수 없는 확장자인 경우는 그때가서 삭제를 진행하기 때문에 오류가 발생할 수 있다.
			//jsp의 특성상 새로운 사용자가 접근을 하게 되면 새로운 스레드를 만들어서 많은 사용자들한테 어떠한 서비스를 제공한다.
			//이는 멀티 스레딩 방식에서 일종의 레이스 컨디션이라는 취약점이 발생할 수 있다.
			//지정한 확장자가 아닐 경우 아래의 코드에 따르면 파일이 업로드 되었다가 삭제가 되는 것인데 이는 사용자의 눈에는 거의 보이지 않는 속도로 진행될 것이다.
			//하지만 논지적으로는 이렇게 업로드 되었다가 삭제가 이루어지는 것이기 때문에 그 순간에는 공백이 생기게 된다.
			//사용자가 악의적으로 무한적으로 업로드하는 프로그램을 작성하게 된다면 경쟁 상태에 빠지게 되고,
			//서버에서 하나의 스레드는 이것을 계속해서 실행하려고 하고, 다른 스레드에서는 계속해서 삭제하려고 하기 때문에 언젠가는 한번쯤 실행이 될 수 있다.
			//이런 식으로 레이스 컨디션, 즉 경쟁 상태를 유발함으로써 한번이라도 해당 파일을 실행하도록 만들어서 실제로 웹쉘 기능을 수행시킬 수가 있다.
			//이러한 취약점을 원천 봉쇄하기 위해서는 파일의 루트 디렉터리 바깥쪽에 업로드 폴더를 위치 시키는 것이다.
			//즉 사용자가 업로드 폴더를 입력해서 특정한 파일을 볼수 없도록 만들어줘야한다.
			//만약 업로드 폴더가 파일의 루트 디렉토리 안쪽에 존재하지 않아서 공격자가 함부로 접근할 수 없는 상태라면 아예 공격할 수 있는 수단이 존재하지 않아서
			//업로드 폴더를 루트 디렉토리 바깥쪽에 위치 시킴으로써 완전하게 이러한 공격을 봉쇄할 수 있게된다.
			if(!fileName.endsWith(".doc") && !fileName.endsWith(".xls") && !fileName.endsWith(".docx")){
				File file = new File(directory + fileRealName);
				file.delete();
				out.write("업로드할 수 없는 확장자입니다.");
			}
			else{
				new FileDAO().upload(fileName, fileRealName);
				out.write("파일명 : "+fileName + "<br>");
				out.write("실제 파일명 : "+fileRealName + "<br>");
			}
			
		}
		
		
		
		
	%>
</body>
</html>