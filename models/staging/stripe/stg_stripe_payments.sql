-- import sources: payment
WITH 

    source AS (
        SELECT * FROM {{ source('stripe', 'payment') }}
),

transformed AS (
        SELECT
        id AS payment_id,
        orderid AS order_id,
        _batched_at AS payment_created_at,
        status AS payment_status,
        round(amount / 100.0, 2) AS payment_amount
    FROM source
)

SELECT * FROM transformed