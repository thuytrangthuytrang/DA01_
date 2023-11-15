--EX1
WITH ect AS
  (SELECT company_id, title, description, 
  COUNT(job_id) as job  
  FROM job_listings
  GROUP BY company_id, title, description)
SELECT COUNT(ect.company_id) AS duplicate_companies
FROM ect 
WHERE ect.job >1;

--EX9
SELECT employee_id
FROM employees
WHERE salary < 30000 
  AND manager_id NOT IN (SELECT employee_id FROM employees)
ORDER BY employee_id;
--EX2




--EX4
SELECT pages.page_id
FROM pages
LEFT JOIN page_likes
  ON pages.page_id=page_likes.page_id
WHERE page_likes.liked_date IS NULL
ORDER BY  pages.page_id;

--EX11
/*tên người, tên phim*/
WITH cte AS 
(SELECT a.name, c.title, a.user_id 
FROM Users AS a
JOIN MovieRating AS b
  ON a.user_id =b.user_id 
JOIN Movies AS c
  ON c.movie_id=b.movie_id
WHERE EXTRACT(month FROM b.created_at)='2' 
AND EXTRACT(year FROM b.created_at)='2020'),

  /*người bình chọn nhiều phim nhất*/
cte2 AS
(SELECT user_id, count(movie_id) as m
FROM MovieRating 
WHERE EXTRACT(month FROM created_at)='2' 
AND EXTRACT(year FROM created_at)='2020'
GROUP BY user_id),


/*phim có điêm bình chọn lớn nhất*/
cte3 AS 
(SELECT user_id,movie_id, AVG(rating) as n
FROM MovieRating 
WHERE EXTRACT(month FROM created_at)='2' 
AND EXTRACT(year FROM created_at)='2020'
GROUP BY movie_id)

SELECT  ect.name
FROM ect
JOIN ect2
  ON ect.user_id=ect2.user_id
JOIN ect3
  ON ect3.user_id=ect.user_id
WHERE MAX(cte2.m) AND MAX(cte3.n);




WITH ect AS 

(SELECT a.name , c.title, b.user_id
FROM Users AS a
JOIN MovieRating AS b
  ON a.user_id =b.user_id 
JOIN Movies AS c
  ON c.movie_id=b.movie_id
WHERE EXTRACT(month FROM b.created_at)='2' 
AND EXTRACT(year FROM b.created_at)='2020'),

ect2 AS
(SELECT user_id, count(movie_id) as m
FROM MovieRating
WHERE EXTRACT(month FROM created_at)='2' 
AND EXTRACT(year FROM created_at)='2020' 
GROUP BY user_id),

ect3 AS 
(SELECT user_id, AVG(rating) as n 
FROM MovieRating 
WHERE EXTRACT(month FROM created_at)='2' 
AND EXTRACT(year FROM created_at)='2020'
GROUP BY movie_id),


SELECT  ect.name
FROM ect
JOIN ect2
  ON ect.user_id=ect2.user_id
JOIN ect3
  ON ect3.user_id=ect.user_id;



