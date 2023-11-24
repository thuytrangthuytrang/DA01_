SET datestyle = 'iso,mdy';  
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN orderdate TYPE date USING (TRIM(orderdate):: date),
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN quantityordered TYPE numeric USING(trim(ordernumber)::numeric),
ALTER COLUMN priceeach TYPE decimal USING(trim(ordernumber)::decimal),
ALTER COLUMN orderlinenumber TYPE numeric USING(trim(ordernumber)::numeric),
ALTER COLUMN sales TYPE numeric USING(trim(ordernumber)::numeric),
ALTER COLUMN msrp TYPE numeric  USING(trim(ordernumber)::numeric)


/****2222222*/
ALTER TABLE sales_dataset_rfm_prj
ADD CHECK ( ORDERNUMBER IS NOT NULL),
ADD CHECK ( QUANTITYORDERED IS NOT NULL),
ADD CHECK ( PRICEEACH IS NOT NULL),                      
ADD CHECK ( ORDERLINENUMBER IS NOT NULL),
ADD CHECK ( SALES IS NOT NULL),
ADD CHECK ( ORDERDATE  IS NOT NULL)



/****/
ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN CONTACTLASTNAME VARCHAR(255),
ADD COLUMN CONTACTFIRSTNAME VARCHAR(255)


/****/

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

/****/

INSERT INTO sales_dataset_rfm_prj(CONTACTFIRSTNAME,CONTACTLASTNAME)
SELECT CONTACTFIRSTNAME,CONTACTLASTNAME
FROM AAA;

/*Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là Qúy,
tháng, năm được lấy ra từ ORDERDATE */

ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN MONTH_ID MONTH,
ADD COLUMN CONTACTFIRSTNAME VARCHAR(255)

SELECT MONTH(ORDERDATE)
FROM sales_dataset_rfm_prj

/* box plot*/

WITH cte AS
(SELECT Q1-1.5*IQR AS min_value, Q3+1.5*IQR AS max_value
FROM
(SELECT 
percentile_cont (0.25) WITHIN GROUP (ORDER BY QUANTITYORDERED ) as Q1,
percentile_cont (0.75) WITHIN GROUP (ORDER BY QUANTITYORDERED ) as Q3,
percentile_cont (0.25) WITHIN GROUP (ORDER BY QUANTITYORDERED ) -
percentile_cont (0.75) WITHIN GROUP (ORDER BY QUANTITYORDERED ) as IQR
FROM sales_dataset_rfm_prj) as bbb)
 
 select *
 from sales_dataset_rfm_prj
 where 
 QUANTITYORDERED < (select min_value from cte)
 or
  QUANTITYORDERED > (select max_value from cte)
  
  /* Z-CORE*/
  
  WITH cte AS
  (
	  SELECT  QUANTITYORDERED,
	  (select avg(QUANTITYORDERED)
	  from sales_dataset_rfm_prj) as av ,
	  (select stddev(QUANTITYORDERED)
	   from sales_dataset_rfm_prj) as stddev 
	 FROM sales_dataset_rfm_prj)
	 
	 select QUANTITYORDERED,
	 (QUANTITYORDERED- av)/stddev as z_score
	  from cte
	  where abs(QUANTITYORDERED- av)/stddev >2



