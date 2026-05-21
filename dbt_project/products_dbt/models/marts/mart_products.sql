{{ config(
    materialized = 'incremental',
    unique_key = 'product_id'
) }}

WITH watermark AS (

    {% if is_incremental() %}

    SELECT COALESCE(MAX(loaded_at), '1900-01-01'::timestamp) AS max_loaded_at
    FROM {{ this }}

    {% else %}

    SELECT '1900-01-01'::timestamp AS max_loaded_at

    {% endif %}

),

source_data AS (

    SELECT
        product_id,
        product_title,
        product_description,
        product_category,
        price,
        discount_price,
        rating,
        stock,
        loaded_at
    FROM {{ ref('stg_products') }}
    CROSS JOIN watermark
    WHERE loaded_at > watermark.max_loaded_at

),

final AS (

    SELECT
        product_id,
        product_title,
        product_description,
        product_category,
        price,
        discount_price,
        rating,
        stock,
        loaded_at,
        CASE WHEN price >= 100 THEN 1 ELSE 0 END AS is_expensive,
        CASE WHEN rating >= 4 THEN 1 ELSE 0 END AS good_rating,
        CASE WHEN stock >= 50 THEN 1 ELSE 0 END AS big_stock,
        CASE
            WHEN price > AVG(price) OVER (PARTITION BY product_category)
            THEN 1 ELSE 0
        END AS higher_price_than_category_avg
    FROM source_data

)

SELECT *
FROM final