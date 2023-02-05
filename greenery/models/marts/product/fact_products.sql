{{
  config(
    materialized='table'
  )
}}

with product_page_views_agg as (
select * from {{ ref('int_product_page_views') }}
)

, product_orders_agg as (
    select * from {{ ref('int_product_orders') }}
)

, dim_product as (
    select * from {{ ref('dim_products') }}
)

, base as (
    select 
        coalesce(pv.date, po.date) as date
        , coalesce(pv.product_id, po.product_id) as product_id
        , coalesce(pv.product_name, po.product_name) as product_name
        , coalesce(pv.page_view, 0) as page_view
        , coalesce(po.order_quantity, 0) as order_quantity
        , coalesce(po.order_count, 0) as order_count
    from product_page_views_agg pv
    full join product_orders_agg po using (date, product_id)
)

select 
    b.*
    , b.order_quantity * p.price as revenue
from base b 
left join dim_product p on p.product_id = b.product_id 