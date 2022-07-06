select now() from dual;
## now() : ���� �ð��� �������� �Լ�
## dual : ����ִ� �ӽ� ��¥ ���̺���

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

## ���ڿ� ""�ƴ϶� ''
insert into TABLE_USER values
	('test1@gmail.com','1234','�浿ȫ','����');



select * from TABLE_USER;

SELECT * FROM TABLE_USER WHERE userID='test1@gmail.com' ;

# ���� ����� ������ �۹�ȣ ��������
select bbsID from bbs oreder by bbsID desc;
# ���� ������ ������
insert into bbs values
	(1,"�̰���","�ﰡ��","2022-06-29","��� �� ����",1);
insert into bbs values
	(2,"����","����","2022-06-30","��� �� ����2",1);
insert into bbs values
	(3,"������","��Ȳ","2022-06-30","��� �� ����3",0);
insert into bbs values
	(4,"���ο�","���","2022-07-01","��� �� ����4",1);
insert into bbs values
	(5,"�׸�","�ʷ�","2022-07-02","��� �� ����5",1);

# ������ ��Ƣ��
## �ڱ� ���� �� �ڱ� �ڽ��� �״�� ���ο� �����ͷ� �߰�
set @count := 0;
select bbsID , bbsTitle ,writer ,crDate , bbsContent , bbsAvailable from bbs;

#PK�� ����� ��Ƣ�� �Ұ�
insert into bbs ( bbsID, bbsTitle ,writer ,crDate , bbsContent , bbsAvailable )
select @count:=@count+1, bbsTitle ,writer, crDate ,bbsContent ,bbsAvailable from bbs ;

select * from bbs ;

# �ȯ��ó��  dB ����
update bbs set bbsAvailable = 0 where bbsID =9;
delete from bbs where bbsID =128;

# �� ��� ��������
select * from bbs where bbsID < 35
	and bbsAvailable = 1
	order by bbsID desc 
	limit 10;


commit;


select bbsID from bbs order by bbsID desc ;
# ���ٴ�
select max(bbsID) from bbs ; 


# �� ��� ��������
select * from bbs where bbsID < 10
	and bbsAvailable = 1
	order by bbsID desc ;

