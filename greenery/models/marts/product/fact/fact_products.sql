{{
  config(
    materialized='table'
  )
}}

with product_page_views_agg as (
select * from {{ref('product_page_views_agg')}}
)

, product_orders_agg as (
    select * from {{ref('product_orders_agg')}}
)

select 
    coalesce(pv.date, po.date) as date
    , coalesce(pv.product_id, po.product_id) as product_id
    , coalesce(pv.product_name, po.product_name) as product_name
    , coalesce(pv.page_view, 0) as page_view
    , coalesce(po.order_quantity, 0) as order_quantity
from product_page_views_agg pv
full join product_orders_agg po using (date, product_id)