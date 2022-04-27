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
SELECT NEXT_DAY(SYSDATE,'금요일')
FROM DUAL;