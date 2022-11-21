-- BR계정에서 풀 것!! 

-- 1. 전 사원들의 직원명과 주민번호를 조회
--    단, 주민번호 9번째 자리부터 끝까지는 '*' 로 채워서 조회
--    EX) 771120-1******
SELECT EMP_NAME "직원명", SUBSTR(EMP_NO, 1, 8) || '******' "주민번호"
FROM EMPLOYEE;

-- 2. 전 사원들의 직원명, 직급코드, 보너스포함연봉(원) 조회
--    단, 보너스포함연봉값에 절대 NULL이 나와서는 안됨
--    뿐만아니라 이때 보너스포함연봉은 \57,000,000원 형식으로 조회되게 함
SELECT EMP_NAME "직원명", JOB_CODE "직급코드", TO_CHAR((SALARY + (SALARY*NVL(BONUS, 0)))*12, 'L999,999,999') || '원' "보너스포함연봉(원)"
FROM EMPLOYEE
WHERE (SALARY + SALARY*BONUS)*12 IS NOT NULL;

-- 3. 부서코드가 D5, D9인 직원들 중 2004년에 입사한 직원들의 사번, 사원명, 부서코드, 입사일 조회
SELECT EMP_ID "사번", EMP_NAME "사원명", DEPT_CODE "부서코드", HIRE_DATE "입사일"
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5','D9')
  AND EXTRACT(YEAR FROM HIRE_DATE) = 2004;
-- SUBSTR(HIRE_DATE, 1, 2) = '04';  -- DATE형식도 SUBSTR함수 사용가능함!!

-- 4. 직원명, 입사일, 입사한 달의 근무일수(주말에 대한건 고려하지 말 것) 조회
SELECT EMP_NAME "직원명", HIRE_DATE "입사일", LAST_DAY(HIRE_DATE) - HIRE_DATE +1 "입사한 달의 근무일수"
FROM EMPLOYEE;
-- 입사한 날도 근무일수에 포함하고 싶으면 +1, 그게 아니면 안해도됨

-- 5. 직원명, 부서코드, 생년월일 조회
--    단, 생년월일은 XX년 XX월 XX일 형식으로 조회되게 함
SELECT EMP_NAME "직원명", DEPT_CODE "부서코드", TO_CHAR(TO_DATE(SUBSTR(EMP_NO, 1, 6), 'RRMMDD'), 'YY"년" MM"월" DD"일"') "생년월일"
FROM EMPLOYEE;
/*
    SUBSTR(EMP_NO, 1, 2) || '년 ' ||
    SUBSTR(EMP_NO, 3, 2) || '월 ' || 
    SUBSTR(EMP_NO, 5, 2) || '일 ' "생년월일" 가능

*/

-- 6. 부서코드가 D5, D6, D9인 사원들만 조회를 하되 이때 직원명, 부서코드, 부서명을 조회
--    (부서명에 대한 값으로는
--     해당 부서코드가 D5일 경우는 총무부로, D6일 경우 기획부로, D9일 경우 영업부로 조회되게끔 하시오)
--    => CASE WHEN도 사용해보고, DECODE도 사용해보삼!
-->CASE WHEN
SELECT EMP_NAME "직원명", DEPT_CODE "부서코드", DEPT_TITLE "부서명",
       CASE 
            WHEN DEPT_CODE = 'D5' THEN '총무부'
            WHEN DEPT_CODE = 'D6' THEN '기획부'
            WHEN DEPT_CODE = 'D9' THEN '영업부'
        END "부서명"
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID
  AND DEPT_CODE IN ('D5', 'D6', 'D9');
  
--> DECODE
SELECT EMP_NAME "직원명", DEPT_CODE "부서코드", DEPT_TITLE "부서명",
       DECODE(DEPT_CODE, 'D5', '총무부', 'D6', '기획부', 'D9', '영업부') "부서명"
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID
  AND DEPT_CODE IN ('D5', 'D6', 'D9');      