with paid_orders as (
        select orders.id as order_id,
            orders.user_id	as customer_id,
            orders.order_date as order_placed_at,
            orders.status as order_status,
            p.total_amount_paid,
            p.payment_finalized_date,
            c.first_name    as customer_first_name,
            c.last_name as customer_last_name
            from raw.jaffle_shop.orders as orders

            left join ( -- this query is the same as the query below, redundant!
                select 
                    orderid as order_id, 
                    max(created) as payment_finalized_date, 
                    sum(amount) / 100.0 as total_amount_paid
                from raw.stripe.payment
                where status <> 'fail'
                group by 1) p on orders.id = p.order_id
            left join raw.jaffle_shop.customers c on orders.user_id = c.id 
)

select
    p.order_id,
    sum(t2.total_amount_paid) as clv_bad
from paid_orders p
left join paid_orders t2 on p.customer_id = t2.customer_id and p.order_id >= t2.order_id
group by 1
order by p.order_id