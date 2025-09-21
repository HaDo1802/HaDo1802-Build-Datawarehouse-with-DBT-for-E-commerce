with dates as (
    select distinct order_purchase_ts as date_key
    from {{ ref('stg_orders') }}
)
select
    date_key,
{{ get_date_parts('date_key') }}
from dates
