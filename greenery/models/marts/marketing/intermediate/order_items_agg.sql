{{
  config(
    materialized = 'view'
    , unique_key = 'order_id'
  )
}}

select 
    order_id
    , count(product_id) as product_types
    , sum(quantity) as product_quantity
from {{ ref('stg_postgres__order_items') }}
group by 1 