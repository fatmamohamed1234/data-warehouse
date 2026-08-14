

INSERT INTO company_dim (company_id, company_name)  

SELECT (company_id, company_name)
FROM read_csv('https://storage.googleapis.com/sql_de/company_dim.csv',
    AUTO_DETECT=true); 
    

