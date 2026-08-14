CREATE TABLE company_dim(
company_id      INT PRIMARY KEY,
name            VARCHAR
);
CREATE TABLE skill_dim(
skill_id      INT PRIMARY KEY,
skill         VARCHAR,
type          VARCHAR
);
CREATE TABLE job_posting_fact(
job_id                INT PRIMARY KEY,
company_id            INT,
job_title_short       VARCHAR,
job_title             VARCHAR,
job_via               VARCHAR,
job_schedule_type     VARCHAR,
job_work_from_home    BOOLEAN,
search_location       VARCHAR,
job_posted_date       TIMESTAMP,
job_no_degree_mention BOOLEAN,
job_health_insurnce   BOOLEAN,
jop_country           VARCHAR,
salry_rate            VARCHAR,
salary_yeare_avg      DOUBLE,
salary_hour_avg       DOUBLE,
FOREIGN KEY (company_id) REFERENCES company_dim(company_id)
);

CREATE TABLE skill_job_dim(
skill_id      INT,
job_id        INT,
PRIMARY KEY (skill_id, job_id),
FOREIGN KEY (skill_id) REFERENCES skill_dim(skill_id),
FOREIGN KEY (job_id)   REFERENCES job_posting_fact(job_id)
);


select table_name 
from information_schema.tables 
where table_schema = 'main' ;



)