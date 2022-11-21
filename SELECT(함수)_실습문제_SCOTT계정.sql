--------------- SELECT 함수 실습문제 ----------------------

-- 1. 시스템으로 부터 오늘 날짜에 대한 정보를 조회하는 구문 작성
SELECT SYSDATE FROM DUAL;
   
-- 2. EMP 테이블로 부터 사번, 사원명, 급여 조회
--    단, 급여는 100단위 까지의 값만 출력 처리함.
--    급여 기준 내림차순 정렬함.
SELECT EMPNO "사번", ENAME "사원명", SAL "급여"
FROM EMP
WHERE TRUNC(SAL, 1)
ORDER BY SAL DESC;

-- 3. EMP 테이블로 부터 사원번호가 홀수인 사원들을 조회
SELECT *
FROM EMP
WHERE MOD(EMPNO,2) = 1;

-- 4. EMP 테이블로 부터 사원명, 입사일 조회
--    단, 입사일은 년도와 월을 분리 추출해서 출력
SELECT EMP_NAME "사원명", HIRE_DATE "입사일"
FROM EMP
WHERE EXTRACT(YEAR FROM HIRE_DATE)
  AND EXTRACT(MONTH FROM HIRE_DATE);

-- 5. EMP 테이블로 부터 9월에 입사한 직원의 정보 조회
SELECT *
FROM EMP
WHERE SUBSTR(HIREDATE, 4, 2) = '09';

-- 6. EMP 테이블로 부터 '81'년도에 입사한 직원 조회
SELECT *
FROM EMP;
WHERE HIREDATE

-- 7. EMP 테이블로 부터 이름이 'E'로 끝나는 직원 조회
SELECT *
FROM EMP
WHERE SUBSTR(ENAME, -1, 1) = 'E';

-- 8. EMP 테이블로 부터 이름의 세번째 글자가 'R'인 직원의 정보 조회
-- >> LIKE 연산자를 사용
SELECT *
FROM EMP
WHERE ENAME LIKE '__R%';

-- >> SUBSTR() 함수 이용
SELECT *
FROM EMP
WHERE SUBSTR(ENAME, 3, 1) = 'R';

-- 9. EMP 테이블로 부터 사번, 사원명, 입사일, 그리고 입사일로부터 40년후의 날짜 조회
     

-- 10. 입사일로 현재날짜까지 40년 이상 근무한 직원의 정보 조회
SELECT *
FROM EMPLOYEE
WHERE YEARS_(HIRE_DATE, SYSDATE)
