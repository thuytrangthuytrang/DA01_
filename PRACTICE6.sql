--EX1

WITH ect AS
  (SELECT company_id, title, description, 
  COUNT(job_id) as job  
  FROM job_listings
  GROUP BY company_id, title, description)
SELECT COUNT(ect.company_id) AS duplicate_companies
FROM ect 
WHERE ect.job >1;

--EX2

WITH cte1 AS 
(SELECT category, product, SUM(spend) as total_spend 
FROM product_spend
WHERE EXTRACT(year from transaction_date)='2022'
AND category='appliance'
GROUP BY category, product
ORDER BY category,  total_spend DESC
LIMIT 2),

cte2 AS
(SELECT category, product, sum(spend) as total_spend 
FROM product_spend
WHERE EXTRACT(year from transaction_date)='2022'
AND category='electronics'
GROUP BY category, product 
ORDER BY category, total_spend  DESC
LIMIT 2)

SELECT category, product, total_spend 
FROM cte1 
UNION ALL 
SELECT category, product, total_spend 
FROM cte2 

---EX3 LỖI 


--EX4
SELECT pages.page_id
FROM pages
LEFT JOIN page_likes
  ON pages.page_id=page_likes.page_id
WHERE page_likes.liked_date IS NULL
ORDER BY  pages.page_id;

---EX5 LỖI

--EX6

SELECT DATE_FORMAT(trans_date, '%Y-%m') AS month, 
country,
COUNT(state) as trans_count, 
sum( case when state ='approved 'then 1 else 0 end) as approved_count,
sum(amount) as trans_total_amount,
sum( case when state ='approved 'then amount else 0 end) as approved_total_amount
FROM Transactions
GROUP BY month, country;

-----------EX7 

WITH cte1 AS 
(SELECT product_id, MIN(year) as min_year 
FROM Sales
GROUP BY product_id)

SELECT a.product_id, a.min_year as first_year,  b.quantity, b.price
FROM cte1  AS a 
JOIN Sales AS b 
ON a.product_id= b. product_id
where a.min_year = b.year

--EX8

WITH cte1 AS 
(SELECT customer_id, COUNT(DISTINCT(product_key) ) as number 
FROM Customer
GROUP BY customer_id
HAVING number=(select count(product_key) from Product))

SELECT customer_id 
FROM cte1;

--EX9

SELECT employee_id
FROM employees
WHERE salary < 30000 
  AND manager_id NOT IN (SELECT employee_id FROM employees)
ORDER BY employee_id;

--EX10

WITH ect AS
  (SELECT company_id, title, description, 
  COUNT(job_id) as job  
  FROM job_listings
  GROUP BY company_id, title, description)
SELECT COUNT(ect.company_id) AS duplicate_companies
FROM ect 
WHERE ect.job >1;


-----EX11

/* lượt phim nhiều nhất*/
WITH cte1 AS

(SELECT user_id, count(movie_id) as m
FROM MovieRating as c
GROUP BY user_id
Limit 1),

/*tên phim đc xem nhiều nhất*/
 cte2 AS
 (SELECT name, COUNT(c.movie_id) as count
 FROM  Users  as a
JOIN MovieRating as c
ON a.user_id = c.user_id 
GROUP BY name
HAVING count = (SELECT cte1.m FROM cte1)
ORDER BY name
LIMIT 1),

/* rating trung bình cao nhất*/
cte3 AS
(SELECT movie_id, AVG(rating ) as n
FROM MovieRating as b
GROUP BY movie_id
ORDER BY n DESC
Limit 1),

/* phim có rating trung bình cao nhất*/
 cte4 AS
 (SELECT title , AVG(rating ) as d
 FROM Movies  as e
JOIN MovieRating as g
ON e.movie_id = g.movie_id
WHERE EXTRACT(month FROM g.created_at)='2' 
AND EXTRACT(year FROM g.created_at)='2020'
GROUP BY title
HAVING d = (SELECT cte3.n FROM cte3)
ORDER BY  title
LIMIT 1)

SELECT name as results
FROM cte2
UNION 
SELECT title as results
FROM cte4;

--EX12

WITH cte1 AS 
(SELECT requester_id as id 
FROM RequestAccepted
UNION ALL 
SELECT accepter_id as id
FROM RequestAccepted)

SELECT id, count(id) as num
from cte1
group by id
order by num desc
limit 1;





