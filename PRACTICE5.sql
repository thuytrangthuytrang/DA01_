---EX1
SELECT country.continent , FLOOR (AVG(city.population))
FROM city
JOIN country 
  ON city.countrycode= country.code 
GROUP BY country.continent;

----- EX2
SELECT 
ROUND(sum(CASE 
				WHEN texts.signup_action ='Confirmed'
					THEN 1
				ELSE 0
				END)::DECIMAL / count(*), 2)  AS confirm_rate
FROM emails 
JOIN texts 
  ON emails.email_id  = texts.email_id;


-----EX3
SELECT age_breakdown.age_bucket,
ROUND(100.0 *sum(case WHEN ac.activity_type = 'send' 
  THEN  ac.time_spent 
  END ) / 
  sum(CASE 
			WHEN ac.activity_type in ('open','send')
			THEN ac.time_spent 
			END),2 )
AS send_perc,
ROUND(100.0 *sum(case WHEN ac.activity_type = 'open' 
  THEN ac.time_spent 
  END) / 
  sum(CASE 
			WHEN ac.activity_type in ('open','send')
			THEN ac.time_spent 
			end),2)
AS open_perc
FROM activities as ac 
JOIN age_breakdown
  ON ac.user_id=age_breakdown.user_id
GROUP BY age_breakdown.age_bucket;

--EX4
SELECT customer_contracts.customer_id
FROM customer_contracts
JOIN products 
  ON customer_contracts.product_id = products.product_id
GROUP BY customer_contracts.customer_id
HAVING COUNT(DISTINCT products.product_category) = 3;

----EX5
SELECT a.Employee_id, a.name, 
COUNT(b.age) AS reports_count, 
ROUND(CAST(SUM(b.age)/COUNT(b.age) AS DECIMAL),0) AS average_age
FROM Employees AS a
INNER JOIN Employees AS b
  ON a.employee_id = b.reports_to
GROUP BY a.Employee_id, a.name
ORDER BY a.Employee_id;

-----EX6
SELECT Products.product_name , SUM(Orders.unit) as unit 
FROM Products
RIGHT JOIN Orders
    ON Products.product_id = Orders.product_id  
WHERE EXTRACT(month FROM Orders.order_date)='2'
AND EXTRACT(year FROM Orders.order_date )='2020'
GROUP BY  Orders.product_id
HAVING SUM(Orders.unit)>=100 ;


--EX7
SELECT pages.page_id
FROM pages
LEFT JOIN page_likes
  ON pages.page_id=page_likes.page_id
WHERE page_likes.liked_date IS NULL
ORDER BY  pages.page_id;

