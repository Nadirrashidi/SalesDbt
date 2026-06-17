{{ config(materialized='table', schema='bronze') }}

with raw_geography as (
    
    select * from {{ source('Source', 'DimGeography') }}
)

select
    *
from raw_geography