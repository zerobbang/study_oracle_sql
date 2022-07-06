select now() from dual;
## now() : 현재 시간을 가져오는 함수
## dual : 비어있는 임시 가짜 테이블에서

select 1+50 as value1 from dual
union all
select 3+20 as value2 from dual

CREATE TABLE TABLE_USER(
	userID VARCHAR(20),
	userPassword VARCHAR(20),
	userName VARCHAR(20),
	userGender VARCHAR(4),
	## PK
	PRIMARY KEY (userID)
);