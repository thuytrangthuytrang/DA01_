---EX1
SELECT country.continent , FLOOR (AVG(city.population))
FROM city
INNER JOIN country 
  ON city.countrycode= country.code 
GROUP BY country.continent;

----- EX2
SELECT 
COUNT(texts.email_id)/COUNT(DISTINCT emails.email_id) AS confirm_rate
FROM emails
LEFT JOIN texts
ON emails_id=texts_id  AND texts.signup_action = 'Confirmed';


-----EX3

SELECT age_breakdown.age_bucket,
CASE 
  WHEN activities.activity_type = 'open' THEN time_spent as time_open 
  ELSE time_spent as time_send
END 
  THEN activities.time_spent/(activities.time_spent+) as open_perc
  ELSE activities.time_spent/(activities.time_spent+) as send_perc
END
FROM activities
LEFT JOIN age_breakdown
ON activities.user_id=age_breakdown.user_id
GROUP BY age_breakdown.age_bucket;

----EX5
SELECT mng.employee_id, emp.name,
COUNT( emp.reports_to) as reports_count,
AVG(emp.age) AS average_age
FROM Employees AS emp
JOIN Employees AS mng
ON emp.employee_id = mng.employee_id 
and emp.reports_count IS NOT NULL;

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

