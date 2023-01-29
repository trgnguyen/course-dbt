with promos as ( 
   select * from {{ ref('stg_postgres__promos') }} 
)
select 
    promo_id
    , discount/100 :: float as discount_pcent
    , status
from promos