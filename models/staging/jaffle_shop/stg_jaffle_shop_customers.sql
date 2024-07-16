-- import sources: customers
WITH 
    source AS (
        SELECT * FROM {{ source('jaffle_shop', 'customers') }}
),

transformed AS (
    SELECT 
        id AS customer_id,
        last_name AS customer_last_name,
        first_name AS customer_first_name,
        first_name || ' ' || last_name AS full_name
    FROM source
)

SELECT * FROM transformed