with dates as (
    select
        dd::date as date_key,
        extract(day from dd) as day,
        extract(month from dd) as month,
        extract(year from dd) as year,
        extract(quarter from dd) as quarter,
        extract(dow from dd) as day_of_week,
        to_char(dd, 'Day') as day_name,
        to_char(dd, 'Month') as month_name,
        case when extract(dow from dd) in (0,6) then true else false end as is_weekend
    from generate_series('2016-01-01'::date, '2025-12-31'::date, interval '1 day') dd
)
select * from dates
