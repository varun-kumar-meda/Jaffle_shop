{% macro convert_cents_to_inr(cents, exchange_rate=83) %}
    -- Convert US cents to dollars first, then to INR
    ({{ cents }} / 100) * {{ exchange_rate }}
{% endmacro %}
