{{
    config(
        materialized='table',
        schema='silver'
    )
}}


with bronze_geo as (
    select * from {{ ref('bronze_dim_geography') }}
)

select
    GeographyID,
    Region,
    Country,
    State,
    City,
    -- Power BI Geo-mapping ke liye full location combination
    CONCAT(TRIM(City), ', ', TRIM(State), ', ', TRIM(Country)) as FullLocationPath
from bronze_geo
where GeographyID is not null