{% snapshot orders_snapshot %}

{{config(
        unique_key='ORDER_ID', 
        strategy='check',  
        check_cols=['SUBTOTAL_INR', 'TAX_PAID_INR', 'ORDER_TOTAL_INR', 'ORDER_COST_INR', 'ORDER_ITEMS_SUBTOTAL_INR', 'CUSTOMER_ORDER_NUMBER']  
    )
}}

-- Select the data to snapshot
SELECT
    CUSTOMER_ID,
    ORDER_ID,
    LOCATION_ID,
    SUBTOTAL_INR,
    TAX_PAID_INR,
    ORDER_TOTAL_INR,
    ORDER_COST_INR,
    ORDER_ITEMS_SUBTOTAL_INR,
    CUSTOMER_ORDER_NUMBER,
    CURRENCY
FROM {{ ref('orders_rupees') }}

{% endsnapshot %}
