{% test unique_counts(model, column_name) %}

   select {{ column_name }}, count(*)
   from {{ model }}
   group by {{ column_name }}
   having count(*) > 1

{% endtest %}