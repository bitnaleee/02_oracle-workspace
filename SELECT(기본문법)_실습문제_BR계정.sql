-- BR계정에서 풀 것!! 

-- 1. 사수가 없고 부서배치도 받지 않은 사원들의 (사원명, 사수사번, 부서코드) 조회
SELECT EMP_NAME, EMP_ID, DEPT_CODE
FROM EMPLOYEE
WHERE MANAGER_ID IS NULL AND DEPT_CODE IS NULL;

-- 2. 연봉(보너스포함X)이 3000만원 이상이고 보너스를 받지 않는 사원들의 (사번, 사원명, 급여, 보너스) 조회
SELECT EMP_ID, EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
WHERE SALARY*12 >= 30000000 AND BONUS IS NULL;

-- 3. 입사일이 '95/01/01'이상이고 부서배치를 받은 사원들의 (사번, 사원명, 입사일, 부서코드) 조회
SELECT EMP_ID, EMP_NAME, HIRE_DATE, DEPT_CODE
FROM EMPLOYEE
WHERE HIRE_DATE >= '95/01/01' AND DEPT_CODE IS NOT NULL;


-- 4. 급여가 200만원 이상 500만원 이하고 입사일이 '01/01/01'이상이고 보너스를 받지 않는 사원들의 
--   (사번, 사원명, 급여, 입사일, 보너스) 조회
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE, BONUS
FROM EMPLOYEE
WHERE SALARY BETWEEN 2000000 AND 5000000 
  AND HIRE_DATE >= '01/01/01' 
  AND BONUS IS NULL;

-- 5. 보너스포함연봉이 NULL이 아니고 이름에 '하'가 포함되어있는 사원들의 (사번, 사원명, 급여, 보너스포함연봉)
SELECT EMP_ID, EMP_NAME, SALARY, (SALARY + SALARY*BONUS)*12 "보너스포함연봉"
FROM EMPLOYEE
WHERE (SALARY + SALARY*BONUS)*12 IS NOT NULL 
  AND EMP_NAME LIKE '%하%';