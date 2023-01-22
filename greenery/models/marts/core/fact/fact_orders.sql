{{
  config(
    materialized='table'
  )
}}

select 
    o.order_id
    , o.order_created_at
    , o.user_id
    , u.first_name
    , u.last_name
    , u.email
    , p.product_id
    , product_name
    , price
    , i.quantity
    , o.promo_id
    , o.order_status
from {{ ref('stg_postgres__orders') }} o 
left join {{ ref('stg_postgres__order_items') }} i on i.order_id = o.order_id
left join {{ ref('stg_postgres__products') }} p on i.product_id = p.product_id
left join {{ ref('stg_postgres__users') }} u on u.user_id = o.user_id
left join {{ ref('stg_postgres__promos') }} pr on pr.promo_id = o.promo_id