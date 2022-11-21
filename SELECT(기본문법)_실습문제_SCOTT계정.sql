--------------- SELECT 기본문법 실습문제 ----------------------
-- 1. COMM(커미션)컬럼값이 NULL이 아닌 직원의 정보 조회
SELECT *
FROM EMP
WHERE COMM IS NOT NULL;

-- 2. 커미션을 받지 못하는 직원 정보 조회
SELECT *
FROM EMP
WHERE COMM IS NULL OR COMM = 0;

-- 3. 관리자가 없는 직원 정보 조회
SELECT *
FROM EMP
WHERE MGR IS NULL;

-- 4. 급여를 많이 받는 직원 순으로 조회
SELECT *
FROM EMP
ORDER BY SAL DESC;

-- 5. 급여를 많이 받는 직원 순으로 조회하되 급여가 같을 경우 커미션을 기준으로 내림차순 정렬 조회
SELECT *
FROM EMP
ORDER BY SAL DESC , COMM DESC;

-- 6. EMP 테이블에서 사원번호, 사원명, 직급, 입사일 조회
--    단, 입사일을 기준으로 오름차순 정렬하여 조회함.
SELECT EMPNO, ENAME, JOB, HIREDATE
FROM EMP
ORDER BY HIREDATE;

-- 7. EMP 테이블로부터 사원번호, 사원명 조회
--    단, 사원번호 기준으로 내림차순 정렬하여 조회함.
SELECT EMPNO, ENAME
FROM EMP
ORDER BY EMPNO DESC;

-- 8. EMP 테이블로부터 사번, 부서번호, 입사일, 사원명, 급여 조회
--    단, 부서번호가 빠른 순으로 조회하되 부서번호가 같을 경우 최근 입사일순으로 조회함.
SELECT EMPNO, DEPTNO, HIREDATE, ENAME, SAL
FROM EMP
ORDER BY DEPTNO, HIREDATE DESC;


