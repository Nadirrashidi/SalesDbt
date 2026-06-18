{{
    config(
        materialized='table',
        schema='silver'
    )
}}


with bronze_cust as (
    select * from {{ ref('bronze_dim_customer') }}
),

split_names as (
    select
        CustomerID,
        CustomerName,
        CHARINDEX(' ', TRIM(CustomerName)) as space_pos,
        Segment,
        GeographyID
    from bronze_cust
    where CustomerID is not null
)

select
    CustomerID,
    CustomerName as FullName,
    case 
        when space_pos > 0 then SUBSTRING(TRIM(CustomerName), 1, space_pos - 1)
        else TRIM(CustomerName)
    end as FirstName,
    case 
        when space_pos > 0 then SUBSTRING(TRIM(CustomerName), space_pos + 1, LEN(CustomerName))
        else ''
    end as LastName,
    Segment,
    GeographyID
from split_names