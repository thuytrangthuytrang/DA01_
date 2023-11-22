--EX1--
WITH cte AS
(SELECT customer_id,order_date, customer_pref_delivery_date,
COUNT(first_order) OVER(PARTITION BY customer_id ) as nnn
FROM 
(SELECT distinct customer_id, order_date,customer_pref_delivery_date,
RANK() OVER(PARTITION BY customer_id ORDER BY  order_date  ) as first_order
FROM Delivery) as cccc
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

--EX2-- ĐỔI RA SỐ GIÂY Ở CASE WHEN 

WITH cte AS
(SELECT *,
CASE
WHEN  event_date =next_day-1 THEN 1
ELSE 0
END as nnn
FROM 
(SELECT player_id,event_date,
LEAD(event_date) OVER(PARTITION BY player_id) as next_day 
FROM Activity) AS aaa)

SELECT ROUND(sum(nnn)/count(DISTINCT player_id),2) AS fraction 
FROM cte;

--EX3--


SELECT
CASE
WHEN mod(id,2)=0 then id-1
WHEN mod(id,2)=1 and id+1 not in (select id from seat) then id
ELSE id+1 
END as id, student
FROM seat order by id;


--EX--4


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

--EX8--


WITH cte AS 
(SELECT person_name,weight,turn,SUM(weight) over (ORDER BY turn) as sum 
FROM Queue)

SELECT person_name
FROM cte
WHERE sum <= 1000
ORDER BY sum DESC
LIMIT 1;


