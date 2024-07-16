-- import sources: orders

WITH 
    source AS (
        SELECT * FROM {{ source('jaffle_shop', 'orders') }}
),

transformed AS (
        SELECT
            id AS order_id,
            user_id AS customer_id,
            order_date AS order_placed_at,
            status AS order_status,
            CASE 
                WHEN status not in ('returned','return_pending') 
                THEN order_date 
            END AS valid_order_date
        FROM source
)

SELECT * FROM transformed