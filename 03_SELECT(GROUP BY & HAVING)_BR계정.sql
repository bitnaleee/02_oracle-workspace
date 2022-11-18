/*
    < GROUP BY 절 >
    그룹기준을 제시할 수 있는 구문 (해당 그룹기준별로 여러 그룹으로 묶을 수 있음)
*/
SELECT SUM(SALARY)
FROM EMPLOYEE; --> 전체 사원들이 하나의 그룹으로 묶여서 총합 구함

SELECT DEPT_CODE, SUM(SALARY) -- 에러발생
FROM EMPLOYEE;

-- 각 부서별 총급여합
SELECT DEPT_CODE, SUM(SALARY) - 3
FROM EMPLOYEE       -- 1
GROUP BY DEPT_CODE  -- 2
ORDER BY DEPT_CODE; -- 4

-- 각 부서별 사원수 
SELECT DEPT_CODE, COUNT(*), SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 각 직급별 총사원수, 보너스를받는사원수, 급여합, 평균급여, 최저급여, 최고급여
SELECT JOB_CODE, COUNT(*) "총사원수", COUNT(BONUS) "보너스를받는사원수",
       SUM(SALARY) "급여합", FLOOR(AVG(SALARY)) "평균급여", 
       MIN(SALARY) "최저급여", MAX(SALARY) "최고급여"
FROM EMPLOYEE
GROUP BY JOB_CODE;


SELECT DEPT_CODE, COUNT(*) "총사원수", COUNT(BONUS) "보너스를받는사원수",
       SUM(SALARY) "급여합", FLOOR(AVG(SALARY)) "평균급여", 
       MIN(SALARY) "최저급여", MAX(SALARY) "최고급여"
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- GROUP BY 절에 함수식 기술 가능 
SELECT DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') "성별", COUNT(*)
FROM EMPLOYEE
GROUP BY SUBSTR(EMP_NO, 8, 1);

-- GROUP BY 절에 여러 컬럼 기술 가능 
SELECT DEPT_CODE, JOB_CODE, COUNT(*), SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE
ORDER BY DEPT_CODE;

-------------------------------------------------------------------------------

/*
    < HAVING 절 >
    그룹에 대한 조건을 제시할 때 사용되는 구문 (주로 그룹함수식을 가지고 조건을 제시함)
*/
-- 각 부서별 평균 급여 조회 (부서코드, 평균급여)
SELECT DEPT_CODE, ROUND(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 부서별 평균급여가 300만원 이상인 부서만을 조회 
SELECT DEPT_CODE, ROUND(AVG(SALARY))
FROM EMPLOYEE
WHERE AVG(SALARY) >= 3000000   -- 오류발생!! (WHERE절에는 그룹함수식 못씀)
GROUP BY DEPT_CODE;

SELECT DEPT_CODE, ROUND(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING AVG(SALARY) >= 3000000;

-- 부서가 D1 또는 D9인 부서만을 조회
SELECT DEPT_CODE, ROUND(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING DEPT_CODE IN ('D1', 'D9');

-- 직급별 총 급여합 (단, 직급별 급여합이 1000만원 이상인 직급만을 조회)
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
HAVING SUM(SALARY) >= 10000000;

-- 부서별 보너스를받는사원이 없는 부서만을 조회 
SELECT DEPT_CODE
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING COUNT(BONUS) = 0;

-- 남자사원들 중 부서별 보너스를받는사원이 없는 부서만을 조회
SELECT DEPT_CODE, COUNT(BONUS)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = '1'
GROUP BY DEPT_CODE
HAVING COUNT(BONUS) = 0;

--------------------------------------------------------------------------------
/*
    < SELECT 문 실행순서 >
    5: SELECT    * | 조회하고자하는 컬럼 [AS] 별칭 | 산술연산식 [AS] "별칭" | 함수식
    1:   FROM    조회하고자하는 테이블명 별칭, 테이블명 "별칭", ..
    2:  WHERE    조건식 (연산자들 가지고 기술)
    3:  GROUP BY 그룹기준으로 삼을 컬럼 | 함수식 | 산술연산식, 컬럼, .. 
    4: HAVING    조건식 (그룹함수 또는 그룹기준의 컬럼 가지고 기술)
    6:  ORDER BY 정렬기준으로 삼을 컬럼|별칭|컬럼순번  [ASC|DESC]  [NULLS FIRST|NULLS LAST]
*/

--------------------------------------------------------------------------------

/*
    < 집계 함수 >
    그룹별 산출된 결과 값에 중간집계를 계산해주는 함수 
    
    ROLLUP, CUBE
    
    => GROUP BY 절에 기술하는 함수 
*/
-- 각 직급별 급여합 
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

-- 마지막 행에 전체 총 급여합 까지 같이 조회하고자할 때 
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(JOB_CODE)
ORDER BY JOB_CODE;

SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(JOB_CODE)
ORDER BY JOB_CODE;
-- 그룹기준의 컬럼이 하나일때는 CUBE, ROLLUP의 차이없음! 


SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE
ORDER BY DEPT_CODE;

-- ROLLUP(컬럼1, 컬럼2) : 컬럼1을 가지고 다시 중간 집계를 내주는 함수 
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
ORDER BY DEPT_CODE;

-- CUBE(컬럼1, 컬럼2) : 컬럼1을 가지고 중간집계 내고, 추가로 컬럼2을 가지고도 중간집계를 냄
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY DEPT_CODE;

--------------------------------------------------------------------------------

/*
    < 집합 연산자 == SET OPERATION >
    
    여러개의 쿼리문을 하나의 쿼리문으로 만드는 연산자 
    
    - UNION     : 합집합(두 쿼리문 수행한 결과값을 더한 후 중복되는 값은 한번만 더해지도록) | OR
    - INTERSECT : 교집합(두 쿼리문 수행한 결과값에 중복된 결과값) | AND
    - UNION ALL : 합집합 + 교집합 (두 쿼리문의 겨로가값을 무조건 더한 결과값 => 중복된 값이 두번 표현될 수 있음
    - MINUS     : 차집합 (선행 쿼리의 결과값에서 후행 쿼리의 결과값을 뺀 나머지

*/

-- 1. UNION
-- 부서코드가 D5인 사원 또는 급여가 300만원 초과인 사원들 조회(사번, 이름, 부서코드, 급여)

-- 부서코드가 D5인 사원들만
SELECT EMP_ID, EMP_NAME, DEPT_DODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'; -- 6개 행 (박나라, 하이유, 김해술, 심봉선, 윤은해, 대북혼)

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- 아래 WHERE 절처럼 OR써도 해결가능
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' OR SALARY > 3000000;

-- 2. INTERSECT (교집합)
-- 부서코드가 D5면서 급여마저가 300만 초과인 사원 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' -- 6명
INTERSECT 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000; -- 8명

-- WHERE절에 AND 쓰면 해결가능
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' AND SALARY > 3000000;

-- 3. UNION ALL : 여러개의 쿼리 결과를 무조건 다 더하는 연산자 (합집합+교집합)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' -- 6명
UNION ALL
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000; -- 8명

-- 4. MINUS : 선행 쿼리 결과값에 후행 쿼리 결과값을 뺀 나머지
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' -- 6명
MINUS
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000; -- 8명

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' AND SALARY <= 3000000;

--------------------------------------------------------------------------------

-- 집합연산자 사용시 유의사항
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION
SELECT EMP_ID, EMP_NAME, DEPT_CODE -- SALARY를 지웠을 때 오류
FROM EMPLOYEE
WHERE SALARY > 3000000;
--> 각 쿼리의 SELECT절에 작성된 컬럼의 갯수 동일해야됨

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION
SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE -- SALARY 대신 HIRE_DATE 추가
FROM EMPLOYEE
WHERE SALARY > 3000000;
--> 컬럼의 갯수 뿐만 아니라 각 컬럼자리마다 동일한 타입으로 기술

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY "보너스또는급여"
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION
SELECT EMP_ID, EMP_NAME, DEPT_CODE, BONUS
FROM EMPLOYEE
WHERE SALARY > 3000000;

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY "보너스또는급여"
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION
SELECT EMP_ID, EMP_NAME, DEPT_CODE, BONUS
FROM EMPLOYEE
WHERE SALARY > 3000000;
ORDER BY EMP_NAME;
--> ORDER BY 절은 마지막에 기술


