select now() from dual;
## now() : 현재 시간을 가져오는 함수
## dual : 비어있는 임시 가짜 테이블에서

select 1+50 as value1 from dual
union all
select 3+20 as value2 from dual;

CREATE TABLE TABLE_USER(
	userID VARCHAR(20),
	userPassword VARCHAR(20),
	userName VARCHAR(20),
	userGender VARCHAR(4),
	## PK
	PRIMARY KEY (userID)
);

create table BBS(
	bbsID INT,
	bbsTitle VARCHAR(50),
	writer VARCHAR(20),
	crDate DATETIME,
	bbsContent VARCHAR(2048),
	bbsAvailable INT,
	primary key (bbsID)
);

## 문자열 ""아니라 ''
insert into TABLE_USER values
	('test1@gmail.com','1234','길동홍','남성');



select * from TABLE_USER;

SELECT * FROM TABLE_USER WHERE userID='test1@gmail.com' ;

# 현재 저장된 마지막 글번호 가져오기
select bbsID from bbs oreder by bbsID desc;
# 샘플 데이터 만들어보기
insert into bbs values
	(1,"이가영","삼가영","2022-06-29","비온 뒤 맑음",1);
insert into bbs values
	(2,"레드","빨강","2022-06-30","비온 뒤 맑음2",1);
insert into bbs values
	(3,"오렌지","주황","2022-06-30","비온 뒤 맑음3",0);
insert into bbs values
	(4,"옐로우","노랑","2022-07-01","비온 뒤 맑음4",1);
insert into bbs values
	(5,"그린","초록","2022-07-02","비온 뒤 맑음5",1);

# 데이터 뻥튀기
## 자기 선택 후 자기 자신을 그대로 새로운 데이터로 추가
set @count := 0;
select bbsID , bbsTitle ,writer ,crDate , bbsContent , bbsAvailable from bbs;

#PK나 오토는 뻥튀기 불가
insert into bbs ( bbsID, bbsTitle ,writer ,crDate , bbsContent , bbsAvailable )
select @count:=@count+1, bbsTitle ,writer, crDate ,bbsContent ,bbsAvailable from bbs ;

select * from bbs ;

# 운영환경처럼  dB 섞기
update bbs set bbsAvailable = 0 where bbsID =9;
delete from bbs where bbsID =128;

# 글 목록 가져오기
select * from bbs where bbsID < 35
	and bbsAvailable = 1
	order by bbsID desc 
	limit 10;


commit;


select bbsID from bbs order by bbsID desc ;
# 보다는
select max(bbsID) from bbs ; 


# 글 목록 가져오기
select * from bbs where bbsID < 10
	and bbsAvailable = 1
	order by bbsID desc ;

