with p as (
  select
    order_id,
    payment_sequential,
    lower(payment_type)          as payment_type,
    coalesce(payment_installments,1)::int as payment_installments,
    payment_value::numeric(10,2) as payment_value
  from {{ ref('stg_payments') }}
),
o as (
  select
    order_id,
    customer_id,
    lower(order_status) as order_status,
    order_purchase_ts
  from {{ ref('stg_orders') }}
)
select
  p.order_id,
  p.payment_sequential,
  o.customer_id,
  o.order_status,
  o.order_purchase_ts,
  p.payment_type,
  p.payment_installments,
  p.payment_value
from p
join o using (order_id)
