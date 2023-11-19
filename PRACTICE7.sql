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

--EX 4

WITH cte1 AS
(SELECT transaction_date, 
user_id, COUNT(product_id) AS a 
FROM user_transactions
GROUP BY user_id,transaction_date)

SELECT cte1.transaction_date, cte1.user_id,
FIRST_VALUE(cte1.a) OVER(PARTITION BY cte1.transaction_date,cte1.user_id 
ORDER BY cte1.transaction_date DESC)
      AS purchase_count 
FROM cte1
ORDER BY cte1.transaction_date


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





  
SELECT transaction_date, user_id, purchase_count
FROM (
SELECT *, FIRST_VALUE(purchase_count ) OVER(PARTITION BY user_id 
ORDER BY transaction_date DESC) AS ranking  
FROM cte1
ORDER BY user_id,transaction_date DESC) AS g 

ORDER BY transaction_date



--------------------------------

WITH cte1 AS 
( SELECT transaction_date, user_id, COUNT(product_id) AS a 
  FROM user_transactions
  GROUP BY  user_id,transaction_date)
SELECT transaction_date, user_id,
FIRST_VALUE(a) OVER(PARTITION BY user_id 
ORDER BY transaction_date DESC) AS   purchase_count
FROM cte1 
ORDER BY transaction_date;

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
