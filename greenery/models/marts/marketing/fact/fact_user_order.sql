{{
  config(
    materialized='table'
  )
}}


with orders as (
    select * from {{ ref('stg_postgres__orders') }}
  )

, users as (
    select * from {{ ref('stg_postgres__users') }}
  )

, order_items as (
    select * from {{ ref('int_order_items') }}
  )

, user_performance as (
    select * from {{ ref('int_user_performance') }}
  )
  
, promo_discount as (
    select * from {{ ref('int_promo_discount') }}
  )

select 
    o.user_id
    , u.first_name
    , u.last_name
    , up.user_first_order as first_order
    , up.user_last_order  as last_order
    , up.user_total_orders as orders_cnt
    , sum(i.product_types) as product_types_cnt
    , sum(i.product_quantity) as product_quantity
    , sum(o.order_cost) as order_cost
    , sum(o.order_shipping_cost) as shipping_cost
    , sum(pr.discount_amount) as discount_amount
    , sum(o.order_total_cost) - sum(pr.discount_amount) as total_spend

from orders o 
left join users u on u.user_id = o.user_id
left join order_items i on i.order_id = o.order_id
left join user_performance up on up.user_id = o.user_id
left join promo_discount pr on pr.order_id = o.order_id
{{ group_by(6) }}

