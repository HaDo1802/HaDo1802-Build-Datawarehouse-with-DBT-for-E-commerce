select distinct
    customer_id,
    customer_unique_id,
    zip_code_prefix,
    customer_city,
    customer_state
from {{ ref('stg_customers') }}
