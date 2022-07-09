SELECT SYSDATE FROM DUAL;

-- 모든 유저 확인
-- SELECT * FROM ALL_USERS;

-- 오라클 버전 확인
-- SELECT * FROM V$VERSION;

-- 1. 유저 생성 문
-- CREATE USER 아이디 IDENTIFIED BY 비번;
-- 19c부터 아이디 앞에 c##을 추가해야한다.
-- CREATE USER c##아이디 IDENTIFIED BY 비번;
-- 위 과정을 없애기 위해 다음을 실행 후 그냥 생성
ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;
CREATE USER zerobbang IDENTIFIED BY zero123;
-- 유저 삭세
-- DROP USER zerobbang;

-- 2. 권한 주기
-- with grant option : 유저가 가지게 될 권한을 다른 사람에게 부여할 권한까지 포함한다.
-- GRANT ALL PRIVILEGES on : 유저가 db에 접근 가능하게 부여한다.
GRANT CONNECT, dba, resource TO zerobbang;
