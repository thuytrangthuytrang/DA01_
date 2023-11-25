/*1. Số lượng đơn hàng và số lượng khách hàng mỗi tháng
Output: month_year ( yyyy-mm) , total_user, total_orde*/


select format_date('%Y-%m', created_at) AS month,
  count(distinct order_id) as sales_per_month, count(distinct user_id) as customer_per_month

from bigquery-public-data.thelook_ecommerce.orders
where  format_date('%Y-%m', created_at) between '2019-01' and '2022-04'and 
      format_date('%Y-%m', shipped_at) between '2019-01' and '2022-04'
group by 1
order by 1 

/*Giá trị đơn hàng trung bình (AOV) và số lượng khách hàng mỗi tháng*/

select format_date('%Y-%m', created_at) AS month_year,
      count(distinct user_id) as  distinct_users,
      sum(sale_price)/count(id) as  average_order_value
 
from bigquery-public-data.thelook_ecommerce.order_items
where format_date('%Y-%m', created_at) between '2019-01' and '2022-04' 
group by 1
order by 1

