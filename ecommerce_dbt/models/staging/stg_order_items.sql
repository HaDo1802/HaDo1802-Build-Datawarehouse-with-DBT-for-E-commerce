with source as (
    select * from {{ source('raw', 'order_items') }}
),
cleaned as (
    select distinct
        order_id,
        cast(order_item_id as int) as order_item_id,
        product_id,
        seller_id,
        cast(shipping_limit_date as timestamp) as shipping_limit_date,
        cast(price as numeric(10,2)) as price,
        cast(freight_value as numeric(10,2)) as freight_value
    from source
)
select * from cleaned
