  --- Thống kê tổng số lượng người mua và số lượng đơn hàng đã hoàn thành mỗi tháng ( Từ 1/2019-4/2022)
WITH bang1 AS (SELECT
FORMAT_DATE('%Y-%m', DATE(created_at)) AS month_year,
COUNT(distinct user_id) AS  total_user, 
COUNT(order_id) AS total_order
FROM bigquery-public-data.thelook_ecommerce.orders
WHERE FORMAT_DATE('%Y-%m', DATE (created_at)) BETWEEN '2019-01' AND '2022-04'
AND status ='Complete'
GROUP BY 1
ORDER BY month_year),

  --- Giá trị đơn hàng trung bình (AOV) và số lượng khách hàng mỗi tháng
bang2 AS (SELECT 
FORMAT_DATE('%Y-%m', DATE(created_at)) AS month_year,
COUNT(distinct user_id) AS distinct_users, 
ROUND(AVG(sale_price),2) AS average_order_value
FROM bigquery-public-data.thelook_ecommerce.order_items
WHERE FORMAT_DATE('%Y-%m', DATE (created_at)) BETWEEN '2019-01' AND '2022-04'
GROUP BY 1
ORDER BY month_year),

  --- Khách hàng trẻ tuổi nhất và lớn tuổi nhất theo từng giới 
bang3 AS
(SELECT first_name, last_name, gender, age,
(CASE 
  WHEN age = (SELECT MIN(age) FROM bigquery-public-data.thelook_ecommerce.users) THEN 'youngest' END) AS tag FROM bigquery-public-data.thelook_ecommerce.users
UNION ALL
SELECT first_name, last_name, gender, age,
(CASE 
  WHEN age = (SELECT MAX(age) FROM bigquery-public-data.thelook_ecommerce.users)THEN 'oldest' END) AS tag FROM bigquery-public-data.thelook_ecommerce.users)

SELECT gender,age,tag, COUNT(*)
 FROM bang3 
 GROUP BY gender, age, tag

  --- Top 5 sản phẩm mỗi tháng
WITH bang4 AS 
(SELECT 
FORMAT_DATE('%Y-%m', DATE(a.created_at)) AS month_year,
a.product_id,b.name AS product_name,
SUM (a.sale_price) AS sales,
SUM (b.cost) AS cost,
SUM (a.sale_price)- SUM (b.cost) AS profit,
FROM bigquery-public-data.thelook_ecommerce.order_items AS a 
JOIN bigquery-public-data.thelook_ecommerce.products AS b
ON a.id = b.id
where DATE(created_at) BETWEEN '2019-01-01' AND '2022-04-30'
group by 1,2,3)

  -- xếp hạng 
SELECT * from 
(SELECT month_year, product_id, product_name, sales, cost, profit,
DENSE_RANK() OVER(PARTITION BY  month_year ORDER BY  profit DESC) AS rank_per_month 
FROM bang4
ORDER BY month_year) AS xephang
WHERE rank_per_month <=5

  --- Doanh thu
SELECT  
DATE(created_at),
b.category AS product_categories,
SUM (a.sale_price) AS revenue,
FROM bigquery-public-data.thelook_ecommerce.order_items AS a 
JOIN bigquery-public-data.thelook_ecommerce.products AS b
ON a.id = b.id
WHERE DATE(created_at) BETWEEN '2022-02-15' AND '2022-04-15'
GROUP BY 1,2
ORDER BY 1 DESC 
