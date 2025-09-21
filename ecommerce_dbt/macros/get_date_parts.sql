{% macro get_date_parts(column) %}
    extract(year from {{ column }}) as year,
    extract(month from {{ column }}) as month,
    extract(day from {{ column }}) as day,
    extract(quarter from {{ column }}) as quarter
{% endmacro %}
