--CHAPTER 3.
-- SELECT
-- p.92
-- 사원 테이블에서 급여가 5000이 넘는 사원번호와 사원명을 조회한다.
DESC  employees;

SELECT employee_id, emp_name
FROM employees
WHERE salary > 5000;

-- + 사번으로 정렬
SELECT employee_id, emp_name
FROM employees
WHERE salary > 5000
ORDER BY employee_id;

-- + 조건 추가 5000이상 그리고 job_id가 IT_PROG
SELECT employee_id, emp_name
FROM employees
WHERE salary > 5000 AND job_id ='IT_PROG'
ORDER BY employee_id;
-- 데이터 값은 대소문자 구분한다.

-- + 조건 추가 5000이상 또는 job_id가 IT_PROG
SELECT employee_id, emp_name
FROM employees
WHERE salary > 5000 OR job_id ='IT_PROG'
ORDER BY employee_id;

-- 테이블 조회 a,b -> 별칭, employees, department 대신에 사용
-- 컬럼 별칭도 가능 원컬럼명 as 컬럼명 별칭
SELECT a.employee_id, a.emp_name, a.department_id, b.department_name as dep_name
FROM employees a, departments b
WHERE a.department_id = b.department_id;

-- 실습
SELECT * FROM EMPLOYEES;
SELECT EMP_NAME, EMAIL, PHONE_NUMBER
FROM employees
WHERE manager_id IS NULL
    OR manager_id < 110
ORDER BY EMP_NAME;






-- INSERT
-- P.95
CREATE TABLE ex3_1(
    col1    varchar2(10)
    , col2  number
    ,col3   date
);

INSERT INTO ex3_1(col1, col2, col3) VALUES ('ABC',10,SYSDATE);
-- 컬럼 순서가 차례대로가 아니어도 된다.
INSERT INTO ex3_1(col3,col1,col2) VALUES (SYSDATE, 'EFF',20);
INSERT INTO ex3_1(col3,col1,col2) VALUES (10, 'EFF',20);
-- 순서가 바뀌어도 데이터 타입은 준수해야 한다.
-- 컬럼명 기술 없이 INSERT 가능
INSERT INTO ex3_1 VALUES ('GHI',10,SYSDATE);
--특정 컬럼만 insert 가능
INSERT INTO ex3_1 (col1,col2) VALUES('ghi',20);
-- 특정 컬럼만 넣는데 컬럼 지정하지 않으면 오류 발생
INSERT INTO ex3_1 VALUES('ghi',20);

CREATE TABLE ex3_2 (
    emp_id  NUMBER
    , emp_name VARCHAR2(100)
);

INSERT INTO ex3_2(emp_id, emp_name)
SELECT employee_id, emp_name
FROM employees
WHERE salary > 5000;

select * from ex3_2;

-- 묵시적 형변환
-- 문자 타입에 숫자 10을 넣어도 문자 10으로 인식
-- 숫자 타입에 문자 10을 넣어도 숫자 10으로 인식
INSERT INTO ex3_1(col1, col2, col3)
VALUES (10, '10','2022-04-26');

SELECT * FROM ex3_1;






-- UPDATE
-- P.99
SELECT * FROM ex3_1;

-- col2 값을 50으로 업데이트
UPDATE ex3_1 SET col2 = 50;
SELECT * FROM ex3_1;

UPDATE ex3_1 SET col3 = SYSDATE
WHERE col3 is null;

SELECT * FROM ex3_1;




-- DROP TABLE ex3_3;

-- MEARGE
-- P.101
-- 테이블에 해당 조건에 맞는 데이터 없으면 INSERT, 있으면 UPDATE 진행한다.
CREATE TABLE ex3_3(
    employee_id NUMBER
    , bonus_amt NUMBER DEFAULT 0
);

-- ex3_3 의 employee_id에 값을 넣는다.
-- employee -> e, sales -> s
-- 조건 sales month가 조건 기간 안에 존재하고 e.id랑 s.id가 동일한 경우에만
-- id로 그룹화
INSERT INTO ex3_3 (employee_id)
SELECT e.employee_id
FROM employees e, sales s
WHERE e.employee_id = s.employee_ID
    AND s.SALES_MONTH BETWEEN '200010' AND '200012'
GROUP BY e.employee_id;

SELECT * FROM ex3_3 ORDER BY employee_id;

--ex3_3과 employees에 동일하게 존재하는 경우에만 조회한다.
-- sub query 구문
SELECT employee_id, manager_id, salary, salary * 0.01
FROM employees
WHERE employee_id IN (SELECT employee_id FROM ex3_3);

-- ex3_3에 존재하지 않는 id중에 manager_id가 146인 값만 출력
SELECT employee_id, manager_id, salary, salary * 0.001
FROM employees
WHERE employee_id NOT IN (SELECT employee_id FROM ex3_3)
    AND manager_id = 146;
 
-- 위 2개의 쿼리 병합   
-- 사원 테이블에서 관리자 사번이 146인 것 중 ex3_3 테이블에 없으면 신규로 처리하는데 급여 8000 미만 -> 보너스 금액 = 금여 * 0.001
-- 일치하면 보너스 = 보너스 + 급여 *0.01
MERGE INTO ex3_3 d
    USING (SELECT employee_id, salary, manager_id
            FROM employees
            WHERE manager_id = 146) b
        ON (d.employee_id = b.employee_id)
WHEN MATCHED THEN
    UPDATE SET d.bonus_amt = d.bonus_amt + b.salary * 0.01
WHEN NOT MATCHED THEN
    INSERT (d.employee_id, d.bonus_amt) VALUES (b.employee_id, b.salary *.001)
    WHERE (b.salary < 8000);

SELECT * FROM ex3_3 ORDER BY employee_id;

-- delete where -> update될 값을 평가해서 조건에 맞는 데이터 삭제
MERGE INTO ex3_3 d
    USING(SELECT employee_id, salary, manager_id FROM employees WHERE manager_id = 146) b
    ON(d.employee_id = b.employee_id)
WHEN MATCHED THEN
    UPDATE SET d.bonus_amt = d.bonus_amt + b.salary * 0.01
    DELETE WHERE(b.employee_id = 161)
WHEN NOT MATCHED THEN
    INSERT (d.employee_id, d.bonus_amt) VALUES (b.employee_id, b.salary * 0.001)
    WHERE b.salary < 8000;

SELECT * FROM ex3_3 ORDER BY employee_id;






-- DELETE -> table안 데이터 지움
-- DELETE ~ WHERE 조건 가능
-- TABLE 삭제는 DROP TABLE
-- p. 105
DELETE ex3_3;






-- commit / rollback / truncate
CREATE TABLE ex3_4(
    employee_id NUMBER
);

INSERT INTO ex3_4 VALUES(100);

SELECT * FROM ex3_4;
-- sql plus에서 조회하면 나오지 않는다.
-- commit or rollaback 을 하지 않는 이상 현재 세션에서만 볼 수 있고 다른 세션에서는 볼 수 가 없다.
-- commit
COMMIT;
-- rollback -> update 후에 이전 으로 돌리는 경우 실행

-- TRUNCATE-> 테이블 전체 삭제
-- DELETE 삭제 후 commit -> rollback하면 삭제 전으로 돌아가지만
-- truncate은 삭제 전으로 불가 -> rollback 불가
TRUNCATE TABLE ex3_4;


