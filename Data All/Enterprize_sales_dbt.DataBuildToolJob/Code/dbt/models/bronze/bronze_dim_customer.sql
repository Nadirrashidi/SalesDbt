{{ config(materialized='table', schema='bronze') }}

with raw_customer as (
    
    select * from {{ source('Source', 'DimCustomer') }}
)

select
    *
from raw_customer