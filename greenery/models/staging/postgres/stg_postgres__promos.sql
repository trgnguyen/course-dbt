{{
  config(
    materialized = 'view'
    , unique_key = 'promo_id'
  )
}}

with src_promos as (
  select * from {{ source('postgres', 'promos') }}
)

, renamed as (
  select
    promo_id 
    , discount
    , status
  from src_promos
)

select * from renamed