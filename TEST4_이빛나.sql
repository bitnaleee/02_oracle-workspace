/*
    1. 전체 사원들의 사원명, 입사일, 부서코드, 직급코드에 대해 조회하시오.
       단, 입사일 출력 형식은 "2001-12-01 (수)" 다음과 같은 형식으로 조회될 수 있도록 하시오.
       사원명 순으로 오름차순 정렬하여 조회하시오.
*/
SELECT EMP_NAME "사원명", TO_CHAR(HIRE_DATE,'YYYY-MM-DD (DY)')"입사일", DEPT_CODE "부서코드", JOB_CODE "직급코드"
FROM EMPLOYEE
ORDER BY EMP_NAME ASC;



/*
    2. 직급코드가 J7 또는 J6인 사원들 중 급여가 200만원 이상이고 보너스를 받고 있으며
       이메일값의 5번째 자리가 _인 여자 사원의 사원명, 주민번호, 직급코드, 급여, 보너스, 이메일을 조회하시오.
*/
SELECT EMP_NAME "사원명", EMP_NO "주민번호", JOB_CODE "직급코드", SALARY "급여", BONUS "보너스", EMAIL "이메일"
FROM EMPLOYEE
WHERE JOB_CODE IN ('J7','J6') 
  AND SALARY >= 2000000
  AND BONUS IS NOT NULL
  AND SUBSTR(EMP_NO, 8 ,1) IN ('2','4')
  AND EMAIL LIKE '____$_%' ESCAPE'$';



-- 3. 지역아이디가 L1 또는 L2인 부서들 중 해외영업관련 부서가 아닌 부서들의 부서코드, 부서명을 조회하시오.
SELECT DEPT_ID "부서코드", DEPT_TITLE "부서명"
FROM DEPARTMENT
WHERE LOCATION_ID IN ('L1', 'L2')
  AND DEPT_TITLE NOT LIKE '해외영업%';



-- 4. 총무부인 사원들의 사원명, 부서명, 직급명을 조회하시오. (오라클구문, ANSI구문 둘 다 작성하시오.)
--> 오라클
SELECT EMP_NAME "사원명", DEPT_TITLE "부서명", JOB_NAME "직급명"
FROM EMPLOYEE E, DEPARTMENT D, JOB J
WHERE D.DEPT_ID = E.DEPT_CODE
  AND E.JOB_CODE = J.JOB_CODE
  AND DEPT_TITLE = '총무부';
  
--> ANSI
SELECT EMP_NAME "사원명", DEPT_TITLE "부서명", JOB_NAME "직급명"
FROM EMPLOYEE E
JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE DEPT_TITLE = '총무부';



-- 5. 해외영업팀에 근무하는 직원들의 사원명, 직급명, 부서코드, 부서명을 조회하시오. (오라클구문, ANSI구분 둘 다 작성하시오.)
--> 오라클
SELECT EMP_NAME "사원명", JOB_NAME "직급명", DEPT_ID "부서코드", DEPT_TITLE "부서명"
FROM EMPLOYEE E, JOB J, DEPARTMENT D
WHERE E.JOB_CODE = J.JOB_CODE
  AND E.DEPT_CODE = D.DEPT_ID
  AND DEPT_TITLE LIKE '해외영업%';

--> ANSI
SELECT EMP_NAME "사원명", JOB_NAME "직급명", DEPT_ID "부서코드", DEPT_TITLE "부서명"
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
WHERE DEPT_TITLE LIKE '해외영업%';



-- 6. 한국에서 근무하는 사원들의 사원명, 부서명, 근무지역명을 조회하시오. (오라클구문, ANSI구분 둘 다 작성하시오.)
--> 오라클
SELECT EMP_NAME "사원명", DEPT_TITLE "부서명", LOCAL_NAME "근무지역명"
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N
WHERE E.DEPT_CODE = D.DEPT_ID
  AND D.LOCATION_ID = L.LOCAL_CODE
  AND L.NATIONAL_CODE = N.NATIONAL_CODE
  AND NATIONAL_NAME = '한국';


--> ANSI
SELECT EMP_NAME "사원명", DEPT_TITLE "부서명", LOCAL_NAME "근무지역명"
FROM EMPLOYEE E
JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
JOIN NATIONAL N USING(NATIONAL_CODE)
WHERE NATIONAL_NAME = '한국';




/*
    7. 박나라 사원과 같은 직급의 사원들의 사원명, 직급명을 조회하시오. (오라클구문, ANSI구분 둘 다 작성하시오.)
       단, 박나라는 제외하고 조회하시오.
*/    
--> 오라클
SELECT EMP_NAME "사원명", JOB_NAME "직급명"
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
  AND E.JOB_CODE = (SELECT JOB_CODE
                      FROM EMPLOYEE
                     WHERE EMP_NAME = '박나라')
  AND E.EMP_NAME != '박나라';
  
--> ANSI
SELECT EMP_NAME "사원명", JOB_NAME "직급명"
FROM EMPLOYEE E 
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE) -- JOIN JOB USING(JOB_CODE)
WHERE E.JOB_CODE = (SELECT JOB_CODE
                    FROM EMPLOYEE
                   WHERE EMP_NAME = '박나라')
  AND EMP_NAME != '박나라';



/*
    8. TEST 라는 이름의 새로운 계정을 생성하려고 한다. 이 때 관리자계정에서 실행시켜야되는 계정 생성 구문과 최소한의
       권한을 부여하는 구문을 작성하시오.
*/       

CREATE USER TEST IDENTIFIED BY ORACLE;

GRANT CONNECT, RESOURCE TO TEST;










