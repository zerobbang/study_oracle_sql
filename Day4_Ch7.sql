-- CHAPTER 7. 

-- p.208 계층형 쿼리







-- p.231 WINDOW FUNCTION
-- 분석 함수, 순위 함수 또는 OVER 함수 라고도 한다.
-- 기존 RDBMS에서는 컬럼간의 연산, 비교, 연결 또는 집합 조회는 가능하지만 행간 관계 조회는 복잡하다.
-- 이를 윈도우 함수에서 가능하게 한다.
-- 함수 종류 정리
-- PARTITION BY : 분석 함수 로 계산될 대상 로우(행)의 그룹 ( 파티션 ) 을 지정

-- ROW_NUMBER()
SELECT department_id
    , emp_name
    , ROW_NUMBER() OVER (PARTITION BY department_id
                            ORDER BY salary ,emp_name) dep_rows
FROM employees;

-- RANK(), DENSE_RANK()
SELECT department_id, emp_name, salary
    , RANK() OVER (PARTITION BY department_id
                ORDER BY salary) dep_rank
    , DENSE_RANK() OVER (PARTITION BY department_id
                ORDER BY salary) dep_denserank
FROM employees;     
-- RANK : 공동 2등 -> 4등 순
-- DENSE_RANK : 공동 2등 -> 3등 순

-- CUME_DIST() / PERCENT_RANK()
-- CUME_DIST : 주어진 그룹에 대한 상대 누적 분포도 값
-- 분포도 값(비울) : 반환 값의 범위 0 초과 1 이하 사이의 값 반환
SELECT department_id, emp_name, salary
    , CUME_DIST() OVER (PARTITION BY department_id
                    ORDER BY salary) dep_dist
    , PERCENT_RANK() OVER (PARTITION BY department_id
                    ORDER BY salary) percentitle
FROM employees
WHERE department_id = 60;

-- NTILE 
-- NTILE(4) : 값을 4 등분 한다.
SELECT department_id, emp_name, salary
    ,NTILE(6) OVER (PARTITION BY department_id
                ORDER BY salary) NTILES
FROM employees
WHERE department_id IN (30,60);
-- 데이터 수 보다 큰 값으로 등분하면 데이터 수 만큼만 등분한다.


-- LAG / LEAD  중요 ***
-- LAG (expr, offset, default_value)  : 선행 로우의 값 참조
-- LEAD (expr, offset, default_value) : 후행 로우의 값 참조
-- offsest : 선행과 후행 로우 간의 간격 수 
-- default_value 추가하지 않으면 NULL값으로 조회된다.
SELECT emp_name, hire_date, salary
    , LAG(salary,1,0) OVER (ORDER BY hire_date) AS prev_sal
    , LEAD(salary,1,0) OVER (ORDER BY hire_date) AS next_sal
FROM employees
WHERE department_id = 30;

