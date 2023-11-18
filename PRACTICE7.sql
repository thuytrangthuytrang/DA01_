---EX8

WITH cte1 AS 
(SELECT a.artist_name,
DENSE_RANK() OVER ( ORDER BY COUNT(c.song_id) DESC) AS artist_rank
FROM artists AS a  
JOIN songs AS b  
  ON a.artist_id = b.artist_id
JOIN global_song_rank AS c  
  ON b.song_id = c.song_id
WHERE c.rank <= 10
GROUP BY a.artist_name )

SELECT artist_name, artist_rank
FROM cte1
WHERE artist_rank <= 5; 
