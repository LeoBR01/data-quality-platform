{{ config(
    materialized='incremental',
    unique_key='trip_id'
) }}

with source as (
    select
        *,
        {{ dbt_utils.generate_surrogate_key(['tpep_pickup_datetime', 'tpep_dropoff_datetime', 'PULocationID', 'DOLocationID']) }} as trip_id,
        current_timestamp as _ingested_at,
        '{{ var("source_file", "manual") }}' as _source_file
    from read_parquet('/opt/data/raw/*.parquet')
)

select * from source

{% if is_incremental() %}
    where _ingested_at > (select max(_ingested_at) from {{ this }})
{% endif %}