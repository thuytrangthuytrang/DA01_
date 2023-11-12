----EX1
SELECT
COUNT(CASE
  WHEN device_type= 'laptop' THEN device_type
  END) AS laptop_views,
COUNT(CASE
  WHEN device_type IN('tablet', 'phone') THEN device_type
  END) AS mobile_views
FROM viewership;

--EX 2
SELECT x,y,z,
CASE
  WHEN z > ABS(x-y) AND z < x+y 
  AND  x > ABS(z-y) AND x < z+y
  AND  y > ABS(x-z) AND y < x+z
  THEN 'Yes' 
  ELSE 'No'
END As triangle
FROM Triangle;

---EX4
SELECT name
FROM customer
WHERE referee_id <>2 OR referee_id IS NULL;

--EX5
select survived,
COUNT(CASE 
  WHEN pclass=1 THEN  pclass
  END) AS first_class,
COUNT(CASE 
  WHEN pclass=2 THEN  pclass
  END) AS sencond_class,
COUNT(CASE 
  WHEN pclass=3 THEN  pclass
  END) AS third_class
FROM titanic
GROUP BY survived;
