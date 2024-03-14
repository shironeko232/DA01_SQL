-- 1 định dạng dữ liệu
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN ordernumber TYPE integer USING (trim(ordernumber)::integer),
ALTER COLUMN quantityordered TYPE integer USING (trim(quantityordered)::integer),
ALTER COLUMN priceeach TYPE float USING (trim(priceeach)::float),
ALTER COLUMN orderlinenumber TYPE integer USING (trim(orderlinenumber)::integer),
ALTER COLUMN sales TYPE float USING (trim(sales)::float),
ALTER COLUMN msrp TYPE integer USING (trim(msrp)::integer);
SET datestyle = 'iso,mdy';  
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN orderdate TYPE date USING (TRIM(orderdate):: date);
-- 2 check dữ liệu
SELECT
CASE
    WHEN ordernumber IS NULL THEN 'Blank' ELSE 'Not Blank'
END,
CASE
    WHEN quantityordered IS NULL THEN 'Blank' ELSE 'Not Blank'
END,
CASE
    WHEN priceeach IS NULL  THEN 'Blank' ELSE 'Not Blank'
END,
CASE
    WHEN orderlinenumber IS NULL THEN 'Blank' ELSE 'Not Blank'
END,
CASE
    WHEN sales IS NULL THEN 'Blank' ELSE 'Not Blank'
END,
CASE
    WHEN orderdate IS NULL THEN 'Blank' ELSE 'Not Blank'
END
FROM sales_dataset_rfm_prj;
-- 3 thêm cột contactlastname, contactfirstname và thêm dữ liệu từ contactfullname
ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN contactlastname VARCHAR(255) ,
ADD COLUMN contactfirstname VARCHAR(255);
UPDATE sales_dataset_rfm_prj
SET contactlastname = UPPER(LEFT(SUBSTRING(contactfullname FROM 1 FOR POSITION('-' IN contactfullname)-1),1)) || LOWER(SUBSTRING(contactlastname FROM 2 FOR length(contactlastname)-1 )),
	contactfirstname = UPPER(LEFT(SUBSTRING(contactfullname FROM POSITION('-' IN contactfullname)+1 FOR POSITION('-' IN contactfullname)+2),1)) || LOWER(SUBSTRING(contactfirstname FROM 2 FOR Length(contactfirstname)-1));
-- 4 thêm cột QTR_ID, MONTH_ID, YEAR_ID và thêm dữ liệu từ orderdate
ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN QTR_ID integer ,
ADD COLUMN MONTH_ID integer,
ADD COLUMN YEAR_ID integer ;
UPDATE sales_dataset_rfm_prj
SET QTR_ID = EXTRACT(quarter FROM orderdate),
	MONTH_ID = EXTRACT (month FROM orderdate),
	YEAR_ID = EXTRACT (year FROM orderdate);
-- 5 tìm outlier
-- Cách 1
WITH min_max_per AS (
SELECT 
Q1-1.5*IQR AS MIN_value,
Q3+1.5*IQR AS MAX_value
FROM (
SELECT 
percentile_cont (0.25) WITHIN GROUP(ORDER BY quantityordered) AS Q1,
percentile_cont (0.75) WITHIN GROUP(ORDER BY quantityordered) AS Q3,
percentile_cont (0.75) WITHIN GROUP(ORDER BY quantityordered) - percentile_cont(0.25) WITHIN GROUP (ORDER BY quantityordered) AS IQR
FROM sales_dataset_rfm_prj) AS percont ) ;
SELECT * FROM sales_dataset_rfm_prj
WHERE quantityordered < (SELECT MIN_value FROM min_max_per) 
OR quantityordered > (SELECT MAX_value FROM min_max_per);
-- Cách 2
SELECT AVG(quantityordered),
STDDEV(quantityordered)
FROM sales_dataset_rfm_prj

WITH bienchay AS (
SELECT quantityordered,
(SELECT SELECT AVG(quantityordered) AS AVG FROM sales_dataset_rfm_prj),
(SELECT STDDEV(quantityordered) AS STDDEV FROM sales_dataset_rfm_prj)
FROM sales_dataset_rfm_prj);

SELECT quantityordered,
(quantityordered- AVG)/STDDEV AS z_score FROM bienchay
WHERE ABS((quantityordered- AVG)/STDDEV)>10;
