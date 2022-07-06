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

-- 오라클 12c 부터 도입된 문법
-- 자동으로 1씩 증가하는 긴으 부여
-- number generated always as IDENTITY..?


-- test
insert into vam_board(title, content, writer) values ('테스트 제목1', '테스트 내용1', '작가1');
insert into vam_board(title, content, writer) values ('테스트 제목2', '테스트 내용2', '작가2');
insert into vam_board(title, content, writer) values ('테스트 제목3', '테스트 내용3', '작가3');
-- PK에 값을 입력하면?
-- insert into vam_board(bno,title, content, writer) values (1,'테스트 제목4', '테스트 내용4', '작가4');
-- generated always ID 열에 삽입 할 수 없다.

-- 재귀 복사
insert into vam_board(title,content,writer) (select title,content, writer from vam_board);

-- 행 확인
select count(*) from vam_board;

SELECT ROWNUM, BNO, TITLE, CONTENT, WRITER, REGDATE, UPDATEDATE
FROM ZEROBBANG.VAM_BOARD;

-- SELECT ROWNUM, BNO, TITLE, CONTENT, WRITER, REGDATE, UPDATEDATE FROM ZEROBBANG.VAM_BOARD ORDER BY WRITER;
-- ROWNUM은 정렬하기 전에 매겨진다.

SELECT * FROM VAM_BOARD ORDER BY BNO ;
SELECT * FROM VAM_BOARD WHERE BNO =8;
DELETE FROM VAM_BOARD WHERE BNO =14;

update vam_board set title='제목 수정', content='내용 수정', updateDate = sysdate where bno = 8;
-- DROP TABLE VAM_BOARD ;


-- 1. 정렬 없는 코드
select rn, bno, title, content, writer, regdate, updatedate from(
 
        select /*+INDEX_DESC(vam_board pk_board) */ rownum as rn, bno, title, content, writer, regdate, updatedate
 
        from vam_board)
        -- select rownum as rownum as rn, bno, title, content, writer, regdate, updatedate from vam_board order by bno desc
 
where rn between 11 and 20;

-- 2. hint 없이 그냥 코드
select rn, bno, title, content, writer, regdate, updatedate from(
        select  rownum as rn, bno, title, content, writer, regdate, updatedate
        from vam_board ORDER BY bno DESC)
where rn between 11 and 20;
-- Oracle이 자동으로 index를 추가한다.


-- rownum2 방식
select rn, bno, title, content, writer, regdate, updatedate from(
        select /*+INDEX_DESC(vam_board pk_board) */ rownum as rn, bno, title, content, writer, regdate, updatedate
        from vam_board where ROWNUM  <=20)
WHERE rn>10;
