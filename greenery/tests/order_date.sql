select *
from {{ ref('stg_postgres__orders') }}
where (order_created_at > order_delivered_at) or (order_created_at > order_estimated_delivery_at) 