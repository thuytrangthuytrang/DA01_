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


/*3333333333333333*//

  

with cte as
(
select a.first_name, a.last_name,a.age,a.gender,
      min(a.age) over(partition by a.gender) as min_age,
      format_date('%Y-%m', b.created_at) as date
from bigquery-public-data.thelook_ecommerce.users as a 
join bigquery-public-data.thelook_ecommerce.orders as b 
  on b.user_id=a.id
where format_date('%Y-%m', b.created_at) between '2019/01' and '2022/04'
),

cte1 as
(
select a.first_name, a.last_name,a.age,a.gender,
      max(a.age) over(partition by a.gender) as max_age,
      format_date('%Y-%m', b.created_at) as date
from bigquery-public-data.thelook_ecommerce.users as a 
join bigquery-public-data.thelook_ecommerce.orders as b 
  on b.user_id=a.id
where format_date('%Y-%m', b.created_at) between '2019/01' and '2022/04'
)

select first_name, last_name,age,gender, 'youngest' as tag
from cte
where age= min_age

union all

select first_name, last_name,age,gender, 'oldest' as tag
from cte1
where age= max_age

  

/*********r4*/

  

with cte as
(
select format_date('%Y-%m',b.created_at) as month_year, a.id as product_id, a.name as  product_name ,
sum(b.sale_price) over (partition by format_date('%Y-%m',b.created_at),a.name) as  sales,
      a.cost * count( b.product_id) over (partition by format_date('%Y-%m',b.created_at),a.name) as cost,
       sum(b.sale_price) over (partition by format_date('%Y-%m',b.created_at),a.name) -
       a.cost * count( b.product_id) over (partition by format_date('%Y-%m',b.created_at),a.name) as profit 
from bigquery-public-data.thelook_ecommerce.products as a
join bigquery-public-data.thelook_ecommerce.order_items as b
  on a.id=b.product_id 
),

cte1 as
(
select month_year,product_id, product_name,sales,cost,profit,
      dense_rank() over(partition by month_year order by profit desc ) as rank_per_month
from cte
)

select * from cte1
where rank_per_month between 1 and 5
order by month_year desc 


/*5.Doanh thu tính đến thời điểm hiện tại trên mỗi danh mục
Thống kê tổng doanh thu theo ngày của từng danh mục sản phẩm (category) trong 3 tháng qua ( giả sử ngày hiện tại là 15/4/2022)
Output: dates (yyyy-mm-dd), product_categories, revenue*/

select format_date('%Y-%m-%d',a.created_at) as dates,c.category as product_categories,
sum(b.sale_price) as revenue 
from bigquery-public-data.thelook_ecommerce.orders as a
join bigquery-public-data.thelook_ecommerce.order_items as b 
  on a.order_id=b.id
join bigquery-public-data.thelook_ecommerce.products as c 
  on b.product_id=c.id
where format_date('%Y-%m-%d',a.created_at)between '2022-01-15' and '2022-04-15'
group by 1,2   
order by 1, sum(b.sale_price) desc


/*****hgjh*/////

select format_date('%Y-%m-%d',a.created_at) as dates,c.category as product_categories,
sum(b.sale_price) over( partition by c.category order by format_date('%Y-%m-%d',a.created_at)) as revenue 
from bigquery-public-data.thelook_ecommerce.orders as a
join bigquery-public-data.thelook_ecommerce.order_items as b 
  on a.order_id=b.id
join bigquery-public-data.thelook_ecommerce.products as c 
  on b.product_id=c.id
where format_date('%Y-%m-%d',a.created_at)between '2022-01-15' and '2022-04-15'



