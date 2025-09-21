with payments as (
    select
        order_id,
        payment_sequential,
        payment_type,
        payment_installments,
        payment_value
    from {{ ref('stg_payments') }}
),

orders as (
    select
        order_id,
        customer_id,
        order_status,
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
from payments p
join orders o using (order_id)
