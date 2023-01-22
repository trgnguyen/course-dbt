select *
from {{ ref('stg_postgres__orders') }}
where order_status ='delivered' and order_delivered_at is null