with source as (
    select * from {{ source('raw', 'geolocation') }}
),
cleaned as (
    select distinct
        cast(geolocation_zip_code_prefix as int) as geolocation_zip_code_prefix,
        cast(geolocation_lat as numeric(9,6)) as lat,
        cast(geolocation_lng as numeric(9,6)) as lng,
        geolocation_city,
        geolocation_state
    from source
)
select * from cleaned
