{{
    config(
        materialized='table',
        schema='silver'
    )
}}


with bronze_prod as (
    select * from {{ ref('bronze_dim_product') }}
)

select
    ProductID,
    Category,
    Subcategory,
    TRIM(ProductName) as ProductName,
    CAST(StandardCost as DECIMAL(10, 2)) as StandardCost,
    CAST(ListPrice as DECIMAL(10, 2)) as ListPrice,
    -- Custom Business Calculation: Profit Margin %
    CAST(
        ((ListPrice - StandardCost) / NULLIF(ListPrice, 0)) * 100 
        as DECIMAL(5, 2)
    ) as PotentialProfitMarginPercent
from bronze_prod
where ProductID is not null