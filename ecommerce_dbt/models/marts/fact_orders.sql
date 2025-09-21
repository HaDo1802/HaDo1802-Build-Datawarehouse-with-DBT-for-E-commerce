with order_items_agg as (
    select
        order_id,
        count(distinct order_item_id) as items_count,
        sum(price) as total_price,
        sum(freight_value) as total_freight,
        sum(price + freight_value) as order_value
    from {{ ref('stg_order_items') }}
    group by order_id
),
payments_agg as (
    select
        order_id,
        sum(payment_value) as total_payment,
        count(distinct payment_sequential) as payment_methods_used
    from {{ ref('stg_payments') }}
    group by order_id
)
select
    o.order_id,
    o.customer_id,
    o.order_status,
    o.order_purchase_ts,
    o.order_approved_ts,
    o.delivered_carrier_ts,
    o.delivered_customer_ts,
    o.estimated_delivery_ts,
    oi.total_price,
    oi.total_freight,
    oi.items_count,
    oi.order_value,
    p.total_payment,
    p.payment_methods_used
from {{ ref('stg_orders') }} o
left join order_items_agg oi on o.order_id = oi.order_id
left join payments_agg p on o.order_id = p.order_id
