---EX1
SELECT name
FROM students
WHERE marks >75
ORDER BY RIGHT(name,3),id;

--EX2
SELECT user_id,
CONCAT (UPPER(LEFT(name,1)),LOWER(RIGHT(name,LENGTH(name)-1))) AS name
FROM users
ORDER BY user_id;

-----EX3

SELECT manufacturer,
CONCAT('$',ROUND(SUM(total_sales)/1000000,0),' ','million') AS sale
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY SUM(total_sales) DESC,manufacturer;

--EX4
SELECT 
EXTRACT(MONTH FROM submit_date) AS mth,
product_id AS PRODUCT,
ROUND(AVG(stars),2) AS avg_stars
FROM reviews
GROUP BY product,EXTRACT(MONTH FROM submit_date)
ORDER BY EXTRACT(MONTH FROM submit_date),product_id;

--EX5
SELECT sender_id,
COUNT(message_id ) AS message_count
FROM messages
WHERE EXTRACT(MONTH FROM sent_date)=8
AND  EXTRACT(YEAR FROM sent_date)=2022
GROUP BY sender_id
ORDER BY COUNT(message_id ) DESC
LIMIT 2;

--EX6
SELECT tweet_id  
FROM Tweets
WHERE LENGTH( content )>15;

------EX7
SELECT DISTINCT activity_date AS day,
COUNT(DISTINCT(user_id)) AS active_users
FROM activity
WHERE activity_date >'2019-06-27' AND  activity_date <='2019-07-27'
GROUP BY day;

---EX8
select COUNT(first_name) AS total_employee
from employees
WHERE EXTRACT(MONTH FROM joining_date) BETWEEN 1 AND 7
AND  EXTRACT(YEAR FROM joining_date)=2022 ;

---EX9
select POSITION('a' IN first_name)
from worker;

--EX10
select SUBSTRING(title FROM LENGTH(winery)+2 FOR 4 )
from winemag_p2;
