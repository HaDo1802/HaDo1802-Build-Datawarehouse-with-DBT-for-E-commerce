with source as (
    select * from {{ source('raw','products') }}
),
cleaned as (
    select distinct
        product_id,
        coalesce(t.product_category_name_english, p.product_category_name) as product_category,
        cast(nullif(product_name_length, '')::numeric as int) as name_length,
        cast(nullif(product_description_length, '')::numeric as int) as description_length,
        cast(nullif(product_photos_qty, '')::numeric as int) as photos_qty,
        cast(nullif(product_weight_g, '')::numeric as int) as weight_g,
        cast(nullif(product_length_cm, '')::numeric as int) as length_cm,
        cast(nullif(product_height_cm, '')::numeric as int) as height_cm,
        cast(nullif(product_width_cm, '')::numeric as int) as width_cm
    from {{ source('raw','products') }} p
    left join {{ source('raw','product_category_name_translation') }} t
      on p.product_category_name = t.product_category_name
)
select * from cleaned
