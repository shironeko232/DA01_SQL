--- EX 1
SELECT name FROM city
WHERE countrycode="USA" AND population>120000

--- EX2
SELECT * FROM city
WHERE countrycode="JPN"

--- EX 3
SELECT city, state FROM station

--- EX 4
SELECT DISTINCT city FROM station 
WHERE city LIKE 'a%' OR city LIKE 'e%' OR city LIKE 'i%' OR city LIKE 'o%' OR city LIKE 'u%'

--- EX 5
SELECT DISTINCT city FROM station 
WHERE city LIKE '%a' OR city LIKE '%e' OR city LIKE '%i' OR city LIKE '%o' OR city LIKE '%u'

--- EX 6
SELECT DISTINCT city FROM station 
WHERE city NOT LIKE 'a%' AND city NOT LIKE 'e%' AND city NOT LIKE 'i%' AND city NOT LIKE 'o%' AND city NOT LIKE 'u%'

--- EX 7
SELECT name FROM employee
ORDER BY name ASC

--- EX 8
SELECT name FROM employee
WHERE months<10 AND salary>2000
ORDER BY employee_id ASC

--- EX 9
SELECT product_id FROM products
WHERE low_fats = 'Y' AND recyclable = 'Y'

--- EX 10
SELECT name FROM Customer 
WHERE referee_id IS NULL OR referee_id != 2

--- EX 11
SELECT name, population, area FROM world
WHERE area >= 3000000 OR population >= 25000000

--- EX 12
SELECT DISTINCT author_id AS id FROM views
WHERE author_id > 3
ORDER BY author_id ASC

--- EX 13
SELECT part, assembly_step FROM parts_assembly
WHERE finish_date IS NULL

--- EX 14
select * from lyft_drivers
WHERE yearly_salary <= 30000
OR yearly_salary >= 70000 

--- EX 15
select * from uber_advertising
WHERE money_spent > 100000 AND year = 2019
