-- CHAPTER 5
-- p.152

-- 기본 집계 함수

-- COUNT
SELECT COUNT(*)
FROM employees;

SELECT COUNT(employee_id)
FROM employees;

SELECT COUNT(department_id)
FROM employees;
-- NULL값은 count되지 않는다.

SELECT COUNT(DISTINCT department_id)
FROM employees;
-- DISTINCT : 중복 제외한다.

SELECT DISTINCT department_id
FROM employees
ORDER BY 1;
-- NULL 값을 포함한다. ( COUNT 없이 연산해서 )

-- SUM
SELECT SUM(salary)
FROM employees;

SELECT SUM(salary), SUM(DISTINCT salary)
FROM employees;


-- AVG
SELECT AVG(salary), AVG(DISTINCT salary)
FROM employees;


-- MIN / MAX
SELECT MIN(salary), MAX(salary), MIN(DISTINCT salary), MAX(DISTINCT salary)
FROM employees;


-- VARIANCE 분산 / STDDEV 표준 편차
SELECT VARIANCE(salary), STDDEV(salary)
FROM employees;




-- GROUP BY AND HAVING
SELECT department_id, SUM(salary)
FROM employees
GROUP BY department_id
ORDER BY department_id;

SELECT * FROM kor_loan_status;

-- 2013년도 기간별, 지역별 loan_jan_amt의 sum 값 추출
SELECT period, region,SUM(loan_jan_amt) total_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period, region
ORDER BY period, region;

-- 2013 11월 총 잔액만 추출
SELECT period, region, SUM(loan_jan_amt) total_jan
FROM kor_loan_status
WHERE period = '201311'
GROUP BY period, region
ORDER BY period, region;
-- GROUP BY 절로 모을 때 SELECT 에서 집계 함수를 제외한 값들은 꼮 명시 해줘야 한다.

-- HAVING 절
-- GROUP BY 뒤에 이어 나오며 GROUP BY의 결과를 대상으로 다시 필터링 한다.
SELECT period, region, SUM(loan_jan_amt) total_jan
FROM kor_loan_status
WHERE period = '201311'
GROUP BY period, region
HAVING SUM(loan_jan_amt) > 100000
ORDER BY region;





-- ROLLUP / CUBE
-- GROUP BY 절에 사용
-- 그룹별 소계를 추가롤 보여주는 함수

-- ROLLUP
-- 레벨별로 집계한 결과 반환
-- n개 입력 -> n +1 레벨까지 반환
SELECT period, gubun, SUM(loan_jan_amt) toatl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period, gubun
ORDER BY period;

SELECT period, gubun, SUM(loan_jan_amt) toal_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY ROLLUP(period, gubun);
-- 3 lavel : period, gubun
-- 2 level : peiod
-- 1 level : 전체

-- ROLLUP ( a, b, c, d)이면??
-- 5 : a,b,c,d
-- 4 : a,b,c
-- 3 : a,b
-- 2 : a
-- 1 : 전체

-- 분할 ROLLUP
SELECT period, gubun,SUM(loan_jan_amt) total_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period, ROLLUP(gubun);
-- 2 : period, gubun
-- 1 : period

SELECT period, gubun, SUM(loan_jan_amt) total_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY ROLLUP(period), gubun;
-- 2 : gubun, period
-- 1 : gubun

-- CUBE
-- 개수에 따라 가능한 모든 조합별로 집계한 결과 반환
-- n개면 -> 2^n 개로 집계 된다.
SELECT period, gubun, SUM(loan_jan_amt) toal_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY CUBE(period, gubun);
-- 전체 / gubun / period / gubun, period

-- GROUPING SETS
-- 특정 항목에 대한 소계를 계산하는 함수
SELECT period, gubun, SUM(loan_jan_amt) toal_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY GROUPING SETS(period, gubun);

SELECT period, gubun,region, SUM(loan_jan_amt) toal_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
    AND region in('서울','경기')
GROUP BY GROUPING SETS(period,(gubun,region));
-- GROUPIN SETS -> period, (gubun, region)
-- GROUP BY -> gubun, region

SELECT gubun,region, SUM(loan_jan_amt) toal_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
    AND region in('서울','경기')
GROUP BY gubun,region ;








-- 집합 연산자
-- data 준비
CREATE TABLE exp_goods_asia (
       country VARCHAR2(10),
       seq     NUMBER,
       goods   VARCHAR2(80));
       
INSERT INTO exp_goods_asia VALUES ('한국', 1, '원유제외 석유류');
INSERT INTO exp_goods_asia VALUES ('한국', 2, '자동차');
INSERT INTO exp_goods_asia VALUES ('한국', 3, '전자집적회로');
INSERT INTO exp_goods_asia VALUES ('한국', 4, '선박');
INSERT INTO exp_goods_asia VALUES ('한국', 5,  'LCD');
INSERT INTO exp_goods_asia VALUES ('한국', 6,  '자동차부품');
INSERT INTO exp_goods_asia VALUES ('한국', 7,  '휴대전화');
INSERT INTO exp_goods_asia VALUES ('한국', 8,  '환식탄화수소');
INSERT INTO exp_goods_asia VALUES ('한국', 9,  '무선송신기 디스플레이 부속품');
INSERT INTO exp_goods_asia VALUES ('한국', 10,  '철 또는 비합금강');

INSERT INTO exp_goods_asia VALUES ('일본', 1, '자동차');
INSERT INTO exp_goods_asia VALUES ('일본', 2, '자동차부품');
INSERT INTO exp_goods_asia VALUES ('일본', 3, '전자집적회로');
INSERT INTO exp_goods_asia VALUES ('일본', 4, '선박');
INSERT INTO exp_goods_asia VALUES ('일본', 5, '반도체웨이퍼');
INSERT INTO exp_goods_asia VALUES ('일본', 6, '화물차');
INSERT INTO exp_goods_asia VALUES ('일본', 7, '원유제외 석유류');
INSERT INTO exp_goods_asia VALUES ('일본', 8, '건설기계');
INSERT INTO exp_goods_asia VALUES ('일본', 9, '다이오드, 트랜지스터');
INSERT INTO exp_goods_asia VALUES ('일본', 10, '기계류');

COMMIT;

SELECT * FROM exp_goods_asia;

-- UNION
-- 합집합
SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
ORDER BY seq;

SELECT goods
FROM exp_goods_asia
WHERE country = '일본'
ORDER BY seq;

SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
UNION
SELECT goods
FROM exp_goods_asia
WHERE country = '일본';


-- UNION ALL
-- 중복된 값도 그대로 추출
SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
UNION ALL
SELECT goods
FROM exp_goods_asia
WHERE country = '일본';


-- INTERSECT
-- 교집합 
SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
INTERSECT
SELECT goods
FROM exp_goods_asia
WHERE country = '일본'; 


-- MINUS
-- 차집합
-- 한국에는 있지만 일본에는 없는 것
SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
MINUS
SELECT goods
FROM exp_goods_asia
WHERE country = '일본'; 

-- 일본에는 있지만 한국에는 없는 것
SELECT goods
FROM exp_goods_asia
WHERE country = '일본'
MINUS
SELECT goods
FROM exp_goods_asia
WHERE country = '한국'; 



-- 집합 연산자의 제한 사항
-- 집합 연산자로 연결되는 각 SELECT 문의 SELECT 리스트의 개수와 데이터 타입은 일치해야 한다.
-- 집합 연산자로 SELECT  문을 연결할 때 ORDER BY 절은 맨 마지막 문장에서만 사용할 수 있다.
-- BLOB, CLOB, BFILE 타입의 컬럼에 대해서는 집합 연산자를 사용할 수 없다.
-- UNION, INTERSECT, MINUS 연산자는 LONG형 컬럼에는 사용할 수 없다.