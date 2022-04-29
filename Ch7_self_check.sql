-- Chapter 7
-- 1. 
-- 문제
SELECT department_id,
    LISTAGG(emp_name, ',') WITHIN GROUP (ORDER BY emp_name) as empnames
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id;

-- 계층형 쿼리 또는 분석 함수 사용
-- 분석 함수를 사용하여 파티션 별 부서 인원이랑 부서별 일련 번호를 조회하자.
SELECT emp_name, department_id
        , COUNT(*) OVER ( PARTITION BY department_id ) cnt
        , ROW_NUMBER () OVER  ( PARTITION BY department_id ORDER BY emp_name) dep_seq
FROM employees
WHERE department_id IS NOT NULL;
-- 그리고 부서별로 총 인원 조회  (서브 쿼리를 이용한다.)
SELECT department_id, cnt
FROM ( SELECT emp_name, department_id
                , COUNT(*) OVER ( PARTITION BY department_id ) cnt
                , ROW_NUMBER () OVER  ( PARTITION BY department_id ORDER BY emp_name) dep_seq
        FROM employees
        WHERE department_id IS NOT NULL
    )
GROUP BY department_id, cnt
ORDER BY department_id;
-- 인원 대신 사람 사람 이름 넣기 -> 계층형 쿼리 사용
-- SYS_CONNECT_BY_PATH (col,char) : 루트 노드에서 자신의 행까지 정보 반환. 반환 순서는 char col 형식
-- 이름, 이름, ... 형식으로 바꿔 주기 위해 SUBSTR 사용
-- char가 먼저 출력 되는거 짜르기 위해 2번째 부터 출력한다.
SELECT department_id, SUBSTR(SYS_CONNECT_BY_PATH(emp_name, '/'),2)
FROM ( SELECT emp_name, department_id
                , COUNT(*) OVER ( PARTITION BY department_id ) cnt
                , ROW_NUMBER () OVER  ( PARTITION BY department_id ORDER BY emp_name) dep_seq
        FROM employees
        WHERE department_id IS NOT NULL
    )
WHERE dep_seq = cnt   -- 이 코드를 넣어 주면서 부서 별로 묶어서 조회 할 수 있다.
START WITH dep_seq = 1  
-- 부서별 일련 번호 1번 부터 출력한다.
CONNECT BY PRIOR dep_seq + 1 = dep_seq
    AND PRIOR department_id = department_id;




-- 2. 
-- 문제
SELECT employee_id, emp_name, hire_date
FROM employees
WHERE job_id = 'SH_CLERK'
ORDER By hire_date; 
-- 사원들의 퇴사 일자를 다음으로 빠른 입사 일자로 설정하기
-- 행간 조회 -> window 함수 사용하자
-- 다음과 같은 구조로 짜자
SELECT employee_id, emp_name, hire_date
    , () end_date
FROM employees
WHERE job_id = 'SH_CLERK'
ORDER BY hire_date;
-- ()안 코드 작성
-- LEAD 이용해 다음 값을 가져오기
SELECT employee_id, emp_name, hire_date
    , LEAD (hire_date,1, SYSDATE) OVER (PARTITION BY job_id ORDER BY hire_date) as end_date
FROM employees
WHERE job_id = 'SH_CLERK'
ORDER BY hire_date;
-- LEAD의 default 값 지정할 때 데이터 타입 맞춰 주어야 한다.




-- 3. 
-- 2001년 12월 판매 데이터 중 현재일자 기준 고객 나이 계산해 연령대별 매출 금액 조회
-- sales, customers 테이블 이용
SELECT * FROM sales;
SELECT * FROM customers;

-- 2001년 12월 판매 데이터, 고객 출생 날짜 조회
SELECT a.sales_month, b.cust_year_of_birth
FROM sales a, customers b
WHERE a.sales_month = '200112'
    AND a.cust_id = b.cust_id
GROUP BY a.sales_month, b.cust_year_of_birth;
-- 현재 나이 조회
-- 출생 년도 데이터 타입이 데이트 타입이 아니라 숫자 타입
-- 만 나이
SELECT a.sales_month, b.cust_year_of_birth
    , ('2022' - b.cust_year_of_birth) age
FROM sales a, customers b
WHERE a.sales_month = '200112'
    AND a.cust_id = b.cust_id
GROUP BY a.sales_month, b.cust_year_of_birth;
-- 연령대로 묶기
-- WIDTH_BUCKET 사용
SELECT a.sales_month, b.cust_year_of_birth
    , ('2022' - b.cust_year_of_birth) as age
    , WIDTH_BUCKET(('2022' - b.cust_year_of_birth),10,100,9 ) as age_group
    , sum(a.amount_sold) as cus_sold
FROM sales a, customers b
WHERE a.sales_month = '200112'
    AND a.cust_id = b.cust_id
GROUP BY a.sales_month, b.cust_year_of_birth;
-- 연령대 별 매출 금액 구하기
SELECT age.age_group*10||'대', sum(cus_sold) as age_group_sold
FROM(SELECT a.sales_month, b.cust_year_of_birth
            , ('2022' - b.cust_year_of_birth) as age
            , WIDTH_BUCKET(('2022' - b.cust_year_of_birth),10,100,9 ) as age_group
            , sum(a.amount_sold) as cus_sold
        FROM sales a, customers b
        WHERE a.sales_month = '200112'
            AND a.cust_id = b.cust_id
        GROUP BY a.sales_month, b.cust_year_of_birth
    ) age
GROUP BY age.age_group
ORDER BY age.age_group;
-- 답지
WITH basis AS ( SELECT WIDTH_BUCKET(to_char(sysdate, 'yyyy') - b.cust_year_of_birth, 10, 90, 8) AS old_seg,
                       TO_CHAR(SYSDATE, 'yyyy') - b.cust_year_of_birth as olds,
                       s.amount_sold
                  FROM sales s, 
                       customers b
                 WHERE s.sales_month = '200112'
                   AND s.cust_id = b.CUST_ID
              ),
     real_data AS ( SELECT old_seg * 10 || ' 대' AS old_segment,
                           SUM(amount_sold) as old_seg_amt
                      FROM basis
                     GROUP BY old_seg
              )
 SELECT *
 FROM real_data
 ORDER BY old_segment; 
 -- 답은 90대와 100대가 합쳐져 있다.
 
 
 
 -- 4. 
 -- 3번 이용해 월별로 판매금액이 가장 하위에 속하는 대륙 조회하기
 -- 이번에는 with 절 이용해보자
 -- 나라별 월별 매출액
SELECT c.country_region , a.sales_month , SUM(a.amount_sold) as sold_month
FROM sales a, customers b, countries c
WHERE a.cust_id = b.cust_id
    AND b.country_id = c.country_id
GROUP BY c.country_region, a.sales_month
ORDER BY c.country_region, a.sales_month ;
                            
-- 전체                           
 WITH country_sold AS ( SELECT c.country_region , a.sales_month , SUM(a.amount_sold) as sold_month
                            FROM sales a, customers b, countries c
                            WHERE a.cust_id = b.cust_id
                                AND b.country_id = c.country_id
                            GROUP BY c.country_region, a.sales_month
                            ),
    r_data AS ( SELECT sales_month, country_region, sold_month
                , RANK () OVER (PARTITION BY sales_month ORDER BY sold_month) ranks
                FROM country_sold
                ) -- 나라별 월별 매출액 테이블에서 판매 월과 나라, 총 월별 매출액을 순위를 매긴다. 작은 매출액이 1위 반환
SELECT *
FROM r_data
WHERE ranks = 1;
-- 순위가 1인 ( 매출액이 가장 낮은 값) 값만 불러온다.




-- 5. 
-- 지역별, 대출종류별, 월별 대출잔액, 지역별 파티션 만들어 대출 종류별 대출 잔액의 퍼센트 구하기
-- 5장 연습 문제 5번 정답
SELECT REGION, 
       SUM(AMT1) AS "201111", 
       SUM(AMT2) AS "201112", 
       SUM(AMT3) AS "201210", 
       SUM(AMT4) AS "201211", 
       SUM(AMT5) AS "201312", 
       SUM(AMT6) AS "201310",
       SUM(AMT6) AS "201311"
  FROM ( 
         SELECT REGION,
                CASE WHEN PERIOD = '201111' THEN LOAN_JAN_AMT ELSE 0 END AMT1,
                CASE WHEN PERIOD = '201112' THEN LOAN_JAN_AMT ELSE 0 END AMT2,
                CASE WHEN PERIOD = '201210' THEN LOAN_JAN_AMT ELSE 0 END AMT3, 
                CASE WHEN PERIOD = '201211' THEN LOAN_JAN_AMT ELSE 0 END AMT4, 
                CASE WHEN PERIOD = '201212' THEN LOAN_JAN_AMT ELSE 0 END AMT5, 
                CASE WHEN PERIOD = '201310' THEN LOAN_JAN_AMT ELSE 0 END AMT6,
                CASE WHEN PERIOD = '201311' THEN LOAN_JAN_AMT ELSE 0 END AMT7
         FROM KOR_LOAN_STATUS
       )
GROUP BY REGION
ORDER BY REGION       
;
-- CASE 구문에 해당하면 THEN 절을 수행한다.            
-- CASE 구문에 해당되지 않으면 ELSE 절을 수행한다.
-- 각각 날짜 별로 amt1 ~ amt7로 명칭한다.
 
 -- +  대출 종류별 추가하기
SELECT region, gubun,
        SUM(AMT1) AS AMT1, 
        SUM(AMT2) AS AMT2, 
        SUM(AMT3) AS AMT3, 
        SUM(AMT4) AS AMT4, 
        SUM(AMT5) AS AMT5, 
        SUM(AMT6) AS AMT6, 
        SUM(AMT6) AS AMT7 
FROM (SELECT region,gubun
             , CASE WHEN PERIOD = '201111' THEN LOAN_JAN_AMT ELSE 0 END AMT1
             , CASE WHEN PERIOD = '201112' THEN LOAN_JAN_AMT ELSE 0 END AMT2
             , CASE WHEN PERIOD = '201210' THEN LOAN_JAN_AMT ELSE 0 END AMT3 
             , CASE WHEN PERIOD = '201211' THEN LOAN_JAN_AMT ELSE 0 END AMT4 
             , CASE WHEN PERIOD = '201212' THEN LOAN_JAN_AMT ELSE 0 END AMT5 
             , CASE WHEN PERIOD = '201310' THEN LOAN_JAN_AMT ELSE 0 END AMT6
             , CASE WHEN PERIOD = '201311' THEN LOAN_JAN_AMT ELSE 0 END AMT7
      FROM KOR_LOAN_STATUS)
GROUP BY region, gubun;

-- 전체 
-- 연산자 || 을 사용해서 값을 붙인다.
-- RATIO_TO_REPORT : 전체 합계 대비 비율 반환
-- RATIO_TO_REPORT * 100 : 백분율
-- RATIO_TO_REPORT (컬럼) OVER () 형태
-- 지역 별로 구분 되어야 하기 때문에 OVER 구문 안에 PARTITION BY region 해준다.
-- 그리고 소수 2번째 자리에서 반올림 하기 위해 ROUND 를 사용한다. 
WITH loan AS (SELECT region, gubun,
                       SUM(AMT1) AS AMT1, 
                       SUM(AMT2) AS AMT2, 
                       SUM(AMT3) AS AMT3, 
                       SUM(AMT4) AS AMT4, 
                       SUM(AMT5) AS AMT5, 
                       SUM(AMT6) AS AMT6, 
                       SUM(AMT6) AS AMT7 
                  FROM ( 
                         SELECT region,gubun
                                , CASE WHEN PERIOD = '201111' THEN LOAN_JAN_AMT ELSE 0 END AMT1
                                , CASE WHEN PERIOD = '201112' THEN LOAN_JAN_AMT ELSE 0 END AMT2
                                , CASE WHEN PERIOD = '201210' THEN LOAN_JAN_AMT ELSE 0 END AMT3 
                                , CASE WHEN PERIOD = '201211' THEN LOAN_JAN_AMT ELSE 0 END AMT4 
                                , CASE WHEN PERIOD = '201212' THEN LOAN_JAN_AMT ELSE 0 END AMT5 
                                , CASE WHEN PERIOD = '201310' THEN LOAN_JAN_AMT ELSE 0 END AMT6
                                , CASE WHEN PERIOD = '201311' THEN LOAN_JAN_AMT ELSE 0 END AMT7
                         FROM KOR_LOAN_STATUS
                       )
                GROUP BY region, gubun
                )   
SELECT region,gubun
       , AMT1 || '( ' || ROUND(RATIO_TO_REPORT(amt1) OVER ( PARTITION BY REGION ),2) * 100 || '% )' AS "201111"
       , AMT2 || '( ' || ROUND(RATIO_TO_REPORT(amt2) OVER ( PARTITION BY REGION ),2) * 100 || '% )' AS "201112"
       , AMT3 || '( ' || ROUND(RATIO_TO_REPORT(amt3) OVER ( PARTITION BY REGION ),2) * 100 || '% )' AS "201210"
       , AMT4 || '( ' || ROUND(RATIO_TO_REPORT(amt4) OVER ( PARTITION BY REGION ),2) * 100 || '% )' AS "201211"
       , AMT5 || '( ' || ROUND(RATIO_TO_REPORT(amt5) OVER ( PARTITION BY REGION ),2) * 100 || '% )' AS "201212"
       , AMT6 || '( ' || ROUND(RATIO_TO_REPORT(amt6) OVER ( PARTITION BY REGION ),2) * 100 || '% )' AS "201310"
       , AMT7 || '( ' || ROUND(RATIO_TO_REPORT(amt7) OVER ( PARTITION BY REGION ),2) * 100 || '% )' AS "201311"
FROM loan
ORDER BY region;
