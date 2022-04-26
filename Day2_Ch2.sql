-- 제약조건
-- P.59 NOT NULL
CREATE TABLE ex2_6_1(
    COL_NULL    VARCHAR2(10)
    , COL_NOT_NULL  VARCHAR2(10) NOT NULL
);

INSERT INTO ex2_6_1  VALUES('AA','');
-- NOT NULL인데 NULL값이 들어가서 오류 발생

INSERT INTO ex2_6_1  VALUES('AA','BB');

SELECT * FROM ex2_6_1;

-- User constratints 제약 조건 확인
SELECT constraint_name, constraint_type, table_name, search_condition
FROM user_constraints
WHERE table_name = 'EX2_6_1'



-- P.61 UNIQUE
-- 중복값 허용 안함
CREATE TABLE ex2_7(
    COL_UNIQUE_NULL VARCHAR2(10) UNIQUE
    , COL_UNIQUE_NNULL  VARCHAR2(10) UNIQUE NOT NULL
    , COL_UNIQUE    VARCHAR2(10)
    ,CONSTRAINTS unique_nml UNIQUE (COL_UNIQUE)
);

-- User constratints 제약 조건 확인
SELECT constraint_name, constraint_type, table_name, search_condition
FROM user_constraints
WHERE table_name = 'EX2_7'

INSERT INTO ex2_7 VALUES ('AA','BB','CC');

INSERT INTO ex2_7 VALUES ('','AA','AA');

INSERT INTO ex2_7 VALUES ('','DD','DD');

SELECT * FROM ex2_7;
-- NULL 값은 중복 제한에서 제외.



-- P.63 PRIMARY KEY
CREATE TABLE ex2_8(
    COL1    VARCHAR2(10) PRIMARY KEY
    ,COL2   VARCHAR2(10)
);

-- User constratints 제약 조건 확인
SELECT constraint_name, constraint_type, table_name, search_condition
FROM user_constraints
WHERE table_name = 'EX2_8'
-- PRIMARY KEY의 constraint_type이 P로 생성된다.

INSERT INTO ex2_8 VALUES ('','AA');
-- 기본키는 널값 갖지 못한다.

INSERT INTO ex2_8 VALUES ('AA','AA');

INSERT INTO ex2_8 VALUES ('AA','');

INSERT INTO ex2_8 VALUES ('BB','');

SELECT * FROM ex2_8;
-- 기본키는 널값을 가지지 않으며 중복을 허용하지 않는다.



-- P.66 CHECK
CREATE TABLE ex2_9(
    num1    NUMBER
    , CONSTRAINTS check1 CHECK (num1 BETWEEN 1 AND 9)
    , gender VARCHAR2(10)
    , CONSTRAINTS check2 CHECK (gender IN('MALE','FEMALE'))
);
-- num1은 1 ~ 9 사이의 숫자만, gender는 male과 female만 가능하도록 설정

SELECT constraint_name, constraint_type, table_name, search_condition
FROM user_constraints
WHERE table_name = 'EX2_9'

INSERT INTO ex2_9 VALUES (10,'MAN');

INSERT INTO ex2_9 VALUES (5,'MALE');

SELECT * FROM ex2_9;



-- p. 67 DEFAULT
CREATE TABLE ex2_10(
    col1    varchar2(10) not null
    , col2  varchar2(10) null
    , create_date date DEFAULT SYSDATE
);

insert into ex2_10 (col1, col2) values ('aa','bb');

select * from ex2_10;

-- delete table
drop table ex2_10;



-- alter table
--p.68 
CREATE TABLE ex2_10(
    col1 varchar2(10) not null
    , col2 varchar2(10) null
    , create_date DATE DEFAULT SYSDATE
);

-- change column name
ALTER TABLE ex2_10 RENAME COLUMN col1 to col11;

-- 테이블에 있는 컬럼 내역 확인
DESC ex2_10;

-- change col type
ALTER TABLE ex2_10 MODIFY col2 VARCHAR(30);

-- add col
ALTER TABLE ex2_10 ADD col3 number;

-- delete col
ALTER TABLE ex2_10 DROP COLUMN col3;

-- add constraint
ALTER TABLE ex2_10 ADD constraints pk_ex2_10 primary key (col11);

SELECT constraint_name, constraint_type, table_name, search_condition
FROM user_constraints
WHERE table_name = 'EX2_10';

-- delete constraint
ALTER TABLE ex2_10 DROP constraints pk_ex2_10;

-- copy table
CREATE TABLE ex2_9_1 as 
SELECT *
FROM ex2_9;

--p.73 View
-- view - 테이블이나 다른 뷰를 참조하는 객체
-- create view
SELECT a.employee_id, a.emp_name, a.department_id, b.department_name
FROM employees a, departments b
WHERE a.department_id = b.department_id;
-- 비효율적 -> 뷰 생성하자

CREATE OR REPLACE VIEW emp_dept_v1 as
SELECT a.employee_id, a.emp_name, a.department_id, b.department_name
FROM employees a, departments b
WHERE a.department_id = b.department_id;

SELECT * FROM emp_dept_v1;

-- delete view
DROP VIEW emp_dept_v1;

-- p.75 index
-- create index
CREATE UNIQUE INDEX ex2_10_ix01 ON ex2_10 (col11);

SELECT index_name, index_type, table_name, uniqueness
FROM user_indexes
WHERE table_name='EX2_10';

SELECT constraint_name, constraint_type, table_name, index_name
FROM user_constraints
WHERE table_name = 'JOB_HISTORY';
-- unique나 primary key는 자동으로 index 생성이 된다.

-- index search
SELECT index_name, index_type, table_name, uniqueness
FROM user_indexes
WHERE table_name = 'JOB_HISTORY';

CREATE INDEX ex2_10_ix02 ON ex2_10 (col11, col2);

SELECT index_name, index_type, table_name, uniqueness
FROM user_indexes
WHERE table_name = 'EX2_10';
-- index는 조회 기능을 높이기 위해 생성.
-- index 많으면 select 에 의한 insert delete update 시 성능 부하

-- delete index
DROP INDEX ex2_10_ix02;

--p.79 Synonym
-- Synonym 동의어 
CREATE OR REPLACE SYNONYM syn_channel FOR channels;
-- publiv -> CREATE OR REPLACE PUBLIC SYNONYM syn_channel FOR channels;

SELECT COUNT(*) FROM syn_channel;

-- public synonym
CREATE OR REPLACE PUBLIC SYNONYM syn_channel2 FOR channels;
-- grant public
GRANT SELECT ON syn_channel2 TO PUBLIC;

-- delete synonym
DROP SYNONYM syn_channel;
DROP PUBLIC SYNONYM syn_channel2;
-- piblic 시노님은 public으로 삭제 진행.


-- p.83 Sequence
-- 자동 순번을 반환하는 DB 객체
-- create wuquence
CREATE SEQUENCE my_seq1
INCREMENT BY 1
START WITH 1
MINVALUE 1
MAXVALUE 1000
NOCYCLE
NOCACHE;

-- DELETE DATA IN EX2_8
DELETE ex2_8;
-- INSERT DATA IN ex2_8
INSERT INTO ex2_8 (col1) VALUES (my_seq1.NEXTVAL);
-- 위 코드의 실행 수에 따라 ex2_8에 숫자가 차례로 들어간다.
SELECT * FROM ex2_8;
-- 현재 시퀀스 값 확인
SELECT my_seq1.CURRVAL FROM Dual;
-- Select NEXTVAL
SELECT my_seq1.NEXTVAL FROM DUAL;
INSERT INTO ex2_8 (col1) VALUES (my_seq1.NEXTVAL);

SELECT * FROM ex2_8;

-- delete SEQUENCE
DROP SEQUENCE my_seq1;




-- p.90 self-check
--1. 
CREATE TABLE ORDERS(
    order_id    number(12,0)    Primary key
    , order_date   date
    , order_mode    varchar2(8 byte)
    , constraints check3 check ( order_mode in('direct','online'))
    , customer_id   number(6,0)
    , order_status  number(2,0)
    , order_total   number(8,2) default 0
    , sales_rep_id  number(6,0)
    , promotion_id  number(6,0)
);

SELECT constraint_name, constraint_type, table_name, search_condition
FROM user_constraints
WHERE table_name = 'ORDERS'

--2.
CREATE TABLE order_items (
    order_id    number(12,0) primary key
    , line_item_id  number(3,0) primary key
    , product_id    number(3,0)
    ,unit_price     number(8,2) default 0
    ,quantity   number(8,0) default 0
);
-- table 당 primary key 1개만 생성 가능하다.

CREATE TABLE  promotions (
    promo_id    number(6,0) primary key
    , promo_name    varchar2(20)
);

--3.
SELECT constraint_name, constraint_type, table_name, search_condition
FROM user_constraints
WHERE table_name = 'PROMOTIONS'


