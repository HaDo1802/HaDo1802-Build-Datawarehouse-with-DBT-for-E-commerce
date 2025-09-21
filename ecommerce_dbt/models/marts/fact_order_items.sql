with order_items as (
    select
        order_id,
        order_item_id,
        product_id,
        seller_id,
        shipping_limit_date,
        price,
        freight_value,
        (price + freight_value) as total_item_value
    from {{ ref('stg_order_items') }}
),

orders as (
    select
        order_id,
        customer_id,
        order_status,
        order_purchase_ts,
        order_approved_ts,
        delivered_customer_ts,
        estimated_delivery_ts
    from {{ ref('stg_orders') }}
)

select
    oi.order_id,
    oi.order_item_id,
    oi.product_id,
    oi.seller_id,
    o.customer_id,
    o.order_status,
    o.order_purchase_ts,
    oi.shipping_limit_date,
    oi.price,
    oi.freight_value,
    oi.total_item_value
from order_items oi
join orders o using (order_id)
