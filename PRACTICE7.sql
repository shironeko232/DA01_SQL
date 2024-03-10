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
MIN(MAKE_DATE(issue_year, issue_month, 1)) OVERạ
 
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
