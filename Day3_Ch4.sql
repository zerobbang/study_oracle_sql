-- CHAPTER4 함수
-- 1. 숫자 함수 p. 126

-- ABS(n)
-- 절대값을 반환
SELECT ABS(10), ABS(-10), ABS(-10.123) FROM DUAL;


-- CEIL(n) / FLOOR(n)
-- ceil n과 같거나 가장 큰 정수를 반환
-- floor <-> ceil
-- floor n 보다 작거나 같은 정수 반환
SELECT CEIL(10.123), CEIL(10.541), CEIL(11.001), CEIL(-2.51), FLOOR(10.123), FLOOR(-2.51), FLOOR(2)
FROM DUAL;


-- ROUND(n,i)
-- N을 I에 따라 반올림한 결과를 반환.
-- I는 생략 가능
-- DEFAULT 값 0
SELECT 
    ROUND(10.154)
    , ROUND(10.151)
    , ROUND(11.001)
    , ROUND(-10.154)
    , ROUND(-10.151)
    , ROUND(-11.001)
FROM DUAL;

SELECT 
    ROUND(10.154,1)
    , ROUND(10.151,2)
    , ROUND(-10.154,1)
    , ROUND(-10.151,2)
    , ROUND(0,3)
    , ROUND(115.155, -1)
    , ROUND(115.155, -2)
FROM DUAL;


-- TRUNC(n, i)
-- 반올림을 하지 않고 n을 소수점 i 기준 오른쪽을 버림한다.
SELECT TRUNC (115.155), TRUNC(115.155,1), TRUNC(115.155,2), TRUNC(115.155, -2)
FROM DUAL;


-- POWER(n2,n1) / SQRT(n)
SELECT POWER(3,2), POWER(3,3), POWER(3,3.001), SQRT(2), SQRT(9)
FROM DUAL;

-- MOD(n2, n1) / REMAINDER(n2,n1)
-- MOD n2/n1의 나머지 값
-- REMAINDER n1/n2의 나머지 값 
SELECT MOD(19,4), MOD (19.123, 4.2), REMAINDER(19,4)
FROM DUAL;


-- EXP(n)  / LN(n) / LOG(n2, n1)
-- EXP 지수 함수, LN 자연 로그 함수, LOG 로그
SELECT EXP(2), LN(2.713), LOG(10,100)
FROM DUAL;


-- 문자 함수

-- CONCAT 
-- || 연산자 처럼 매개 변수로 들어오는 두 문자 붙여 반환한다.
SELECT CONCAT('I HAVE', ' A DREAM') , 'I HAVE' || ' A DREAM'
FROM DUAL;

-- SUBSTR(char, pos, len)  중요***
-- 문자를 자른다.
-- 문자열 char의 pos번째 문자부터 len길이만큼 잘라낸다.
SELECT SUBSTR ('ABCDEFG',1,4), SUBSTR('ABCDEFG',1,2) , SUBSTR('ABCDEFG', -1, 4)
FROM DUAL;

-- SUBSTRB(char, pos, len) 
-- 문자열의 바이트 수만큼 LEN 잘라낸다.
SELECT SUBSTRB('ABCDEFG',1,4), SUBSTRB('가나다라마바',1,4)
FROM DUAL;

-- LTRIM (char, set)
-- char에서 set문자열을 왼쪽부터 해서 제거한다.
-- RTRIM (char, set)
-- char에서 set문자열을 오른쪽 끝에서 제거한다.
-- CHAR는 맨 왼쪽 또는 맨 오른쪽에 있어야 한다.
-- SET가 문자 중간에 있으면 문자 전체를 반환한다.
SELECT LTRIM('ABCDABC','ABC'), LTRIM('가나다라가','가'), RTRIM('ABCDABC','ABC'), RTRIM ('가나다라가','가')
FROM DUAL;

-- LPAD / RPAD
-- LPAD (expr1, n, expr2)
-- RPAD (expr1, n, expr2)
-- expr2를 n자리만큼 왼쪽 또는 오른쪽부터 채워 expr1을 반환
CREATE TABLE ex4_1(
    phone_num VARCHAR2(30)
);

INSERT INTO ex4_1 VALUES ('111-1111');
INSERT INTO ex4_1 VALUES ('111-2222');
INSERT INTO ex4_1 VALUES ('111-3333');

SELECT LPAD(phone_num, 12,'(02)')
FROM ex4_1;

SELECT RPAD(phone_num, 12,'(02)')
FROM ex4_1;




-- 날짜 함수

SELECT SYSDATE, SYSTIMESTAMP FROM DUAL;

-- ADD MONTHS
SELECT ADD_MONTHS (SYSDATE,1), ADD_MONTHS(SYSDATE, -1)
FROM DUAL;

-- MONTHS_BETWEEN
SELECT  MONTHS_BETWEEN(SYSDATE, ADD_MONTHS(SYSDATE,1)) mon1
        , MONTHS_BETWEEN(ADD_MONTHS(SYSDATE,1),SYSDATE) mon2
FROM DUAL;

-- LAST DAY
SELECT LAST_DAY(SYSDATE), LAST_DAY(ADD_MONTHS(SYSDATE,4))
FROM DUAL;

-- ROUND(date, format) / TRUNC(date, format)
SELECT SYSDATE, ROUND(SYSDATE,'month'), ROUND(SYSDATE,'year'), TRUNC(SYSDATE,'month')
FROM DUAL; 


-- NEXT DAY
SELECT NEXT_DAY(SYSDATE,'일요일')
FROM DUAL;





-- 변환 함수
--p.140
SELECT TO_CHAR(123456789, '999,999,999')
FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD')
FROM DUAL;

SELECT TO_NUMBER('123456')
FROM DUAL;

SELECT TO_DATE('20220427','YYYY-MM-DD')
FROM DUAL;

SELECT TO_DATE('20220427','YYYY-MM-DD HH24:MI:SS')
FROM DUAL;





-- NULL 관련 함수
-- NVL(expr1, expr2)
-- expr1이 null 이면 expr2가 반환
SELECT NVL (manager_id, employee_id) FROM employees
WHERE manager_id IS NULL;
-- NVL2(expr1, expr2, expr3)
-- expr1이 NULL이 아니면 expr2, NULL이면 expr3
SELECT employee_id,
    NVL2(commission_pct, salary + (salary * commission_pct), salary) AS salary2
FROM employees;

-- COALESCE(expr1, expr2)
-- expr1이 NILL이면 expr2, NULL이 아니면 expr1
SELECT employee_id, salary, commission_pct,
    COALESCE (salary * commission_pct, salary ) AS salary2
FROM employees;

-- LNNVL (조건식)
-- 조건식이 FALSE나 UNKNOWN이면 TRUE, TRUE 이면 FALSE
SELECT employee_id, commission_pct
FROM employees
WHERE commission_pct < 0.2;
-- NULL은 포함되어 있지 않았다.

SELECT COUNT(*)
FROM employees
WHERE NVL(commission_pct, 0 )< 0.2;
-- 0.2이하인 값들을 83개

SELECT COUNT(*)
FROM employees
WHERE LNNVL(commission_pct >= 0.2) ;
-- NULL값 포함
-- LNNVL은 결과를 반대로 출력하기 때문에 여기서 우리가 얻고자 하는 0.2이하의 값들을 구하기 위해서는
-- 위와 같이 commission_pct >= 0.2로 연산해야 한다.

-- NULLIF (expr1, expr2)
-- expr1 expr2를 비교해 같으면 NULL,  다르면 expr1 반환
SELECT TO_CHAR(employee_id) , TO_CHAR(start_date, 'YYYY') start_year,
    TO_CHAR(end_date,'YYYY') end_year
    , NULLIF(TO_CHAR(end_date,'YYYY'), TO_CHAR(start_date,'YYYY') ) nullif_year
FROM job_history;




-- 기타 함수
-- GREATEST (expr1,expr2,...)
-- LEAST (expr1, expr2, ... )
SELECT GREATEST (1,2,3,2), LEAST(1,2,3,2)
FROM DUAL;

SELECT GREATEST ('이순신','강감찬','세종대왕'), LEAST('이순신','강감찬','세종대왕')
FROM DUAL;

-- DECODE(expr, search1, result1, search2, result2, ... , default)
-- expr와 search1을 비교하여 갑으면 result1, search2와 같으면 result2, 없으면 default 값 반환
SELECT channel_id
    , prod_id
    , DECODE(channel_id, 3, 'Direct',
                                9, 'Direct',
                                5, 'Indirect',
                                4, 'Indirect',
                                'Oters') decodes
FROM sales
WHERE prod_id =125;
