{{
    config(
        materialized='table',
        schema='gold'
    )
}}


with fact_sales as (
    select * from {{ ref('bronze_fact_sales') }}
),

dim_cust as (
    select * from {{ ref('silver_dim_customer') }}
),

dim_prod as (
    select * from {{ ref('silver_dim_product') }}
),

dim_geo as (
    select * from {{ ref('silver_dim_geography') }}
)

select
    -- Fact Columns
    f.SalesLineID,
    f.OrderID,
    CAST(f.OrderDate as DATE) as OrderDate,
    CAST(f.Quantity as INT) as Quantity,
    
    -- Macro Call
    {{ clean_amount('f.UnitPrice') }} as UnitPrice,
    {{ clean_amount('f.GrossSales') }} as GrossSales,
    {{ clean_amount('f.DiscountAmount') }} as DiscountAmount,
    {{ clean_amount('f.NetSales') }} as NetSales,
    {{ clean_amount('f.TotalCost') }} as TotalCost,
    {{ clean_amount('f.Profit') }} as Profit,

    -- Customer Attributes (Fixed column names)
    c.FullName as CustomerFullName,
    c.FirstName as CustomerFirstName,
    c.LastName as CustomerLastName,
    c.Segment as CustomerSegment,      -- Silver mein naam 'Segment' tha, alias hum 'CustomerSegment' rakh rahe hain

    -- Product Attributes (Fixed column names)
    p.ProductName,
    p.Category as ProductCategory,      -- Silver mein naam 'Category' tha
    p.Subcategory as ProductSubcategory,  -- Silver mein naam 'Subcategory' tha
    p.PotentialProfitMarginPercent,

    -- Geography Attributes
    g.Region,
    g.Country,
    g.State,
    g.City,
    g.FullLocationPath

from fact_sales f
left join dim_cust c on f.CustomerID = c.CustomerID
left join dim_prod p on f.ProductID = p.ProductID
left join dim_geo g on f.GeographyID = g.GeographyID