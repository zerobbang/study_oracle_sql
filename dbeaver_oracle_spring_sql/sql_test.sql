SELECT * from Artist ;
SELECT * from Album ;
SELECT * FROM Track;
SELECT * FROM Genre;

-- 1.
-- ��Ƽ��Ʈ�� �� ������� ���
SELECT COUNT(*) from Artist ;

-- 2.
-- ��Ƽ��Ʈ�� �ߺ����� ���� �ٹ��Ǽ� ���
SELECT COUNT( DISTINCT ArtistId) from Album;

-- 3.
-- ��(Track)�� ����(Milliseconds)�� 4���� �Ѵ� ���� �̸�(Name)�� �����ּ���
SELECT Name  from Track
WHERE Milliseconds > 240000;

-- 4.
-- �帣�� �ٹ��� �ƴ϶� � �ο��ȴ�.
SELECT g.Name, COUNT(t.TrackId)  from Track t
join Genre g on t.GenreId = g.GenreId 
group by t.GenreId ;

-- 5. 
-- Artistid, Name, �� ��Ƽ��Ʈ�� ����Ѿٹ�(Album)�Ǽ��� �ٹ����� ������������ ���
SELECT al.Artistid, Name,COUNT(al.AlbumId) as total from Album al
join Artist arti on al.ArtistId = arti.ArtistId 
GROUP by arti.Artistid 
ORDER by total desc;
