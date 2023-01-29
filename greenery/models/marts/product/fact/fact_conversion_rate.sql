{{
  config(
    materialized='table'
  )
}}

with events as (
    select *
    from {{ ref('stg_postgres__events') }}
)

{%- set event_types = dbt_utils.get_column_values(
      table=ref('stg_postgres__events'), 
      column='event_type') 
-%}

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