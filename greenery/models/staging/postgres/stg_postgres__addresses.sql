{{
  config(
    materialized = 'view'
    , unique_key = 'address_id'
  )
}}

with src_addresses as (
  select * from {{ source('postgres', 'addresses') }}
)

, renamed as (
  select
    address_id 
    , address 
    , lpad(zipcode::varchar, 5, '0') as zip_code
    , state 
    , country 
  from src_addresses
)

select * from renamed