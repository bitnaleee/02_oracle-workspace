/*
    DQL (QUERY 데이터 질의 언어) : SELECT(쿼리문)
    
    DML (MANIPULATION 데이터 조작 언어) : INSERT, UPDATE, DELETE
    DDL (DEFINITION 데이터 정의 언어) : CREATE, ALTER, DROP
    DCL (CONTROL 데이터 제어 언어) : GRANT, REVOKE, [COMMIT, ROLLBACK]
    
    TCL (TRANSATION 트랜잭션 제어 언어) : COMMIT, ROLLBACK
    
    < DML 데이터 조작언어 >
    테이블에 데이터를 삽입(INSERT)하거나, 수정(UPDATE)하거나, 삭제(DELETE)하는 구문 
    
*/

/*
    1. INSERT
       테이블에 새로운 행을 추가시키는 구문
       
       [표현법]
       1) 특정 컬럼을 지정하지 않고 삽입하고자 할 때
          INSERT INTO 테이블명 VALUES(값, 값, 값, 값, ...);
          컬럼 순번을 지켜서 VALUES에 값을 나열해야됨! (컬럼 갯수 만큼 값 제시)
          
          부족하게 값을 제시했을 경우 => not enough values 오류
          값을 더 많이 제시했을 경우 => too many values 오류
    
*/

INSERT INTO EMPLOYEE
VALUES(900, '장채현', '980914-2341625', 'jang_ch@br.com', '01011112222', 'D1', 'J7', 4000000, 0.2, 200, SYSDATE, NULL, DEFAULT);

SELECT * FROM EMPLOYEE WHERE EMP_NAME = '장채현';

/*
    2) 특정 컬럼을 선택해서 값을 제시하고자 할 때
    INSERT INTO 테이블명(컬럼명, 컬럼명, 컬럼명) VALUES(값, 값, 값);

    한 행으로 추가되기 때문에 선택안된 컬럼에는 기본적으로 NULL이라도 들어감
    => NOT NULL 제약조건이 걸려있는 컬럼은 반드시 선택해서 직접 값 제시해야됨
       단, 기본값(DEFAULT)이 지정되어있으면 NULL 아닌 기본값이 들어감
*/

INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE)
VALUES(901, '강람보', '840918-2233445', 'J7', SYSDATE);

SELECT * FROM EMPLOYEE WHERE EMP_NAME = '강람보';

INSERT
INTO EMPLOYEE
     (
     EMP_ID
   , EMP_NAME
   , EMP_NO
   , JOB_CODE
   , HIRE_DATE
   )
VALUES
     (
        901
    , '강람보'
    , '840918-2233445'
    , 'J7'
    , TO_DATE('901223 143000', 'RRMMDD HH24MISS')
    );

--------------------------------------------------------------------------------

/*
    3) 서브쿼리를 수행 결과값을 통채로 INSERT하고자 할 때
    INSERT INTO 테이블명
    (서브쿼리);

*/

-- 새로운 테이블 세팅
CREATE TABLE EMP_01(
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(20),
    DEPT_TITLE VARCHAR2(20)
);

SELECT * FROM EMP_01;

INSERT INTO EMP_01
(
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE
      FROM EMPLOYEE
      JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
);

SELECT * FROM EMP_01;

--------------------------------------------------------------------------------

/*
    2. INSERT ALL
       두 개 이상의 테이블에 각각 INSERT 할 때
       사용되는 서브쿼리가 동일할 경우 

*/

--> 새로운 테이블 2개 만들기
CREATE TABLE EMP_DEPT
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
     FROM EMPLOYEE
    WHERE 1 = 0;
    
CREATE TABLE EMP_MANAGER
AS SELECT EMP_ID, EMP_NAME, MANAGER_ID
     FROM EMPLOYEE
    WHERE 1 = 0;

-- 부서코드가 D1인 사원들의 사번, 이름, 부서코드, 입사일, 사수사번 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

/*
    [표현법]
    1) 
    INSERT ALL
    INTO 테이블명1 VALUES(컬럼명, 컬럼명, 컬럼명,...)
    INTO 테이블명2 VALUES(컬럼명, 컬럼명, ...)
        서브쿼리;
    
*/

INSERT ALL
INTO EMP_DEPT VALUES(EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE)
INTO EMP_MANAGER VALUES(EMP_ID, EMP_NAME, MANAGER_ID)
    SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
      FROM EMPLOYEE
     WHERE DEPT_CODE = 'D1';
     

-- * 조건을 사용해서도 각 테이블 INSERT 가능
CREATE TABLE EMP_OLD
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
     FROM EMPLOYEE
    WHERE 1 = 0;

CREATE TABLE EMP_NEW
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
     FROM EMPLOYEE
    WHERE 1 = 0;
    
/*
    2)
    INSERT ALL
    WHEN 조건1 THEN
        INTO 테이블명1 VALUES(컬럼명, 컬럼명, ...)
    WHEN 조건2 THEN
        INTO 테이블명2 VALUES(컬럼명, 컬럼명, ...)
    서브쿼리;

*/

INSERT ALL
WHEN HIRE_DATE < '2000/01/01' THEN
    INTO EMP_OLD VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
WHEN HIRE_DATE >= '2000/01/01' THEN
    INTO EMP_NEW VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
    SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
    FROM EMPLOYEE;

--------------------------------------------------------------------------------

-- 추가 : INSERT시 컬럼값으로 서브쿼리를 써도 됨
INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, SALARY)
VALUES(500, '김채원', '900912-2345676', 'J7', (SELECT MAX(SALARY) FROM EMPLOYEE));

SELECT * FROM EMPLOYEE;

--------------------------------------------------------------------------------

/*
    3. UPDATE
    테이블에 기록되어있는 기존의 데이터를 수정하는 구문
    
    [표현법]
    UPDATE 테이블명
    SET 컬럼명 = 바꿀값, 
        컬럼명 = 바꿀값,
        ... --> 여러개의 컬럼값 동시변경 가능 (,로 나열해야됨)
    [WHERE 조건]; --> 생략하면 전체 모든 행의 데이터가 변경됨
    
*/

-- 복사본 테이블 만들기
CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPARTMENT;

SELECT * FROM DEPT_COPY;

-- D9부서의 부서명을 '전략기획팀'으로 수정
UPDATE DEPT_COPY
SET DEPT_TITLE = '전략기획팀';   -- WHERE을 까먹고 안썼을 경우 전체 9행이 업데이트 됨ㅜ

ROLLBACK; 

UPDATE DEPT_COPY
SET DEPT_TITLE = '전략기획팀'
WHERE DEPT_ID = 'D9';   

-- 복사본 테이블 만들기
CREATE TABLE EMP_SALARY
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY, BONUS
     FROM EMPLOYEE;
     
SELECT * FROM EMP_SALARY;

-- 노옹철 사원의 급여를 100만원으로 변경
UPDATE EMP_SALARY
SET SALARY = 1000000
WHERE EMP_NAME = '노옹철';

-- 선동일 사원의 급여를 700만원으로, 보너스는 0.2로 변경
UPDATE EMP_SALARY
SET SALARY = 7000000, BONUS = 0.2 -- AND 아니고 ,(콤마)
WHERE EMP_NAME = '선동일'; -- WHERE절에 만족하는 숫자기 때문에 1행이 업데이트되었습니다. 라고 뜸

-- 전체 사원의 급여를 기존의 급여에 10프로를 인상한 금액(SALARY * 1.1)변경
UPDATE EMP_SALARY
SET SALARY = SALARY * 1.1;

-- * UPDATE문 안에 서브쿼리 예시

-- 방명수 사원의 급여와 보너스값을 유재식 사원의 급여와 보너스값으로 변경
UPDATE EMP_SALARY
SET SALARY = (SELECT SALARY -- 유재식사원의급여
                FROM EMP_SALARY
               WHERE EMP_NAME = '유재식'),
     BONUS = (SELECT BONUS -- 유재식사원의보너스
                 FROM EMP_SALARY
                WHERE EMP_NAME = '유재식')
WHERE EMP_NAME = '방명수';

-- 다중열 서브쿼리로도 가능
UPDATE EMP_SALARY
SET (SALARY, BONUS) = (SELECT SALARY, BONUS
                         FROM EMP_SALARY
                        WHERE EMP_NAME = '유재식')
WHERE EMP_NAME = '방명수';

SELECT * FROM EMP_SALARY;

-- EMP_SALARY로부터 보너스값을 0.3으로 변경
-- 단, ASIA 지역에서 근무하는 사원들만
UPDATE EMP_SALARY
SET BONUS = 0.3
WHERE EMP_ID IN (SELECT EMP_ID   -- ASIA지역에 근무하는 사원번호
                  FROM EMP_SALARY
                  JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
                  JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
                 WHERE LOCAL_NAME LIKE 'ASIA%');

-- * UPDATE시에도 해당 컬럼에 대한 제약조건에 위배되서는 안됨
-- 사번이 200번인 사원의 이름을 NULL로 변경
UPDATE EMPLOYEE
SET EMP_NAME = NULL
WHERE EMP_ID = 200; --> 오류발생 (NOT NULL 제약조건 위배)

-- 노옹철 사원의 직급코드를 J9로 변경
UPDATE EMPLOYEE
SET JOB_CODE = 'J9'
WHERE EMP_NAME = '노옹철'; --> 오류발생 (FOREIGN KEY 제약조건 위배)

--------------------------------------------------------------------------------

/*
    4. DELETE
    테이블에 기록된 데이터를 삭제하는 구문 (한 행 단위로 삭제됨)
    
    [표현법]
    DELETE FROM 테이블명
    [WHERE 조건]; --> WHERE절 제시 안하면 전체 행 다 삭제됨
    
*/

-- 장채현 사원의 데이터 지우기
DELETE FROM EMPLOYEE;

ROLLBACK;

DELETE FROM EMPLOYEE
WHERE EMP_NAME = '장채현';

-- 강람보 사원 지우기 + 김말순
DELETE FROM EMPLOYEE
WHERE EMP_NAME IN ('강람보','김말순');

COMMIT;
ROLLBACK;   -- 최종 마지막으로 수행된 COMMTIO 시점으로 돌아감

-- DEPT_ID가 D1인 부서를 삭제
DELETE FROM DEPARTMENT
WHERE DEPT_ID = 'D1';   -- D1을 쓰고 있는 자식데이터 있기 때문에 삭제가 안됨

-- DEPT_ID가 D3인 부서를 삭제
DELETE FROM DEPARTMENT
WHERE DEPT_ID = 'D3'; -- D3을 쓰고 있는 자식데이터가 없기 때문에 삭제됨

ROLLBACK;

-- 삭제 시 외래키 제약조건에 의해서 삭제가 불가능할 경우
-- 잠시 제약조건을 비활성화 시킬 수 있음

ALTER TABLE EMPLOYEE DISABLE CONSTRAINT SYS_C007175 CASCADE;    -- 비활성화
INSERT INTO DEPARTMENT VALUES('D1', '인사관리부','L1');
ALTER TABLE EMPLOYEE ENABLE CONSTRAINT SYS_C007175; -- 활성화

-- * TRUNCATE : 테이블의 전체 행을 삭제할 때 사용되는 구문
--              DELETE 보다 수행속도가 더 빠름
--              별도의 조건 제시 불가, ROLLBACK이 불가함

-- [표현법] TRUNCATE TABLE 테이블명;

SELECT * FROM EMP_SALARY;

TRUNCATE TABLE EMP_SALARY; -- 테이블값이 지워진 것 구성은 있음
ROLLBACK;









