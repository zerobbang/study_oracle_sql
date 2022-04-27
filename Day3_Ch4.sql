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