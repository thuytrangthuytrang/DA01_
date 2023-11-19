---EX8--

WITH cte1 AS 
(SELECT a.artist_name,
DENSE_RANK() OVER ( ORDER BY COUNT(c.song_id) DESC) AS artist_rank
FROM artists AS a  
JOIN songs AS b  
  ON a.artist_id = b.artist_id
JOIN global_song_rank AS c  
  ON b.song_id = c.song_id
WHERE c.rank <= 10
GROUP BY a.artist_name )

SELECT artist_name, artist_rank
FROM cte1
WHERE artist_rank <= 5; 

--EX7--

WITH cte1 AS 
(SELECT category,product,
SUM(spend) AS total,
RANK() OVER(PARTITION BY category ORDER BY SUM(spend) DESC) AS ranking 
FROM product_spend
WHERE EXTRACT(year from transaction_date)='2022'
GROUP BY category, product) 

SELECT category,product,total
FROM cte1 
WHERE ranking <=2
ORDER BY category, ranking;

--EX6--

WITH cte AS 
(SELECT merchant_id,credit_card_id,amount,
      CAST(transaction_timestamp AS time) AS time,
    LEAD(CAST(transaction_timestamp AS time)) 
      OVER( PARTITION BY merchant_id,credit_card_id	,amount) AS next,
    
LEAD(CAST(transaction_timestamp AS time)) 
  OVER( PARTITION BY merchant_id,credit_card_id	,amount)
  -CAST(transaction_timestamp AS time) AS diff
  FROM transactions),
  
cte1 AS
(SELECT *,extract(hour FROM diff)*60 + extract (minute FROM diff) as hhh 
FROM cte)

SELECT count(*)
FROM cte1
Where hhh<=10;

--EX5--

WITH cte AS 
(SELECT user_id, tweet_date, ROUND(cast(tweet_count as decimal),2) as c ,
lag (tweet_count,2) OVER(PARTITION BY user_id ORDER BY tweet_date) as a,
lag(tweet_count,1) OVER(PARTITION BY user_id ORDER BY tweet_date ) as b  
FROM tweets)

SELECT  user_id, tweet_date,
CASE 
  WHEN a IS NULL AND b IS NOT NULL THEN ROUND(cast((c+b)/2 as DECIMAL),2)
  WHEN b IS NULL AND a IS NULL THEN  c
  ELSE ROUND(cast ((c+a+b)/3 as DECIMAL),2)
END AS rolling_avg_3d
FROM cte;

---------------EX 4----------
WITH cte1 AS 
(SELECT transaction_date, user_id, COUNT(product_id) AS a 
  FROM user_transactions
  GROUP BY  user_id,transaction_date),
  
cte2 AS  
(SELECT transaction_date, user_id,a,
        FIRST_VALUE(a) OVER(PARTITION BY user_id ORDER BY transaction_date DESC) AS purchase_count,
        FIRST_VALUE(transaction_date) OVER(PARTITION BY user_id ORDER BY transaction_date DESC )  as ngay           
FROM cte1 
ORDER BY transaction_date)

SELECT DISTINCT cte2.transaction_date, cte2.user_id,purchase_count
FROM cte2
JOIN cte1 ON cte1.user_id=cte2.user_id
WHERE cte1.a=cte2.purchase_count
  AND cte2.ngay= cte2.transaction_date
ORDER BY  cte2.transaction_date;
-------CÁCH 2 

WITH cte AS
(SELECT transaction_date, user_id,COUNT(transaction_date) AS purchase_count,
RANK() OVER(PARTITION BY user_id ORDER BY transaction_date DESC) AS ranking 
FROM user_transactions
GROUP BY user_id,transaction_date
ORDER BY user_id,transaction_date DESC)

SELECT transaction_date, user_id,purchase_count
FROM cte 
WHERE ranking = 1
ORDER BY transaction_date;
  
--EX3--

WITH cte1 AS 
(SELECT user_id, spend, transaction_date, 
        RANK() OVER (PARTITION BY user_id ORDER BY transaction_date) AS ranking 
FROM transactions)

SELECT user_id, spend, transaction_date
FROM cte1
WHERE ranking = 3;

--EX2--

WITH cte1 AS 
(SELECT card_name, issued_amount,
        RANK() OVER(PARTITION BY card_name ORDER BY issue_year, issue_month) AS ranking 
FROM monthly_cards_issued) 

SELECT card_name, issued_amount
FROM cte1
WHERE ranking=1
ORDER BY issued_amount DESC;

--EX1--

WITH cte AS 
(SELECT EXTRACT(YEAR FROM transaction_date) AS year,
        product_id, spend,
        LAG(spend) OVER(PARTITION BY product_id ORDER BY transaction_date) 
        AS prev_year_spend
FROM user_transactions )

SELECT *, ROUND(100*(spend-prev_year_spend)/prev_year_spend,2)
FROM cte;

