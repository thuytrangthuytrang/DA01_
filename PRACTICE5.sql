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

