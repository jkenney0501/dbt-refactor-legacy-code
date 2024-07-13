## Refactoring Legacy Code WITH dbt

When migrating and refactoring code, it’s of course important to stay organized. We'll do this by following several steps:

1. Migrate your code 1:1 into dbt
    - This step is simple, create a "legacy" folder and then create a file WITH a suitable name for the leagcy code.

2. Implement dbt sources rather than referencing raw databASe tables
    - Use the source function which helps connect to DWH sources & set up models to be referenced downstream.

3. Choose a refactoring strategy:
    - Two methods can be considered realistically: in plac and along side refacting.
    - Both have pros and cons. To read more about the [read here.](https://docs.getdbt.com/guides/refactoring-legacy-sql?step=4)

4. Implement CTE groupings and cosmetic cleanup
    - Clean up ugly code that is disorganized and inconsistent.
    - Apply modularity to code using CTE's for readability and reusability.

5. Separate data transformations into standardized layers
    - Folder structure is typically broken up into folders: 
        - ***models*** > ***staging*** > ***int*** (intermediate models that get transformed) > ***dim*** > ***fct*** (fact tables) > ***marts*** (for BI reporting).
    - Staging: WHERE your source modesl that query the DWH live.
    - int: WHERE you transformations take place, this is typically WHERE I build DIM's or FCT's.
    - dim: folder for dimensaion models that add context to facts.
    - fct: this is WHERE your fact tables live. All live events that have occured and are meASured.
    - marts: Typically used for business intelligence report creation whihc can combine facts and dimesions to create a large report. These are downstream and get queried alot. Thye are best materializwed AS tables.
    - **Read more on transformations** [here.](https://www.getdbt.com/analytics-engineering/transformation)
6. Audit the output of dbt models vs legacy SQL
    - Use a package WITH its macros to ensure consistency WITH legact code results.
    - Audit helper is a good one for this. It can be found [here.](https://hub.getdbt.com/dbt-labs/audit_helper/latest/)


### Use a 4 part layout to help guide the refactor process

1. Import CTEs
    - These are your bASic references for each source.
2. Logical CTEs
    - This is WHERE caluclations occur.
    - Logical CTEs contain unique transformations used to generate the final product, and we want to separate these into logical blocks. 
      To identify our logical CTEs, we will follow subqueries in order.

    - **If a subquery hAS nested subqueries, we will want to continue moving down until we get to the first layer, then pull out the subqueries 
      in order AS CTEs, making our way back to the final SELECT statement.**

    - Name these CTEs AS the aliAS that the subquery wAS given - you can rename it later, but for now it is best to make AS few changes AS possible.

    - If the script is particularly complicated, it's worth it to go through once you're finished pulling out subqueries and follow the CTEs 
      to make sure they happen in an order that makes sense for the end result.

      example:
```sql
      
WITH

    import_orders AS (

            -- query only non-test orders
            SELECT * FROM {{ source('jaffle_shop', 'orders') }}
            WHERE amount > 0
),

import_customers AS (
            SELECT * FROM {{ source('jaffle_shop', 'customers') }}
),

logical_cte_1 AS (

    -- perform some math on import_orders

),

logical_cte_2 AS (

    -- perform some math on import_customers
),

final_cte AS (

    -- join together logical_cte_1 and logical_cte_2
)

SELECT * FROM final_cte
```

Source: [dbt labs](https://docs.getdbt.com/guides/refactoring-legacy-sql?step=5)

3. A Final CTE
    - This joins everything together.
4. A simple SELECT statement
    -  calls the CTE for the final output.
