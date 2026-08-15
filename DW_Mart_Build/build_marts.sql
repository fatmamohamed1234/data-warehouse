--duckdb dw_marts.duckdb -c ".read build_marts.sql"


--step 1:create star schema tables
.read 01_create_tables_dw.sql

--step 2: load data from csv files into tables
.read 02_load_schema_dw.sql

--step 3: Mart -create flat mart
.read 03_create_flat_mart.sql


--step 4: Mart -create skills demand mart
.read 04_create_skills_mart.sql

--step 5:Mart -create priority rules mart
.read 05_create_priority_mart.sql

---step 6:Mart -update priority mart
.read 06_update_priority_mart.sql