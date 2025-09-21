with source as (
    select * from {{ source('raw', 'customers') }}
),
cleaned as (
    select distinct
        customer_id,
        customer_unique_id,
        cast(customer_zip_code_prefix as int) as zip_code_prefix,
        customer_city,
        customer_state
    from source
)
select * from cleaned
