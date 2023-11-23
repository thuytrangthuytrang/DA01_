-----1. thay đổi dữ liệu----
ALTER TABLE SALES_DATASET_RFM_PRJ
ALTER COLUMN TYPE ordernumber TYPE numberic USING(trim(ordernumber)::numeric),
ALTER COLUMN TYPE quantityordered TYPE numberic USING(trim(ordernumber)::numeric),
ALTER COLUMN TYPE priceeach TYPE numberic USING(trim(ordernumber)::decimal),
ALTER COLUMN TYPE orderlinenumber TYPE numberic USING(trim(ordernumber)::numeric),
ALTER COLUMN TYPE salesTYPE numberic USING(trim(ordernumber)::decimal),
ALTER COLUMN TYPE orderdate USING(trim(ordernumber)::YYYY-MM-DD H:MI),
ALTER COLUMN TYPE msrp USING(trim(ordernumber)::numeric),
ALTER COLUMN TYPE orderdate USING(trim(ordernumber)::YYYY-MM-DD H:MI),
