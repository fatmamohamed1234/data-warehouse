INSERT INTO company_dim (company_id, company_name)  
SELECT (company_id, company_name)
FROM read_csv('https://storage.googleapis.com/sql_de/company_dim.csv',
    AUTO_DETECT=true); 
    
INSERT INTO skill_dim (skill_id, skill, type)
SELECT (skill_id, skill, type)
FROM read_csv('https://storage.googleapis.com/sql_de/skill_dim.csv',
    AUTO_DETECT=true);

INSERT INTO job_posting_fact (job_id, company_id, job_title_short, job_title, job_via, job_schedule_type, job_work_from_home, search_location,
  job_posted_date, job_no_degree_mention, job_health_insurance, job_country, salary_rate, salary_year_avg, salary_hour_avg)
SELECT job_id, company_id, job_title_short, job_title, job_via, job_schedule_type, job_work_from_home, search_location,
  job_posted_date, job_no_degree_mention, job_health_insurance, job_country, salary_rate, salary_year_avg, salary_hour_avg
FROM read_csv('https://storage.googleapis.com/sql_de/job_posting_fact.csv',
    AUTO_DETECT=true);
