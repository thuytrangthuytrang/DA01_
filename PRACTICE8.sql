--EX1--
WITH cte AS
(SELECT customer_id,order_date, customer_pref_delivery_date,
COUNT(first_order) OVER(PARTITION BY customer_id ) as nnn
FROM 
(SELECT distinct customer_id, order_date,customer_pref_delivery_date,
RANK() OVER(PARTITION BY customer_id ORDER BY  order_date  ) as first_order
FROM Delivery) as aaa
WHERE first_order=1),

cte2 AS
(SELECT customer_id,
CASE 
WHEN order_date =customer_pref_delivery_date THEN 1
ELSE 0
END AS immediate 
FROM cte)

SELECT round(100*sum(cte2.immediate)/count(cte.customer_id),2) as immediate_percentage
FROM cte
JOIN cte2 
  ON cte.customer_id=cte2.customer_id;

--EX2--

WITH cte AS
(SELECT player_id, event_date,
ROW_NUMBER()OVER(PARTITION BY player_id ORDER BY event_date) as ranking 
FROM Activity),

cte1 AS
(SELECT player_id, event_date 
FROM cte 
WHERE ranking=1), 

cte2 AS
(SELECT player_id, event_date
FROM cte
WHERE ranking=2),

cte3 AS
(SELECT a.player_id, a.event_date, b.event_date as next_day
FROM cte1 as a
JOIN cte2 as b 
ON a.player_id=b.player_id
AND a.event_date=DATE_SUB(b.event_date, INTERVAL 1 DAY))

SELECT ROUND(COUNT(c.player_id)/COUNT(d.player_id),2) AS fraction 
FROM cte3 as c
RIGHT JOIN cte1 as d
  ON c.player_id= d.player_id;

--EX3--


SELECT
CASE
WHEN mod(id,2)=0 then id-1
WHEN mod(id,2)=1 and id+1 not in (select id from seat) then id
ELSE id+1 
END as id, student
FROM seat order by id;


--EX4--


WITH cte AS

(SELECT visited_on,amount ,  amount +
lag(amount,6) OVER(ORDER BY visited_on) + lag(amount,5) OVER(ORDER BY visited_on ) +
lag(amount,4) OVER(ORDER BY visited_on )+ lag(amount,3) OVER(ORDER BY visited_on)  +
lag(amount,2) OVER(ORDER BY visited_on )+ lag(amount,1) OVER(ORDER BY visited_on ) 
as sum 
FROM 
(SELECT visited_on, SUM(amount) as amount
FROM Customer
GROUP BY  visited_on ) AS aaa)

SELECT visited_on, sum as amount, round(sum/7,2) as average_amount
FROM cte 
WHERE sum IS NOT NULL;

--EX5--

WITH cte AS
(SELECT pid, tiv_2015, tiv_2016, 
COUNT(TIV_2015) OVER (PARTITION BY tiv_2015) as a,
COUNT(concat(lat, lon)) OVER (PARTITION BY concat(lat, lon)) as b
FROM Insurance )

SELECT ROUND(SUM(tiv_2016),2) as  tiv_2016 
FROM cte 
WHERE a<>1 AND  b=1;


--EX6--

WITH cte AS
(SELECT *, 
DENSE_RANK() OVER(PARTITION BY Department ORDER BY Salary DESC ) as ranking 
FROM 
(SELECT b.name as Department,a.name as Employee,a.salary as salary 
FROM Employee as a
JOIN Department as b
    ON a.departmentId=b.id) AS a)

SELECT Department,Employee, salary
FROM cte 
WHERE ranking <=3

--EX7--


WITH cte AS 
(SELECT person_name,weight,turn,
SUM(weight) over (ORDER BY turn) as sum 
FROM Queue)

SELECT person_name
FROM cte
WHERE sum <= 1000
ORDER BY sum DESC
LIMIT 1;

--EX8--

WITH cte AS
(SELECT product_id, price
FROM 
(SELECT product_id, new_price AS price, rank() OVER(PARTITION BY product_id ORDER BY change_date desc)
as ranking 
FROM Products
WHERE change_date<='2019-08-16' ) AS a
WHERE ranking=1)

SELECT *
FROM cte
UNION
SELECT product_id, '10' as price
FROM Products
WHERE product_id NOT IN (SELECT product_id FROM cte);



