with source as (
    select * from {{ source('raw', 'order_reviews') }}
),
cleaned as (
    select distinct
        review_id,
        order_id,
        cast(review_score as int) as review_score,
        review_comment_title,
        review_comment_message,
        cast(review_creation_date as timestamp) as review_creation_date,
        cast(review_answer_timestamp as timestamp) as review_answer_timestamp
    from source
)
select * from cleaned
