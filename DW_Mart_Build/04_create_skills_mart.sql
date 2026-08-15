--step 4: create skills demand mart
DROP SCHEMA IF EXISTS skills_mart CASCADE;

CREATE SCHeMA skills_mart;


SELECT '=== loadind data dim for skills mart ====' AS info;
CREATE TABLE skills_mart.dim_skills (
     skill_id     INT PRIMARY KEY,
     skill        VARCHAR,
     type         VARCHAR
);

INSERT INTO skills_mart.dim_skills (skill_id, skill, type)

SELECT
    skill_id,
    skill,
    type
FROM skill_dim;
SELECT '===loading Date dim for skills mart ====' AS info;

CREATE TABLE skills_mart.dim_date_month (
    month_start_date DATE PRIMARY KEY,
    year              INT,
    month             INT,
    quarter           INT,
    quarter_name      VARCHAR,
    year_quarter      VARCHAR
);

INSERT INTO skills_mart.dim_date_month (
    month_start_date,
     year, 
     month, 
     quarter, 
     quarter_name, 
     year_quarter
)

SELECT DISTINCT
DATE_TRUNC('month', job_posted_date) AS month_start_date,
EXTRACT(year FROM job_posted_date) AS year,
EXTRACT(month FROM job_posted_date) AS month,
EXTRACT(QUARTER FROM job_posted_date) AS quarter,
'Q-' || EXTRACT(QUARTER FROM job_posted_date)::VARCHAR AS quarter_name,
EXTRACT(year FROM job_posted_date)::VARCHAR || '-Q' ||
EXTRACT(QUARTER FROM job_posted_date)::VARCHAR AS year_quarter

FROM job_posting_fact
ORDER BY month_start_date;

SELECT '===loading Skill Fact for skills mart ====' AS info;
CREATE TABLE skills_mart.fact_skills_demand_monthly (
    skill_id                         INT,
    month_start_date                DATE,
    job_title_short              VARCHAR,
    postings_count                   INT,
    remote_posting_count             INT,
    no_degree_mention_postings_count INT,
    health_insurance_postings_count  INT,
    PRIMARY KEY (skill_id, month_start_date, job_title_short),
    FOREIGN KEY (skill_id) REFERENCES skills_mart.dim_skills(skill_id),
    FOREIGN KEY (month_start_date) REFERENCES skills_mart.dim_date_month(month_start_date)
);
INSERT INTO skills_mart.fact_skills_demand_monthly (
    skill_id,
    month_start_date,
    job_title_short,
    postings_count,
    remote_posting_count,
    no_degree_mention_postings_count,
    health_insurance_postings_count
)

WITH job_postings_prep AS (
  SELECT
    sjd.skill_id,
    Date_TRUNC('month', jpf.job_posted_date) AS month_start_date,
    jpf.job_title_short,
    -- convert boolean flags (1 or 0)
    CASE WHEN jpf.job_work_from_home = TRUE THEN 1 ELSE 0 END AS is_remote,
    CASE WHEN jpf.job_no_degree_mention = TRUE THEN 1 ELSE 0 END AS no_degree_required,
    CASE WHEN jpf.job_health_insurance = TRUE THEN 1 ELSE 0 END AS has_health_insurance
FROM
    job_posting_fact AS jpf
INNER JOIN
    skill_job_dim AS sjd
    ON jpf.job_id = sjd.job_id

)

SELECT

    skill_id,
    month_start_date,
    job_title_short,
    COUNT(*) AS postings_count,
    SUM(is_remote) AS remote_posting_count,
    SUM(no_degree_required) AS no_degree_mention_postings_count,
    SUM(has_health_insurance) AS health_insurance_postings_count
from
  job_postings_prep
GROUP BY ALL
ORDER BY skill_id, month_start_date, job_title_short;

SELECT 'Skills Dimension ' AS table_name, count(*) AS row_count from skills_mart.dim_skills
UNION ALL
SELECT 'DATE Month Dimension', count(*) from skills_mart.dim_date_month
UNION ALL
SELECT 'Skills Demand Fact', count(*) from skills_mart.fact_skills_demand_monthly;

SELECT'==== Skills Dimension Sample ====' AS info;
SELECT * from skills_mart.dim_skills LIMIT 5;

SELECT'==== Date Month Dimension Sample ====' AS info;
SELECT * from skills_mart.dim_date_month LIMIT 5;

SELECT'==== Skills Demand Fact Sample ====' AS info;
SELECT * from skills_mart.fact_skills_demand_monthly LIMIT 5;
