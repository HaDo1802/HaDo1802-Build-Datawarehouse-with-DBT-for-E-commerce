with source as (
    select * from {{ ref('stg_sellers') }}
),
cleaned as (
    select
        seller_id,
        lpad(seller_zip_code_prefix::text, 5, '0') as seller_zip_code_prefix,
        initcap(seller_city) as seller_city,
        upper(seller_state) as seller_state
    from source
),
with_surrogate as (
    select
        row_number() over(order by seller_id) as seller_key,
        *,
        current_date as last_updated
    from cleaned
)
select * from with_surrogate
