-- EX 1
SELECT COUNTRY.CONTINENT, 
FLOOR(AVG(CITY.POPULATION))
FROM CITY
JOIN COUNTRY
ON CITY.COUNTRYCODE=COUNTRY.CODE
GROUP BY COUNTRY.CONTINENT
-- EX 2
SELECT 
  ROUND(CAST(COUNT(texts.email_id) AS DECIMAL)
  /COUNT(DISTINCT emails.email_id),2) AS activation_rate
FROM emails
LEFT JOIN texts
  ON emails.email_id = texts.email_id
  AND texts.signup_action = 'Confirmed'
-- EX 3
SELECT age_breakdown.age_bucket,
ROUND(SUM(activities.time_spent) FILTER (WHERE activities.activity_type = 'send') / SUM(activities.time_spent) *100, 2)
AS send_perc, --- = time spent sending / (Time spent sending + Time spent opening)
ROUND (SUM(activities.time_spent) FILTER (WHERE activities.activity_type = 'open') / SUM(activities.time_spent)
 *100 , 2) AS open_perc  --- = time spent opening / (Time spent sending + Time spent opening)
FROM activities
INNER JOIN age_breakdown
ON activities.user_id = age_breakdown.user_id --- chung 2 bang
WHERE activities.activity_type IN ('open', 'send') --- dieu kien loc
GROUP BY age_breakdown.age_bucket --- cot chinh
--- EX 4
SELECT customer_contracts.customer_id
FROM customer_contracts
INNER JOIN products
ON customer_contracts.product_id = products.product_id
GROUP BY customer_contracts.customer_id
HAVING COUNT(DISTINCT product_category) = 
  (SELECT COUNT(DISTINCT product_category) FROM products)
--- EX 5 - SELF JOIN
SELECT E1.employee_id, E1.name,
COUNT(E2.employee_id) AS reports_count,
ROUND(AVG(E2.age)) AS average_age
FROM Employees E1 JOIN Employees E2 ON E1.employee_id = E2.reports_to
GROUP BY E1.employee_id, E1.name
ORDER BY employee_id
--- EX 6
#it nhat 100 don vi duoc dat hang trong thang 2 2020
SELECT Products.product_name, SUM(orders.unit) AS unit
FROM Products
JOIN Orders
ON Products.product_id=Orders.product_id
WHERE month(order_date)='02' AND year(order_date)='2020'
GROUP BY Products.product_id
HAVING SUM(orders.unit) >=100
--- EX 7
SELECT pages.page_id
FROM pages
LEFT JOIN page_likes 
ON pages.page_id = page_likes.page_id
WHERE  page_likes.page_id IS NULL
GROUP BY pages.page_id
ORDER BY pages.page_id

---
-- BÀI 1
SELECT DISTINCT MIN (replacement_cost) FROM film
-- BÀI 2
SELECT 
    CASE 
        WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 'low' 
        WHEN replacement_cost BETWEEN 20.00 AND 24.99 THEN 'medium' 
        WHEN replacement_cost >= 25.00 THEN 'high' 
    END AS cost_range, 
    COUNT(*) AS so_luong
FROM film
WHERE replacement_cost BETWEEN 9.99 AND 19.99
GROUP BY cost_range 
ORDER BY cost_range
-- BÀI 3
SELECT a.title, a.length, c.name
FROM film AS a
JOIN film_category AS b ON a.film_id = b.film_id
JOIN category AS c ON b.category_id = c.category_id
WHERE c.name IN ('Drama', 'Sports')
GROUP BY a.title, c.name, a.length
ORDER BY a.length DESC
LIMIT 1
-- BÀI 4

