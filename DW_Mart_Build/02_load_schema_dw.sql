-- step 2: DW - load data from csv files into the data warehouse tables

select'====== loading company_dim table ===='; AS info;

INSERT INTO company_dim (company_id, name)  
SELECT company_id, name
FROM read_csv('https://storage.googleapis.com/sql_de/company_dim.csv',
    AUTO_DETECT=true); 


    
    
select'====== loading skill_dim table ===='; AS info;
INSERT INTO skill_dim (skill_id, skill, type)
SELECT skill_id, skills AS skill, type
FROM read_csv('https://storage.googleapis.com/sql_de/skill_dim.csv',
    AUTO_DETECT=true);




select'====== loading job_posting_fact table ===='; AS info;
INSERT INTO job_posting_fact (job_id, company_id, job_title_short, job_title, job_via, job_schedule_type, job_work_from_home, search_location,
  job_posted_date, job_no_degree_mention, job_health_insurance, job_country, salary_rate, salary_year_avg, salary_hour_avg)
SELECT job_id, company_id, job_title_short, job_title, job_via, job_schedule_type, job_work_from_home, search_location,
  job_posted_date, job_no_degree_mention, job_health_insurance, job_country, salary_rate, salary_year_avg, salary_hour_avg
FROM read_csv('https://storage.googleapis.com/sql_de/job_posting_fact.csv',
    AUTO_DETECT=true);



select'====== loading skill_job_dim table ===='; AS info;
INSERT INTO skill_job_dim (skill_id, job_id)
SELECT skill_id, job_id
FROM read_csv('https://storage.googleapis.com/sql_de/skill_job_dim.csv',
    AUTO_DETECT=true);