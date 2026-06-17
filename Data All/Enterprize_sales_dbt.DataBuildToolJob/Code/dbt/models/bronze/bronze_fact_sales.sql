{{ config(materialized='table', schema='bronze') }}

with raw_factsales as (
    
    select * from {{ source('Source', 'FactSales') }}
)

select
    *
from raw_factsales