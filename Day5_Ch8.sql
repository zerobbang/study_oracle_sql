-- PL/SQL 
-- 블록 단위로 실행

-- 선언부
SET SERVEROUTPUT ON -- DBMS_OUTPUT사용시 필요
SET TIMING ON -- 경과 시간 출력
DECLARE
    vi_num NUMBER;
-- 실행
BEGIN
    vi_num :=100;
    DBMS_OUTPUT.PUT_LINE(vi_num);
END; -- 블록 종료
-- /   pl/sql 자체 종료 ( 스크립트로 실행 할 때 )


DECLARE
    a INTEGER := 2**2*3**2;
BEGIN
    DBMS_OUTPUT.PUT_LINE('a = ' || TO_CHAR(a));
END;


-- p.267
-- DML문
-- PL/SQL 테이블과 연동해서 특정 로직을 처리
DECLARE
    vs_emp_name VARCHAR2(80);
    vs_dep_name VARCHAR2(80);
BEGIN
    SELECT a.emp_name, b.department_name
    INTO vs_emp_name, vs_dep_name
    FROM employees a, departments b
    WHERE a.department_id = b.department_id
        AND a.employee_id = 100;

DBMS_OUTPUT.PUT_LINE(vs_emp_name || ' - ' || vs_dep_name);
END;

-- 변수 컬럼 타입 자동으로 가져오기
-- 테이블명.컬럼명%TYPE;
DECLARE
    vs_emp_name employees.emp_name%TYPE;
    vs_dep_name departments.department_name%TYPE;
BEGIN
    SELECT a.emp_name, b.department_name
    INTO vs_emp_name, vs_dep_name
    FROM employees a, departments b
    WHERE a.department_id = b.department_id
        AND a.employee_id = 100;

DBMS_OUTPUT.PUT_LINE(vs_emp_name || ' - ' || vs_dep_name);
END;


-- 두 수의 합
accept p_num1 prompt '첫번째 숫자를 입력하시오.'
accept p_num2 prompt '두번째 숫자를 입력하시오.'

DECLARE 
    v_sum NUMBER(10);
BEGIN
    v_sum := &p_num1 + &p_num2;
    DBMS_OUTPUT.PUT_LINE('총 합은 : ' || v_sum);
END;    

-- 데이터 테이블 추가하기
DROP table emp;
DROP table dept;

CREATE TABLE DEPT
       (DEPTNO number(10),
        DNAME VARCHAR2(14),
        LOC VARCHAR2(13) );

INSERT INTO DEPT VALUES (10, 'ACCOUNTING', 'NEW YORK');
INSERT INTO DEPT VALUES (20, 'RESEARCH',   'DALLAS');
INSERT INTO DEPT VALUES (30, 'SALES',      'CHICAGO');
INSERT INTO DEPT VALUES (40, 'OPERATIONS', 'BOSTON');

CREATE TABLE EMP (
 EMPNO               NUMBER(4) NOT NULL,
 ENAME               VARCHAR2(10),
 JOB                 VARCHAR2(9),
 MGR                 NUMBER(4) ,
 HIREDATE            DATE,
 SAL                 NUMBER(7,2),
 COMM                NUMBER(7,2),
 DEPTNO              NUMBER(2) );

INSERT INTO EMP VALUES (7839,'KING','PRESIDENT',NULL,'81-11-17',5000,NULL,10);
INSERT INTO EMP VALUES (7698,'BLAKE','MANAGER',7839,'81-05-01',2850,NULL,30);
INSERT INTO EMP VALUES (7782,'CLARK','MANAGER',7839,'81-05-09',2450,NULL,10);
INSERT INTO EMP VALUES (7566,'JONES','MANAGER',7839,'81-04-01',2975,NULL,20);
INSERT INTO EMP VALUES (7654,'MARTIN','SALESMAN',7698,'81-09-10',1250,1400,30);
INSERT INTO EMP VALUES (7499,'ALLEN','SALESMAN',7698,'81-02-11',1600,300,30);
INSERT INTO EMP VALUES (7844,'TURNER','SALESMAN',7698,'81-08-21',1500,0,30);
INSERT INTO EMP VALUES (7900,'JAMES','CLERK',7698,'81-12-11',950,NULL,30);
INSERT INTO EMP VALUES (7521,'WARD','SALESMAN',7698,'81-02-23',1250,500,30);
INSERT INTO EMP VALUES (7902,'FORD','ANALYST',7566,'81-12-11',3000,NULL,20);
INSERT INTO EMP VALUES (7369,'SMITH','CLERK',7902,'80-12-11',800,NULL,20);
INSERT INTO EMP VALUES (7788,'SCOTT','ANALYST',7566,'82-12-22',3000,NULL,20);
INSERT INTO EMP VALUES (7876,'ADAMS','CLERK',7788,'83-01-15',1100,NULL,20);
INSERT INTO EMP VALUES (7934,'MILLER','CLERK',7782,'82-01-11',1300,NULL,10);

commit;

drop  table  salgrade;

create table salgrade
( grade   number(10),
  losal   number(10),
  hisal   number(10) );

insert into salgrade  values(1,700,1200);
insert into salgrade  values(2,1201,1400);
insert into salgrade  values(3,1401,2000);
insert into salgrade  values(4,2001,3000);
insert into salgrade  values(5,3001,9999);

commit;


-- 사원 번호를 찾아라.
SELECT * FROM emp;
-- 사원번호 입력하면 해당 사원의 급여가 나오도록 출력 ( 7782 > 2450 )
accept emp_num prompt '사원 번호를 입력하시오. '

DECLARE
    v_sal number(10);
BEGIN
    SELECT sal INTO v_sal
    FROM emp
    WHERE empno = &emp_num;
    
    DBMS_OUTPUT.PUT_LINE('월급은 : ' || v_sal);
END;    


-- 조건절 &  반복문
-- 사원 이름 입력
-- KING, ALLEN
SELECT * FROM emp;
accept p_ename prompt '사원 이름 입력하시오.'
DECLARE 
    v_ename emp.ename%TYPE := upper('&p_ename');
    v_sal emp.sal%TYPE;
BEGIN
    SELECT sal into v_sal
    FROM emp
    WHERE ename = v_ename;
    DBMS_OUTPUT.PUT_LINE('급여' || v_sal);
    
    IF v_sal >=3500 THEN
        DBMS_OUTPUT.PUT_LINE('고소득자');
    ELSIF v_sal >= 2000 THEN
        DBMS_OUTPUT.PUT_LINE('중간소득자');
    ELSE 
        DBMS_OUTPUT.PUT_LINE('저소득자');
    END IF;
END;

-- 반복문
-- 구구단
DECLARE
    -- 초기값 설정
    v_count NUMBER(10) := 0;
BEGIN
    -- 반복문 실행 선언
    LOOP
        v_count := v_count + 1;
        DBMS_OUTPUT.PUT_LINE('2 * ' || v_count || ' = ' || 2 * v_count);
        EXIT WHEN v_count = 9;
    END LOOP;
END;

-- FOR - LOOP 문
DECLARE
    num1 NUMBER(10) := 0;
    num2 NUMBER(10) := 0;
BEGIN
    FOR num1 IN 2..9
    LOOP
        DBMS_OUTPUT.PUT_LINE(num1 || '단 시작');
        FOR num2 IN 1..5
        LOOP
            DBMS_OUTPUT.PUT_LINE(num1 || ' * ' || num2 || ' = ' || num1 * num2);
        END LOOP;
    END LOOP;
END;
    
            
        

