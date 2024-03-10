  -- EX1
WITH cte AS (SELECT EXTRACT ( year FROM transaction_date) AS year,
product_id,
spend AS curr_year_spend,
LAG(spend) OVER(PARTITION BY product_id ORDER BY product_id,
EXTRACT (year FROM transaction_date)) AS prev_year_spend
FROM user_transactions) 
SELECT 
year, product_id, curr_year_spend, prev_year_spend, 
ROUND(((curr_year_spend - prev_year_spend) / prev_year_spend )*100,2) AS yoy_rate
FROM cte

  -- EX 2
WITH cte AS (SELECT card_name,
issued_amount,
MAKE_DATE(issue_year, issue_month, 1) AS issue_date,
MIN(MAKE_DATE(issue_year, issue_month, 1)) OVER

  -- EX 3
WITH cte AS ( SELECT 
user_id, 
spend, 
transaction_date, 
ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY transaction_date) AS row_num 
FROM transactions )
SELECT user_id, spend, transaction_date
FROM cte 
WHERE row_num = 3
  
  -- EX 4
WITH cte AS (SELECT user_id, transaction_date, product_id, 
RANK() OVER (PARTITION BY user_id ORDER BY transaction_date DESC ) AS ranking 
FROM user_transactions)
SELECT transaction_date, user_id, 
COUNT(product_id ) AS purchase_count
FROM cte 
WHERE ranking  = 1 
GROUP BY transaction_date, user_id

  -- EX 5
SELECT    
  user_id,    
  tweet_date,   
  ROUND(AVG(tweet_count) OVER (PARTITION BY user_id ORDER BY tweet_date     
  ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS rolling_avg_3d
FROM tweets
  
  -- EX 6
WITH cte AS (SELECT 
transaction_id, merchant_id, credit_card_id, amount, 
transaction_timestamp - LAG(transaction_timestamp) OVER(PARTITION BY merchant_id, credit_card_id, amount ORDER BY  transaction_timestamp ) AS  diff_time
FROM transactions)
SELECT COUNT(*) AS payment_count
FROM  cte
WHERE  diff_time <= '00:10:00'
  
  -- EX 7
WITH bang_xep_hang AS (
SELECT category, product, 
SUM(spend) AS total_spend,
RANK() OVER ( 
PARTITION BY category
ORDER BY SUM(spend) DESC) AS xep_hang
FROM product_spend
WHERE EXTRACT (year FROM transaction_date) = 2022
GROUP BY category, product)
SELECT category, product, total_spend
FROM bang_xep_hang
WHERE xep_hang<=2
ORDER BY category, xep_hang

  -- EX 8
WITH artist_top10 AS (
SELECT
        a.artist_name,
        COUNT(a.artist_name) AS appearance
        FROM global_song_rank AS gsr
        JOIN songs s ON gsr.song_id = s.song_id
        JOIN artists a ON s.artist_id = a.artist_id
    WHERE gsr.rank <= 10
    GROUP BY a.artist_name),
artist_ranking AS (SELECT
artist_name, appearance,
DENSE_RANK() OVER (ORDER BY appearance DESC) AS artist_rank
FROM artist_top10 )
SELECT artist_name, artist_rank
FROM artist_ranking
WHERE artist_rank <= 5
ORDER BY artist_rank
