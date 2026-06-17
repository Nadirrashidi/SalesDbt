{{ config(materialized='table', schema='bronze') }}

with raw_product as (
    
    select * from {{ source('Source', 'DimProduct') }}
)

select
    *
from raw_product