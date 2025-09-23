with o as (
  select
    order_id,
    customer_id,
    lower(order_status) as order_status,
    order_purchase_ts,
    delivered_customer_ts,
    estimated_delivery_ts
  from {{ ref('stg_orders') }}
),
items_agg as (


  select
    order_id,
    count(*)                                       as items_count,
    sum(price)::numeric(12,2)                      as total_price,
    sum(freight_value)::numeric(12,2)              as total_freight,
    sum(price + freight_value)::numeric(12,2)      as order_value
  from {{ ref('stg_order_items') }}
  group by order_id
),
payments_agg as (
  select
    order_id,
    sum(payment_value)::numeric(12,2)             as total_payment,
    count(*)                                      as payment_count,
    count(distinct lower(payment_type))           as payment_methods_used
  from {{ ref('stg_payments') }}
  group by order_id
)
select
  o.order_id,
  o.customer_id,
  o.order_status,
  o.order_purchase_ts,
  o.delivered_approved_ts,
  o.delivered_carrier_ts,
  o.delivered_customer_ts,
  o.estimated_delivery_ts,
  (extract(epoch from (o.delivered_customer_ts - o.order_purchase_ts))/86400.0)  as delivery_time_days,
  (extract(epoch from (o.estimated_delivery_ts - o.order_purchase_ts))/86400.0)  as estimated_delivery_time_days,
  (extract(epoch from (o.delivered_customer_ts - o.delivered_carrier_ts))/86400.0) as delivery_to_carrier_days,
  (extract(epoch from (o.delivered_customer_ts - o.delivered_customer_ts))/86400.0) as carrier_to_customer_days,
  (extract(epoch from (o.delivered_customer_ts - o.estimated_delivery_ts))/86400.0) as below_estimation_days,
  ia.items_count,
  ia.total_price,
  ia.total_freight,
  ia.order_value,
  pa.total_payment,
  pa.payment_count,
  pa.payment_methods_used
from o
left join items_agg   ia on o.order_id = ia.order_id
left join payments_agg pa on o.order_id = pa.order_id
