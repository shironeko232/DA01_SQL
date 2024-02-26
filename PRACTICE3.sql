  -- EX 1
SELECT NAME FROM STUDENTS
WHERE MARKS>75
ORDER BY RIGHT(NAME,3), ID ASC

  -- EX 2
SELECT 
user_id, 
CONCAT(UPPER(SUBSTRING(name, 1, 1)),
LOWER(SUBSTRING(name, 2, LENGTH(name)))) AS name
FROM Users
ORDER BY user_id

  -- EX 3
SELECT MANUFACTURER,
'$' || ROUND(SUM(TOTAL_SALES)/1000000) || ' ' || 'million' AS SALE
FROM pharmacy_sales
GROUP BY MANUFACTURER
ORDER BY SUM(TOTAL_SALES) DESC, MANUFACTURER

  -- EX 4
SELECT 
EXTRACT(month FROM submit_date) AS mth,
product_id,
ROUND(AVG(stars),2) AS avg_stars
FROM reviews
GROUP BY mth, product_id
ORDER BY mth, product_id

  -- EX 5
SELECT 
sender_id,
COUNT(message_id) AS message_count
FROM messages
WHERE EXTRACT(month FROM sent_date)=8 AND EXTRACT(year FROM sent_date)=2022
GROUP BY sender_id
ORDER BY message_count DESC
LIMIT 2

  -- EX 6
SELECT tweet_id FROM Tweets
WHERE LENGTH(content) > 15

  -- EX 7
SELECT 
DATE(activity_date) AS day, 
COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE activity_date >= '2019-06-28' AND activity_date <= '2019-07-27'
GROUP BY DATE(activity_date)
ORDER BY DATE(activity_date)

  -- EX 8
select 
COUNT(id) AS number_employees
from employees
WHERE EXTRACT(month FROM joining_date) BETWEEN 1 AND 7
AND EXTRACT(year FROM joining_date)=2022

  -- EX 9
select
POSITION ('a'IN first_name) AS ' vị trí '
from worker
WHERE first_name = ' Amitah '

  -- EX 10
select 
SUBSTRING (title, length(winery)+2, 4)
from winemag_p2
WHERE country = ' Macedonia '
