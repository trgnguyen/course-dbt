{{
  config(
    materialized = 'view'
    , unique_key = 'order_id'
  )
}}

with orders as ( 
   select * from {{ ref('stg_postgres__orders') }}
)

, promos as ( 
   select * from {{ ref('stg_postgres__promos') }}
)

select 
    o.order_id
    , coalesce((o.order_total_cost * (p.discount/100 :: float)),0) as discount_amount
    , o.order_total_cost - coalesce((o.order_total_cost * (p.discount/100 :: float)),0) as order_total_cost

from orders o 
left join promos p on p.promo_id = o.promo_id
