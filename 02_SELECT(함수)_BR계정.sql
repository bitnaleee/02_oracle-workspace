/*
    * 함수 FUNCTION
    전달된 컬럼값을 읽어들여서 함수를 실행한 결과를 반환함
    
    - 단일행 함수 : N개의 값을 읽어 들여서 N개의 결과값을 반환 (매 행마다 함수 실행 결과 반환)
    - 그룹 함수 : N개의 값을 읽어들여서 1개의 결과값을 반환 (그룹을 지어 그룹별로 함수 실행 결과 반환)
    
    >> SELECT절 단일행함수랑 그룹함수를 함께 기술 못함!
       => 왜? 결과 행의 갯수가 다르기 때문에
       
    >> 함수식을 기술할 수 있는 위치 : SELECT절, WHERE절, ORDER BY절, HAVING절, DML문 등
    
*/

-- =========================== < 단일행 함수 > ================================

/*
    < 문자 처리 함수 >
    
    * LENGTH / LENGTHB
    LENGTH('문자열값'|컬럼) : 해당 문자열값의 글자수 반환
    LENGTHB('문자열값'|컬럼) : 해당 문자열값의 바이트수 반환
    
    '강' '나' 'ㄱ' 한글 한글자당 3BYTE
    영문자,숫자,특수문자 한글자당 1BYTE

*/

SELECT LENGTH('오라클'), LENGTHB('오라클')
FROM DUAL;

SELECT LENGTH('oracle'), LENGTHB('oracle')
FROM DUAL;

SELECT EMP_NAME, LENGTH(EMP_NAME), LENGTHB(EMP_NAME)
FROM EMPLOYEE;

------------------------------------------------------------------------------

/*
    *INSTR
    문자열로부터 특정 문자의 시작위치를 찾아서 반환
    
    INSTR(컬럼| '문자열값', '찾고자하는문자', [찾을위치의 시작값, (순번)])
    
    > 찾을위치의 시작값
    1 : 앞에서부터 탐색하겠다.
    -1 : 뒤에서부터 탐색하겠다.
    
*/

SELECT INSTR('AABAACAABBAA', 'B') FROM DUAL; -- 찾을위치의시작값 1기본값, 순번 1 기본값
SELECT INSTR('AABAACAABBAA', 'B', -1) FROM DUAL;
SELECT INSTR('AABAACAABBAA', 'B', 1, 2) FROM DUAL;
SELECT INSTR('AABAACAABBAA', 'B', 1, 100) FROM DUAL; -- 찾지 못할 경우 0을 반환

SELECT EMAIL, INSTR(EMAIL, '_', 1, 1) "_위치", INSTR(EMAIL, '@') "@위치"
FROM EMPLOYEE;

-------------------------------------------------------------------------------

/*
    * SUBSTR
    문자열에서 특정 문자열을 추출해서 반환 (자바에서의 substring()메소드와 유사)
    
    SUBSTR(STRING, POSITION, [LENGTH])   => 결과값이 CHARACTER타입
    - STRING : 문자타입의 컬럼 또는 '문자열값'
    - POSITION : 문자열을 추출할 시작위치값 (음수값도 제시가능)
    - LENGTH : 추출할 문자 갯수 (생략시 끝까지 의미)
    
*/

SELECT SUBSTR('SHOWMETHEMONEY', 7) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', 5, 2) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', 1, 6) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', -8, 3) FROM DUAL;

SELECT EMP_NAME, EMP_NO, SUBSTR(EMP_NO, 8, 1) "성별"
FROM EMPLOYEE;

-- 여자사원들만 조회
SELECT EMP_NAME
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = '2' OR SUBSTR(EMP_NO, 8, 1) = '4';

-- 남자사원들만 조회
SELECT EMP_NAME
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN ('1','3');

-- 함수 중첩사용
SELECT EMP_NAME, EMAIL, SUBSTR(EMAIL, 1, INSTR(EMAIL, '@') -1) "아이디"
FROM EMPLOYEE;

-------------------------------------------------------------------------------

/*
    * LPAD / RPAD
    문자열에 특정 문자를 왼쪽 또는 오른쪽에 붙일 때 사용
    
    LPAD / RPAD(STRING, 최종적으로 반환할문자의 길이, [덧붙이고자하는 문자]) => 결과값은 CHARACTER 타입
    
    문자열에 덧붙이고자하는 문자를 왼쪽 또는 오른쪽에 덧붙여서 최종 N길이만큼의 문자열을 반환
    
*/

SELECT EMP_NAME, LPAD(EMAIL, 20) -- 덧붙이고자하는문자 생략시 기본값이 공백
FROM EMPLOYEE;

SELECT EMP_NAME, LPAD(EMAIL, 20, '#') 
FROM EMPLOYEE;

SELECT EMP_NAME, RPAD(EMAIL, 20, '#') 
FROM EMPLOYEE;

-- 850918-2****** 형식으로 조회 => 총 글자수 : 14글자
SELECT EMP_NAME, RPAD(SUBSTR(EMP_NO, 1 , 8), 14 , '*')
FROM EMPLOYEE;

SELECT EMP_NAME, SUBSTR(EMP_NO, 1, 8) || '******'
FROM EMPLOYEE;

-------------------------------------------------------------------------------

/*
    * LTRIM / RTRIM
    문자열에서 특정 문자를 제거한 나머지를 반환
    
    LTRIM / RTRIM(STRING, [제거하고자하는문자들])  => 결과값은 CHARACTER 타입
    
*/

SELECT LTRIM('   B R ') FROM DUAL;   -- 제거하고자하는문자 생략시 기본값이 공백문자
SELECT LTRIM('123123BR123', '123') FROM DUAL;
SELECT LTRIM('ACABACCBR', 'ABC') FROM DUAL;

/*
    * TRIM
    문자열의 앞/뒤/양쪽에 있는 지정한 문자들을 제거한 나머지 변환
    
     TRIM( [ [LEADING|TRAILING|BOTH] 제거하고자하는문자들 FROM ] STRING )
    
*/

-- 기본적으로 양쪽에 있는 문자들 다 찾아서 제거
SELECT TRIM('     B R  ') FROM DUAL;
SELECT TRIM('Z' FROM 'ZZZBRZZZ') FROM DUAL;

SELECT TRIM(LEADING 'Z' FROM 'ZZZBRZZZ') FROM DUAL; -- LEADING : 앞 => LTRIM
SELECT TRIM(TRAILING 'Z' FROM 'ZZZBRZZZ') FROM DUAL; -- TRAILING : 뒤 => RTRIM
SELECT TRIM(BOTH 'Z' FROM 'ZZZBRZZZ') FROM DUAL; -- BOTH : 양쪽 => 생략시 기본값

------------------------------------------------------------------------------

/*
    * LOWER / UPPER / INITCAP
    
    LOWER/UPPER/INITCAP(STRING) => 결과값은 CHARACTER 타입
    
    LOWER : 다 소문자로 변경
    UPPER : 다 대문자로 변경
    INITCAP : 단어 앞글자마다 대문자로 변경
    
*/

SELECT LOWER('Welcome To My World') FROM DUAL;
SELECT UPPER('Welcome To My World') FROM DUAL;
SELECT INITCAP('welcome to my world') FROM DUAL;

-------------------------------------------------------------------------------

/*
    * CONCAT
    문자열 두개 전달받아 하나로 합친 결과 반환
    
    CONCAT(STRING, STRING)      => 결과값 CHARACTER 타입 -- 두개만 가능 세개는 연결연산자이용
    
*/

SELECT CONCAT('가나다', 'ABC') FROM DUAL;
SELECT '가나다' || 'ABC' FROM DUAL;

-------------------------------------------------------------------------------

/*
    * REPLACE
    
    REPLACE(STRING, STR1, STR2) => 결과값은 CHARACTER 타입
    
*/

SELECT EMP_NAME, EMAIL
FROM EMPLOYEE;

SELECT EMP_NAME, REPLACE(EMAIL, 'br.com', 'gmail.com')  -- 실제 데이터값이 변경된건 아님
FROM EMPLOYEE;

--------------------------------------------------------------------------------

/*
    < 숫자 처리 함수 >
    
    * ABS
    숫자의 절대값을 구해주는 함수
    
    ABS(NUMBER)     => 결과값은 NUMBER타입
    
*/

SELECT ABS(-10) FROM DUAL;
SELECT ABS(-5.7) FROM DUAL;

-------------------------------------------------------------------------------

/*
    MOD
    두 수를 나눈 나머지값을 반환해주는 함수
    
    MOD(NUMBER, NUMBER)     => 결과값 NUMBER 타입

*/

SELECT 10 / 3 FROM DUAL;
-- SELECT 10 % 3 FROM DUAL; -- % 같은 연산자 없음
SELECT MOD(10, 3) FROM DUAL;
SELECT MOD(10.9, 3) FROM DUAL;

-------------------------------------------------------------------------------

/*
    * ROUND
    반올림한 결과를 반환
    
    ROUND(NUMBER, [위치])     => 결과값은 NUMVER 타입

*/

SELECT ROUND(123.456) FROM DUAL; -- 위치 생략시 기본값 0
SELECT ROUND(123.456, 0) FROM DUAL;
SELECT ROUND(123.456, 1) FROM DUAL;
SELECT ROUND(123.456, 5) FROM DUAL;
SELECT ROUND(123.456, -1) FROM DUAL;
SELECT ROUND(123.456, -2) FROM DUAL;

SELECT ROUND(15703, -3) FROM DUAL;

--------------------------------------------------------------------------------

/*
    * CEIL
    올림처리해주는 함수
    
    CEIL(NUMBER)

*/

SELECT CEIL(123.001) FROM DUAL;
--SELECT CEIL(123.001, 2) FROM DUAL; -- 오류 발생 (위치 지정 불가능)

--------------------------------------------------------------------------------

/*
    * FLOOR
    소수점 아래 버림처리하는 함수
    
    FLOOR (NUMBER)

*/

SELECT FLOOR(123.152) FROM DUAL;
SELECT FLOOR(123.999) FROM DUAL;

-------------------------------------------------------------------------------

/*
    * TRUNC
    위치 지정 가능한 버림처리해주는 함수
    
    TRUNC(NUMBER, [위치])

*/

SELECT TRUNC(123.152) FROM DUAL;
SELECT TRUNC(123.152, 1) FROM DUAL;
SELECT TRUNC(123.152, -1) FROM DUAL;

SELECT EMP_NAME, HIRE_DATE, FLOOR(SYSDATE - HIRE_DATE) "근무일수"
FROM EMPLOYEE
ORDER BY 근무일수 DESC;

-------------------------------------------------------------------------------

/*
    < 날짜 처리 함수 >
    
*/

-- * SYSDATE : 현재 시스템 날짜 및 시간 반환
SELECT SYSDATE FROM DUAL;

-- * MONTHS_BETWEEN(DATE1, DATE2) : 두 날짜 사이의 개월 수 => 내부적으로 DATE1 - DATE2 후 나누기 30, 31이 진행됨
-- => 결과값 NUMBER 타입
-- 사원명, 입사일, 근무개월수
SELECT EMP_NAME, HIRE_DATE, CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) || '개월차' "근무개월수"
FROM EMPLOYEE;

-- * ADD_MONTHS(DATE, NUMBER) : 특정 날짜에 해당 숫자만큼의 개월수를 더해서 그 날짜 리턴
-- => 결과값은 DATE 타입
SELECT ADD_MONTHS(SYSDATE, 3) FROM DUAL;

-- 사원명, 입사일, 입사후 6개월이 된 날짜(정규직이 된 날짜) 조회
SELECT EMP_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE, 6)
FROM EMPLOYEE;

-- * NEXT_DAY(DATE, 요일(문자|숫자)) : 특정날짜 이후에 가까운 해당 요일의 날짜를 반환해주는 함수
-- => 결과값은 DATE 타입
SELECT SYSDATE, NEXT_DAY(SYSDATE, '금요일')FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, '토')FROM DUAL;
-- 1:일요일, 2:월요일, ..., 6:금요일, 7:토요일
SELECT SYSDATE, NEXT_DAY(SYSDATE, 7)FROM DUAL;

SELECT SYSDATE, NEXT_DAY(SYSDATE, 'FRIDAY')FROM DUAL; -- 에러 (현재언어가 KOREAN이기 때문)

-- 언어변경
ALTER SESSION SET NLS_LANGUAGE = AMERICAN;
ALTER SESSION SET NLS_LANGUAGE = KOREAN;

-- * LAST_DAY(DATE): 해당 월의 마지막 날짜를 구해서 반환
-- => 결과값 DATE 타입
SELECT LAST_DAY(SYSDATE) FROM DUAL;

-- 사원명, 입사일, 입사한 달의 마지막 날짜, 입사한달에 근무한 일수
SELECT EMP_NAME, HIRE_DATE, LAST_DAY(HIRE_DATE), LAST_DAY(HIRE_DATE)- HIRE_DATE
FROM EMPLOYEE;

/*
    * EXTRACT : 특정 날짜로부터 년도 / 월 / 일만 추출해서 반환하는 함수
    
    EXTRACT(YEAR|MONTH|DAY FROM DATE)       => 결과값은 NUMBER 타입
    
*/
-- 사원명, 입사년도, 입사월, 입사일 조회
SELECT EMP_NAME,
       EXTRACT(YEAR FROM HIRE_DATE) "입사년도",
       LPAD(EXTRACT(MONTH FROM HIRE_DATE), 2, '0') "입사월",
       EXTRACT(DAY FROM HIRE_DATE) "입사일"
   FROM EMPLOYEE;     

--------------------------------------------------------------------------------

/*
    < 형변환 함수 >
    
    * TO_CHAR : 숫자 타입 또는 날짜 타입의 값을 문자 타입으로 변환시켜주는 함수
    
    TO_CHAR(숫자|날짜, [포맷])  => 결과값은 CHARACTER 타입
    
*/

-- 숫자 ==> 문자 타입
SELECT TO_CHAR(1234) FROM DUAL;

SELECT TO_CHAR(1234, '99999') FROM DUAL;    -- 5칸 자리 확보, 오른쪽 정렬, 빈칸 공백으로 채움 음수로 바꿀 자리 한칸 확보해놓는게 좋음
SELECT TO_CHAR(1234, '00000') FROM DUAL;    --                          빈칸 0으로 채움
SELECT TO_CHAR(-1234, '00000') FROM DUAL;
SELECT TO_CHAR(1234, 'L99999') FROM DUAL;   -- L : 현재 설정된 나라의 화폐단위 표시 빈칸 공백 
SELECT TO_CHAR(1234, 'fmL99999') FROM DUAL; -- FM : 공백을 없앨 때 사용됨
SELECT TO_CHAR(1234, '$99999') FROM DUAL;     -- $ 표시
SELECT TO_CHAR(1234, 'L99,999') FROM DUAL;  -- 콤마 표시

SELECT EMP_NAME, TO_CHAR(SALARY, 'L999,999,999'),TO_CHAR(SALARY*12, 'L999,999,999')
FROM EMPLOYEE;

-- 날짜 ==> 문자타입
SELECT SYSDATE FROM DUAL;
SELECT TO_CHAR(SYSDATE) FROM DUAL;  -- 22/11/16 기본포맷

SELECT TO_CHAR(SYSDATE, 'PM HH:MI:SS') FROM DUAL;   -- HH : 12시간 형식
SELECT TO_CHAR(SYSDATE, 'PM HH24:MI:SS') FROM DUAL; -- HH24 : 24시간 형식
SELECT TO_CHAR(SYSDATE, 'PM FMHH24:MI:SS') FROM DUAL;   -- FM : 0을 없앨 수 있음 (단, FM이 붙은 자리 이후 모두 적용)
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD DAY') FROM DUAL; 
SELECT TO_CHAR(SYSDATE, 'MON, YYYY') FROM DUAL;

-- 년도와 관련된 포맷
SELECT TO_CHAR(SYSDATE, 'YYYY'),
       TO_CHAR(SYSDATE, 'YY'),
       TO_CHAR(SYSDATE, 'RRRR'),
       TO_CHAR(SYSDATE, 'RR'),
       TO_CHAR(SYSDATE, 'YEAR')
FROM DUAL;

--월과 관련된 포맷
SELECT TO_CHAR(SYSDATE, 'MM'),
       TO_CHAR(SYSDATE, 'MON'),
       TO_CHAR(SYSDATE, 'MONTH'),
       TO_CHAR(SYSDATE, 'RM')
FROM DUAL;

--일과 관련된 포맷
SELECT TO_CHAR(SYSDATE, 'DDD'), -- 년 기준 몇일째
       TO_CHAR(SYSDATE, 'DD'),  -- 월 기준 몇일째
       TO_CHAR(SYSDATE, 'D')    -- 주 기준 몇일째 (1-7, 일-토)
FROM DUAL;

--요일에 관련된 포맷
SELECT TO_CHAR(SYSDATE, 'DAY'),
       TO_CHAR(SYSDATE, 'DY')
FROM DUAL;

--XXXX년 XX월 XX일 (X)
SELECT EMP_NAME, TO_CHAR(HIRE_DATE, 'YYYY"년" MM"월" DD"일" (DY)') --()같은 특수문자는 O 년월일같은 문자는 쌍따옴표로 묶어줄것
FROM EMPLOYEE;

-------------------------------------------------------------------------------

/*
    * TO_DATE : 숫자 타입 또는 문자 타입 데이터를 날짜 타입으로 변환시켜주는 함수
    
    TO_DATE(숫자|문자, [포맷])     => 결과값 DATE 타입
    
*/

SELECT TO_DATE(20100101) FROM DUAL;
SELECT TO_DATE(100101) FROM DUAL;
SELECT TO_DATE(1001) FROM DUAL; -- 에러

SELECT TO_DATE(070101) FROM DUAL;   -- 에러 (앞0을 빼고 70101숫자로 인식해버림)
SELECT TO_DATE('070101') FROM DUAL;

SELECT TO_DATE('041030 143005', 'YYMMDD HH24MISS') FROM DUAL;

SELECT TO_DATE('140630', 'YYMMDD') FROM DUAL;   -- 2014년
SELECT TO_DATE('980630', 'YYMMDD') FROM DUAL;   -- 2098년
-- YY : 무조건 현재 세기로 반영 

SELECT TO_DATE('140630', 'RRMMDD') FROM DUAL;   -- 2014년
SELECT TO_DATE('980630', 'RRMMDD') FROM DUAL;   -- 1989년
-- RR : 해당 두 자리 년도가 50미만일 경우 현재세기 반영, 50이상일 경우 이전 세기 반영

-------------------------------------------------------------------------------

/*
    * TO_NUMBER : 문자타입의 데이터를 숫자타입으로 변환시켜주는 함수
    
    TO_NUMBER(문자, [포맷])     => 결과값은 NUMBER 타입
    
*/

SELECT TO_NUMBER('05123485') FROM DUAL;

SELECT '1000000' * '550000' FROM DUAL;  -- 오라클에서는 자동형변환 잘 되어있음

SELECT '1,000,000' * '550,000' FROM DUAL;   -- 에러발생

SELECT TO_NUMBER('1,000,000', '999,999,999') + TO_NUMBER('550,000', '999,999,999') FROM DUAL;

-------------------------------------------------------------------------------

/*
    < NULL 처리 함수 >
    
*/

-- * NVL(컬럼, 해당컬럼값이 NULL일 경우 반환할 값)
SELECT EMP_NAME, NVL(BONUS, 0)
FROM EMPLOYEE;

SELECT EMP_NAME, NVL(BONUS, '없음')   --  타입이 맞지 않아 오류
FROM EMPLOYEE;

-- 전 사원의 이름 보너스 포함 연봉
SELECT EMP_NAME, (SALARY + SALARY*NVL(BONUS, 0)) * 12, NVL(DEPT_CODE, '부서없음')
FROM EMPLOYEE;

-- * NVL2(컬럼, 반환값1, 반환값2)
-- 컬럼값이 존재할 경우 반환값 : 반환
-- 컬럼값이 존재하지 않을 경우 반환값 : 반환
SELECT EMP_NAME, BONUS, NVL2(BONUS, 0.7, 0.1)
FROM EMPLOYEE;

SELECT EMP_NAME, NVL2(DEPT_CODE, '부서없음', '부서없음')
FROM EMPLOYEE;


-- * NULLIF(비교대상, 비교대상2)
-- 두 개의 값이 일치하면 NULL 반환
-- 두 개의 값이 일치하지 않으면 비교대상1 반환
SELECT NULLIF('123', '123') FROM DUAL;
SELECT NULLIF('123', '456') FROM DUAL;

-------------------------------------------------------------------------------

/*
    < 선택 함수 >
    
    * DECODE(비교하고자하는대상컬럼|산술연산|함수식, 비교값1, 결과값1, 비교값2, 결과값2, ..., 결과값N)

*/

-- 사번, 사원명, 주민번호, 성별
SELECT EMP_ID, EMP_NAME, EMP_NO, DECODE(SUBSTR(EMP_NO, 8 , 1), 1, '남', 3, '남', 2, '여', 4, '여') "성별"
FROM EMPLOYEE;

-- 직원의 급여 조회 시 각 직급별로 인상시켜서 조회
-- J7인 사원은 급여를 10% 인상 (SALARY * 1.1)
-- J6인 사원은 급여를 15% 인상 (SALARY * 1.15)
-- J5인 사원은 급여를 20% 인상 (SALARY * 1.2)
-- 그 외의 사원은 급여를 5% 인상 (SALARY * 1.05)

-- 사원명, 직급코드, 기존급여, 인상된 급여

SELECT EMP_NAME, JOB_CODE, SALARY,
       DECODE(JOB_CODE, 'J7', SALARY*1.1, 
                        'J6', SALARY * 1.15, 
                        'J5', SALARY * 1.2, 
                              SALARY * 1.05) "인상금액"
FROM EMPLOYEE;

-------------------------------------------------------------------------------

/*
    * CASE WHEN THEN
    
    [표현법1]
    CASE WHEN 조건식1 THEN 결과값1
         WHEN 조건식2 THEN 결과값2
         ...
         ELSE 결과값N
    END
    
    [표현법2]
    CASE 비교대상컬럼 | 산술연산식 | 함수식
         WHEN 비교값1 THEN 결과값1
         WHEN 비교값2 THEN 결과값2
         ...
         ELSE 결과값N
    END
    
*/

SELECT EMP_ID, EMP_NAME, EMP_NO,
       CASE WHEN SUBSTR(EMP_NO, 8, 1) IN ('1', '3') THEN '남'
            WHEN SUBSTR(EMP_NO, 8, 1) IN ('2', '4') THEN '여'
       END "성별"
FROM EMPLOYEE;

SELECT EMP_ID, EMP_NAME, EMP_NO,
       CASE SUBSTR(EMP_NO, 8, 1)
            WHEN '1' THEN '남'
            WHEN '2' THEN '여'
       END "성별"
FROM EMPLOYEE;

-- 사원명, 급여, 등급
-- 급여가 500만원 이상일 경우 '고급'
-- 급여가 350만원 이상일 경우 '중급'
-- 둘 다 아닐 경우 '초급'

SELECT EMP_NAME, SALARY,
       CASE WHEN SALARY >= 5000000 THEN '고급'
            WHEN SALARY >= 3500000 THEN '중급'
            ELSE '초급'
       END  "등급"    
FROM EMPLOYEE;

-- =========================== < 그룹 함수 > ================================

/*
    < 그룹 함수 >
    
*/

-- 1. SUM(NUMBER) : 해당 컬럼 값들의 총 합계를 구해서 반환해주는 함수

-- EMPLOYEE에 전 사원들의 총 급여 합
SELECT SUM(SALARY)
FROM EMPLOYEE; -- 전체사원이 한 그룹으로 묶임

-- 남자 사원들의 총 급여 합
SELECT SUM(SALARY)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN ('1', '3'); -- 남자사원들이 한 그룹으로 묶임

-- 2. AVG(NUMBER) : 해당 컬럼값들의 평균값을 구해서 반환해주는 함수

-- 전 사원의 평균 급여 조회
SELECT ROUND(AVG(SALARY))
FROM EMPLOYEE;

-- 3. MIN(ANY타입) : 해당 컬럼값들 중에 가장 작은 값 구해서 반환

SELECT MIN(EMP_NAME), MIN(SALARY), MIN(HIRE_DATE)
FROM EMPLOYEE;

-- 4. MAX(ANY타입) : 해당 컬럼값들 중에 가장 큰 값 구해서 반환

SELECT MAX(EMP_NAME), MAX(SALARY), MAX(HIRE_DATE)
FROM EMPLOYEE;

-- 5. COUNT(* | 컬럼 | DISTINCT 컬럼) : 행 갯수를 세서 반환
      COUNT(*) : 조회될 결과의 모든 행 갯수를 세서 반환
      COUNT(컬럼) : 제시한 해당 컬럼값이 NULL이 아닌 것만 행 갯수 세서 반환
      COUNT(DISTINCT 컬럼) : 해당 컬럼값을 중복 제거한 후 행 갯수 세서 반환

-- 전체 사원 수 
SELECT COUNT(*)
FROM EMPLOYEE;

-- 여자 사원 수 
SELECT COUNT(*)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN ('2', '4')

-- 보너스를 받는 사원 수
SELECT COUNT(*)
FROM EMPLOYEE
WHERE BONUS IS NOT NULL;

SELECT COUNT(BONUS)
FROM EMPLOYEE;

-- 부서배치를 받은 사원 수
SELECT COUNT(DEPT_CODE)
FROM EMPLOYEE;

-- 현재 사원들이 총 몇개의 직급에 분포되어있는지
SELECT COUNT(DISTINCT JOB_CODE)
FROM EMPLOYEE;

-- 현재 사원들이 총 몇개의 부서에 속해있는지
SELECT COUNT(DISTINCT DEPT_CODE)
FROM EMPLOYEE;


