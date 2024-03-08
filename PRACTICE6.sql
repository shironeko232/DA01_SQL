  -- EX 1
WITH ds_trung_lap AS (
  SELECT company_id
  FROM job_listings AS jl1
  WHERE EXISTS (
    SELECT 1
    FROM job_listings AS jl2
    WHERE jl1.company_id = jl2.company_id
      AND jl1.title = jl2.title
      AND jl1.description = jl2.description
      AND jl1.id <> jl2.id )
  GROUP BY company_id
  HAVING COUNT(title) > 1 )
SELECT COUNT(*)
FROM ds_trung_lap;
  -- EX 2
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

  -- EX 3
WITH so_luong_cuoc_goi AS (
SELECT case_id, COUNT(DISTINCT call_received)
FROM callers
GROUP BY case_id )
SELECT COUNT (*)
FROM so_luong_cuoc_goi

  -- EX 4
SELECT pages.page_id
FROM pages
WHERE NOT EXISTS (
  SELECT page_id
  FROM page_likes AS likes
  WHERE likes.page_id = pages.page_id)

  -- EX 5
SELECT 
  EXTRACT (month FROM thangnay.event_date) AS month,
  COUNT(DISTINCT thangnay.user_id) AS monthly_active_users
FROM user_actions AS thangnay -- phần đếm số người dùng tháng này
WHERE EXISTS ( --- Lọc dữ liệu theo điều kiện
  SELECT thangtruoc.user_id
  FROM user_actions AS thangtruoc
  WHERE thangtruoc.user_id = thangnay.user_id --- id của người dùng tháng trước và tháng này giống nhau
  AND EXTRACT (month FROM thangtruoc.event_date) = EXTRACT (month FROM thangnay.event_date - interval '1 month')
  )
  AND EXTRACT (month FROM thangnay.event_date) = 7
  AND EXTRACT (year FROM thangnay.event_date ) = 2022
  --- điều kiện tháng 7 năm 20222022
  GROUP BY EXTRACT (month FROM thangnay.event_date) 

  -- EX 6
SELECT 
DATE_FORMAT(trans_date, '%Y-%m') AS month ,
country,
COUNT(*) AS trans_count,
SUM(CASE WHEN state = 'approved' THEN 1 ELSE 0 END) as approved_count,
SUM(amount) AS trans_total_amount,
SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) as approved_total_amount
FROM Transactions AS trans
GROUP BY month, country
ORDER BY month

  -- EX 7
SELECT 
    s.product_id,
    s.year AS first_year,
    s.quantity,
    s.price
FROM Sales AS s
JOIN 
    (SELECT 
        product_id,
        MIN(year) AS first_year
    FROM Sales
    GROUP BY product_id) AS pr
ON s.product_id = pr.product_id AND s.year = pr.first_year

  -- EX 8
SELECT cus.customer_id
FROM Customer AS cus
JOIN Product AS pr
ON cus.product_key = pr.product_key 
GROUP BY cus.customer_id
HAVING COUNT(DISTINCT cus.product_key) = (SELECT COUNT(DISTINCT product_key) FROM Product)

  -- EX 9
SELECT employee_id
FROM Employees
WHERE salary < 30000
AND manager_id NOT IN (
    SELECT employee_id
    FROM Employees)
ORDER BY employee_id

  -- EX 10
WITH ds_trung_lap AS (
  SELECT company_id
  FROM job_listings AS jl1
  WHERE EXISTS (
    SELECT 1
    FROM job_listings AS jl2
    WHERE jl1.company_id = jl2.company_id
      AND jl1.title = jl2.title
      AND jl1.description = jl2.description
      AND jl1.id <> jl2.id )
  GROUP BY company_id
  HAVING COUNT(title) > 1 )
SELECT COUNT(*)
FROM ds_trung_lap

  -- EX 11
WITH noi_bang AS (
    SELECT mr.*, u.name, m.title
    FROM MovieRating AS mr
    JOIN Users AS u ON mr.user_id = u.user_id
    JOIN Movies AS m ON mr.movie_id = m.movie_id )
(SELECT name AS results
FROM noi_bang
GROUP BY name
ORDER BY COUNT(*) DESC, name
LIMIT 1)
UNION ALL
(SELECT title
FROM noi_bang
WHERE DATE_FORMAT(created_at, "%Y-%m") = "2020-02"
GROUP BY title
ORDER BY AVG(rating) DESC, title
LIMIT 1)

  -- EX 12
SELECT 
    requester_id AS id, 
    COUNT(*) AS num
FROM (SELECT requester_id FROM RequestAccepted
    UNION ALL 
    SELECT accepter_id FROM RequestAccepted ) AS friend_request
GROUP BY id 
ORDER BY num DESC 
LIMIT 1


