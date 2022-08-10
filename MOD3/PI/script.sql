SELECT * FROM country;
SELECT * FROM spotify;
SELECT * FROM artists;
SELECT * FROM genre;

SELECT * FROM genre
WHERE track_id = '0WIbzDVEpmOyBnqqdtqIL9';

SELECT * FROM spotify
WHERE track_id = '0WIbzDVEpmOyBnqqdtqIL9';

SELECT * FROM spotify
WHERE artists_id IN (SELECT artists_id FROM artists
WHERE artists = '[''Christian Nodal'']');

SELECT track_id, count(0) FROM genre
GROUP BY track_id
HAVING count(0) > 1;

SELECT track_id, count(0) FROM spotify
GROUP BY track_id
HAVING count(0) > 1;

SELECT track_id, count(0) FROM country
GROUP BY track_id;

SELECT artists, count(0) FROM artists
GROUP BY artists
HAVING count(0) > 1;

SELECT s.track_id, s."name", a.artists, g.genre--, c.country
FROM spotify s
	INNER JOIN artists a
	ON a.artists_id = s.artists_id
	INNER JOIN genre g
	ON g.track_id = s.track_id
	INNER JOIN country c
	ON c.track_id = s.track_id
;

SELECT * FROM country c WHERE c."year" = 2021

SELECT s.track_id, s."name", c.country
FROM spotify s	
	INNER JOIN country c
	ON c.track_id = s.track_id
;

SELECT s.*
FROM spotify s
--WHERE s.artists LIKE '%Weird%'
WHERE s.artists = '[''"Weird Al" Yankovic'']'

SELECT * FROM country c
WHERE c.track_id = '0EPxmvsG1BY5td4aTOkWBF'

SELECT *
FROM artists
WHERE artists = '[''"Weird Al" Yankovic'']'

['"Weird Al" Yankovic']