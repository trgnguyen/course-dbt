# Project Week 02

## What is our user repeat rate?
#### **Answer: The repeat rate is 79.8%**
```
with orders_count as (
    select 
        user_id
        , count(distinct order_id) as orders_cnt
    from {{ ref('stg_postgres__orders') }}
    group by 1
)

select div0(
            count(case when orders_cnt >= 2 then user_id end),
            count(distinct user_id)
            ) as repeat_rate
from orders_count;
```


## Snapshots: Which orders changed from week 1 to week 2? 
#### **Answer: There are three orders which changed from week 1 to week 2. The order_id are 265f9aae-561a-4232-a78a-7052466e46b7, e42ba9a9-986a-4f00-8dd2-5cf8462c74ea, b4eec587-6bca-4b2a-b3d3-ef2db72c4a4f**

```
select t2.*

from (
    select * 
    from {{ ref('orders_snapshot') }} 
    where dbt_valid_to is not null) t1

left join {{ ref('orders_snapshot') }} t2 on t2.order_id = t1.order_id
order by t2.order_id asc, t2.dbt_updated_at asc;
```
