{{
  config(
    materialized='view'
  )
}}

with products as ( 
   select * from {{ ref('stg_postgres__products') }}
)

select 
  product_id
  , product_name
  , price
  , inventory
from products