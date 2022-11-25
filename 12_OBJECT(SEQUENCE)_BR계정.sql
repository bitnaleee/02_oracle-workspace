/*
    < 시퀀스 SEQUENCE >
    자동으로 숫자 발생시켜주는 역할을 하는 객체
    정수값을 순차적으로 일정값씩 증가시키면서 생성해줌
    
    EX) 회원번호, 사원번호, 게시글번호, ...

*/

/*
    1. 시퀀스 객체 생성
    
    [표현법]
    CREATE SEQUENCE 시퀀스명
    [START WITH 시작숫자]   --> 처음 발생시킬 시작값 지정 (기본값1)
    [INCREMENT BY 숫자]    --> 몇 씩 증가시킬건지 (기본값 1)
    [MAXVALUE 숫자]        --> 최대값 지정 (기본값 엄청 큼)
    [MINVALUE 숫자]        --> 최소값 지정 (기본값 1)
    [CYCLE NOCYCLE]       --> 값 순환 여부 지정 (기본값 NOCYCLE)
    [NOCACHE|CACHE 바이트크기]   --> 캐시메모리 할당 (기본값 CACHE 20)
    
    * 캐시메모리 : 미리 발생될 값들을 생성해서 저장해두는 공간
                 매번 호출할 때마다 새로 숫자를 생성하는게 아니라
                 캐시메모리 공간에 미리 생성된 값들을 가져오기 때문에 속도가 빨라짐
                 접속이 해제되면 캐시메모리에 미리 만들어 둔 번호가 날라감
                 
      테이블명 : TB     
      뷰명 : VW
      시퀀스명 : SEQ
      트리거명 : TRG
        
*/

CREATE SEQUENCE SEQ_TEST;

-- [참고] USER_SEQUENCES : 이 사용자가 가지고 있는 시퀀들의 구조를 보고자할때의 시스템 테이블
SELECT * FROM USER_SEQUENCES;

CREATE SEQUENCE SEQ_EMPNO
START WITH 300
INCREMENT BY 5
MAXVALUE 310
NOCYCLE
NOCACHE;

/*
    2. 시퀀스 사용 (즉, 숫자발생)
    시퀀스명.CURRVAL : 현재 시퀀스의 값 (마지막으로 성공적으로 수행된 NEXTVAL)
    시퀀스명.NEXTVAL : 일정값을 증가시켜서 새로 발생된 값
                      현재 시퀀스 값에 INCREMENT BY 값만큼 증가된 값
*/

SELECT SEQ_EMPNO.CURRVAL FROM DUAL;
-- NEXTVAL를 수행하지 않으면 CURRVAL을 사용할 수 없음
-- 왜? : CURRVAL은 마지막으로 성공적으로 수행된 NEXTVAL의 값을 임시 보관하고 있는 값

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 300
SELECT SEQ_EMPNO.CURRVAL FROM DUAL; -- 300

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 305
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 310

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 지정한 MAXVALUE값을 초과했기 때문에 오류 발생
SELECT SEQ_EMPNO.CURRVAL FROM DUAL; -- 310

SELECT * FROM USER_SEQUENCES;

/*
    3. 시퀀스 변경
    
    ALTER SEQUENCE 시퀀스명
    [INCREMENT BY 증가값]
    [MAXVALUE 최대값]
    [MINVALUE 최소값]
    [CYCLE|NOCYCLE]
    [NOCACHE|CACHE 바이트크기];
    
    * START WITH 변경불가능

*/

ALTER SEQUENCE SEQ_EMPNO
INCREMENT BY 10
MAXVALUE 400;

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL;

-- 4. 시퀀스 삭제
DROP SEQUENCE SEQ_EMPNO;

--------------------------------------------------------------------------------

-- * INSERT 문에서 시퀀스 활용
-- 사번으로 활용할 시퀀스
CREATE SEQUENCE SEQ_EID
START WITH 300
NOCACHE;

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
        SEQ_EID.NEXTVAL
        , '홍길동'
        , '111111-1111111'
        , 'J7'
        , SYSDATE
        );
        
ROLLBACK;

