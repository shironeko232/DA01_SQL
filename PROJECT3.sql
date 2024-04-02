  -- 1) Doanh thu theo từng ProductLine, Year  và DealSize?
SELECT 
  PRODUCTLINE, YEAR_ID, DEALSIZE,
  SUM(sales) AS REVENUE
FROM public.sales_dataset_rfm_prj
GROUP BY PRODUCTLINE, YEAR_ID, DEALSIZE
ORDER BY PRODUCTLINE
-- 2) Đâu là tháng có bán tốt nhất mỗi năm?
SELECT
  month_id,
  MAX(SUM(sales)) OVER (PARTITION BY month_id) AS REVENUE, 
COUNT(ordernumber)
FROM public.sales_dataset_rfm_prj
GROUP BY month_id
GROUP BY month_id
-- 3) Product line nào được bán nhiều ở tháng 11?
WITH bang1 AS (
SELECT  
  month_id,
  year_id,
  SUM(sales) AS REVENUE,
  productline,
  ordernumber
FROM public.sales_dataset_rfm_prj
WHERE month_id = 11
GROUP BY month_id, 
          year_id, 
      productline, 
      ordernumber),
bangxephang AS (
SELECT
  month_id,
  year_id,
  productline,
  ROW_NUMBER() OVER (PARTITION BY year_id ORDER BY REVENUE DESC) AS product_rank,
  REVENUE,
  ordernumber
FROM bang1)
SELECT
  month_id,
  year_id,
  REVENUE,
  ordernumber,
  productline
FROM bangxephang
WHERE product_rank = 1
-- 4) Đâu là sản phẩm có doanh thu tốt nhất ở UK mỗi năm? 
WITH UK AS (
SELECT  
  year_id,
  productline,
  SUM(sales) AS REVENUE,
  ROW_NUMBER() OVER (PARTITION BY year_id ORDER BY SUM(sales) DESC) AS rank_by_revenue
FROM public.sales_dataset_rfm_prj
WHERE country = 'UK'
GROUP BY year_id, productline)
SELECT 
  year_id,
  productline,
  REVENUE,
	ROW_NUMBER() OVER (ORDER BY year_id DESC) as rank
FROM UK
WHERE rank_by_revenue = 1
LIMIT 1
-- 5) Ai là khách hàng tốt nhất, phân tích dựa vào RFM
  -- tính RFM
WITH RFM AS (
SELECT
customername,
current_date - MAX(orderdate) AS R,
COUNT(DISTINCT ordernumber) AS F,
SUM(sales) AS M
FROM public.sales_dataset_rfm_prj
GROUP BY customername),
  -- chia khoảng theo thang 1-5
RFM_SCORE AS (
SELECT 
customername,
ntile(5) OVER(ORDER BY R DESC) AS R_SCORE,
ntile(5) OVER(ORDER BY F DESC) AS F_SCORE,
ntile(5) OVER(ORDER BY M DESC) AS M_SCORE
from RFM),
  -- Kết quả
KETQUA as (
SELECT 
customername,
CAST(R_SCORE AS VARCHAR) || CAST(F_SCORE AS VARCHAR) || CAST(M_SCORE AS VARCHAR) AS RFM_SCORE
FROM RFM_SCORE)
,
customer_segment AS (
SELECT 
a.customername,
b.segment
FROM KETQUA AS a
JOIN segment_score b 
ON a.rfm_score=b.scores)
SELECT * FROM customer_segment
WHERE segment = 'Champions'
