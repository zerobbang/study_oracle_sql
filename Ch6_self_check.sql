--p.205 Chapter6 Self_Check

-- 1. 101번 사원
-- 필요한 테이블 employees, jobs, job_history, department 서로 연결되어있음 (ERD)
-- 내가 짠 코드
SELECT a.employee_id, a.emp_name
    , (SELECT c.job_title
        FROM jobs c
        WHERE b.job_id = c.job_id) AS job_name
    , b.start_date, b.end_date
    , (SELECT d.department_name
        FROM departments d
        WHERE b.department_id = d.department_id) AS department_name
FROM employees a, job_history b
WHERE a.employee_id = b.employee_id 
    AND a.employee_id = 101;
-- ERD를 더 잘 보고 해야 할 듯
-- 나는 SELECT로 가져올 때 원하는 값만 가져오도록 서브 쿼리를 이용해서 가져왔는데 하드 코딩이 되어버렸다.

-- 답지
SELECT a.employee_id, a.emp_name, d.job_title, b.start_date, b.end_date, c.department_name
FROM employees a, job_history b, departments c, jobs d
WHERE a.employee_id = b.employee_id
    AND b.department_id = c.department_id
    AND b.job_id = d.job_id
    AND a.employee_id = 101;




-- 2. 
-- 외부 조인시에는 모든 데이터 (NULL값 포함)를 출력할 테이블에 + 조건을 모두 동일하게 걸어줘야 한다.
-- 하지만 2번 코드에서는 + 조건을 다르게 걸어주었기 때문에 오류가 날 수 밖에 없다.
-- 그래서 2번 코드에서 AND a.department_id = b.department_id(+);로 수정



-- 3.
-- IN절이 한 개인 경우에는 '=' 로 바꿔 처리할 수 있기 때문에 IN 절에서 값이 1개인 경우에는 외부조인을 사용 할 수 있다.


-- 4.
-- 현재 코드는 내부 조인
SELECT a.department_id , a.department_name
FROM departments a, employees b
WHERE a.department_id = b.department_id
    AND b.salary > 3000
ORDER BY a.department_name;   
-- ANSI 문법 변환
SELECT a.department_id, a.department_name
FROM departments a
INNER JOIN employees b
    ON (a.department_id = b.department_id)
WHERE b.salary > 3000
ORDER BY a.department_name;
-- 조인 조건을 INNER JOIN ON절안으로 넣어주기만 하면 된다.



-- 5. 
-- 연관성 있는 서브 쿼리
-- 동등 조인 조건 사용
SELECT a.department_id, a.department_name
FROM departments a
WHERE EXISTS ( SELECT 1
                FROM job_history b
                WHERE a.department_id = b.department_id);
                
-- 연관성 없는 서브 쿼리로 변환 -- 조인 조건을 제거하자!! 오직 서브 쿼리로만 작성
SELECT department_id, department_name
FROM departments
WHERE department_id IN ( SELECT department_id FROM job_history );



-- 6. 
-- 연도별 이탈리아 최대매출액과 사원뿐만 아니라 최소 매출액과 해당 사원도 조회하는 쿼리 작성하자
-- 필요한 테이블 : countries, customers, sales, employees
-- 1. 연도별, 사원별 이탈리아 매출액 구하기
SELECT SUBSTR(a.sales_month, 1,4) AS sales_year
    , a.employee_id
    , SUM(a.amount_sold) AS total_sold
FROM sales a, customers b, countries c
WHERE a.cust_id = b.cust_id
    AND b.country_id = c.country_id
    AND c.country_name = 'Italy'
GROUP BY SUBSTR(a.sales_month, 1,4), a.employee_id
ORDER BY SUBSTR(a.sales_month, 1,4);
-- 연도는 sales_month의 앞 4자리를 짤라 사용한다.
-- 연도별 사원별 총 판매액을 구하기 위해 집계함수 SUM을 사용한다.
-- 고객 id가 세일 테이블과 고객 테이블이 같아야 하고 나라 id가 나라 테이블과 고객 테이블이 같아야 한다.

-- 2. 연도별 사원별 이탈리아 최대 매출액 / 최소 매출액
-- 집계함수 MAX와 MIN을 사용해서 최대 최소 매출액을 조회한다.
SELECT sales_year
    , MAX(total_sold) AS max_sold
    , MIN(total_sold) AS min_sold
FROM (
    SELECT SUBSTR(a.sales_month, 1,4) AS sales_year
        , a.employee_id
        , SUM(a.amount_sold) AS total_sold
    FROM sales a, customers b, countries c
    WHERE a.cust_id = b.cust_id
        AND b.country_id = c.country_id
        AND c.country_name = 'Italy'
    GROUP BY SUBSTR(a.sales_month, 1,4), a.employee_id
    )
GROUP BY sales_year
ORDER BY sales_year;
-- 3. 최대 최소 매출액을 찍은 사원 추출하기
-- 위 두 코드를 이용해 서브 쿼리로 최대 최소 매출액을 찍은 사원을 조회한다.
SELECT emp.sales_year, emp.total_sold , emp.employee_id , emp2.emp_name
FROM ( SELECT sales_year
            , MAX(total_sold) AS max_sold
            , MIN(total_sold) AS min_sold
        FROM (
            SELECT SUBSTR(a.sales_month, 1,4) AS sales_year
                , a.employee_id
                , SUM(a.amount_sold) AS total_sold
            FROM sales a, customers b, countries c
            WHERE a.cust_id = b.cust_id
                AND b.country_id = c.country_id
                AND c.country_name = 'Italy'
            GROUP BY SUBSTR(a.sales_month, 1,4), a.employee_id
            )
        GROUP BY sales_year
    ) sold
    ,(SELECT SUBSTR(a.sales_month, 1,4) AS sales_year
            , a.employee_id
            , SUM(a.amount_sold) AS total_sold
        FROM sales a, customers b, countries c
        WHERE a.cust_id = b.cust_id
            AND b.country_id = c.country_id
            AND c.country_name = 'Italy'
        GROUP BY SUBSTR(a.sales_month, 1,4), a.employee_id
    ) emp 
    , employees emp2
WHERE emp.sales_year = sold.sales_year
    AND (sold.max_sold = emp.total_sold or sold.min_sold = emp.total_sold)
    AND emp.employee_id = emp2.employee_id
ORDER BY sales_year;


