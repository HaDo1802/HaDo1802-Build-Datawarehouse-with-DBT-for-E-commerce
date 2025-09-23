with source as (
    select * from {{ source('raw', 'sellers') }}
),
cleaned as (
    select distinct
        seller_id,
        cast(seller_zip_code_prefix as int) as seller_zip_code_prefix,
        seller_city,
        seller_state
    from source
)
select * from cleaned
