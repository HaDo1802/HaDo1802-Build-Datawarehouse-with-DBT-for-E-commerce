{{ config(materialized='view', schema='staging') }}

select
    product_category_name,
    product_category_name_english
from {{ source('raw', 'product_category_name_translation') }}
