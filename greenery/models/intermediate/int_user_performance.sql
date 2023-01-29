{{
  config(
    materialized = 'view'
    , unique_key = 'user_id'
  )
}}

with orders as ( 
   select * from {{ ref('stg_postgres__orders') }}
)

select 
    user_id
    , min(order_created_at) user_first_order
    , max(order_created_at) user_last_order
    , count(order_id) user_total_orders
from orders
{{ group_by(1) }}
