----EX1

--EX 2
SELECT x,y,z,
CASE
WHEN z BETWEEN ABS(x-y) AND x+y THEN 'Yes'
ELSE 'No'
END As triangle
FROM Triangle;

---- EX3
SELECT 
ROUND(CAST((COUNT(CASE
WHEN call_category='n/a' THEN call_category
END)+
COUNT(CASE
WHEN call_category IS NULL THEN call_category
END))
/COUNT(call_category) DECIMAL),1)
AS call_percentage
FROM callers;

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
