## JSP_FileUpload

* JSP 파일 업로드
    * 파일 업로드 기능이란 게시판, 프로필 사진 설정 등으로 웹 서버에 파일을 업로드 하는 기능입니다.
    * DB 연동, 웹 서버의 디스크 자원 차지 등 다양한 기능이 수행됩니다.

![ezgif-2-05821b332b80](https://user-images.githubusercontent.com/38427658/55099494-250ef600-5103-11e9-951d-3d2c4aab589f.gif)

* JSP 파일 업로드 긴으 구현 순서

    1. 데이터베이스 구축하기
        * 파일 업로드에서 반드시 구현되어야 할 정보는 두 가지입니다.
            1. 서버에 저장된 실제 파일의 이름
            2. 사용자가 저장한 파일의 이름

    2. 업로드 양식 페이지 작성하기

    3. 데이터베이스 연동 클래스 작성하기
        * COS 라이브러리와 JDBC라이브러리를 WEB-INF 폴더에 삽입합니다.
        * FILE 테이블 관련 DTO(Database Transfer Object)와 DAO(Database Access Object)를 작성합니다.

    4. 업로드 처리 페이지 작성하기

    5. 파일 다운로드 페이지 작성하기

    6. 보안 코딩(Secure Coding) 적용하기
        * 파일 업로드 취약점으로 대표적인 것은 Web Shell 업로드 취약점입니다.
        * ASP, JSP, PHP 모든 유형에서 적용이 가능한 기법입니다.