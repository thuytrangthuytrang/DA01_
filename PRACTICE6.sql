--EX1
WITH job AS
  (SELECT
    company_id, 
    title, 
    description, 
    COUNT(job_id) AS job_count
  FROM job_listings
  GROUP BY company_id, title, description)
SELECT COUNT(job.company_id) AS duplicate_companies
FROM job
WHERE job.job_count >1;

--EX2


--EX4
SELECT pages.page_id
FROM pages
LEFT JOIN page_likes
  ON pages.page_id=page_likes.page_id
WHERE page_likes.liked_date IS NULL
ORDER BY  pages.page_id;

--EX11
SELECT a.name, c.title
FROM Users AS a
JOIN MovieRating AS b
  ON a.user_id =b.user_id 
JOIN Movies AS c
  ON c.movie_id=b.movie_id
WHERE EXTRACT(month FROM b.created_at)='2' 
AND EXTRACT(year FROM b.created_at)='2020'

(SELECT user_id, count(movie_id)
WHERE EXTRACT(month FROM b.created_at)='2' 
AND EXTRACT(year FROM b.created_at)='2020'
FROM MovieRating 
GROUP BY user_id) AS table_1; 


SELECT user_id, AVG(rating)
WHERE EXTRACT(month FROM b.created_at)='2' 
AND EXTRACT(year FROM b.created_at)='2020'
FROM MovieRating 
GROUP BY movie_id;


