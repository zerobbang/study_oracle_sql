-- Chanper 6.
-- 조인



-- 내부 조인

-- 동등 조인
-- = 사용하여 조인
SELECT a.employee_id, a.emp_name, a.department_id, b.department_name
FROM employees a,
    departments b
WHERE a.department_id = b.department_id;

-- 세미 조인
-- 서브 쿼리 사용하여 서브 쿼리에만 존재하는 데이터만 메인 쿼리에서 추출한다.
-- a : main query
-- b : sub query
-- 중복 허용 X
-- EXISTS 사용
SELECT department_id, department_name
FROM departments a
WHERE EXISTS(SELECT * FROM employees b
                WHERE a.department_id = b.department_id
                AND b.salary > 3000)
ORDER BY a.department_name;
-- IN 사용
SELECT department_id, department_name
FROM departments a
WHERE a.department_id IN (SELECT b.department_id FROM employees b
                            WHERE b.salary > 3000)
ORDER BY department_name;      

-- 일반 조인으로 확인해보면 중복 값도 추출이 된다.
SELECT a.department_id, a.department_name
FROM departments a, employees b
WHERE a.department_id = b.department_id
    AND b. salary > 3000
ORDER BY a.department_name;


-- 안티 조인
-- sub query에 없는 main query 의 데이터만 추출한다.
-- NOT IN
SELECT a.employee_id, a.emp_name, a.department_id, b.department_name
FROM employees a, departments b
WHERE a.department_id = b.department_id 
    AND a.department_id NOT IN(SELECT department_id FROM departments 
                                    WHERE manager_id IS NULL);
-- NOT EXISTS
SELECT count(*)
FROM employees a
WHERE NOT EXISTS (SELECT 1 FROM departments b
    WHERE a.department_id = b.department_id 
    AND manager_id is NULL);
-- 조인 조건이 NOT IN -> 밖에 / NOT EXISTS -> 안에 
-- 부서 번호가 NULL값인 데이터 하나 존재 -> 그래서 NOT EXISTS에서 걸러지지 않고 NOT IN보다 1개 더 많다.


-- 셀프 조인
SELECT a.employee_id, a.emp_name, b.employee_id, b.emp_name, a.department_id
FROM employees a, employees b
WHERE a.employee_id < b.employee_id   --1.
    AND a.department_id = b.department_id
    AND a.department_id = 20;
-- 부서 id 20은 2건이 존재.
-- 1.번에 의해서 1건만 조회가 된다.






-- 외부 조인
-- 일반 조인을 확장한 개념
-- 데이터가 NULL이거나 해당 행이 아예 없더라도 데이터를 모두 추출.
-- 일반 조인 vs 외부 조인
-- 일반 조인 - job_history에 없는 데이터는 조회 되지 않는다.
SELECT a.department_id, a.department_name, b.job_id, b.department_id
FROM departments a, job_history b
WHERE a.department_id = b.department_id;
-- 외부 조인 - job_history에 없는 데이터도 조회 된다.
SELECT a.department_id, a.department_name, b.job_id, b.department_id
FROM departments a, job_history b
WHERE a.department_id = b.department_id(+);
-- 조인 조건에서 데이터가 없는 테이블의 컬럼에 + : 외부 조인

SELECT a.employee_id, a.emp_name, b.job_id, b.department_id
FROM employees a, job_history b
WHERE a.employee_id = b.employee_id(+)
    AND a.department_id = b.department_id;
-- 외부 조인은 조인 조건에 해당하는 곳에 모두 +를 붙여줘야 한다.

SELECT a.employee_id, a.emp_name, b.job_id, b.department_id
FROM employees a, job_history b
WHERE a.employee_id = b.employee_id(+)
    AND a.department_id = b.department_id(+);
-- 외부 조인 시 참고해야할 사항
-- 1. 조인 대상 테이블 중 데이터가 없는 테이블 조인 조건에 (+)를 붙인다.
-- 2. 외부 조인의 조인 조건이 여러 개일 떄 모든 조건에 (+)를 붙인다.
-- 3. 한 번에 한 테이블에만 외부 조인을 할 수 있다.
-- 4. (+) 연산자가 붙은 조건과 OR를 같이 사용할 수 없다.
-- 5. (+) 연산자가 붙은 조건에는 IN 연산자를 같이 사용할 수 없다. (단, IN절에 포함되는 값이 1개일 때는 사용 가능)


-- 카타시안 조인
-- WHERE 절에 조인 조건이 없는 조인을 의미한다.
-- FROM 절에는 명시했지만 조인 조건이 없다.
SELECT a.employee_id, a.emp_name, b.department_id, b.department_name
FROM employees a, departments b;
-- a : 107개, b : 27개 
-- 107 * 27 = 2.889개



-- ANSI 조인
-- ANSI SQL 문법을 사용한 조인을 의미한다.
-- 조인 조건이 WHERE 절에 존재하는 것이 아니라 FROM 절에 들어간다.
-- 내부 조인과 외부 조인이 있다.
-- JOIN이 명시 되어 있다.
-- 조인 조건은 ON으로 명시
-- ON 대신 USING사용 가능한데 그때는 컬럼명만 명시.

-- 2013년 1월 1일 이후 입사한 사원 번호, 사원명, 부서 번호 ,부서명 조회
-- 내부 조인
-- 기존 문법
SELECT a.employee_id, a.emp_name, b.department_id, b.department_name
FROM employees a, departments b
WHERE a.department_id = b.department_id
    AND a.hire_date >= TO_DATE('2003-01-01','YYYY-MM-DD');
-- ANSI 문법
SELECT a.employee_id, a.emp_name, b.department_id, b.department_name
FROM employees a
INNER JOIN departments b
    ON (a.department_id = b.department_id)
WHERE  a.hire_date >= TO_DATE('2003-01-01','YYYY-MM-DD');
-- USING 사용    
 SELECT a.employee_id, a.emp_name, department_id, b.department_name
FROM employees a
INNER JOIN departments b
    USING (department_id)
WHERE  a.hire_date >= TO_DATE('2003-01-01','YYYY-MM-DD');   
    
-- 외부 조인
-- 기본 문법
SELECT a.employee_id, a.emp_name, b.job_id, b.department_id
FROM employees a, job_history b
WHERE a.employee_id = b.employee_id(+)
AND a.department_id = b.department_id(+);
-- ANSI 문법 - left join
SELECT a.employee_id, a.emp_name, b.job_id, b.department_id
FROM employees a
LEFT OUTER JOIN job_history b
 ON (a.employee_id = b.employee_id
    AND a.department_id = b.department_id);
-- ANSI 문법 - right join
SELECT a.employee_id, a.emp_name, b.job_id, b.department_id
FROM job_history b
RIGHT OUTER JOIN employees a
 ON (a.employee_id = b.employee_id
    AND a.department_id = b.department_id);
-- OUTER 생략 가능
SELECT a.employee_id, a.emp_name, b.job_id, b.department_id
FROM employees a
LEFT JOIN job_history b
 ON (a.employee_id = b.employee_id
 AND a.department_id = b.department_id );


-- CROSS 조인
-- ANSI 조인의 카타시안 조인
-- 기존
SELECT a.employee_id, a.emp_name, b.department_id, b.department_name
FROM  employees a, departments b;
-- CROSS 조인
SELECT a.employee_id, a.emp_name, b.department_id, b.department_name
FROM employees a
CROSS JOIN departments b;


-- FULL OUTER 조인
-- 외부 조인 중 하나로 ANIS 조인에서만 가능.
-- 기존 외부 조인은 한 쪽에만 NULL이거나 없는 데이터를 다 추출했다면 이번에는 양 쪽에서 NULL이거나 없는 데이터를 모두 추출한다.
CREATE TABLE HONG_A (EMP_ID INT);
CREATE TABLE HONG_B (EMP_ID INT);
INSERT INTO HONG_A VALUES (10);
INSERT INTO HONG_A VALUES (20);
INSERT INTO HONG_A VALUES (40);
INSERT INTO HONG_B VALUES (10);
INSERT INTO HONG_B VALUES (20);
INSERT INTO HONG_B VALUES (30);
COMMIT;

SELECT a.emp_id, b.emp_id
FROM hong_a a
FULL OUTER JOIN hong_b b
    ON (a.emp_id = b.emp_id);








-- 서브 쿼리 p.191
-- SQL 문장 안 보조로 사용되는 또 다른 SELECT 문을 의미한다.
-- SELECT or FROM or WHERE 절에 서브 쿼리가 들어 갈 수 있다.
-- 서브 쿼리 안에 서브 쿼리가 들어 갈 수 있다.

-- main과 연관성이 없는 서브 쿼리
-- 유형 1.
SELECT count(*)
FROM employees
WHERE salary >= (SELECT AVG(salary) FROM employees);

-- 유형 2.
SELECT count(*)
FROM employees
WHERE department_id IN (SELECT department_id FROM departments WHERE parent_id IS NULL);

-- 유형 3.
SELECT employee_id, emp_name, job_id
FROM employees
WHERE (employee_id, job_id) IN (SELECT employee_id , job_id FROM job_history);

-- UPDATE문과 DELETE문도 가능



-- 연관성이 있는 서브 쿼리
-- 조인 조건으로 연결되어 있다,
SELECT a.department_id, a.department_name
FROM departments a
WHERE EXISTS (SELECT 1 FROM job_history b
                WHERE a.department_id = b.department_id);

-- SELECT 절에 서브 쿼리 존재
SELECT a.employee_id,
    (SELECT b.emp_name FROM employees b
    WHERE a.employee_id = b.employee_id) AS emp_name,
    a.department_id,
    (SELECT b.department_name FROM departments b
    WHERE a.department_id = b.department_id) AS dep_name,
    (SELECT b.job_title FROM jobs b
    WHERE a.job_id = b.job_id) AS title_name
FROM job_history a;

-- 중첩 서브 쿼리
SELECT a.department_id, a.department_name
FROM departments a
WHERE EXISTS (SELECT 1 FROM employees b
    WHERE a.department_id = b.department_id
    AND b.salary > (SELECT AVG(salary) FROM employees));



-- 인 라인 뷰
-- FROM절에 사용하는 서브 쿼리를 인라인 뷰라고 한다.

-- 기획부 산하에 있는 부서에 속한 사원이 평균 급여보다 많은 급여를 받는 사원
SELECT a.employee_id, a.emp_name, b.department_id, b.department_name
FROM employees a, departments b,
    (SELECT AVG(c.salary) AS avg_salary
        FROM departments b, employees c
        WHERE b.parent_id = 90
        AND b.department_id = c.department_id ) d  --기획부 데이터
WHERE a.department_id = b.department_id
AND a.salary > d.avg_salary;

-- 이탈리아의 2000년도에서 2000년도 평균 매출액 보다 큰 월 평균 매출액 구하기
-- 이탈리아 월 별 평균 매출 -> 첫번째
-- 이탈리아 2000년 평균 매출액 -> 두번째
-- 조건 : cust_id, country_id가 일치한 데이터 추출
SELECT * FROM sales;
SELECT * FROM countries;
SELECT * FROM customers;

-- 2000년도 이탈리아 월별 평균 매출액
SELECT a.sales_month, ROUND(AVG(a.amount_sold)) AS month_avg
FROM sales a, customers b ,countries c
WHERE a.sales_month BETWEEN '200001' AND '200012'
    AND a.cust_id = b.CUST_ID
    AND b.COUNTRY_ID = c.COUNTRY_ID
    AND c.COUNTRY_NAME = 'Italy'
GROUP BY a.sales_month;

-- 2000년도 이탈리아 2000년도 평균 매출액
SELECT ROUND(AVG(a.amount_sold)) AS year_avg
FROM sales a, customers b ,countries c
WHERE a.sales_month BETWEEN '200001' AND '200012'
    AND a.cust_id = b.CUST_ID
    AND b.COUNTRY_ID = c.COUNTRY_ID
    AND c.COUNTRY_NAME = 'Italy';

-- 전체
SELECT a.*
FROM ( SELECT a.sales_month, ROUND(AVG(a.amount_sold)) AS month_avg
        FROM sales a, customers b, countries c
        WHERE a.sales_month BETWEEN '200001' AND '200012'
        AND a.cust_id = b.CUST_ID
        AND b.COUNTRY_ID = c.COUNTRY_ID
        AND c.COUNTRY_NAME = 'Italy'
        GROUP BY a.sales_month) a
        , (SELECT ROUND(AVG(a.amount_sold)) AS year_avg
            FROM sales a, customers b, countries c
            WHERE a.sales_month BETWEEN '200001' AND '200012'
            AND a.cust_id = b.CUST_ID
            AND b.COUNTRY_ID = c.COUNTRY_ID
            AND c.COUNTRY_NAME = 'Italy') b
WHERE a.month_avg > b.year_avg;        


-- 복잡한 쿼리
--p.200
-- 연도별 이탈리아 매출 데이터를 살펴 매출실적이 가장 많은 사원의 목록과 매축액 구하기
-- 연도, 매출실적 많은 사원 목록, 최대 매출액
-- table : countries / customers / sales / employees

-- 연도별 사원별 이탈리아 매출액 구하기
-- 고객 : customers, countries -> coutry_id 로 조인
-- 매출 : 위 결과와 sales 테이블을 cust_id로 조인
-- MAX , GROUP BY 사용

-- 1. 연도별 매출액
SELECT
    SUBSTR(a.sales_month,1,4) AS years
    , a.employee_id
    , SUM(a.amount_sold) AS amount_sold
FROM 
    sales a, customers b, countries c
WHERE a.cust_id = b.CUST_ID
    AND b.COUNTRY_ID = c.COUNTRY_ID
    AND c.COUNTRY_NAME = 'Italy'
GROUP BY SUBSTR(a.sales_month,1,4), a.employee_id;

-- 2. + 연도별 최대 매출액
SELECT 
    years
    , MAX(amount_sold) AS max_sold
    , MIN(amount_sold) AS min_sold
FROM (
    SELECT
        SUBSTR(a.sales_month,1,4) AS years
        , a.employee_id
        , SUM(a.amount_sold) AS amount_sold
    FROM 
        sales a, customers b, countries c
    WHERE a.cust_id = b.CUST_ID
        AND b.COUNTRY_ID = c.COUNTRY_ID
        AND c.COUNTRY_NAME = 'Italy'
    GROUP BY SUBSTR(a.sales_month,1,4), a.employee_id
) K
GROUP BY years
ORDER BY years;

-- 3. 1 + 2 -> 최대 매출 찍은 사원 찾기
SELECT emp.years
    , emp.employee_id
    , emp2.emp_name
    , emp.amount_sold
FROM 
    (
    SELECT
        SUBSTR(a.sales_month,1,4) AS years
        , a.employee_id
        , SUM(a.amount_sold) AS amount_sold
    FROM 
        sales a, customers b, countries c
    WHERE a.cust_id = b.CUST_ID
        AND b.COUNTRY_ID = c.COUNTRY_ID
        AND c.COUNTRY_NAME = 'Italy'
    GROUP BY SUBSTR(a.sales_month,1,4), a.employee_id) emp
    , (
    SELECT 
        years
        , MAX(amount_sold) AS max_sold
    FROM (
        SELECT
            SUBSTR(a.sales_month,1,4) AS years
            , a.employee_id
            , SUM(a.amount_sold) AS amount_sold
        FROM 
            sales a, customers b, countries c
        WHERE a.cust_id = b.CUST_ID
            AND b.COUNTRY_ID = c.COUNTRY_ID
            AND c.COUNTRY_NAME = 'Italy'
        GROUP BY SUBSTR(a.sales_month,1,4), a.employee_id) K
    GROUP BY years ) sale
    , employees emp2
WHERE emp.years = sale.years
    AND emp.amount_sold = sale.max_sold
    AND emp.employee_id = emp2.employee_id
ORDER BY years;
