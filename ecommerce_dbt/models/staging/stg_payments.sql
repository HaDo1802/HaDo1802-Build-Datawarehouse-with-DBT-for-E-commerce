with source as (
    select * from {{ source('raw', 'payments') }}
),
cleaned as (
    select distinct
        order_id,
        cast(payment_sequential as int) as payment_sequential,
        payment_type,
        cast(payment_installments as int) as payment_installments,
        cast(payment_value as numeric(10,2)) as payment_value
    from source
)
select * from cleaned
