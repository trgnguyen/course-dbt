# Project Week 03

## What is our overall conversion rate?
#### **Answer: 0.624567**
```
select div0(sum(checkout), count(distinct session_id)) as conversion_rate
from dev_db.dbt_trangnguyenaudibenede.fact_conversion_rate;
```

## What is our conversion rate by product?
#### **Answer: The following query gives us the conversion rate per product.**
```
select p.product_name, total_orders, count(distinct session_id) as total_sessions, div0(total_orders,count(distinct session_id)) product_conversion_rate
      from dev_db.dbt_trangnguyenaudibenede.fact_conversion_rate as f
      left join ( select product_id, count(order_id) as total_orders
                  from dev_db.dbt_trangnguyenaudibenede.stg_postgres__order_items
                  group by 1) as o on o.product_id = f.product_id
left join dev_db.dbt_trangnguyenaudibenede.dim_products p on p.product_id = f.product_id
where f.product_id is not null
group by 1,2;
```



## Which orders changed from week 2 to week 3? 
#### **Answer: There are three orders which changed from week 2 to week 3. The order_id are 29d20dcd-d0c4-4bca-a52d-fc9363b5d7c6, c0873253-7827-4831-aa92-19c38372e58d, e2729b7d-e313-4a6f-9444-f7f65ae8db9a**
```
select t2.*
from (
    select * 
    from dev_db.dbt_trangnguyenaudibenede.orders_snapshot
    where dbt_valid_to is not null and date(dbt_valid_to) > '2023-01-22') t1 

left join dev_db.dbt_trangnguyenaudibenede.orders_snapshot t2 on t2.order_id = t1.order_id
order by t2.order_id asc, t2.dbt_updated_at asc;
```
