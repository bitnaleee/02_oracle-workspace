
/*
    < PL/SQL >
    PROCEDURE LANGAUGE EXTENSION TO SQL 
    
    오라클에 내장되어 있는 절차적 언어로
    SQL문 내에서 변수 활용, 조건처리(IF), 반복처리(LOOP, FOR, WHILE)등을 지원하여 SQL의 단점을 보완 
    다수의 SQL문을 한번에 실행 가능 (BLOCK 구조)
    
    * PL/SQL 구조
    - [선언부 (DECLARE SECTION)] : DECLARE로 시작, 변수나 상수를 선언 및 초기화하는 부분
    - 실행부 (EXECUTABLE SECTION) : BEGIN로 시작, SQL문 또는 제어문(조건문, 반복문)등의 로직을 기술하는 부분
    - [예외처리부 (EXCEPTION SECTION)] : EXCEPTION로 시작, 예외 발생시 해결하기 위한 구문을 미리 기술해둘 수 있는 부분 
*/

-- * 간단하게 화면에 HELLO ORACLE 출력
-- 출력을 위해 한번은 실행해야됨
SET SERVEROUTPUT ON; 

BEGIN
    -- System.out.println("HELLO ORACLE"); -- 자바
    DBMS_OUTPUT.PUT_LINE('HELLO ORACLE');
END;
/ 

--------------------------------------------------------------------------------

/*
    1. DECLARE 선언부 
       변수 및 상수 선언하는 공간 (선언과 동시에 초기화도 가능)
       일반타입변수, 레퍼런스타입변수, ROW타입변수
       
       1_1) 일반타입변수 선언 및 초기화
            변수명 [CONSTANT] 자료형 [:= 값];
*/
DECLARE
    EID NUMBER;
    ENAME VARCHAR2(20);
    ACADEMY CONSTANT VARCHAR2(30) := '구디아카데미';
BEGIN
    EID := &번호;
    ENAME := '&이름';
    
    DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('ACADEMY : ' || ACADEMY);
END;
/

--------------------------------------------------------------------------------

-- 1_2) 레퍼런스타입변수 선언 및 초기화
--      변수명 테이블명.컬럼명%TYPE; --> 특정 컬럼의 데이터타입을 참조해서 그 타입으로 지정 
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
BEGIN
    --EID := '300';
    --ENAME := '김로제';
    --SAL := 2000000;
    
    -- 200번 사원의 사번, 사원명, 급여 조회해서 각 변수에 대입
    SELECT EMP_ID, EMP_NAME, SALARY
      INTO EID, ENAME, SAL 
      FROM EMPLOYEE
     WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('SAL : ' || SAL);
END;
/
------------------------------- 실습문제 ---------------------------------
/*
    레퍼런스변수로 EID, ENAME, JCODE, SAL, DTITLE를 선언하고 
    자료형 EMPLOYEE(EMP_ID, EMP_NAME, JOB_CODE, SALARY), DEPARTMENT(DEPT_TITLE) 참조
    
    사용자가 입력한 사번에 해당하는 사원을 조회해서 각 변수에 대입한 후 출력
*/
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    JCODE EMPLOYEE.JOB_CODE%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY, DEPT_TITLE
      INTO EID, ENAME, JCODE, SAL, DTITLE
      FROM EMPLOYEE, DEPARTMENT
     WHERE DEPT_CODE = DEPT_ID
       AND EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE(EID || ', ' || ENAME || ', ' || JCODE || ', ' || SAL || ', ' || DTITLE);
END;
/
--------------------------------------------------------------------------------

-- 1_3) ROW타입 변수 선언
--      테이블의 한 행에 대한 모든 컬럼값을 한꺼번에 담을 수 있는 변수 
--      변수명 테이블명%ROWTYPE;
DECLARE
    E EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
      INTO E
      FROM EMPLOYEE
     WHERE EMP_ID = &사번;
     
    --DBMS_OUTPUT.PUT_LINE(E);
    DBMS_OUTPUT.PUT_LINE('사원명 : ' || E.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || E.SALARY);
    DBMS_OUTPUT.PUT_LINE('보너스 : ' || NVL(E.BONUS, 0));
END;
/

--------------------------------------------------------------------------------

/*
    2. BEGIN 실행부
    
    < 조건문 >
    
    1) IF 조건식 THEN 실행내용 END IF; (단일 IF문)
*/

-- 특정 사원의 사번, 이름, 급여, 보너스율(%) 출력
-- 단, 보너스를 받지 않는 사원은 보너스율 출력 전 '보너스를 지급받지 않는 사원입니다' 출력
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SALARY EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS,0)
      INTO EID, ENAME, SALARY, BONUS
      FROM EMPLOYEE
     WHERE EMP_ID = &사번;
     
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || SALARY);
    
    IF BONUS = 0
        THEN DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않는 사원입니다');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('보너스율 : ' || BONUS * 100 || '%');
    
END;
/

-- 2) IF 조건식 THEN 실행내용 ELSE 실행내용 END IF; (IF-ELSE문)
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SALARY EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS,0)
      INTO EID, ENAME, SALARY, BONUS
      FROM EMPLOYEE
     WHERE EMP_ID = &사번;
     
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || SALARY);
    
    IF BONUS = 0
        THEN DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않는 사원입니다');
    ELSE
        DBMS_OUTPUT.PUT_LINE('보너스율 : ' || BONUS * 100 || '%');
    END IF;
END;
/

------------------------------- 실습문제 -------------------------------
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
    NCODE LOCATION.NATIONAL_CODE%TYPE;
    
    -- 소속을 담을 변수 ('국내팀' / '해외팀')
    TEAM VARCHAR2(10);
BEGIN
    -- 특정 사원의 사번, 이름, 부서명, 근무국가코드 조회 후 각 변수에 대입
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE
      INTO EID, ENAME, DTITLE, NCODE
      FROM EMPLOYEE
      JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
      JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
     WHERE EMP_ID = &사번; 
    
    -- 근무국가코드가 KO일 경우 => TEAM에 '국내팀' 대입
    --              그게 아닐 경우 => TEAM에 '해외팀' 대입
    IF NCODE = 'KO'
        THEN TEAM := '국내팀';
    ELSE
        TEAM := '해외팀';
    END IF;
    
    -- 사번, 이름, 부서, 소속 출력 
    DBMS_OUTPUT.PUT_LINE(EID || ', ' || ENAME || ', ' || DTITLE || ', ' || TEAM);
END;
/

-- 3) IF 조건식1 THEN 실행내용1 ELSIF 조건식2 THEN 실행내용2 ... [ELSE 실행내용N] END IF; (IF-ELSE IF)
DECLARE
    SCORE NUMBER;
    GRADE VARCHAR2(10);
BEGIN
    SCORE := &점수;
    
    IF SCORE >= 90 THEN GRADE := 'A';
    ELSIF SCORE >= 80 THEN GRADE := 'B';
    ELSIF SCORE >= 70 THEN GRADE := 'C';
    ELSIF SCORE >= 60 THEN GRADE := 'D';
    ELSE GRADE := 'F';
    END IF;
    
    -- 당신의 점수는 XX점이고, 학점은 X학점입니다.
    DBMS_OUTPUT.PUT_LINE('당신의 점수는 ' || SCORE || '점이고, 학점은 ' || GRADE || '학점입니다.');
END;
/
----------------------------------- 실습문제 -----------------------------------
-- 특정 사원의 급여를 조회해서 SAL변수에 대입
-- SAL에 담긴값이 
-- 500만원 이상이면 '고급'
-- 300만원 이상이면 '중급'
-- 300만원 미만이면 '초급'
-- '해당 사원의 급여 등급은 XX입니다'
DECLARE
    SAL EMPLOYEE.SALARY%TYPE;
    GRADE VARCHAR2(10);
BEGIN
    SELECT SALARY
      INTO SAL
      FROM EMPLOYEE
     WHERE EMP_ID = &사번;
    
    IF SAL >= 5000000 THEN GRADE := '고급';
    ELSIF SAL >= 3000000 THEN GRADE := '중급';
    ELSE GRADE := '초급';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('해당 사원의 급여 등급은 ' || GRADE || '입니다.');
    
END;
/

-- 4) CASE 비교대상자 WHEN 비교값1 THEN 결과값1 WHEN 비교값2 THEN 결과값2 ... [ELSE 결과값N] END; (SWITCH문)
DECLARE
    EMP EMPLOYEE%ROWTYPE;
    DNAME VARCHAR2(30);
BEGIN
    SELECT *
      INTO EMP
      FROM EMPLOYEE
     WHERE EMP_ID = &사번;
     
    DNAME := CASE EMP.DEPT_CODE
                WHEN 'D1' THEN '인사팀'
                WHEN 'D2' THEN '회계팀'
                WHEN 'D3' THEN '마케팅팀'
                ELSE '기타팀'
             END;
              
    -- XXX님은 XXX입니다.
    DBMS_OUTPUT.PUT_LINE(EMP.EMP_NAME || '님은 ' || DNAME || '입니다.');
END;
/

-------------------------------------------------------------------------------

/*
    < 반복문 >
    
    1) BASIC LOOP문
    
    LOOP
        반복적으로 수행할 구문;
        * 반복문을 빠져나갈수 있는 구문 *
    END LOOP;
    
    * 반복문을 빠져나갈 수 있는 구문 (2가지)
    1) IF 조건식 THEN EXIT; END IF;
    2) EXIT WHEN 조건식;    
*/
-- 1~5까지 1씩증가되는 값 출력 

DECLARE
    I NUMBER := 1; -- 선언과 동시에 초기화
BEGIN
    
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
        I := I + 1;
        
        --IF I = 6 THEN EXIT; END IF;
        EXIT WHEN I=6;
    END LOOP;
    
END;
/

/*
    2) FOR LOOP문
    
    FOR 변수 IN [REVERSE] 초기값..최종값
    LOOP
        반복적으로 실행할 구문;
    END LOOP;
*/
BEGIN
    FOR I IN REVERSE 1..5
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
    END LOOP;
END;
/

/*
    3) WHILE LOOP문
    
    WHILE 반복문이수행될조건
    LOOP
        반복적으로 실행할 구문;
    END LOOP;
*/

DECLARE
    I NUMBER := 1;
BEGIN
    WHILE I < 6
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
        I := I + 1;
    END LOOP;
END;
/

-- * 반복문 활용 예시 
CREATE TABLE BOARD
(
  BOARD_NO NUMBER PRIMARY KEY,
  BOARD_TITLE VARCHAR2(50) NOT NULL,
  BOARD_CONTENT VARCHAR2(4000) NOT NULL,
  REGIST_DATE DATE NOT NULL
);
-- 게시글번호로 활용할 시퀀스
CREATE SEQUENCE SEQ_BNO;

BEGIN
    FOR I IN 1..100
    LOOP
        INSERT INTO BOARD 
        VALUES(SEQ_BNO.NEXTVAL, '제목입니다' || I, '내용입니다' || I, SYSDATE);
    END LOOP;
END;
/
SELECT * FROM BOARD;

--------------------------------------------------------------------------------

/*
    3. 예외처리부 EXCEPTION
    
       예외(EXCEPTION) : 실행 중 발생되는 오류 
       
       [표현법]
       EXCEPTION
            WHEN 예외명1 THEN 예외처리구문1;
            WHEN 예외명2 THEN 예외처리구문2;
            ... 
            WHEN OTHERS THEN 예외처리구문;
       
       * 시스템예외 (오라클에서 미리 정의해둔 예외)
       - NO_DATA_FOUND : SELECT한 결과가 한 행도 없을 경우 
       - TOO_MANY_ROWS : SELECT한 결과가 여러행일 경우 
       - ZERO_DIVIDE : 0으로 나누기 했을 경우 
       - DUP_VAL_ON_INDEX : UNIQUE 제약조건에 위배되었을 경우
       ...
*/

DECLARE
    RESULT NUMBER;
BEGIN
    RESULT := 10 / &숫자;
    DBMS_OUTPUT.PUT_LINE('결과 : ' || RESULT);
EXCEPTION
    --WHEN ZERO_DIVIDE THEN DBMS_OUTPUT.PUT_LINE('나누기 연산시 0으로 나눌 수 없습니다.');
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('나누기 연산시 0으로 나눌 수 없습니다.');
END;
/

-- UNIQUE 제약조건 위배
BEGIN
    UPDATE EMPLOYEE
       SET EMP_ID = '&변경할사번'
     WHERE EMP_NAME = '노옹철'; 
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN DBMS_OUTPUT.PUT_LINE('이미 존재하는 사번입니다.');
END;
/
ROLLBACK;

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME
      INTO EID, ENAME
      FROM EMPLOYEE
     WHERE MANAGER_ID = &사수사번;
     
    DBMS_OUTPUT.PUT_LINE(EID || ', ' || ENAME);
EXCEPTION
    WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE('너무 많은 사원이 조회되었습니다.');
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('조회 결과가 없습니다.');
END;
/
