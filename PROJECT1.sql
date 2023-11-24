SET datestyle = 'iso,mdy';  
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN quantityordered TYPE numeric USING(trim(ordernumber)::numeric),
ALTER COLUMN priceeach TYPE decimal USING(trim(ordernumber)::decimal),
ALTER COLUMN orderlinenumber TYPE numeric USING(trim(ordernumber)::numeric),
ALTER COLUMN sales TYPE numeric USING(trim(ordernumber)::numeric),
ALTER COLUMN msrp TYPE numeric  USING(trim(ordernumber)::numeric),
ALTER COLUMN orderdate TYPE date USING(TRIM(orderdate)::time),
/*2. check null/blank*/ 
ALTER TABLE sales_dataset_rfm_prj
ADD CHECK ( ORDERNUMBER IS NOT NULL),
ADD CHECK ( QUANTITYORDERED IS NOT NULL),
ADD CHECK ( PRICEEACH IS NOT NULL),                      
ADD CHECK ( ORDERLINENUMBER IS NOT NULL),
ADD CHECK ( SALES IS NOT NULL),
ADD CHECK ( ORDERDATE  IS NOT NULL)

/*3 Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME 
được tách ra từ CONTACTFULLNAME
Chuẩn hóa CONTACTLASTNAME, CONTACTFIRSTNAME
theo định dạng chữ cái đầu tiên viết hoa, chữ cái tiếp theo viết thường */
ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN CONTACTLASTNAME VARCHAR(255),
ADD COLUMN CONTACTFIRSTNAME VARCHAR(255)

INSERT INTO sales_dataset_rfm_prj(CONTACTLASTNAME,CONTACTFIRSTNAME)
VALUES 

SELECT CONTACTFULLNAME FROM sales_dataset_rfm_prj

ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN CONTACTLASTNAME VARCHAR(255),
ADD COLUMN CONTACTFIRSTNAME VARCHAR(255),

INSERT INTO sales_dataset_rfm_prj(CONTACTFIRSTNAME,CONTACTLASTNAME)
SELECT (FDF,HFGDFHB)



LEFT(CONTACTFULLNAME,POSITION('-' IN CONTACTFULLNAME)-1) AS CONTACTFIRSTNAME,
RIGHT(CONTACTFULLNAME,POSITION('-' IN CONTACTFULLNAME)-1) AS CONTACTLASTNAME

FROM sales_dataset_rfm_prj

