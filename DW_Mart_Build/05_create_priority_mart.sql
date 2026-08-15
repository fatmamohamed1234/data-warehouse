-- step 5: Mart - create priority rules mart

DROP SCHEMA IF EXISTS priority_mart CASCADE;


CREATE SCHEMA priority_mart;


CREATE TABLE priority_mart.priority_roles (
    role_id             INT PRIMARY KEY,
    role_name           VARCHAR,
    priority_lvl        INT
);

INSERT INTO priority_mart.priority_roles (role_id, role_name, priority_lvl)
values
    (1, 'Data Engineer', 2),
    (2, 'senior Data Engineer', 1),
    (3, 'software Engineer', 3);



select * from priority_mart.priority_roles;

-- Step 3: Create priority jobs snapshot table
-- This table contains a snapshot of jobs with their priority levels
SELECT '=== loading Snapshot for priority mart ====' AS info;
CREATE OR REPLACE TABLE priority_mart.priority_jobs_snapshot (                      -- updated to use priority_mart schema
  job_id              INTEGER PRIMARY KEY,
  job_title_short     VARCHAR,
  company_name        VARCHAR,
  job_posted_date     TIMESTAMP,
  salary_year_avg     DOUBLE,
  priority_lvl        INTEGER,
  updated_at          TIMESTAMP
);

INSERT INTO priority_mart.priority_jobs_snapshot (                                   -- updated to use priority_mart schema
  job_id,
  job_title_short,
  company_name,
  job_posted_date,
  salary_year_avg,
  priority_lvl,
  updated_at
)
SELECT 
  jpf.job_id,
  jpf.job_title_short,
  cd.name AS company_name,
  jpf.job_posted_date,
  jpf.salary_year_avg,
  r.priority_lvl,
  CURRENT_TIMESTAMP
FROM
    job_posting_fact AS jpf                  -- updated to use main schema
LEFT JOIN company_dim AS cd                   -- updated to use main schema
    ON jpf.company_id = cd.company_id
INNER JOIN priority_mart.priority_roles AS r       -- updated to use priority_mart schema
    ON jpf.job_title_short = r.role_name;

-- Verify mart was created
SELECT 'Priority Roles Dimension' AS table_name, COUNT(*) as record_count FROM priority_mart.priority_roles
UNION ALL
SELECT 'Priority Jobs Snapshot', COUNT(*) FROM priority_mart.priority_jobs_snapshot;

-- Show sample data from each table
SELECT '=== Priority Roles Dimension Sample ===' AS info;
SELECT * FROM priority_mart.priority_roles;

SELECT '=== Priority Jobs Snapshot Sample ===' AS info;
SELECT 
    job_title_short,
    COUNT(*) AS job_count,
    MIN(priority_lvl) AS priority_lvl,
    MIN(updated_at) AS updated_at
FROM priority_mart.priority_jobs_snapshot         
 -- updated to use priority_mart schema
GROUP BY job_title_short
ORDER BY job_count DESC;