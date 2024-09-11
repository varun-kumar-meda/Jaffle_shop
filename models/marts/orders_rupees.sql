with

orders as (

    select * from {{ ref('stg_orders_inr') }}

),

order_items as (

    select * from {{ ref('order_items') }}

),

order_items_summary as (

    select
        order_id,

        sum({{ convert_usd_to_inr('supply_cost') }}) as order_cost_inr,
        sum({{ convert_usd_to_inr('product_price') }}) as order_items_subtotal_inr,
        count(order_item_id) as count_order_items,
        sum(
            case
                when is_food_item then 1
                else 0
            end
        ) as count_food_items,
        sum(
            case
                when is_drink_item then 1
                else 0
            end
        ) as count_drink_items

    from order_items

    group by 1,order_id

),

compute_booleans as (

    select
        -- orders.order_id,orders.location_id,orders.customer_id,orders.subtotal_inr,
        -- orders.tax_paid_inr,orders.order_total_inr,
        orders.*,
        order_items_summary.order_cost_inr,
        order_items_summary.order_items_subtotal_inr,
        order_items_summary.count_food_items,
        order_items_summary.count_drink_items,
        order_items_summary.count_order_items,
        order_items_summary.count_food_items > 0 as is_food_order,
        order_items_summary.count_drink_items > 0 as is_drink_order

    from orders

    left join
        order_items_summary
        on orders.order_id = order_items_summary.order_id

),

customer_order_count as (

    select
        -- *,
        customer_id,order_id,location_id,subtotal_inr,tax_paid_inr,order_total_inr,order_cost_inr,order_items_subtotal_inr,

        row_number() over (
            partition by customer_id
            order by ordered_at asc
        ) as customer_order_number,'INR' as currency

    from compute_booleans

)

select * from customer_order_count
