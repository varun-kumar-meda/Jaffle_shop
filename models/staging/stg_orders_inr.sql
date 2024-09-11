with

source as (

    select * from {{ source('ecom', 'raw_orders') }}

),

renamed as (

    select

        ----------  ids
        id as order_id,
        store_id as location_id,
        customer as customer_id,

        ---------- numerics
        subtotal as subtotal_cents,
        tax_paid as tax_paid_cents,
        order_total as order_total_cents,
        {{ convert_cents_to_inr('subtotal') }} as subtotal_inr,
        {{ convert_cents_to_inr('tax_paid') }} as tax_paid_inr,
        {{ convert_cents_to_inr('order_total') }} as order_total_inr,

        ---------- timestamps
        {{ dbt.date_trunc('day','ordered_at') }} as ordered_at

    from source

)

select * from renamed
