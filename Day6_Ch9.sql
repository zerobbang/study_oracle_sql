-- Chapter 9
-- IF문
SET SERVEROUTPUT ON
DECLARE
    vn_num1 NUMBER := 1;
    vn_num2 NUMBER := 2;
BEGIN
    IF vn_num1 >= vn_num2 THEN
        DBMS_OUTPUT.PUT_LINE(vn_num1 || '이 큰 수이다.');
    ELSE
        DBMS_OUTPUT.PUT_LINE(vn_num2 || '이 큰 수 이다.');
    END IF;
END;

-- 중첩 IF문
DECLARE
    vn_salary NUMBER := 0;
    vn_department_id NUMBER := 0;
    vn_comission NUMBER := 0;
BEGIN
    vn_department_id := ROUND(DBMS_RANDOM.VALUE(10,120),-1);
    
    SELECT salary, commission_pct
        INTO vn_salary, vn_comission
    FROM employees
    WHERE department_id = vn_department_id
        AND ROWNUM = 1;
        
        DBMS_OUTPUT.PUT_LINE(vn_salary);
        
    IF vn_comission > 0 THEN
        IF vn_comission > 0.15 THEN
            DBMS_OUTPUT.PUT_LINE(vn_salary * vn_comission );
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE(vn_salary);
    END IF;
END;




-- CASE 사용
DECLARE
    vn_salary NUMBER := 0;          -- 변수 초기화
    vn_department_id NUMBER := 0;   -- 변수 초기화
BEGIN
    vn_department_id := ROUND(DBMS_RANDOM.VALUE (10, 120), -1);
    
    SELECT salary
        INTO vn_salary
    FROM employees
    WHERE department_id = vn_department_id
        AND ROWNUM = 1;
    
    DBMS_OUTPUT.PUT_LINE(vn_salary);
    
    CASE WHEN vn_salary BETWEEN 1 AND 3000 THEN
            DBMS_OUTPUT.PUT_LINE('낮음');
        WHEN vn_salary BETWEEN 3001 AND 6000 THEN
            DBMS_OUTPUT.PUT_LINE('중간');
        WHEN vn_salary BETWEEN 6001 AND 10000 THEN
            DBMS_OUTPUT.PUT_LINE('높음');
        ELSE
            DBMS_OUTPUT.PUT_LINE('최상위');
    END CASE;
END;



-- LOOP문
DECLARE
    vn_base_num NUMBER := 3;
    vn_cnt NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE (vn_base_num || '*' || vn_cnt || '= ' || vn_base_num * vn_cnt);
        vn_cnt := vn_cnt + 1;
        EXIT WHEN vn_cnt > 9;
    END LOOP;
END;



-- WHILE문 조건이 참일 때만 Loop문 실행
DECLARE
    vn_base_num NUMBER := 3;
    vn_cnt NUMBER := 1;
BEGIN
WHILE vn_cnt <=9
    LOOP
        DBMS_OUTPUT.PUT_LINE (vn_base_num || '*' || vn_cnt || '= ' || vn_base_num * vn_cnt);
        vn_cnt := vn_cnt + 1;
    END LOOP;
END;

-- +  EXIT 절 추가
DECLARE
    vn_base_num NUMBER := 3;
    vn_cnt NUMBER := 1;
BEGIN
WHILE vn_cnt <= 9
    LOOP
        DBMS_OUTPUT.PUT_LINE (vn_base_num || '*' || vn_cnt || '= ' || vn_base_num * vn_cnt);
        EXIT WHEN vn_cnt = 5;
        vn_cnt := vn_cnt + 1;
    END LOOP;
END;



-- FOR문
DECLARE
    vn_base_num NUMBER := 3;
BEGIN 
    FOR i IN 1..9
    LOOP
        DBMS_OUTPUT.PUT_LINE(vn_base_num || '*' || i || '= ' || vn_base_num * i);
    END LOOP;
END;

-- + REVERSE 사용
DECLARE
    vn_base_num NUMBER := 3;
BEGIN 
    FOR i IN REVERSE 1..9
    LOOP
        DBMS_OUTPUT.PUT_LINE(vn_base_num || '*' || i || '= ' || vn_base_num * i);
    END LOOP;
END;


-- CONTINUE문
-- 조건에 해당하는 경우 다음 코드를 실행하지 않고 넘어간다.
DECLARE
    vn_base_num NUMBER:= 3;
BEGIN
    FOR i IN 1..9
    LOOP
        CONTINUE WHEN i=5;
        DBMS_OUTPUT.PUT_LINE(vn_base_num || '*' || i || '= ' || vn_base_num * i);
    END LOOP;
END;

-- GOTO 문
-- 지정된 라벨로 제어가 넘어간다.
DECLARE
    vn_base_num NUMBER := 3;
BEGIN
    <<third>>
    FOR i IN 1..9
    LOOP
        DBMS_OUTPUT.PUT_LINE(vn_base_num || '*' || i ||'= '|| vn_base_num * i);
        IF i = 3 THEN
            GOTO fourth;
        END IF;
    END LOOP;
    
    <<fourth>>
    vn_base_num :=4;
    FOR i IN 1..9
    LOOP
        DBMS_OUTPUT.PUT_LINE(vn_base_num || '*' || i || '= '|| vn_Base_num * i);
    END LOOP;
END;


-- NULL문
-- 아무것도 처리하지 않는 문장
-- IF문이나 CASE문 사용시 주로 사용
-- 조건절에 부합하지 않는 경우 ELSE절에서 아무것도 처리하고 싶지 않을 때 NULL 처리







-- p.285
-- 사용자 정의 함수

-- 함수 생성
-- 나머지 값 반환하는 함수 만들기
CREATE OR REPLACE FUNCTION my_mod ( num1 NUMBER , num2 NUMBER)
    RETURN NUMBER
IS
    vn_remainder NUMBER := 0;
    vn_quotient NUMBER := 0;
BEGIN
    vn_quotient := FLOOR(num1 / num2);              -- 정수 부분 추출
    vn_remainder := num1 - (num2 * vn_quotient);    -- 나머지 부분 추출
    
    RETURN vn_remainder;
END;


-- 함수 호출
SELECT my_mod(14,3) reminder
FROM DUAL;

SELECT my_mod(598,3) reminder
FROM DUAL;



-- 또 다른 함수 만들기
CREATE OR REPLACE FUNCTION fn_get_country_name (p_country_id NUMBER)
    RETURN VARCHAR2
IS
    vs_country_name COUNTRIES.COUNTRY_NAME%TYPE;
BEGIN
    SELECT country_name
        INTO vs_country_name
    FROM countries
    WHERE country_id = p_country_id;
    
    RETURN vs_country_name;
END;

SELECT fn_get_country_name (52777) COUN1, fn_get_country_name(10000)COUN2
FROM DUAL;