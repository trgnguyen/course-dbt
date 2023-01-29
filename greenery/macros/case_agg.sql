{% macro case_agg(column_name, value) %}

    sum(case when {{ column_name }} = '{{ value }}' then 1 else 0 end)

{% endmacro %}




