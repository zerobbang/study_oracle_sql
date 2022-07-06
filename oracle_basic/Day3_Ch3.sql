-- CHAPTER 3 p.112 ~
-- 연산자
DESC employees;
SELECT * FROM employees;



-- 문자 연산자 ||
-- || 두 문자를 연결하는 연산을 수행.
-- 다음은 사번-사원이름 형태로 추출.
SELECT employee_id || '-' || emp_name AS employee_info
FROM employees
WHERE ROWNUM < 5;



-- 표현식
-- 1개 이상의 값과 연산자, SQL 함수 등이 결합된 식
-- CASE WHEN 조건 THEN 값
SELECT employee_id, salary,
    CASE WHEN salary <= 5000 THEN 'C등급'
        WHEN salary > 5000 AND salary <= 15000 THEN 'B등급'
        ELSE 'A등급'
    END AS salary_grade
FROM employees;



-- 조건식
-- 1개 이상의 표현식과 논리 연산자가 결합된 식으로 TRUE, FALSE, UNKNOWN 세가지 타입 반환


-- 비교 조건식
-- 논리 연산자, ANY, SOME, ALL 키워드로 비교하는 조건식
SELECT employee_id, salary
FROM employees
WHERE salary = ANY (2000,3000,4000)
ORDER BY employee_id;
-- ANY -> 괄호 안에 있는 값 중에 아무나 갖고 있는 데이터 값 추출

-- OR
SELECT employee_id, salary
FROM employees
WHERE salary = 2000
    OR salary = 3000
    OR salary = 4000
ORDER BY employee_id;

-- ALL = AND 
SELECT employee_id, salary
FROM employees
WHERE salary = ALL(2000,3000,4000)
ORDER BY employee_id;

-- SOME = ANY 
SELECT employee_id, salary
FROM employees
WHERE salary = SOME (2000,3000,4000)
ORDER BY employee_id;


-- 논리 조건식
-- 조건절에서 AND, OR, NOT 사용
SELECT employee_id, salary
FROM employees
WHERE NOT (salary >= 2500)
ORDER BY employee_id;
-- not salary >=2500 == salary < 2500 인 값 추출


-- NULL 조건식
-- 특정 값이 NULL값인지를 체크하는 조건식
-- IS NULL / IS NOT NULL


-- BETWEEN AND 조건식
-- 범위에 해당되는 값을 찾을 때 사용되는 조건식
SELECT employee_id, salary
FROM employees
WHERE salary BETWEEN 2000 AND 2500
ORDER BY employee_id;


-- IN 조건식
-- 조건절에 명시한 값이 표함된 값을 반환.
-- ANY와 비슷한 형태
SELECT employee_id, salary
FROM employees
WHERE salary IN (2000,3000,4000)
ORDER BY employee_id;

SELECT employee_id, salary
FROM employees
WHERE salary NOT IN (2000,3000,4000)
ORDER BY employee_id;


-- EXISTS 조건식
-- IN과 비슷한 형태지만 후행 조건절로 서브 쿼리만 가능.
-- 또 서브 쿼리 안에 조인 조건이 있어야8 한다.
SELECT department_id, department_name
FROM departments a
WHERE EXISTS ( SELECT * FROM employees b
                WHERE a.department_id = b.department_id
                    AND b.salary > 3000 )
ORDER BY  a.department_name;


-- LIKE 조건식
-- 문자열의 패턴을 검색할 때 사용하는 조건식
SELECT emp_name
FROM employees
WHERE emp_name LIKE 'A%'
ORDER BY emp_name;
-- A% 첫 글자가 A로 시작하고 뒤에는 어떤 글자가 와도 상관이 없다.

SELECT emp_name
FROM employees
WHERE emp_name LIKE 'Al%'
ORDER BY emp_name;
-- 대소문자 구분한다.
-- _는 한 글자를 의미

CREATE TABLE ex3_5(
    names VARCHAR2(30)
);

INSERT INTO ex3_5 VALUES ('홍길동');
INSERT INTO ex3_5 VALUES ('홍길용');
INSERT INTO ex3_5 VALUES ('홍길상');
INSERT INTO ex3_5 VALUES ('홍길상동');

SELECT * FROM ex3_5
WHERE names LIKE '홍길_';

SELECT * FROM ex3_5
WHERE names LIKE '홍길%';

SELECT * FROM ex3_5
WHERE names LIKE '%동%';




-- SELF_CHECK
-- P. 122
--1.
CREATE TABLE ex3_6 (
    emp_id  NUMBER(6,0)
    , emp_name  VARCHAR2(80 BYTE)
    , man_id    NUMBER(6,0)
);

INSERT INTO ex3_6 
SELECT employee_id, emp_name, manager_id
FROM employees
WHERE manager_id = '124' 
    AND salary BETWEEN 2000 AND 3000;

SELECT * FROM ex3_6;

--2.
DELETE ex3_3;

INSERT INTO ex3_3 (employee_id)
SELECT e.employee_id
FROM employees e, sales s
WHERE e.employee_id = s.employee_id
    AND s.SALES_MONTH BETWEEN '200010' AND '200012'
GROUP BY e.employee_id;

--3.
SELECT employee_id, emp_name
FROM employees
WHERE commission_pct IS NULL;

--4.
SELECT employee_id, salary
FROM employees
WHERE salary >= 2000 AND salary <= 2500
ORDER BY employee_id;

--5.
SELECT employee_id, salary
FROM employees
WHERE salary = ANY (2000,3000,4000)
ORDER BY employee_id;

SELECT employee_id, salary
FROM employees
WHERE salary <> ALL(2000,3000,4000)
ORDER BY employee_id;