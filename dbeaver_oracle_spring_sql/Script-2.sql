SELECT SYSDATE FROM DUAL;

-- ��� ���� Ȯ��
-- SELECT * FROM ALL_USERS;

-- ����Ŭ ���� Ȯ��
-- SELECT * FROM V$VERSION;

-- 1. ���� ���� ��
-- CREATE USER ���̵� IDENTIFIED BY ���;
-- 19c���� ���̵� �տ� c##�� �߰��ؾ��Ѵ�.
-- CREATE USER c##���̵� IDENTIFIED BY ���;
-- �� ������ ���ֱ� ���� ������ ���� �� �׳� ����
ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;
CREATE USER zerobbang IDENTIFIED BY zero123;
-- ���� �輼
-- DROP USER zerobbang;

-- 2. ���� �ֱ�
-- with grant option : ������ ������ �� ������ �ٸ� ������� �ο��� ���ѱ��� �����Ѵ�.
GRANT ALL PRIVILEGES TO zerobbang;
GRANT CONNECT, dba, resource TO zerobbang;
