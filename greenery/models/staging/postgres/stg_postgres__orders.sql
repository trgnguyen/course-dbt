{{
  config(
    materialized = 'view'
    , unique_key = 'order_id'
  )
}}

with src_orders as (
  select * from {{ source('postgres', 'orders') }}
)

, renamed as (
  select
    order_id 
    , user_id
    , address_id
    , order_cost
    , shipping_cost as order_shipping_cost
    , order_total as order_total_cost
    , status as order_status
    , tracking_id
    , shipping_service
    , created_at::timestampntz as order_created_at
    , estimated_delivery_at::timestampntz as order_estimated_delivery_at
    , delivered_at::timestampntz as order_delivered_at
    , promo_id::string as promo_id
  from src_orders
)

select * from renamed