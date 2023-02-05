{{
  config(
    materialized = 'view'
  )
}}

with orders as ( 
   select * from {{ ref('stg_postgres__orders') }}
)

, order_items as ( 
   select * from {{ ref('stg_postgres__order_items') }}
)

, products as ( 
   select * from {{ ref('stg_postgres__products') }}
)

select 
    date(o.order_created_at) as date
    , i.product_id
    , p.product_name
    , sum(quantity) order_quantity
    , count(distinct o.order_id) order_count
from  orders  o 
left join order_items i on i.order_id = o.order_id
left join products p on i.product_id = p.product_id
{{ group_by(3) }}