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
