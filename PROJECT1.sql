/*****1. Chuyển đổi kiểu dữ liệu phù hợp cho các trường*/

SET datestyle = 'iso,mdy';  
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN orderdate TYPE date USING (TRIM(orderdate):: date),
ALTER COLUMN quantityordered TYPE numeric USING(trim(quantityordered)::numeric),
ALTER COLUMN priceeach TYPE decimal USING(trim(priceeach)::decimal),
ALTER COLUMN orderlinenumber TYPE numeric USING(trim(orderlinenumber)::numeric),
ALTER COLUMN sales TYPE numeric USING(trim(sales)::numeric),
ALTER COLUMN msrp TYPE numeric  USING(trim(msrp)::numeric)


/****2. Check NULL*/
ALTER TABLE sales_dataset_rfm_prj
ADD CHECK ( ORDERNUMBER IS NOT NULL),
ADD CHECK ( QUANTITYORDERED IS NOT NULL),
ADD CHECK ( PRICEEACH IS NOT NULL),                      
ADD CHECK ( ORDERLINENUMBER IS NOT NULL),
ADD CHECK ( SALES IS NOT NULL),
ADD CHECK ( ORDERDATE  IS NOT NULL)



/****3. Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME */
ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN CONTACTLASTNAME VARCHAR(255),
ADD COLUMN CONTACTFIRSTNAME VARCHAR(255)


/*tách first, last name từ CONTACTFULLNAME**/

CREATE TEMP TABLE AAA AS
(
SELECT 
UPPER (LEFT(CONTACTFULLNAME,1)) || 
	RIGHT(LEFT(CONTACTFULLNAME,POSITION('-' IN CONTACTFULLNAME)-1),
	  	LENGTH(LEFT(CONTACTFULLNAME,POSITION('-' IN CONTACTFULLNAME)-1))-1)
        AS CONTACTFIRSTNAME,
	
 UPPER (LEFT(right(CONTACTFULLNAME, LENGTH(CONTACTFULLNAME)-
			 LENGTH(LEFT(CONTACTFULLNAME,POSITION('-' IN CONTACTFULLNAME)))),1))
	|| right(right(CONTACTFULLNAME, LENGTH(CONTACTFULLNAME)-
			 LENGTH(LEFT(CONTACTFULLNAME,POSITION('-' IN CONTACTFULLNAME)))),
			 LENGTH(right(CONTACTFULLNAME, LENGTH(CONTACTFULLNAME)-
			 LENGTH(LEFT(CONTACTFULLNAME,POSITION('-' IN CONTACTFULLNAME)))-1)))
			 AS CONTACTLASTNAME
FROM sales_dataset_rfm_prj)




/**********Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là Qúy,
tháng, năm được lấy ra từ ORDERDATE */

ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN QTR_ID int,
ADD COLUMN MONTH_ID int,
ADD COLUMN YEAR_ID int

/*Qúy,tháng, năm được lấy ra từ ORDERDATE*/

create temp table nnnn as 
(
SELECT 
EXTRACT( MONTH FROM ORDERDATE) AS MONTH_ID,
EXTRACT( YEAR FROM ORDERDATE) AS YEAR_ID,
CASE
	WHEN EXTRACT( MONTH FROM ORDERDATE) IN(1,2,3) THEN 1
	WHEN EXTRACT( MONTH FROM ORDERDATE) IN(4,5,6) THEN 2
	WHEN EXTRACT( MONTH FROM ORDERDATE) IN(7,8,9) THEN 3
	ELSE 4
END AS QTR_ID
FROM sales_dataset_rfm_prj)


	
/******5. outlier*////
/* box plot*/

WITH cte AS
(SELECT Q1-1.5*IQR AS min_value, Q3+1.5*IQR AS max_value
FROM
(SELECT 
percentile_cont (0.25) WITHIN GROUP (ORDER BY QUANTITYORDERED ) as Q1,
percentile_cont (0.75) WITHIN GROUP (ORDER BY QUANTITYORDERED ) as Q3,
percentile_cont (0.75) WITHIN GROUP (ORDER BY QUANTITYORDERED ) -
percentile_cont (0.25) WITHIN GROUP (ORDER BY QUANTITYORDERED ) as IQR
FROM sales_dataset_rfm_prj) as bbb)
 
 select *
 from sales_dataset_rfm_prj
 where 
 QUANTITYORDERED < (select min_value from cte)
 or
  QUANTITYORDERED > (select max_value from cte)
  
  /* Z-CORE*/
  
   WITH cte AS
  ( SELECT  QUANTITYORDERED,
	  (select avg(QUANTITYORDERED)
	  from sales_dataset_rfm_prj) as av ,
	  (select stddev(QUANTITYORDERED)
	   from sales_dataset_rfm_prj) as stddev 
	 FROM sales_dataset_rfm_prj),
	 cte1 as
	 (select QUANTITYORDERED,
	 (QUANTITYORDERED- av)/stddev as z_score
	  from cte
	  where abs(QUANTITYORDERED- av)/stddev >2)
  
  DELETE from sales_dataset_rfm_prj
  where QUANTITYORDERED in (select QUANTITYORDERED from cte1)


/******6. Lưu vào bảng mới tên là SALES_DATASET_RFM_PRJ_CLEAN*/

CREATE TABLE SALES_DATASET_RFM_PRJ_CLEAN AS
(
SELECT * FROM sales_dataset_rfm_prj )




