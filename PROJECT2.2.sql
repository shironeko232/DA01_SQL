CREATE VIEW bigquery-public-data.thelook_ecommerce.vw_ecommerce_analyst AS
WITH bang1 AS (
SELECT
FORMAT_DATE('%Y-%m', DATE (a.created_at)) AS month_year, 
EXTRACT (YEAR FROM a.created_at) AS year,
c.category AS product_category, (SUM (b.sale_price) - SUM (c.cost)) AS TPV,
COUNT (a.order_id) AS TPO, SUM (c.cost) AS total_cost,
((SUM (b.sale_price) - SUM (c.cost)) - SUM (c.cost)) AS total_profit
FROM bigquery-public-data.thelook_ecommerce.orders AS a
JOIN bigquery-public-data.thelook_ecommerce.order_items AS b
ON a.order_id=b.order_id
JOIN bigquery-public-data.thelook_ecommerce.products AS c
ON b.product_id=c.id
GROUP BY FORMAT_DATE('%Y-%m', DATE (a.created_at)), c.category, EXTRACT (YEAR FROM a.created_at))
SELECT month_year, year, product_category, TPV, TPO,
100*(TPV - LAG (TPV) OVER (PARTITION BY product_category ORDER BY month_year ASC))/(TPV + LAG (TPV) OVER (PARTITION BY product_category ORDER BY month_year ASC)) ||'%' AS revenue_growth,
100*(TPO - LAG (TPO) OVER (PARTITION BY product_category ORDER BY month_year ASC))/(TPO + LAG (TPO) OVER (PARTITION BY product_category ORDER BY month_year ASC)) ||'%' AS order_growth,
total_cost, total_profit, total_profit/cte1.total_cost AS profit_to_cost_ratio
FROM bang1,

--- Bảng Cohort
WITH bang2 AS (
SELECT user_id,sale_price,
FORMAT_DATE('%Y-%m', DATE (first_puchase_date)) as chd,
created_at,
(extract(year from created_at)-extract(year from first_puchase_date))*12
+ (extract(month from created_at)-extract(month from first_puchase_date))+ 1 as index
FROM
(SELECT user_id,sale_price,
MIN(created_at) OVER (PARTITION BY user_id) as first_puchase_date,
created_at
FROM bigquery-public-data.thelook_ecommerce.order_items
WHERE status ='Complete'
))
,bang3 AS (
SELECT chd, index,
COUNT(DISTINCT user_id) as cnt,
SUM (sale_price) as revenue
FROM bang2
WHERE index <=4
GROUP BY 1,2
ORDER BY chd)
,customer_cohort AS (
SELECT chd,
SUM(case when index = 1 then cnt else 0 end) as t1,
SUM(case when index = 2 then cnt else 0 end) as t2,
SUM(case when index = 3 then cnt else 0 end) as t3,
SUM(case when index = 4 then cnt else 0 end) as t4
FROM bang3
GROUP BY chd
ORDER BY chd
)
--retention cohort
, retention_cohort AS (
SELECT chd,
ROUND(100.00* t1/t1,2)||'%' t1,
ROUND(100.00* t2/t1,2)||'%' t2,
ROUND(100.00* t3/t1,2)||'%' t3,
ROUND(100.00* t4/t1,2)||'%' t4
FROM customer_cohort)
--churn cohort
SELECT chd,
(100-ROUND(100.00* t1/t1,2))||'%' t1,
(100-ROUND(100.00* t2/t1,2))||'%' t2,
(100-ROUND(100.00* t3/t1,2))||'%' t3,
(100-ROUND(100.00* t4/t1,2))||'%' t4
FROM customer_cohort


--- em vẫn là dựa vào phần solution, em đã hiểu cách là và nên làm như thế nào ạ, dù bài này sẽ giống phần solution nhưng vẫn mong anh/chị duyệt ạ, bài sau em sẽ cố gắng nhiều hơn nữa, em cảm ơn anh/chị ạ !
--- bài này em nộp muộn nhiều nhưng do em trùng lịch thi kết thúc học phần nên ph hoãn lại chút chút, giờ em làm đều hơn vào những buổi cuối ạ !
