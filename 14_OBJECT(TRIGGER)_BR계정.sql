/*

    < 트리거 TRIGGER>
    내가 지정한 테이블에 INSERT, UPDATE, DELETE등의 DML문에 의해 변경사항이 생길 때
    (즉, 테이블에 이벤트 발생했을 때) 매번 "자동으로 실행시킬 내용"을 미리 정의해둘 수 있는 객체
    
    EX)
    회원탈퇴시 기존의 회원테이블에 데이터 DELETE 후 곧바로 탈퇴된 회원들만 따로 보관하는 테이블에 자동으로 INSERT처리해야된다
    회원의 신고횟수가 일정 수를 넘었을 때 묵시적으로 해당 회원을 블랙리스트로 처리되게끔
    입출고에 대한 데이터가 기록 될 때마다 해당 상품에 대한 재고수량을 매번 수정해야될 때
    
    * 트리거 종류
    - SQL문의 실행시기에 따른 분류
    > BEFORE TRIGGER : 내가 지정한 테이블에 이벤트가 발생되기 전에 트리거 실행
    > AFTER TRIGGER : 내가 지정한 테이블에 이벤트가 발생된 후에 트리거 실행
    
    - SQL문에 의해 영향을 받는 각 행에 따른 분류
    > STATEMENT TRIGGER(문장트리거) : 이벤트가 발생한 SQL문에 대해 딱 한번만 트리거 실행
    > ROW TRIGGER(행트리거) : 해당 SQL문 실행될 때마다 매번 트리거 실행
                            (FOR EACH ROW 옵션 기술해야됨)    
                            - :OLD - BEFORE UPDATE(수정 전 데이터), BEFORE DELETE(삭제 전 데이터)
                            - :NEW - AFTER INSERT(추가된 데이터), AFTER UPDATE(수정 후 데이터)
    
    * 트리거 생성 구문
    
    [표현법]
    CREATE [OR REPLACE]TRIGGER 트리거명
    BEFORE | AFTER    INSERT | UPDATE | DELETE ON 테이블명
    [FOR EACH ROW]
    DECLARE
        변수선언;
    BEGIN
        실행내용(위에 지정된 이벤트 발생시 묵시적으로(자동적으로) 실행할 구문)
    EXCEPTION
         예외처리구문;
    END;
    /
    
*/

-- EMPLOYEE 테이블에 새로운 행이 INSERT 될 때마다 자동으로 메세지 출력시켜주는 트리거 정의
CREATE OR REPLACE TRIGGER TRG_01
AFTER INSERT ON EMPLOYEE 
BEGIN -- 변수가 필요없어서 DECLARE 생략
    DBMS_OUTPUT.PUT_LINE('신입사원님 환영합니다!');
END;
/
SET SERVEROUTPUT ON;

INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, DEPT_CODE, JOB_CODE, HIRE_DATE)
VALUES(500, '이순신', '111111-2111111', 'D7', 'J3', SYSDATE);

INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, DEPT_CODE, JOB_CODE, HIRE_DATE)
VALUES(501, '강개똥', '111111-2344444', 'D2', 'J1', SYSDATE);

--------------------------------------------------------------------------------

-- 상품 입고 및 출고 관련 예시
-->> 필요한 테이블 및 시퀀스 생성
-- 1. 상품에 대한 데이터 보관할 테이블 (TB_PRODUCT)
CREATE TABLE TB_PRODUCT(
    PCODE VARCHAR2(8) PRIMARY KEY,
    PNAME VARCHAR2(30) NOT NULL,
    BRAND VARCHAR2(30) NOT NULL,
    PRICE NUMBER,
    STOCK NUMBER DEFAULT 0
);

-- 상품코드용 시퀀스 (SEQ_PCODE)
CREATE SEQUENCE SEQ_PCODE
NOCACHE;

-- 샘플데이터 3개 추가
INSERT INTO TB_PRODUCT VALUES('PRO_' || LPAD(SEQ_PCODE.NEXTVAL, 3, '0'), '갤럭시플립', '삼성', 1400000, DEFAULT);
INSERT INTO TB_PRODUCT VALUES('PRO_' || LPAD(SEQ_PCODE.NEXTVAL, 3, '0'), '아이폰14PRO', '애플', 1500000, 10);
INSERT INTO TB_PRODUCT VALUES('PRO_' || LPAD(SEQ_PCODE.NEXTVAL, 3, '0'), '대륙폰', '샤오미', 700000, 20);

SELECT * FROM TB_PRODUCT;
COMMIT;

-- 2. 상품 입출고 상세 이력 테이블 (TB_PRODETAIL)
-- 어떤 상품이 어떤 날짜에 몇 개가 입고 또는 출고가 되었는지에 대한 데이터를 기록하는 테이블
CREATE TABLE TB_PRODETAIL(
    DCODE NUMBER PRIMARY KEY,
    PCODE VARCHAR2(8) REFERENCES TB_PRODUCT,
    PDATE DATE NOT NULL,
    AMOUNT NUMBER NOT NULL,
    STATUS CHAR(6) CHECK(STATUS IN ('입고', '출고'))
);

-- 이력번호용 시퀀스
CREATE SEQUENCE SEQ_DCODE
NOCACHE;

-- 'PRO_001' 상품이 오늘날짜로 10개 입고
--> TB_PRODETAIL 이력데이터 INSERT
INSERT INTO TB_PRODETAIL
VALUES (SEQ_DCODE.NEXTVAL, 'PRO_001', SYSDATE, 10, '입고');

--> TB_PRODUCT 상품데이터 UPDATE (재고수량늘리기)
UPDATE TB_PRODUCT
   SET STOCK = STOCK + 10
 WHERE PCODE = 'PRO_001';

COMMIT;

-- 'PRO_002' 상품이 오늘날짜로 5개 출고
--> TB_PRODETAIL 이력데이터 INSERT
INSERT INTO TB_PRODETAIL
VALUES(SEQ_DCODE.NEXTVAL, 'PRO_002', SYSDATE, 5, '출고');

--> TB_PRODUCT 상품데이터 UPDATE (재고수량 감소시키기)
UPDATE TB_PRODUCT
   SET STOCK = STOCK - 5
 WHERE PCODE = 'PRO_002';

COMMIT;

-- 'PRO_003' 상품이 오늘날짜로 20개 입고
--> TB_PRODETAIL INSERT
INSERT INTO TB_PRODETAIL
VALUES(SEQ_DCODE.NEXTVAL, 'PRO_003', SYSDATE, 20, '입고');

--> TB_PRODUCT UPDATE
UPDATE TB_PRODUCT
   SET STOCK = STOCK + 20
 WHERE PCODE = 'PRO_001'; -- 'PRO_003'인데 실수했을 경우
 
ROLLBACK; -- INSERT만 잘하면 자동UPDATE면 좋을텐데.. > TRIGGER

-- TB_PRODETAIL 테이블에 INSERT 이벤트 발생시
-- TB_PRODUCT 테이블에 매번 자동으로 재고수량 UPDATE되게끔 트리거 정의

/*
    - 상품이 입고된 경우 (INSERT된 자료의 STATUS값이 '입고'일 경우)
      UPDATE TB_PRODUCT
         SET STOCK = STOCK + 현재입고된수량 (INSERT된 자료의 AMOUNT값)
       WHERE PCODE = 현재입고된상품코드 (INSERT된 자료된 PCODE값)
       
    - 상품이 출고된 경우 (INSERT된 자료의 STATUS값이 '출고'일 경우)
      UPDATE TB_PRODUCT
         SET STOCK = STOCK - 현재출고된수량 (INSERT된 자료의 AMOUNT값)
       WHERE PCODE = 현재입고된상품코드 (INSERT된 자료된 PCODE값)    

*/
 
CREATE OR REPLACE TRIGGER TRG_02 -- 트리거명
AFTER INSERT ON TB_PRODETAIL -- 테이블명
FOR EACH ROW
BEGIN
    IF :NEW.STATUS = '입고'
        THEN 
            UPDATE TB_PRODUCT
               SET STOCK = STOCK + :NEW.AMOUNT
             WHERE PCODE = :NEW.PCODE;
    END IF;
    
    IF :NEW.STATUS = '출고'
        THEN 
            UPDATE TB_PRODUCT
               SET STOCK = STOCK - :NEW.AMOUNT
             WHERE PCODE = :NEW.PCODE;
    END IF;
END;
/

-- 'PRO_003' 상품이 오늘날짜로 20개 입고
INSERT INTO TB_PRODETAIL
VALUES (SEQ_DCODE.NEXTVAL, 'PRO_003', SYSDATE, 20, '입고');

-- 'PRO_001' 상품이 오늘날짜로 7개 출고
INSERT INTO TB_PRODETAIL
VALUES(SEQ_DCODE.NEXTVAL, 'PRO_001', SYSDATE, 7, '출고');
