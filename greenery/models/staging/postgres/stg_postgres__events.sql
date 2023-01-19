{{
  config(
    materialized = 'view'
    , unique_key = 'event_id'
  )
}}

with src_events as (
  select * from {{ source('postgres', 'events') }}
)

, renamed as (
  select
    event_id 
    , session_id
    , user_id
    , page_url
    , created_at as event_created_at
    , event_type 
    , order_id
    , product_id
  from src_events
)

select * from renamed