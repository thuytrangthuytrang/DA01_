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
select month_year, product_id,  product_name, sales,cost,profit, rank_per_month
from 
(select format_date('%Y-%m',a.created_at) as month_year, a.product_id, b.name as product_name,
sum(a.sale_price) as  sales, sum (b.cost) as cost, sum(a.sale_price) - sum (b.cost) as profit,
dense_rank() over ( partition by 1 order by (sum(a.sale_price) - sum (b.cost))desc) as rank_per_month

from  bigquery-public-data.thelook_ecommerce.order_items as a
join bigquery-public-data.thelook_ecommerce.products as b
  on a.product_id=b.id
  group by 1,2,3 
order by 1 ) as ggg

order by rank_per_month, rank_per_month between 1 and 5 


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





