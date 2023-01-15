# Project Week 01

## Q1: How many users do we have?
### **Answer: We have 130 users.**
```
select count(distinct user_id) AS users 
from dev_db.dbt_trangnguyenaudibenede.stg_postgres__users;
```


## Q2: On average, how many orders do we receive per hour? 
### **Answer: On average, we receive 7.52 orders per hour.**

```
with order_per_hour
    as (
        select date_trunc('hour', created_at),
               count(distinct order_id) as orders
        from dev_db.dbt_trangnguyenaudibenede.stg_postgres__orders
        group by 1
     ) 
select round(avg(orders),2) as orders_per_hour
from order_per_hour;
```

   
## Q3: On average, how long does an order take from being placed to being delivered? 
### **Answer: On average, it takes around 3.89 days for the order from being placed to being delivered.**

```
select round(avg(datediff('day',created_at, delivered_at)),2) as days
from dev_db.dbt_trangnguyenaudibenede.stg_postgres__orders;
```



## Q4: How many users have only made one purchase? Two purchases? Three+ purchases? Note: you should consider a purchase to be a single order. In other words, if a user places one order for 3 products, they are considered to have made 1 purchase.    
### **Answer: We have 25 users made only one purchase, 28 users made two purchases, and 71 users made three or more purchases.**

```
with orders_count 
    as (
        select user_id, count(distinct order_id) as orders
        from dev_db.dbt_trangnguyenaudibenede.stg_postgres__orders
        group by 1
     )

select count(distinct case when orders = 1  then user_id end) as one_purchase,
       count(distinct case when orders = 2  then user_id end) as two_purchases,
       count(distinct case when orders >= 3 then user_id end) as three_purchases
from orders_count; 
```



## Q5: On average, how many unique sessions do we have per hour?
### **Answer: On average, we have around 16.33 unique sessions per hour.**

```
with session_per_hour
    as (
        select date_trunc('hour', created_at),
               count(distinct session_id) as sessions
        from dev_db.dbt_trangnguyenaudibenede.stg_postgres__events
        group by 1
    )
select round(avg(sessions),2) as sessions_per_hour
from session_per_hour;
```
