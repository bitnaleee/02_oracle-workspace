-- 한줄짜리 주석
/*
   여러줄
   주석
   
   도구 > 환경설정 > Environment > 인코딩 UTF - 8로 변경
   
*/
SELECT * FROM DBA_USERS; -- 현재 모든 계정들에 대해서 조회하는 명령문
-- 명령문 하나 실행 (위쪽의 재생버튼 클릭 : CTRL + ENTER)

-- 일반 사용자계정 생성하는 구문(오로지 관리자 계정에서만 할 수 있음!)
-- [표현법] : CREATE USER 계정명 IDENTIFIED BY 비밀번호;
CREATE USER BR IDENTIFIED BY BR;

-- 위에서 생성된 일반 사용자계정에게 최소한의 권한 부여 (데이터관리, 접속) 부여
-- [표현법] : GRANT 권한1, 권한2, ... TO 계정명;
GRANT RESOURCE, CONNECT TO br;
-- 계정명은 대소문자 가리지 않음 (단, 비밀번호는 가림)


