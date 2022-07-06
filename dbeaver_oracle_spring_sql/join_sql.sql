SELECT * from Album; -- 전체 347
SELECT * FROM Artist; -- 전체 275
-- 앨범과 아티스트의 아티스트 아이디 존재


-- 조인
SELECT al.AlbumId , al.Title , al.ArtistId , arti.Name 
FROM Album al,
	Artist arti
WHERE al.ArtistId  = arti.ArtistId ;
-- 여러개의 앨범을 낸 아티스트가 있다.

-- 데이터 조작
UPDATE Album set ArtistId  = 999 WHERE AlbumId =275;
UPDATE Album set ArtistId  = 275 WHERE AlbumId =999;
-- rollback은 commit전의 내용으로 돌리므로 commit후 rollback은 먹지 않는다.

-- 1. inner join
SELECT al.AlbumId , al.Title , al.ArtistId , arti.Name 
FROM Album al,
	Artist arti
WHERE al.ArtistId  = arti.ArtistId;
-- ANSI 조인
SELECT al.AlbumId , al.Title , al.ArtistId , arti.Name 
FROM Album al
join Artist arti on al.ArtistId  = arti.ArtistId;


-- 2. outer join
-- Album 기준
-- Oracle 조인 - dbeaver는 안먹음
SELECT al.AlbumId , al.Title , al.ArtistId , arti.Name 
FROM Album al,
	Artist arti
WHERE al.ArtistId  = arti.ArtistId(+);
-- ANSI 조인
SELECT al.AlbumId , al.Title , al.ArtistId , arti.Name 
FROM Album al
left join Artist arti on al.ArtistId  = arti.ArtistId;


-- 3.outer join
-- Artist 기준
-- 여기서 right 랑 full outer 지원 안된다.
-- Oracle 조인 - dbeaver는 안먹음
SELECT al.AlbumId , al.Title , al.ArtistId , arti.Name 
FROM Album al,
	Artist arti
WHERE al.ArtistId(+)  = arti.ArtistId;
-- ANSI 조인
SELECT al.AlbumId , al.Title , al.ArtistId , arti.Name 
FROM Artist arti
left join Album al on arti.ArtistId  = al.ArtistId;
-- 418개
-- 가수 id가 275인 가수가 앨범 artist id에 없어서 다 null로 가져온다.