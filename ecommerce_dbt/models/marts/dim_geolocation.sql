with source as (
    select * from {{ ref('stg_geolocation') }}
),
cleaned as (
    select distinct
        lpad(geolocation_zip_code_prefix::text, 5, '0') as geolocation_zip_code_prefix,
        lat,lng,
        initcap(geolocation_city) as geolocation_city,
        upper(geolocation_state) as geolocation_state
    from source
),
with_surrogate as (
    select
        row_number() over(order by geolocation_zip_code_prefix) as geolocation_key,
        *
    from cleaned
)
select * from with_surrogate
