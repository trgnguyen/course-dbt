{{
  config(
    materialized = 'view'
    , unique_key = 'order_id'
  )
}}

with src_order_items as (
  select * from {{ source('postgres', 'order_items') }}
)

, renamed as (
  select
    order_id 
    , product_id
    , quantity
  from src_order_items
)

select * from renamed
