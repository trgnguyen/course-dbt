select 
    promo_id
    , discount/100 :: float as discount_pcent
    , status
from {{ ref('stg_postgres__promos') }}