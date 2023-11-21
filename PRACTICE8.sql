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

--

