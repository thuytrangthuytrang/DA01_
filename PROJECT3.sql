/*****1) Doanh thu theo từng ProductLine, Year  và DealSize?
Output: PRODUCTLINE, YEAR_ID, DEALSIZE, REVENUE***/
select ProductLine, Year_id, DealSize,
		sum(sales) as Revenue
from public.sales_dataset_rfm_prj_clean
group by ProductLine, Year_id, DealSize
order by ProductLine, Year_id, DealSize


/***2) Đâu là tháng có bán tốt nhất mỗi năm?
Output: MONTH_ID, REVENUE, ORDER_NUMBER
 *****/

with cte as
(
select MONTH_ID,year_ID,ORDERNUMBER,REVENUE,
		row_number() over( partition by Year_id order by revenue desc) as ranking 
from 
(	
select MONTH_ID,year_ID,
		count(ordernumber)  as ORDERNUMBER,
		sum(sales) as REVENUE
from public.sales_dataset_rfm_prj_clean
group by Year_id,MONTH_ID) as a 
)
select MONTH_ID,year_ID,ORDERNUMBER,REVENUE
from cte
where ranking=1

/*****3) Product line nào được bán nhiều ở tháng 11?
Output: MONTH_ID, REVENUE, ORDER_NUMBER
*****/

with cte as
(
	select * , row_number() over(order by revenue) as ranking 
	from 
	(
		select MONTH_ID, Year_id, Productline, 
				sum(sales) as revenue, count(ORDERNUMBER) as ORDER_NUMBER
		from public.sales_dataset_rfm_prj_clean 
		where MONTH_ID=11
		group by Productline, Year_id, MONTH_ID) as a
)

select MONTH_ID, Year_id,Productline,ORDER_NUMBER,revenue
from cte
where ranking=1 

/***4) Đâu là sản phẩm có doanh thu tốt nhất ở UK mỗi năm? 
Xếp hạng các các doanh thu đó theo từng năm.
Output: YEAR_ID, PRODUCTLINE,REVENUE, RANK**/



