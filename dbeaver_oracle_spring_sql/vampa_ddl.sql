SELECT SYSDATE FROM dual;


create table vam_board(
    bno number generated always as IDENTITY,
    title varchar2(150) not null,
    content varchar2(2000) not null,
    writer varchar2(50) not null,
    regdate date default sysdate,
    updatedate date default sysdate,
    constraint pk_board PRIMARY key(bno)
);

-- ����Ŭ 12c ���� ���Ե� ����
-- �ڵ����� 1�� �����ϴ� ���� �ο�
-- number generated always as IDENTITY..?


-- test
insert into vam_board(title, content, writer) values ('�׽�Ʈ ����1', '�׽�Ʈ ����1', '�۰�1');
insert into vam_board(title, content, writer) values ('�׽�Ʈ ����2', '�׽�Ʈ ����2', '�۰�2');
insert into vam_board(title, content, writer) values ('�׽�Ʈ ����3', '�׽�Ʈ ����3', '�۰�3');
-- PK�� ���� �Է��ϸ�?
-- insert into vam_board(bno,title, content, writer) values (1,'�׽�Ʈ ����4', '�׽�Ʈ ����4', '�۰�4');
-- generated always ID ���� ���� �� �� ����.

-- ��� ����
insert into vam_board(title,content,writer) (select title,content, writer from vam_board);

-- �� Ȯ��
select count(*) from vam_board;

SELECT ROWNUM, BNO, TITLE, CONTENT, WRITER, REGDATE, UPDATEDATE
FROM ZEROBBANG.VAM_BOARD;

-- SELECT ROWNUM, BNO, TITLE, CONTENT, WRITER, REGDATE, UPDATEDATE FROM ZEROBBANG.VAM_BOARD ORDER BY WRITER;
-- ROWNUM�� �����ϱ� ���� �Ű�����.

SELECT * FROM VAM_BOARD ORDER BY BNO ;
SELECT * FROM VAM_BOARD WHERE BNO =8;
DELETE FROM VAM_BOARD WHERE BNO =14;

update vam_board set title='���� ����', content='���� ����', updateDate = sysdate where bno = 8;
-- DROP TABLE VAM_BOARD ;


-- 1. ���� ���� �ڵ�
select rn, bno, title, content, writer, regdate, updatedate from(
 
        select /*+INDEX_DESC(vam_board pk_board) */ rownum as rn, bno, title, content, writer, regdate, updatedate
 
        from vam_board)
        -- select rownum as rownum as rn, bno, title, content, writer, regdate, updatedate from vam_board order by bno desc
 
where rn between 11 and 20;

-- 2. hint ���� �׳� �ڵ�
select rn, bno, title, content, writer, regdate, updatedate from(
        select  rownum as rn, bno, title, content, writer, regdate, updatedate
        from vam_board ORDER BY bno DESC)
where rn between 11 and 20;
-- Oracle�� �ڵ����� index�� �߰��Ѵ�.


-- rownum2 ���
select rn, bno, title, content, writer, regdate, updatedate from(
        select /*+INDEX_DESC(vam_board pk_board) */ rownum as rn, bno, title, content, writer, regdate, updatedate
        from vam_board where ROWNUM  <=20)
WHERE rn>10;
