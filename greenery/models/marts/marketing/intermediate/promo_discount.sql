{{
  config(
    materialized = 'view'
    , unique_key = 'order_id'
  )
}}

select 
    o.order_id
    , coalesce((o.order_total_cost * p.discount_pcent),0) as discount_amount
    , o.order_total_cost - coalesce((o.order_total_cost * p.discount_pcent),0)  as order_total_cost

from {{ ref('stg_postgres__orders') }} o 
left join {{ ref('dim_promos') }} p on p.promo_id = o.promo_id
