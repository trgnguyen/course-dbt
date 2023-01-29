with users as ( 
   select * from {{ ref('stg_postgres__users') }}
)

, addresses as ( 
   select * from {{ ref('stg_postgres__addresses') }}
)


select 
  user_id
  , first_name
  , last_name
  , email
  , phone_number
  , u.address_id
  , address
  , zip_code
  , state
  , country
  , user_created_at
  , user_updated_at
from users u 
left join addresses a on a.address_id = u.address_id 