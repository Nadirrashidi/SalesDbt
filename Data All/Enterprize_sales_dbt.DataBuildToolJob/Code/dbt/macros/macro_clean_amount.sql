{% macro clean_amount(column_name) %}
    CAST(COALESCE({{ column_name }}, 0) as DECIMAL(10, 2))
{% endmacro %}