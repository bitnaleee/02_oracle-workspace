/*
    < DDL 데이터 정의 언어 >
    객체들을 생성(CREATE), 변경(ALTER), 삭제(DROP)하는 구문
    
    < ALTER >
    객체를 변경하는 구문
    
    [표현법]
    ALTER TABLE 테이블명 변경할내용;
    
    * 변경할 내용
    1) 컬럼 추가 / 수정 / 삭제
    2) 제약조건 추가 / 삭제
    3) 컬럼명 / 제약조건명 / 테이블명 수정
    
*/

-- 1) 컬럼
-- 1_1) 컬럼 추가 (ADD) : ADD 컬럼명 자료형 [DEFAULT 기본값]
-- DEPT_COPY에 CNAME 컬럼 추가
ALTER TABLE DEPT_COPY ADD CNAME VARCHAR2(20);
--> 새로운 컬럼이 만들어지고 기본적으로 NULL로 채워짐

-- DEPT_COPY에 LNAME 컬럼 추가 (기본값 지정)
ALTER TABLE DEPT_COPY ADD LNAME VARCHAR2(20) DEFAULT '한국';
--> 새로운 컬럼이 만들어지고 내가 지정한 DEFAULT값으로 채워짐

SELECT * FROM DEPT_COPY;

-- 1_2) 컬럼 수정 (MODIFY)
--      > 데이터타입 수정 : MODIFY 컬럼명 바꾸고자하는 데이터타입
--      > DEFAULT값 수정 : MODIFY 컬럼명 DEFAULT 바꾸고자하는기본값

ALTER TABLE DEPT_COPY MODIFY DEPT_ID CHAR(3);
-- ALTER TABLE DEPT_COPY MODIFY DEPT_ID NUMBER; -- 오류발생
-- ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE VARCHAR2(10); -- 오류발생

-- DEPT_TITLE 컬럼을 VARCHAR2(40)로
-- LOCATION_ID 컬럼을 VARCHAR2(2)로
-- LNAME 컬럼의 기본값을 '미국'으로 변경
ALTER TABLE DEPT_COPY
    MODIFY DEPT_TITLE VARCHAR2(40)
    MODIFY LOCATION_ID VARCHAR2(2)
    MODIFY LNAME DEFAULT '미국';  -- 다중 변경 가능
    
-- 1_3) 컬럼 삭제 (DROP COLUMN) : DROP COLUMN 삭제하고자하는컬럼명
ALTER TABLE EMP_NEW DROP COLUMN SALARY;
ALTER TABLE EMP_NEW DROP COLUMN EMP_NAME;
ALTER TABLE EMP_NEW DROP COLUMN HIRE_DATE;

ALTER TABLE EMP_NEW DROP COLUMN EMP_ID; -- 모든 컬럼 삭제할 수 없어서 마지막 한개는 오류
--> 최소 한 개의 컬럼은 존재해야됨

SELECT * FROM EMP_NEW;

ROLLBACK;   --> DDL구문은 취소시킬 수 없음

--------------------------------------------------------------------------------

-- 2) 제약조건 추가 / 삭제
/*
    2_1) 제약조건 추가
    PRIMARY KEY : ADD PRIMARY KEY(컬럼명)
    FOREIGN KEY : ADD FOREIGN KEY (컬럼명) REFERENCES 참조할테이블명 [(컬럼명)] [삭제옵션]
    UNIQUE      : ADD UNIQUE(컬럼명)
    CHECK       : ADD CHECK(컬럼에대한조건)
    NOT NULL    : MODIFY 컬럼명 NOT NULL | NULL

*/

-- DEPT_COPY 테이블로부터
-- DEPT_ID에 PRIMARY KEY 제약조건 추가
-- DEPT_TITLE에 UNIQUE 제약조건 추가
-- LNAME에 NOT NULL 제약조건 추가

ALTER TABLE DEPT_COPY
    ADD CONSTRAINT DCOPY_PK PRIMARY KEY(DEPT_ID)
    ADD CONSTRAINT DCOPY_UQ UNIQUE(DEPT_TITLE)
    MODIFY LNAME CONSTRAINT DCOPY_NN NOT NULL;

-- 2_2) 제약조건 삭제 : DROP CONSTRAINT 제약조건명 / MODIFY 컬럼명 NULL (NOT NULL같은 경우)
ALTER TABLE DEPT_COPY DROP CONSTRAINT DCOPY_PK;

ALTER TABLE DEPT_COPY
    DROP CONSTRAINT DCOPY_UQ
    MODIFY LNAME NULL;

--------------------------------------------------------------------------------

-- 3) 컬럼명 / 제약조건명 / 테이블명 변경 (RENAME)
-- 3_1) 컬럼명 변경 : RENAME COLUMN 기존컬럼명 TO 바꿀컬럼명
ALTER TABLE DEPT_COPY RENAME COLUMN DEPT_TITLE TO DEPT_NAME;

-- 3_2) 제약조건명 변경 : RENAME CONSTRAINT 기존제약조건명 TO 바꿀제약조건명
ALTER TABLE DEPT_COPY RENAME CONSTRAINT SYS_C007182 TO LID_NN;

-- 3_3) 테이블명 변경 : RENAME [기존테이블명] TO 바꿀테이블명
ALTER TABLE DEPT_COPY RENAME TO DEPT_TEST;

SELECT * FROM DEPT_TEST;

--------------------------------------------------------------------------------

-- 테이블 삭제
DROP TABLE DEPT_TEST;

-- 단, 어딘가에 참조되고 있는 부모테이블은 함부로 삭제 안됨!
-- 만약에 삭제하고자 한다면
-- 방법1. 자식 테이블 먼저 삭제한 후 부모테이블 삭제하는 방법
-- 방법2. DROP TABLE 테이블명 CASCADE CONSTRAINT;
--       부모테이블만 삭제하는데 제약조건까지 같이 삭제하는 방법









