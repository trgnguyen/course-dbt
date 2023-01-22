{{
  config(
    materialized = 'view'
  )
}}

select 
    date(o.order_created_at) as date
    , i.product_id
    , p.product_name
    , sum(quantity) order_quantity
from  {{ ref('stg_postgres__orders') }}  o 
left join {{ ref('stg_postgres__order_items') }} i on i.order_id = o.order_id
left join {{ ref('stg_postgres__products') }} p on i.product_id = p.product_id
group by 1,2,3