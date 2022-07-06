SELECT * from Album; -- ��ü 347
SELECT * FROM Artist; -- ��ü 275
-- �ٹ��� ��Ƽ��Ʈ�� ��Ƽ��Ʈ ���̵� ����


-- ����
SELECT al.AlbumId , al.Title , al.ArtistId , arti.Name 
FROM Album al,
	Artist arti
WHERE al.ArtistId  = arti.ArtistId ;
-- �������� �ٹ��� �� ��Ƽ��Ʈ�� �ִ�.

-- ������ ����
UPDATE Album set ArtistId  = 999 WHERE AlbumId =275;
UPDATE Album set ArtistId  = 275 WHERE AlbumId =999;
-- rollback�� commit���� �������� �����Ƿ� commit�� rollback�� ���� �ʴ´�.

-- 1. inner join
SELECT al.AlbumId , al.Title , al.ArtistId , arti.Name 
FROM Album al,
	Artist arti
WHERE al.ArtistId  = arti.ArtistId;
-- ANSI ����
SELECT al.AlbumId , al.Title , al.ArtistId , arti.Name 
FROM Album al
join Artist arti on al.ArtistId  = arti.ArtistId;


-- 2. outer join
-- Album ����
-- Oracle ���� - dbeaver�� �ȸ���
SELECT al.AlbumId , al.Title , al.ArtistId , arti.Name 
FROM Album al,
	Artist arti
WHERE al.ArtistId  = arti.ArtistId(+);
-- ANSI ����
SELECT al.AlbumId , al.Title , al.ArtistId , arti.Name 
FROM Album al
left join Artist arti on al.ArtistId  = arti.ArtistId;


-- 3.outer join
-- Artist ����
-- ���⼭ right �� full outer ���� �ȵȴ�.
-- Oracle ���� - dbeaver�� �ȸ���
SELECT al.AlbumId , al.Title , al.ArtistId , arti.Name 
FROM Album al,
	Artist arti
WHERE al.ArtistId(+)  = arti.ArtistId;
-- ANSI ����
SELECT al.AlbumId , al.Title , al.ArtistId , arti.Name 
FROM Artist arti
left join Album al on arti.ArtistId  = al.ArtistId;
-- 418��
-- ���� id�� 275�� ������ �ٹ� artist id�� ��� �� null�� �����´�.