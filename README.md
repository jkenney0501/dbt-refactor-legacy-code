## Refactoring Legacy Code with dbt

When migrating and refactoring code, it’s of course important to stay organized. We'll do this by following several steps:

1. Migrate your code 1:1 into dbt
    - This step is simple, create a "legacy" folder and then create a file with a suitable name for the leagcy code.

2. Implement dbt sources rather than referencing raw database tables
    - Use the source function which helps connect to DWH sources & set up models to be referenced downstream.

3. Choose a refactoring strategy:
    - side by side?

4. Implement CTE groupings and cosmetic cleanup
    - Clean up ugly code that is dosorganized and inconsistent.
    - Apply modularity to code using CTE's for readability and reusability.

5. Separate data transformations into standardized layers
    - Folder structure is typically broken up into folders: 
        - ***models*** > ***staging*** > ***int*** (intermediate models that get transformed) > ***dim*** > ***fct*** (fact tables) > ***marts*** (for BI reporting).
    - Staging: where your source modesl that query the DWH live.
    - int: where you transformations take place, this is typically where I build DIM's or FCT's.
    - dim: folder for dimensaion models that add context to facts.
    - fct: this is where your fact tables live. All live events that have occured and are measured.
    - marts: Typically used for business intelligence report creation whihc can combine facts and dimesions to create a large report. These are downstream and get queried alot. Thye are best materializwed as tables.
    - **Read more on transformations** [here.](https://www.getdbt.com/analytics-engineering/transformation)
6. Audit the output of dbt models vs legacy SQL
    - Use a package with its macros to ensure consistency with legact code results.
    - Audit helper is a good one for this. It can be found [here.](https://hub.getdbt.com/dbt-labs/audit_helper/latest/)
