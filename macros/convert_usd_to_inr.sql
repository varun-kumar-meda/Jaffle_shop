{% macro convert_usd_to_inr(usd_amount) %}
    -- Convert USD amount to INR amount
    ({{ usd_amount }} * {{ 83 }})::numeric(16, 2)
{% endmacro %}
