---EX1
SELECT country.continent , FLOOR (AVG(city.population))
FROM city
INNER JOIN country 
  ON city.countrycode= country.code 
GROUP BY country.continent;

-- EX2

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

