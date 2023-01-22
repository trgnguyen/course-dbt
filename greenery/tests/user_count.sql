select 
    user_id
    , count(*)
from {{ ref('fact_user_order') }}
group by 1 
having count(*) > 1