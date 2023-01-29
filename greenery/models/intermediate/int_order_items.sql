{{
  config(
    materialized = 'view'
    , unique_key = 'order_id'
  )
}}

with order_items as ( 
   select * from {{ ref('stg_postgres__order_items') }}
)


select 
    order_id
    , count(product_id) as product_types
    , sum(quantity) as product_quantity
from order_items
{{ group_by(1) }}