with products as (
    select * from {{ ref('stg_products') }}
),
cleaned as (
    select
        p.product_id,
        coalesce(t.product_category_name_english, 'Unknown') as product_category,
        coalesce(product_photos_qty,0) as product_photos_qty,
        coalesce(product_weight_g,0) as product_weight_g,
        coalesce(product_length_cm,0) as product_length_cm,
        coalesce(product_height_cm,0) as product_height_cm,
        coalesce(product_width_cm,0) as product_width_cm
    from products p
    left join {{ ref('stg_product_category_name_translation') }} t
        on p.product_category = t.product_category_name
),
with_surrogate as (
    select
        row_number() over(order by product_id) as product_key,
        *,
        current_date as last_updated
    from cleaned
)
select * from with_surrogate
