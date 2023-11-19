---EX8

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

--EX7

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

--EX6

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

--EX5

WITH cte AS 
(SELECT user_id, tweet_date, tweet_count as c ,
lag (tweet_count,2) OVER(PARTITION BY user_id ORDER BY tweet_date) as a,
lag(tweet_count,1) OVER(PARTITION BY user_id ORDER BY tweet_date ) as b  
FROM tweets)

SELECT *,
CASE 
  WHEN a IS NULL THEN ROUND(CAST((c+b)/2 AS DECIMAL),2)
  WHEN b IS NULL AND a IS NULL THEN  c
  ELSE ROUND(cast ((c+a+b)/3 as DECIMAL),2)
END AS rolling_avg_3d
FROM cte;

--EX 4

SELECT transaction_date, user_id,COUNT(transaction_date) AS purchase_count
FROM
(SELECT * ,
RANK() OVER(PARTITION BY user_id
ORDER BY transaction_date DESC) AS ranking 
FROM user_transactions
ORDER BY user_id,transaction_date DESC) AS a  

WHERE ranking = 1
GROUP BY user_id,transaction_date
ORDER BY transaction_date


--EX3

WITH cte1 AS 
(SELECT user_id, spend, transaction_date, 
        RANK() OVER (PARTITION BY user_id ORDER BY transaction_date) AS ranking 
FROM transactions)

SELECT user_id, spend, transaction_date
FROM cte1
WHERE ranking = 3;

--EX2

WITH cte1 AS 
(SELECT card_name, issued_amount,
RANK() OVER(PARTITION BY card_name ORDER BY issue_year, issue_month) AS ranking 
FROM monthly_cards_issued) 

SELECT card_name, issued_amount
FROM cte1
WHERE ranking=1
ORDER BY issued_amount DESC;
-- 
