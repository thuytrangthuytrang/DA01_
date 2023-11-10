-- EX1
SELECT DISTINCT city FROM station
WHERE id%2=0;

EX2: 
SELECT COUNT(CITY)-COUNT(DISTINCT(city))
FROM station;

---------EX4: MEAN------
SELECT 
SELECT ROUND(CAST(SUM(item_count*order_occurrences)/ SUM(order_occurrences) AS DECIMAL),1) AS mean
FROM items_per_order;

--EX5
SELECT candidate_id FROM candidates
WHERE skill IN('Python','Tableau','PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(skill)=3;

---EX6:
SELECT user_id,
DATE(MAX(post_date))-DATE(MIN(post_date)) AS days_between
FROM posts 
WHERE post_date BETWEEN '2021/01/01' AND '2022/01/01'
GROUP BY user_id; 

--EX7
SELECT card_name,
MAX(issued_amount)-MIN(issued_amount) AS different
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY MAX(issued_amount)-MIN(issued_amount) DESC;

--EX8
SELECT manufacturer,
COUNT(drug) AS drug_count,
ABS(SUM(total_sales-cogs)) AS total_loss
FROM pharmacy_sales
WHERE cogs>total_sales
GROUP BY manufacturer
ORDER BY ABS(SUM(total_sales-cogs)) DESC;

--EX9
SELECT id, movie, description,rating
FROM cinema
WHERE id%2=1 AND description NOT LIKE 'boring'
ORDER BY rating DESC;

--EX10
SELECT teacher_id,
COUNT(DISTINCT(subject_id)) AS  cnt
FROM Teacher
GROUP BY teacher_id;

--EX11
ELECT user_id,
COUNT(follower_id ) AS followers_count
FROM followers
GROUP BY user_id
ORDER BY user_id;


--EX 12
SELECT class
FROM courses
HAVING COUNT(student)>=5;

