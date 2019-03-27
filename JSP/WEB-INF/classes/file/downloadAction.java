package file;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/downloadAction")
public class downloadAction extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//파일 이름은 기본적으로 사용자가 요청한 그 파일 이름으로 가져올수 있도록 한다.
		String fileName=request.getParameter("file");
		
		//실제 서버의 물리적인 경로에 있는 업로드 폴더 안에 있는 파일을 다운로드 받을수 있도록 한다.
		//실제로 해당 파일을 찾을 수 있도록 한다.
		//String directory=this.getServletContext().getRealPath("/upload/");
		String directory="C:/JSP/UploadTest";
		File file=new File(directory+"/"+fileName);// directory뒤 "/" 중요, 없으면 정해진 확장자가 아닐 경우에도 저장됨.
		
		//mimeType; 어떠한 데이터를 주고 받을지에 대한 정보를 담는 것
		//getMimeType를 이용해서 파일 데이터라는 것을 알려줄 수 있도록 한다.
		String mimeType=getServletContext().getMimeType(file.toString());
		if(mimeType==null) { //값이 null이라면 오류가 발생하지 않도록 set
			//서버가 접속한 사용자한테 응답을 하는 것이기 때문에 (서버가 응답하는 정보를 통해서)
			//사용자 입장에선 자기가 받는 데이터가 파일 정보라는 것을 response를 통해 알수있다.
			response.setContentType("application/octet-stream");//(이진 데이터 형식의 파일)파일 관련한 데이터를 주고 받을때는 octet-stream을 사용한다.
		}
		
		//실제 다운로드 받을 다운로드 네임
		//사용자가 현재 접속한 브라우저에 따라 다르게 적용해준다.
		//MSIE는 인터넷 익스플로러를 의미한다.
		String downloadName=null;
		if(request.getHeader("user-agent").indexOf("MSIE")==-1) {
			//인터넷 익스플로러 접속이 아닐 경우
			//파일 네임을 UTF-8방식으로 얻어서 8859_1 형식으로 바꿔준다.
			//8859_1 형식으로 인코딩을 처리한다면 전달할 데이터가 깨지지 않고 잘 전달이 된다.
			downloadName=new String(fileName.getBytes("EUC-KR"), "8859_1");
		}else {
			downloadName=new String(fileName.getBytes("EUC-KR"), "8859_1");
		}
		
		//헤더 처리
		//이후에 사용자한테 전달할 응답에서 Content-Disposition라는 헤더 속성에다가 filename을 (attachment)넣어서 보내준다.
		//브라우저에서는 지금 받는 것이 파일 데이터구나하고 인식을 한 뒤에 파일을 다운로드 받도록 수행할 수 있게 된다.
		response.setHeader("Content-Disposition", "attachment;filename=\""
				+ downloadName + "\";");
		
		//실제로 헤더처리까지 끝냈기 때문에 이제 response 패킷에 우리가 전달할 파일 데이터를 담아 줘야하기 때문에 FileInputStream을 이용한다.
		FileInputStream fileInputStream = new FileInputStream(file);
		ServletOutputStream servletOutputStream=response.getOutputStream();
		
		//실제로 우리가 데이터를 전송할 때는 바이트 단위로 쪼개서 보내줘야한다.
		byte b[]=new byte[1024];//한번에 1024 바이트 단위로 보낼 수 있다.
		int data=0;
		
		while((data = (fileInputStream.read(b, 0, b.length))) != -1) {
			//반복적으로 1024씩 보낸다.
			//사용자는 파일을 다로드할때 이 서버측에서의 ServletOutputStream 객체에 의해서 계속해서 데이터를 전달받게 된다.
			servletOutputStream.write(b, 0, data);
		}
		
		//업로드 후 다운로드 횟수 증가 표시
		new FileDAO().hit(fileName);
		
		//데이터를 다 보낸 이후에는 flush를 해줌으로써 남아있는 데이터를 전부 다 보내줄수 있도록 만들어준다.
		servletOutputStream.flush();
		servletOutputStream.close();
		fileInputStream.close();
	}


}
