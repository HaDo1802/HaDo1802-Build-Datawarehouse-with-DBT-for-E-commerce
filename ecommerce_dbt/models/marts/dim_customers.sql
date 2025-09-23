with source as (
    select * from {{ ref('stg_customers') }}
),
cleaned as (
    select
        customer_id,
        customer_unique_id::text,
        lpad(customer_zip_code_prefix::text, 5, '0') as customer_zip_code_prefix,
        initcap(customer_city) as customer_city,
        upper(customer_state) as customer_state
    from source
),
with_surrogate as (
    select
        row_number() over(order by customer_id) as customer_key,
        *,
        current_date as effective_date,
        current_date + interval '50 years' as end_date,
        true as is_current
    from cleaned
)
select * from with_surrogate
