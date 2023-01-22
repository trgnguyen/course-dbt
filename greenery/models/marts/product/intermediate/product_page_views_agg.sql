{{
  config(
    materialized = 'view'
  )
}}

select 
    date(event_created_at) as date
    , p.product_id
    , p.product_name
    , count(distinct session_id) as page_view
from {{ ref('stg_postgres__events') }} e 
left join {{ ref('stg_postgres__products') }} p on p.product_id = e.product_id
where event_type='page_view'
group by 1,2,3
