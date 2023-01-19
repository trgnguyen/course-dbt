{{
  config(
    materialized = 'view'
    , unique_key = 'product_id'
  )
}}

with src_products as (
  select * from {{ source('postgres', 'products') }}
)

, renamed as (
  select
    product_id 
    , name as product_name
    , price
    , inventory
  from src_products
)

select * from renamed