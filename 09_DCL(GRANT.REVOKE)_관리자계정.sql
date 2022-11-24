 /*
 
    < DCL : DATA CONTROL LANGUAGE >
    데이터 제어 언어
    
    계정에게 시스템권한 또는 객체접근권한을 부여(GRANT)하거나 회수(REVOKE)하는 구문
    
    > 시스템 권한 : DB에 접근하는 권한, 객체들을 생성할 수 있는 권한
    > 객체접근권한 : 특정 객체들을 조작할 수 있는 권한
    
 */
 
 /*
    * 시스템권한 종류
    - CREATE SESSTION : 접속할 수 있는 권한
    - CREATE TABLE : 테이블을 생성할 수 있는 권한
    - CREATE VIEW : 뷰 생성할 수 있는 권한
    - CREATE SEQUENCE : 시퀀스 생성할 수 있는 권한
    ....

 */
 
 -- 1. SAMPLE / SAMPLE 계정
 CREATE USER SAMPLE IDENTIFIED BY SAMPLE;
 -- 2. 접속을 위해 CREATE SESSION 권한 부여
 GRANT CREATE SESSION TO SAMPLE;
 
 -- 3_1. 테이블을 생성할 수 있는 CREATE TABLE 권한 부여
 GRANT CREATE TABLE TO SAMPLE;
 
 -- 3_2. TABLESPACE 할당
 ALTER USER SAMPLE QUOTA 2M ON SYSTEM;
 
 -------------------------------------------------------------------------------
 
 /*
    * 객체 접근 권한 종류
    특정 객체에 접근해서 조작할 수 있는 권한
    
    권한종류    특정객체
    SELECT    TABLE, VEW, SEQUENCE
    INSERT    TABLE, VIEW
    UPDATE    TABLE, VIEW
    DELETE    TABLE, VIEW
    ...
    
    [표현법]
    GRANT 권한종류 ON 특정객체 TO 계정명;
 */
 
 -- 4. 권한 부여
 GRANT SELECT ON BR.EMPLOYEE TO SAMPLE;
 
 -- 5. 권한 부여
 GRANT INSERT ON BR.DEPARTMENT TO SAMPLE;
 
 -- 권한 회수 (REVOKE)
 -- REVOKE 회수할권한 FROM 계정명;
 REVOKE SELECT ON BR.EMPLOYEE FROM SAMPLE;
 
 -- 항상 최소한의 권한 부여했었음
 -- GRANT CONNECT, RESOURCE TO 계정명;
 /*
    < 롤 ROLE >
    특정 권한들을 하나의 집합으로 모아놓은 것
    
    CONNECT : 접속할 수 있는 권한 (CREATE SESSION)
    RESOURCE : 특정 객체들을 생성할 수 있는 권한 (CREATE TABLE, CREATE SEQUENCE, ...)
    
 */
 
 SELECT *
 FROM ROLE_SYS_PRIVS
 WHERE ROLE IN ('CONNECT', 'RESOURCE')
 ORDER BY 1;
 
 