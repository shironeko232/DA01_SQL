  -- EX 1
SELECT 
SUM(CASE 
  WHEN DEVICE_TYPE = 'laptop' THEN 1 ELSE 0 
END) AS laptop_reviews,
SUM(CASE 
  WHEN DEVICE_TYPE IN ('tablet', 'phone') THEN 1 ELSE 0 
END) AS mobile_views
FROM viewership;
  
  -- EX 2
SELECT *,
    CASE 
    WHEN x + y <= z OR x + z <= y OR y + z <= x  THEN 'No' ELSE 'Yes'
    END AS triangle
FROM Triangle

  -- EX 3 ( SAI )
SELECT 
    ROUND((
            COUNT(CASE WHEN call_category IS NULL OR call_category = 'n/a' THEN 1 END)
            /
            COUNT(*)) * 100,1) AS call_percentage
FROM callers

  -- EX 4 ( da duoc lam )
SELECT name FROM Customer 
WHERE referee_id IS NULL OR referee_id != 2

  -- EX 5
select survived,
    SUM(CASE WHEN pclass = 1 THEN 1 ELSE 0 END) AS first_class,
    SUM(CASE WHEN pclass = 2 THEN 1 ELSE 0 END) AS second_class,
    SUM(CASE WHEN pclass = 3 THEN 1 ELSE 0 END) AS third_class
from titanic
GROUP BY survived
