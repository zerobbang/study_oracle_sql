SELECT * from Artist ;
SELECT * from Album ;
SELECT * FROM Track;
SELECT * FROM Genre;

-- 1.
-- 아티스트가 총 몇명인지 출력
SELECT COUNT(*) from Artist ;

-- 2.
-- 아티스트가 중복되지 않은 앨범의수 출력
SELECT COUNT( DISTINCT ArtistId) from Album;

-- 3.
-- 곡(Track)의 길이(Milliseconds)가 4분이 넘는 곡의 이름(Name)을 보여주세요
SELECT Name  from Track
WHERE Milliseconds > 240000;

-- 4.
-- 장르는 앨범이 아니라 곡에 부여된다.
SELECT g.Name, COUNT(t.TrackId)  from Track t
join Genre g on t.GenreId = g.GenreId 
group by t.GenreId ;

-- 5. 
-- Artistid, Name, 그 아티스트가 출시한앨범(Album)의수를 앨범수의 내림차순으로 출력
SELECT al.Artistid, Name,COUNT(al.AlbumId) as total from Album al
join Artist arti on al.ArtistId = arti.ArtistId 
GROUP by arti.Artistid 
ORDER by total desc;
