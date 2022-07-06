-- CHAPTER 7. 

-- p.208 계층형 쿼리
-- 계층형 쿼리란?
-- 한 테이블에 담겨 있는 데이터들이 서로 상하 관계를 이루려 존재할 때를 말한다.
-- 회사 조직도를 예로 살펴보면 사장 및에 부장, 부장 밑에 과장 대리가 있고 이는 부서별로 각각 존재한다.
-- 경영부를 살펴보면 부서 안에 회계팀, 인사팀, 재무 1팀, 재무 2팀이 있다고 하면 
-- 여기서 부모는 경영부, 자식은 회계팀, 인사팀, 재무 1팀, 재무 2팀이 해당된다.

-- 계층형 쿼리를 작성 할 때는 다음 절을 이용한다.
-- START WITH ~ CONNECT BY
-- START WITH : 부모를 지정한다.
-- CONNECT BY : 부모와 자식의 관계 규정한다. PRIOR 연산자를 이용해서 표현한다.

-- CONNECT BY PRIOR 자식 컬럼 = 부모 컬럼 :  부모에서 자식으로 트리 구성 (하향식 구조 TOP DOWN)
-- CONNECT BY PRIOR 부모 컬럼 = 자식 컬럼 :  자식에서 부모로 트리 구성  (상향식 구조 BOTTOM UP)
-- CONNECT BY NOCYCLE PRIOR :  무한 루프 방지


-- CONNECT BY 조건문 정리
SELECT department_id, LPAD(' ', 3 * (LEVEL-1)) || department_name AS department
    , LEVEL
FROM departments
START WITH parent_id IS NULL
CONNECT BY PRIOR department_id = parent_id;

-- manager_id는 해당 사원의 매니저 사번 존재, 각 매니저도 사원 ID 존재
-- 사원별 계층 구조 만들고 부서 테이블과 조인해서 부서명까지 조회
SELECT a.employee_id, LPAD(' ',3 * (LEVEL-1)) || a.emp_name AS emp_name
    , LEVEL
    , b.department_name
FROM employees a, departments b
WHERE a.department_id = b.department_id
START WITH a.manager_id IS NULL
CONNECT BY PRIOR a.employee_id = a.manager_id;

SELECT a.employee_id, LPAD(' ',3 * (LEVEL-1)) || a.emp_name AS emp_name
    , LEVEL
    , b.department_name, a.department_id
FROM employees a, departments b
WHERE a.department_id = b.department_id
    AND a.department_id = 30
START WITH a.manager_id IS NULL
CONNECT BY NOCYCLE PRIOR a.employee_id = a.manager_id;

SELECT a.employee_id, LPAD(' ',3 * (LEVEL-1)) || a.emp_name AS emp_name
    , LEVEL
    , b.department_name, a.department_id
FROM employees a, departments b
WHERE a.department_id = b.department_id
START WITH a.manager_id IS NULL
CONNECT BY NOCYCLE PRIOR a.employee_id = a.manager_id
    AND a.department_id = 30;

-- 계층형 쿼리 정리
-- 조인을 먼저 처리
-- STARAT WITH 절을 참조해 최상위 계층 로우를 선택
-- CONNECT BY 절에 명시된 구문에 따라 계층형 관계를 파악



-- WITH 절 
-- p.226

-- kor_loan_status 테이블에서 연도별 최종월 기준 가장 대출이 많은 도서와 잔액

SELECT b2.*
FROM ( SELECT period, region, sum(loan_jan_amt) jan_amt
         FROM kor_loan_status 
         GROUP BY period, region
      ) b2,      
      ( SELECT b.period,  MAX(b.jan_amt) max_jan_amt
         FROM ( SELECT period, region, sum(loan_jan_amt) jan_amt
                  FROM kor_loan_status 
                 GROUP BY period, region
              ) b,
              ( SELECT MAX(PERIOD) max_month
                  FROM kor_loan_status
                 GROUP BY SUBSTR(PERIOD, 1, 4)
              ) a
         WHERE b.period = a.max_month
         GROUP BY b.period
      ) c   
 WHERE b2.period = c.period
   AND b2.jan_amt = c.max_jan_amt
 ORDER BY 1;

-- with절 -> 동일 구문 반복 사용 시 사용
WITH b2 AS (SELECT period, region, sum(loan_jan_amt) jan_amt
            FROM kor_loan_status 
            GROUP BY period, region)
    , c AS (SELECT b.period, MAX(b.jan_amt) max_jan_amt
            FROM (SELECT period, region, sum(loan_jan_amt) jan_amt
                        FROM kor_loan_status 
                        GROUP BY period, region) b
                 , (SELECT MAX(PERIOD) max_month
                        FROM kor_loan_status
                        GROUP BY SUBSTR(PERIOD,1,4))a
             WHERE b.period = a.max_month
             GROUP BY b.period
            )
-- SELECT * FROM b2;
-- 전체 데이터 뽑아오고 업뎃 하기

SELECT b2.*
FROM b2,c
WHERE b2.period = c.period
    AND b2.jan_amt = c.max_jan_amt
    ORDER BY 1;


-- with 절 실습
SELECT * FROM employees;

WITH t AS ( 
    SELECT employee_id, emp_name, job_id, salary
    FROM employees)
-- SELECT * FROM t;
SELECT t.job_id, sum(t.salary) as total_job_salary
FROM t
GROUP BY t.job_id;





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


-- WINDOW  절
-- p.240 정리
-- ROWS                 : 로우 단위로 window 절 지정
-- RANGE                : 논리적인 범위로 window 절 지정
-- BETWEEN AND          : window 절의 시작과 끝 지점을 명시
-- UNBOUNDED PRECEDING  : 파티션으로 구분된 첫 번째 로우가 시작 지점
-- UNBOUNDED FOLLOWING  : 파티션으로 구분된 마지막 로우가 끝 지점
-- CURRENT ROW
-- value_expr PRECEDING
-- value_expr FOLLOWING

-- 실습
SELECT department_id, emp_name, hire_date, salary
    , SUM(salary) OVER (PARTITION BY department_id ORDER BY hire_date
                ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING ) AS all_salary    -- 파티션 별 총 합계
    , SUM(salary) OVER (PARTITION BY department_id ORDER BY hire_date
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) AS first_current_sal     -- 파티션 처음부터 현재 로우까지의 합
    , SUM(salary) OVER (PARTITION BY department_id ORDER BY hire_date
                ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING ) AS current_end_sal       -- 현재 로우부터 파티션 끝까지의 합
FROM employees
WHERE department_id IN (30, 90);


SELECT department_id, emp_name, hire_date, salary
    , SUM(salary) OVER (PARTITION BY department_id ORDER BY hire_date
                RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING ) AS all_salary    -- 
    , SUM(salary) OVER (PARTITION BY department_id ORDER BY hire_date
                RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) AS first_current_sal     -- 
    , SUM(salary) OVER (PARTITION BY department_id ORDER BY hire_date
                RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING ) AS current_end_sal       -- 
FROM employees
WHERE department_id = 30;
-- ROW 와 RANGE 결과 같은 같다.


-- 해당 범위에서 첫번째 값 추출
SELECT department_id, emp_name, hire_date, salary
    , FIRST_VALUE(salary) OVER (PARTITION BY department_id ORDER BY hire_date
                ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING ) AS all_salary       -- 파티션 모든 범위
    , FIRST_VALUE(salary) OVER (PARTITION BY department_id ORDER BY hire_date
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) AS first_to_current_sal     -- 파티션 처음 부터 현재 행까지 범위
    , FIRST_VALUE(salary) OVER (PARTITION BY department_id ORDER BY hire_date
                ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING ) AS current_to_end_sal       -- 현재 행 부터 파티션 마지막까지 범위
FROM employees
WHERE department_id IN (30,90);


-- 해당 범위에서 마지막 값
SELECT department_id, emp_name, hire_date, salary
    , LAST_VALUE(salary) OVER (PARTITION BY department_id ORDER BY hire_date
                ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING ) AS all_salary       -- 파티션 모든 범위
    , LAST_VALUE(salary) OVER (PARTITION BY department_id ORDER BY hire_date
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) AS first_to_current_sal     -- 파티션 처음 부터 현재 행까지 범위
    , LAST_VALUE(salary) OVER (PARTITION BY department_id ORDER BY hire_date
                ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING ) AS current_to_end_sal       -- 현재 행 부터 파티션 마지막까지 범위
FROM employees
WHERE department_id IN (30,90);

-- 해당 범위에서 n번째 로우에 해당하는 measure_expr 값
SELECT department_id, emp_name, hire_date, salary
    , NTH_VALUE(salary,2) OVER (PARTITION BY department_id ORDER BY hire_date
                ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING ) AS all_salary       -- 파티션 모든 범위
    , NTH_VALUE(salary,2) OVER (PARTITION BY department_id ORDER BY hire_date
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) AS first_to_current_sal     -- 파티션 처음 부터 현재 행까지 범위
    , NTH_VALUE(salary,2) OVER (PARTITION BY department_id ORDER BY hire_date
                ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING ) AS current_to_end_sal       -- 현재 행 부터 파티션 마지막까지 범위
FROM employees
WHERE department_id IN (30,90);









