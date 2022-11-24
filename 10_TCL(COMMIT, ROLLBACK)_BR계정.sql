/*

    < TCL : TRANSATION CONTROL LANGUAGE >
    트랜잭션 제어 언어
    
    * 트랜잭션 (TRANSACTION)
    - 데이터베이스의 논리적 연산단위
    - 데이터의 변경사항(DML)들을 하나로 묶어서 처리할 때 필요한 개념
      DML문을 한 번 수행할 때 트랜잭션이 존재하면 해당 트랜잭션에 같이 묶어서 처리
                           트랜잭션이 존재하지 않으면 새로운 트랜잭션을 만들어서 묶음
    
    - COMMIT : 트랜잭션에 담겨있는 변경사항들을 실제 DB에 반영시키겠다는 의미 (후에 트랜잭션은 사라짐)
    - ROLLBACK : 트랜잭션에 담겨있는 변경사항들을 삭제(취소)한 후
    - SAVEPOINT 포인트명 : 현재 시점에 해당 포인트명으로 임시저장점을 정의해두는 거
                          ROLLBACK시 전체 취소가 아닌 일부만 롤백 가능함

*/

SELECT * FROM EMP_01;

-- 사번이 900 사원 지우기
DELETE FROM EMP_01
WHERE EMP_ID = 900;

-- 사번이 901 사원 지우기
DELETE FROM EMP_01
WHERE EMP_ID = 901;

ROLLBACK;

--------------------------------------------------------------------------------

-- 200 사원 지우기
DELETE FROM EMP_01
WHERE EMP_ID = 200;

-- 800 사원 추가
INSERT INTO EMP_01
VALUES(800, '홍길동', '총무부');

SELECT * FROM EMP_01;

COMMIT;
ROLLBACK;

--------------------------------------------------------------------------------

SELECT * FROM EMP_01;

-- 217, 216, 214 사원 삭제
DELETE FROM EMP_01
WHERE EMP_ID IN (217, 216, 214);

SAVEPOINT SP;

-- 801 사원 추가
INSERT INTO EMP_01
VALUES(801, '김말똥', '인사관리부');

-- 218 사원 삭제
DELETE FROM EMP_01
WHERE EMP_ID = 218;

ROLLBACK TO SP;

COMMIT;

--------------------------------------------------------------------------------

-- 900, 901 사원 지움
DELETE FROM EMP_01
WHERE EMP_ID IN (900,901);

-- DDL문
CREATE TABLE TEST(
    TID NUMBER
);

ROLLBACK;

SELECT * FROM EMP_01;

--> DDL문 (CREATE, ALTET, DROP)을 수행하는 순간 무조건 COMMIT(실제 DB에 반영)
-- 즉, DDL문 수행 전 변경사항들이 있었다면 정확히 픽스(COMMIT, ROLLBACK) 하고 진행




