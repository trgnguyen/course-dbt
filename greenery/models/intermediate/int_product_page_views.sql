{{
  config(
    materialized = 'view'
  )
}}

with events as ( 
   select * from {{ ref('stg_postgres__events') }}
)

, products as ( 
   select * from {{ ref('stg_postgres__products') }}
)


select 
    date(event_created_at) as date
    , p.product_id
    , p.product_name
    , count(distinct session_id) as page_view
from events e 
left join products p on p.product_id = e.product_id
where event_type='page_view'
{{ group_by(3) }}
