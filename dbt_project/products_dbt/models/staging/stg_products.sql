SELECT
    id as product_id,title as product_title, description as product_description, category as product_category,price, 
    cast(((price*(100-discountPercentage))/100) AS DECIMAL(10,2)) AS discount_price,rating,stock,loaded_at
FROM {{source('products_raw','raw_products')}}