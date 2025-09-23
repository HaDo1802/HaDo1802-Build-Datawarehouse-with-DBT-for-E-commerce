with oi as (
  select
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price::numeric(10,2)        as price,
    freight_value::numeric(10,2) as freight_value,
    (price + freight_value)::numeric(10,2) as total_item_value
  from {{ ref('stg_order_items') }}
),
o as (
  select
    order_id,
    customer_id,
    lower(order_status)                      as order_status,
    order_purchase_ts,
    delivered_customer_ts,
    estimated_delivery_ts
  from {{ ref('stg_orders') }}
)
select
  oi.order_id,
  oi.order_item_id,
  o.customer_id,               
  oi.product_id,
  oi.seller_id,
  o.order_status,
  o.order_purchase_ts,
  oi.shipping_limit_date,
  oi.price,
  oi.freight_value,
  oi.total_item_value,
  (extract(epoch from (o.delivered_customer_ts - o.order_purchase_ts))/86400.0)      as delivery_time_days,
  (extract(epoch from (o.estimated_delivery_ts - o.order_purchase_ts))/86400.0)      as estimated_delivery_time_days,
  (o.order_purchase_ts::date) as order_date_key
from oi
join o using (order_id)
