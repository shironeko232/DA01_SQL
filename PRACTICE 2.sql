  -- EX1
SELECT DISTINCT city FROM station
WHERE id%2=0

  -- EX2
SELECT COUNT(city) - COUNT(DISTINCT city) FROM station
  -- EX3
DE SAU
  
  -- EX4
SELECT 
ROUND(CAST (SUM (ITEM_COUNT * ORDER_OCCURRENCES) / SUM(ORDER_OCCURRENCES) AS DECIMAL),1)
AS MEAN
FROM ITEMS_PER_ORDER

  -- EX 5
SELECT candidate_id FROM candidates
WHERE skill IN ('Python', 'Tableau', 'PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(skill) = 3

  -- EX 6
SELECT user_id,
DATE(MAX(post_date)) - DATE(MIN(post_date)) AS days_between
FROM posts
WHERE post_date >= '2021-01-01' AND post_date <= '2022-01-01'
GROUP BY user_id
HAVING COUNT(post_id) >= 2

  -- EX 7
SELECT card_name,
MAX(issued_amount) - MIN(issued_amount) AS difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY card_name DESC

  -- EX 8
SELECT manufacturer, 
COUNT(drug) AS drug_count,
ABS(SUM(cogs - total_sales)) AS total_loss
FROM pharmacy_sales
WHERE total_sales < cogs
GROUP BY manufacturer
ORDER BY total_loss DESC

  -- EX 9
SELECT * FROM cinema
WHERE id%2=1 AND description<>'boring'
ORDER BY rating DESC

  -- EX 10
SELECT teacher_id,
COUNT(DISTINCT(subject_id)) AS cnt 
FROM teacher
GROUP BY teacher_id

  -- EX 11
SELECT user_id,
COUNT(follower_id) AS followers_count
FROM followers
GROUP BY user_id
ORDER BY user_id ASC

  -- EX 12
SELECT class FROM courses
GROUP BY class
HAVING COUNT(class) >=5
