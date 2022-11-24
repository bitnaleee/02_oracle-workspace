/*
    < VIEW 뷰 >
    
    SELECT문(쿼리문)을 저장해둘 수 있는 객체
    (자주 쓰는 긴 SELECT문을 저장해두면 매번 긴 SELECT문을 다시 기술할 필요 없음)
    임시테이블 같은 존재 (실제 데이터가 담겨있는건 아님! => 논리적인 테이블)
*/

-- '한국'에서 근무하는 사원들의 사번, 이름, 부서명, 급여, 근무국가명 조회 
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
JOIN NATIONAL USING(NATIONAL_CODE)
WHERE NATIONAL_NAME = '한국';

-- '러시아'에서 근무하는 사원들의 사번, 이름, 부서명, 급여, 근무국가명 조회 
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
JOIN NATIONAL USING(NATIONAL_CODE)
WHERE NATIONAL_NAME = '러시아';

-- '일본'에서 근무하는 사원들의 사번, 이름, 부서명, 급여, 근무국가명 조회 
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
JOIN NATIONAL USING(NATIONAL_CODE)
WHERE NATIONAL_NAME = '일본';

-------------------------------------------------------------------------------

/*
    1. VIEW 생성 
    
    [기본표현법]
    CREATE [OR REPLACE] VIEW 뷰명
    AS 저장시키고자하는쿼리문(==서브쿼리);
    
    [OR REPLACE] : 뷰 생성시 중복된 이름의 뷰가 없으면 새로이 뷰를 생성
                            중복된 이름의 뷰가 있다면 해당 뷰를 변경(갱신)하는 옵션
*/
CREATE OR REPLACE VIEW VW_EMPLOYEE
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME, BONUS
    FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
    JOIN NATIONAL USING(NATIONAL_CODE);

GRANT CREATE VIEW TO BR; --> 관리자 계정에서 실행 해야됨

SELECT *
FROM VW_EMPLOYEE;
--> 아래와 같은 맥락
SELECT *
FROM (SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
        FROM EMPLOYEE
        JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
        JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
        JOIN NATIONAL USING(NATIONAL_CODE));

--> 뷰는 논리적인 가상 테이블 (실제 데이터를 저장하고 있지 않음)

-- '한국', '러시아', '일본' 에 근무
SELECT *
FROM VW_EMPLOYEE
WHERE NATIONAL_NAME = '한국';

SELECT EMP_NAME, SALARY, BONUS
FROM VW_EMPLOYEE
WHERE NATIONAL_NAME = '러시아';

-- [참고] USER_VIEWS : 현재 이 사용자가 가지고 있는 뷰 객체에 대한 정보를 조회할 수 있는 시스템 테이블
SELECT * FROM USER_VIEWS;

--------------------------------------------------------------------------------

/*
    * 뷰 컬럼에 별칭 부여
      서브쿼리의 SELECT절에 산술연산식, 함수식을 기술했을 경우 반드시 별칭 지정해야됨
*/

-- 전 사원의 사번, 이름, 직급명, 성별(남/여), 근무년수를 조회할 수 있는 SELECT문 
CREATE OR REPLACE VIEW VW_EMP_JOB
AS SELECT EMP_ID, EMP_NAME, JOB_NAME, 
          DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') "성별",
          EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) "근무년수" 
     FROM EMPLOYEE
     JOIN JOB USING(JOB_CODE);

-- 아래와 같은 방법도 가능 (단, 모든 컬럼에 대한 별칭을 다 작성)
CREATE OR REPLACE VIEW VW_EMP_JOB(사번, 이름, 직급명, 성별, 근무년수)
AS SELECT EMP_ID, EMP_NAME, JOB_NAME, 
          DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여'),
          EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
     FROM EMPLOYEE
     JOIN JOB USING(JOB_CODE);

SELECT * FROM VW_EMP_JOB;

SELECT 이름, 직급명
FROM VW_EMP_JOB
WHERE 근무년수 >= 20;

 SELECT *
   FROM VW_EMP_JOB
  WHERE 성별 = '여';

-- 뷰 삭제하고자 한다면 
DROP VIEW VW_EMP_JOB;

------------------------------------------------------------------------------

-- 생성된 뷰를 이용해서 DML(INSERT, UPDATE, DELETE) 가능하긴 함
-- 뷰를 통해서 조작하면 실제 데이터가 담겨있는 "베이스테이블"에 반영됨 
CREATE OR REPLACE VIEW VW_JOB
AS SELECT JOB_CODE, JOB_NAME
     FROM JOB;
     
SELECT * FROM VW_JOB; -- 논리적인 테이블
SELECT * FROM JOB;    -- 베이스 테이블 (실제 데이터가 담겨있는)

-- 뷰를 통해서 INSERT
INSERT INTO VW_JOB VALUES('J8', '인턴');

-- 뷰를 통해서 UPDATE
UPDATE VW_JOB
   SET JOB_NAME = '알바'
 WHERE JOB_CODE = 'J8';

-- 뷰를 통해서 DELETE
DELETE FROM VW_JOB
 WHERE JOB_CODE = 'J8';

--------------------------------------------------------------------------------

/*
    * DML로 조작이 불가능한 경우가 더 많음
    
    1) 뷰에 정의되어있지 않은 컬럼을 조작하려고 하는 경우 
    2) 뷰에 정의되어있지 않은 컬럼 중에 베이스테이블상에 NOT NULL제약조건이 걸려 있는 경우 
    3) 산술연산식 또는 함수식으로 정의되어있는 경우
    4) 그룹함수나 GROUP BY절이 포함되어있는 경우 
    5) DISTINCT 구문이 포함되어있는 경우
    6) JOIN을 이용해서 여러 테이블을 연결시켜놓은 경우 
*/

-- 1) 뷰에 정의되어있지 않은 컬럼을 조작하려고 하는 경우 
CREATE OR REPLACE VIEW VW_JOB
AS SELECT JOB_CODE
     FROM JOB;

SELECT * FROM VW_JOB;
SELECT * FROM JOB;

-- INSERT (오류)
INSERT INTO VW_JOB(JOB_CODE, JOB_NAME) VALUES('J8', '인턴');

-- UPDATE (오류)
UPDATE VW_JOB
   SET JOB_NAME = '인턴'
 WHERE JOB_CODE = 'J7';

-- DELETE (오류)
DELETE
  FROM VW_JOB
 WHERE JOB_NAME = '대표';
 
-- 2) 뷰에 정의되어있지 않은 컬럼 중에 베이스테이블상에 NOT NULL제약조건이 걸려있는 경우
CREATE OR REPLACE VIEW VW_JOB
AS SELECT JOB_NAME
     FROM JOB;

SELECT * FROM VW_JOB;
SELECT * FROM JOB;

-- INSERT (오류)
INSERT INTO VW_JOB VALUES('인턴'); -- 실제 베이스테이블에 INSERT시 (NULL, '인턴') 추가

-- UPDATE 
UPDATE VW_JOB
   SET JOB_NAME = '알바'
 WHERE JOB_NAME = '사원';

UPDATE VW_JOB
   SET JOB_NAME = NULL
 WHERE JOB_NAME = '알바';

ROLLBACK;

-- DELETE
DELETE FROM VW_JOB
WHERE JOB_NAME = '사원';

-- 3) 함수식 또는 산술연산식으로 정의된 경우
CREATE OR REPLACE VIEW VW_EMP_SAL
AS SELECT EMP_ID, EMP_NAME, SALARY * 12 "연봉", SUBSTR(EMP_NO, 8, 1) "성별"
     FROM EMPLOYEE;

SELECT * FROM VW_EMP_SAL;
SELECT * FROM EMPLOYEE;

-- INSERT (오류)
INSERT INTO VW_EMP_SAL VALUES(400, '홍길동', 40000000, 1);
INSERT INTO VW_EMP_SAL(EMP_ID, EMP_NAME) VALUES(400, '홍길동');

-- UPDATE
-- 200번 사원의 연봉을 8000만원으로 
UPDATE VW_EMP_SAL
   SET 연봉 = 80000000
 WHERE EMP_ID = 200; -- 에러

-- 200번 사원의 이름을 성동일로 
UPDATE VW_EMP_SAL
   SET EMP_NAME = '성동일'
 WHERE EMP_ID = 200; -- 성공

-- 연봉이 72000000인 사원의 이름을 송중기로 변경
UPDATE VW_EMP_SAL
   SET EMP_NAME = '송중기'
 WHERE 연봉 = 72000000; -- 성공

-- DELETE
DELETE FROM VW_EMP_SAL
WHERE 성별 = 2; -- 성공

ROLLBACK;

-- 4) 그룹함수 또는 GROUP BY절을 포함하는 경우 
CREATE OR REPLACE VIEW VW_GROUPDEPT
AS SELECT DEPT_CODE, SUM(SALARY) "합계", FLOOR(AVG(SALARY)) "평균"
     FROM EMPLOYEE 
    GROUP
       BY DEPT_CODE;

SELECT * FROM VW_GROUPDEPT;
SELECT * FROM EMPLOYEE;

-- INSERT (오류)
INSERT INTO VW_GROUPDEPT VALUES('D3', 8000000, 4000000);
-- UPDATE (오류)
 UPDATE VW_GROUPDEPT
   SET 평균 = 3000000
 WHERE DEPT_CODE = 'D1';
-- DELETE (오류)
DELETE FROM VW_GROUPDEPT
WHERE 합계 = 7820000;

-- 5) DISTINCT가 포함된 경우 
CREATE OR REPLACE VIEW VW_EMP_JOB
AS SELECT DISTINCT JOB_CODE
     FROM EMPLOYEE;

SELECT * FROM VW_EMP_JOB;
SELECT * FROM EMPLOYEE;

-- INSERT (오류)
INSERT INTO VW_EMP_JOB VALUES('J8');

-- UPDATE (오류)
UPDATE VW_EMP_JOB
   SET JOB_CODE = 'J8'
 WHERE JOB_CODE = 'J7';

-- DELETE (오류)
DELETE FROM VW_EMP_JOB
WHERE JOB_CODE = 'J7';

-- 6) JOIN을 이용해서 여러 테이블을 연결해둔 경우 
CREATE OR REPLACE VIEW VW_JOINEMP
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE
     FROM EMPLOYEE
     JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

SELECT * FROM VW_JOINEMP;
SELECT * FROM EMPLOYEE;

-- INSERT (에러)
INSERT INTO VW_JOINEMP VALUES(300, '조세오', '기술지원부');
-- UPDATE
UPDATE VW_JOINEMP
   SET EMP_NAME = '서동일'
 WHERE EMP_ID = 200; -- 성공
 
UPDATE VW_JOINEMP
   SET DEPT_TITLE = '회계부'
 WHERE EMP_ID = 200; -- 에러
 
UPDATE VW_JOINEMP
   SET EMP_NAME = '홍길동'
 WHERE DEPT_TITLE = '총무부'; -- 성공 
 
-- DELETE
DELETE FROM VW_JOINEMP
WHERE DEPT_TITLE = '총무부'; -- 성공

ROLLBACK;

-------------------------------------------------------------------------------
/*
    * VIEW 옵션
    
    [상세표현법]
    CREATE [OR REPLACE] [FORCE|"NOFORCE"] VIEW 뷰명
    AS 서브쿼리
    [WITH CHECK OPTION]
    [WITH READ ONLY];
    
    - FORCE/NOFORCE
        > FORCE : 서브쿼리에 기술된 테이블이 존재하지 않아도 뷰 생성 가능 
        > NOFORCE : 서브쿼리에 기술된 테이블이 존재해야만 뷰 생성 가능 (생략시 기본값)
    - WITH CHECK OPTION : DML시 서브쿼리에 기술된 조건에 부합하는 값으로만 DML이 가능하도록
    - WITH READ ONLY : 뷰에 대해 조회만 가능 (DML문 수행불가)
    
*/
-- NOFORCE
CREATE OR REPLACE /*NOFORCE*/ VIEW VW_TEST
AS SELECT TCODE, TNAME, TCONTENT
     FROM TT;
     
-- FORCE
CREATE OR REPLACE FORCE VIEW VW_TEST
AS SELECT TCODE, TNAME, TCONTENT
     FROM TT;
SELECT * FROM VW_TEST;

-- TT테이블을 생성해야만 그때부터 VIEW 활용 가능
CREATE TABLE TT(
    TCODE NUMBER,
    TNAME VARCHAR2(20),
    TCONTENT VARCHAR2(40)
);

-- WITH CHECK OPTION : 서브쿼리에 기술된 조건에 맞지 않으면 오류 발생 

CREATE OR REPLACE VIEW VW_EMP
AS SELECT *
     FROM EMPLOYEE
    WHERE SALARY >= 3000000; -- WITH CHECK OPTION X 

SELECT * FROM VW_EMP; -- 8명 조회

-- 200번 사원의 급여를 200만원으로 (서브쿼리의 조건에 부합되지 않는 값으로 변경)
UPDATE VW_EMP
  SET SALARY = 2000000
 WHERE EMP_ID = 200;

ROLLBACK;

CREATE OR REPLACE VIEW VW_EMP
AS SELECT *
     FROM EMPLOYEE
    WHERE SALARY >= 3000000
WITH CHECK OPTION;

SELECT * FROM VW_EMP;

UPDATE VW_EMP
   SET SALARY = 2000000
 WHERE EMP_ID = 200;

UPDATE VW_EMP
   SET SALARY = 4000000
 WHERE EMP_ID = 200;

SELECT * FROM EMPLOYEE;

-- WITH READ ONLY : 뷰에 대해 조회만 가능 (DML 불가능)
CREATE OR REPLACE VIEW VW_EMP
AS SELECT EMP_ID, EMP_NAME, BONUS
     FROM EMPLOYEE
    WHERE BONUS IS NOT NULL
WITH READ ONLY;

SELECT * FROM VW_EMP;

DELETE FROM VW_EMP
WHERE EMP_ID = 200;


