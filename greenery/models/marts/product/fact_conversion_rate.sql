{{
  config(
    materialized='table'
  )
}}

with order_items as (
    select *
    from {{ ref('stg_postgres__order_items') }}
)

, dim_products as (
    select *
    from {{ ref('dim_products') }}
)

, events as (
    select *
    from {{ ref('stg_postgres__events') }}
)

{%- set event_types = dbt_utils.get_column_values(
      table=ref('stg_postgres__events'), 
      column='event_type') 
-%}

, event_type_agg as (
    select 
        session_id
        , user_id
        , product_id
        , order_id
        {%- for event_type in event_types %}
        , {{ case_agg('event_type', event_type) }} as {{ event_type }}
        {%- endfor %}
    from events
    {{ group_by(4) }}
)

, order_product_session as ( 
    select distinct 
        e.session_id
        , o.order_id
        , o.product_id
        , quantity
    from order_items o
    left join events e on e.order_id = o.order_id
)

, retrieve_order_id as (
    select 
        e.*
        , o.order_id as order_id_filled
    from event_type_agg e
    left join order_product_session o on o.session_id = e.session_id and o.product_id = e.product_id
)

, base as (
    select 
        r.*
        , e.checkout as checkout_filled
        , e.package_shipped as package_shipped_filled
    from retrieve_order_id r
    left join event_type_agg e on e.order_id = r.order_id_filled
    where r.product_id is not null
) 

select 
    b.product_id
    , product_name
    , session_id
    , session_id as total_sessions
    , case when page_view + add_to_cart + coalesce(checkout_filled,0) > 0 then session_id else null end as page_view
    , case when add_to_cart + coalesce(checkout_filled,0) > 0 then session_id else null end as add_to_cart 
    , case when coalesce(checkout_filled,0) > 0 then session_id else null end as check_out
    , case when coalesce(package_shipped_filled,0) > 0 then session_id else null end as package_shipped
from base b 
left join dim_products p on p.product_id = b.product_id