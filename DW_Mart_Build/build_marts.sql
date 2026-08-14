--duckdb dw_marts.duckdb -c ".read build_marts.sql"--


--step 1:create star schema tables
.read 01_create_tables_dw.sql

--step 2: load data from csv files into tables
.read 02_load_schema_dw.sql