{{
  config(
    materialized='table'
  )
}}

with orders as ( 
   select * from {{ ref('stg_postgres__orders') }}
)

, order_items as ( 
   select * from {{ ref('stg_postgres__order_items') }}
)

, products as ( 
   select * from {{ ref('dim_products') }}
)

, users as ( 
   select * from {{ ref('dim_users') }}
)

select 
    o.order_id
    , o.order_created_at
    , o.user_id
    , u.first_name
    , u.last_name
    , u.email
    , p.product_id
    , product_name
    , price
    , i.quantity
    , o.promo_id
    , o.order_status
from orders o 
left join order_items i on i.order_id = o.order_id
left join products p on i.product_id = p.product_id
left join users u on u.user_id = o.user_id
