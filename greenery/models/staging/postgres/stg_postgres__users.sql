{{
  config(
    materialized = 'view'
    , unique_key = 'user_id'
  )
}}

with src_users as (
  select * from {{ source('postgres', 'users') }}
)

, renamed as (
  select
    user_id 
    , first_name
    , last_name
    , email
    , phone_number
    , address_id
    , created_at::timestampntz as user_created_at
    , updated_at::timestampntz as user_updated_at
  from src_users
)

select * from renamed