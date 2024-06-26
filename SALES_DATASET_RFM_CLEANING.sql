/*****1. Chuyển đổi kiểu dữ liệu phù hợp cho các trường*/

SET datestyle = 'iso,mdy';  
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN orderdate TYPE date USING (TRIM(orderdate):: date),
ALTER COLUMN quantityordered TYPE numeric USING(trim(quantityordered)::numeric),
ALTER COLUMN priceeach TYPE decimal USING(trim(priceeach)::decimal),
ALTER COLUMN orderlinenumber TYPE numeric USING(trim(orderlinenumber)::numeric),
ALTER COLUMN sales TYPE numeric USING(trim(sales)::float),
ALTER COLUMN ordernumber TYPE numeric USING(trim(ordernumber)::numeric),
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
ADD COLUMN CONTACTFIRSTNAME VARCHAR(255),
ADD COLUMN CONTACTLASTNAME VARCHAR(255)
	

UPDATE sales_dataset_rfm_prj
SET
CONTACTFIRSTNAME =UPPER (LEFT(CONTACTFULLNAME,1)) || 
RIGHT(LEFT(CONTACTFULLNAME,POSITION('-' IN CONTACTFULLNAME)-1),
LENGTH(LEFT(CONTACTFULLNAME,POSITION('-' IN CONTACTFULLNAME)-1))-1), 
	

CONTACTLASTNAME = UPPER (LEFT(right(CONTACTFULLNAME, LENGTH(CONTACTFULLNAME)-
LENGTH(LEFT(CONTACTFULLNAME,POSITION('-' IN CONTACTFULLNAME)))),1))
|| right(right(CONTACTFULLNAME, LENGTH(CONTACTFULLNAME)-
LENGTH(LEFT(CONTACTFULLNAME,POSITION('-' IN CONTACTFULLNAME)))),
LENGTH(right(CONTACTFULLNAME, LENGTH(CONTACTFULLNAME)-
LENGTH(LEFT(CONTACTFULLNAME,POSITION('-' IN CONTACTFULLNAME)))-1)))



/**********Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là Qúy,
tháng, năm được lấy ra từ ORDERDATE */

ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN QTR_ID int,
ADD COLUMN MONTH_ID int,
ADD COLUMN YEAR_ID int


UPDATE sales_dataset_rfm_prj
SET 	QTR_ID=EXTRACT( QUARTER FROM ORDERDATE),
	MONTH_ID=EXTRACT( MONTH FROM ORDERDATE),
	YEAR_ID=EXTRACT( YEAR FROM ORDERDATE)
	

	
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
	(SELECT  QUANTITYORDERED, 
		(select avg(QUANTITYORDERED)
  		from sales_dataset_rfm_prj) as av ,
 		(select stddev(QUANTITYORDERED)
		from sales_dataset_rfm_prj) as stddev 
	FROM sales_dataset_rfm_prj),
	 
cte1 AS
	(select QUANTITYORDERED,(QUANTITYORDERED- av)/stddev as z_score
	from cte
	where abs(QUANTITYORDERED- av)/stddev) > 2 )

/* xử lý outlier*/	
DELETE from sales_dataset_rfm_prj
WHERE QUANTITYORDERED in (select QUANTITYORDERED from cte1)


/******6. Lưu vào bảng mới tên là SALES_DATASET_RFM_PRJ_CLEAN*/

CREATE TABLE SALES_DATASET_RFM_PRJ_CLEAN AS
(SELECT * FROM sales_dataset_rfm_prj )

/****************PROJECT2**********/

/*1.Thống kê tổng số lượng người mua và số lượng đơn hàng đã hoàn thành mỗi tháng ( Từ 1/2019-4/2022)
Output: month_year ( yyyy-mm) , total_user, total_orde*/

select format_date('%Y-%m', created_at) AS month,
       count(distinct user_id)  as total_user, count(id) as total_orde
from bigquery-public-data.thelook_ecommerce.order_items
where status='Complete'and
      format_date('%Y-%m', created_at) between '2019-01' and '2022-04'
group by 1
order by 1

/*--->Số lượng đơn hàng và số lượng khách hàng nhìn chung có xu hướng tăng từ 1/2019- 4/2022*/
  
/********2. Giá trị đơn hàng trung bình (AOV) và số lượng khách hàng mỗi tháng*******/

select format_date('%Y-%m', created_at) AS month_year,
       count(distinct user_id) as  distinct_users,
       sum(sale_price)/count( distinct id) as  average_order_value
 
from bigquery-public-data.thelook_ecommerce.order_items
where format_date('%Y-%m', created_at) between '2019-01' and '2022-04' 
group by 1
order by 1

 /*--->cả số lượng khách hàng và giá trị đơn hàng trung bình hàng tháng tăng từ 1/2019 - 4/2022
giá trị đơn hàng lớn nhất là vào 2/2019, giá trị đơn hàng nhỏ nhất là vào 11/2019*/



/******3.Tìm các khách hàng có trẻ tuổi nhất và lớn tuổi nhất theo từng giới tính ( Từ 1/2019-4/2022)*******/


begin 

create temp table young_old as 
       ( select * from 
              (
               with cte as
              (
              select first_name, last_name,age,gender,
                    min(age) over(partition by gender) as min_age,
                    format_date('%Y-%m', created_at) as date
              from `bigquery-public-data.thelook_ecommerce.users`
              where format_date('%Y-%m', created_at) between '2019/01' and '2022/04'
              ),
              
              cte1 as
              (
              select first_name, last_name,age,gender,
                    max(age) over(partition by gender) as max_age,
                    format_date('%Y-%m', created_at) as date
              from `bigquery-public-data.thelook_ecommerce.users` 
              where format_date('%Y-%m', created_at) between '2019/01' and '2022/04'
              )
              
              select first_name, last_name,age,gender, 'youngest' as tag
              from cte
              where age= min_age
              
              union all
              
              select first_name, last_name,age,gender, 'oldest' as tag
              from cte1
              where age= max_age));

end;

/* số người nhỏ tuổi nhất */
select count(*)
from pristine-glass-406208._script259ccdc8a72adc5c1e9b44b5957a0ebd50cb9a98.young_old
where tag='youngest'

/*số người lớn tuổi nhất */
 
select count(*)
from pristine-glass-406208._scripta5b2dd14328521efa0282b23b6472a3b9d200b04.young_old
where tag='oldest'
 
/*--->tuổi nhỏ nhất là 12 tuổi với  981 người trong đó 467 nữ, 514 nam 
tuổi lớn nhất là 70 tuổi với 1019 người trong đó 496 nữ, 523 nam */
  

/****4. Top 5 sản phẩm mỗi tháng*****/
with cte as
(
  
select format_date('%Y-%m',a.created_at) as month_year, a.product_id, b.name as product_name,
sum(a.sale_price) as  sales, sum (b.cost) as cost, sum(a.sale_price) - sum (b.cost) as profit

from  bigquery-public-data.thelook_ecommerce.order_items as a
join bigquery-public-data.thelook_ecommerce.products as b
  on a.product_id=b.id
group by 1,2,3  
order by 1,2
),


cte1 as (
select month_year, product_id, product_name, sales, cost, profit,
 dense_rank() over ( partition by month_year order by profit desc) as ranking 
from cte
)

select * from cte1 where ranking <=5
order by month_year 



/*5.Doanh thu tính đến thời điểm hiện tại trên mỗi danh mục
 trong 3 tháng qua ( giả sử ngày hiện tại là 15/4/2022)*/


select format_date('%Y-%m-%d',b.created_at) as datee,c.category as product_categories,
sum(b.sale_price) as revenue 
from bigquery-public-data.thelook_ecommerce.orders as a
join bigquery-public-data.thelook_ecommerce.order_items as b 
  on a.order_id=b.id
join bigquery-public-data.thelook_ecommerce.products as c 
  on b.product_id=c.id
where format_date('%Y-%m-%d',b.created_at)between '2022-01-15' and '2022-04-15'
group by 1,2   
order by 1, sum(b.sale_price) desc 


/**********************************PART 2 ****************************************/
/***Tạo retention cohort analysis***/

with vw_ecommerce_analyst as (
with cte as
(
select extract (month from b.created_at) as month, extract ( year from b.created_at) as year,c.category as Product_category,
      count(b.id)  over(partition by extract ( year from b.created_at), extract (month from b.created_at)) as tpo,
      sum(c.cost) over(partition by extract ( year from b.created_at), extract (month from b.created_at)) as total_cost,
      sum(b.sale_price) over(partition by extract ( year from b.created_at), extract (month from b.created_at)) -
      sum(c.cost) over(partition by extract ( year from b.created_at), extract (month from b.created_at)) as total_profit,
      sum(b.sale_price) over(partition by extract ( year from b.created_at), extract (month from b.created_at)) as tpv,
      round((sum(b.sale_price) over(partition by extract ( year from b.created_at), extract (month from b.created_at)) -
      sum(c.cost) over(partition by extract ( year from b.created_at), extract (month from b.created_at)))/ 
      (sum(c.cost) over(partition by extract ( year from b.created_at), extract (month from b.created_at))),2) as Profit_to_cost_ratio,

         concat(extract (month from b.created_at),'-',extract ( year from b.created_at)) AS monthhh,


from bigquery-public-data.thelook_ecommerce.orders as a
join bigquery-public-data.thelook_ecommerce.order_items as b
on a.order_id=b.id
join bigquery-public-data.thelook_ecommerce.products as c
on b.product_id=c.id
order by year,month
),

cte1 as(
select distinct month,year,tpv,tpo,Profit_to_cost_ratio
from cte
order by year, month),

cte2 as 
(
select *, 
lead(tpv) over (order by year,month) as sale_next_month,
lead(tpo) over (order by year,month) as order_next_month,
concat (round((lead(tpv) over (order by year,month) - tpv)/tpv,2),'%') as Revenue_growth,
concat(round((lead(tpo) over (order by year,month) - tpo)/tpo,2),'%') as Order_growth
from cte1
order by year, month )


select g.month, g.year, g.Product_category, g.tpv,h.Revenue_growth,h.Order_growth, g.total_cost,g.total_profit, g.Profit_to_cost_ratio
from cte as g
join cte2 as h 
  on h.month=g.month and h.year=g.year 
order by year, month)

/**=====> mới chỉ nhóm theo ngày tháng chưa nhóm theo category***/

/************SỬA *********/

with cte as
(select 
 format_date('%Y-%m', o.created_at) as Month
,format_date('%Y', o.created_at) as Year
,p.category as Product_category
,sum(sale_price) as TPV
,count(oi.order_id) as TPO
,sum(cost) as Total_cost
from bigquery-public-data.thelook_ecommerce.orders as o
inner join bigquery-public-data.thelook_ecommerce.order_items as oi
on o.order_id = oi.order_id
inner join bigquery-public-data.thelook_ecommerce.products as p
on p.id = oi.product_id 
group by 1,2,3
order by 1,2),

cte2 as(
select *
,lag(TPV) over(partition by Month order by Month) as next_rev
,lag(TPO) over(partition by Month order by Month) as next_order
,TPV-TPO as Total_profit
from cte
)

 select Month,Year,Product_category,TPV,TPO,Total_cost,Total_profit
,concat(round((next_rev - TPV)/TPV*100.0,2),"%") as Revenue_growth
,concat(round((next_order - TPO)/TPO*100.0,2),"%") as Order_growth
,round(Total_profit/Total_cost,2) as Profit_to_cost_ratio 
from cte2


       
/***2. tỷ lệ số khách hàng quay lại ****/


with cte as 
(
select format_date('%Y-%m',first) as cohort_date,date, (extract(year from date)-extract(year from first))*12+
(extract(month from date)-extract(month from first))+1 as index,user_id
from
(
select user_id,created_at as date,
min(created_at) over(partition by user_id) as first
from  bigquery-public-data.thelook_ecommerce.order_items
where created_at between '2019-01-06'and '2021-01-31')),

cte1 as (
select cohort_date, index, count(distinct user_id) as number_user
from cte 
group by cohort_date,index),

cohort as
(
select cohort_date,
sum (case when index = 1 then number_user else 0 end) as m1,
sum (case when index= 2 then number_user else 0 end) as m2,
sum (case when index= 3 then number_user else 0 end) as m3,
sum (case when index= 4 then number_user else 0 end) as m4
from cte1
group by cohort_date
order by cohort_date)

select cohort_date,
round(100.00*m1/m1,2) || '%' as m1,
round(100.00*m2/m1,2) || '%' as m2,
round(100.00*m3/m1,2) || '%' as m3,
round(100.00*m4/m1,2) || '%' as m4,
from cohort


/*Visualize số khách hàng quay lại trong 1 năm từ 1/2019-1/2020*/

with cte as 
(
select format_date('%Y-%m',first) as cohort_date,date, (extract(year from date)-extract(year from first))*12+
(extract(month from date)-extract(month from first))+1 as index,user_id
from
(
select user_id,created_at as date,
min(created_at) over(partition by user_id) as first
from  bigquery-public-data.thelook_ecommerce.order_items
where created_at between '2019-01-06'and '2020-01-31'))

select cohort_date, index, count(distinct user_id) as number_user
from cte 
group by cohort_date,index
order by cohort_date,index 

















