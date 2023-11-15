---1
SELECT DISTINCT title,replacement_cost 
FROM film
GROUP BY title,replacement_cost 
ORDER BY replacement_cost;

-----2
SELECT COUNT(replacement_cost) AS low,
(SELECT COUNT(replacement_cost) AS medium
FROM film 
WHERE replacement_cost between 20.00 and 24.99),
(SELECT COUNT(replacement_cost) AS hight
FROM film 
WHERE replacement_cost between 9.99 and 19.99)
FROM film 
WHERE replacement_cost between 9.99 and 19.99 ;

---3
SELECT a.title, a.length, c.name
FROM film AS a
JOIN film_category AS b
	ON a.film_id = b.film_id
JOIN category AS c
	ON b.category_id=c.category_id
WHERE  c.name IN ('Drama', 'Sports')
ORDER BY a.length DESC;

---4
SELECT c.name, COUNT(a.title) AS number
FROM film AS a
JOIN film_category AS b
	ON a.film_id = b.film_id
JOIN category AS c
	ON b.category_id=c.category_id
GROUP BY c.name
ORDER BY number DESC;


--5
SELECT a.first_name ||a.last_name as name, count (title) as film_number
FROM ACTOR AS a
JOIN FILM_ACTOR AS b
	ON a.actor_id=b.actor_id
JOIN FILM AS c
	ON b.film_id=c.film_id
GROUP BY name
ORDER BY film_number DESC;

--6
SELECT COUNT(b.address)
FROM CUSTOMER AS a
RIGHT JOIN address AS b
	ON a.address_id=b.address_id
WHERE a.customer_id IS NULL;

--7
SELECT d.city,sum(a.amount)
FROM payment as a
JOIN customer as b
	ON a.customer_id=b.customer_id
JOIN address as c
	ON c.address_id=b.address_id
JOIN city as d
	ON c.city_id=d.city_id
GROUP BY d.city
ORDER BY sum(a.amount) DESC;

--8
SELECT d.city||','||e.country AS CITY, SUM(a.amount)
FROM payment as a
JOIN customer as b
	ON a.customer_id=b.customer_id
JOIN address as c
	ON c.address_id=b.address_id
JOIN city as d
	ON c.city_id=d.city_id
JOIN country as e
	on d.country_id=e.country_id
GROUP BY d.city,e.country
ORDER BY SUM(a.amount) DESC;
