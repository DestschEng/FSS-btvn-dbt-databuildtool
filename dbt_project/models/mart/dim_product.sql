SELECT DISTINCT
    productkey,
    UPPER(product) AS product_name,
    COALESCE(standardcost, 0) AS standard_cost,
    COALESCE(UPPER(color), 'UNKNOWN') AS color,
    COALESCE(UPPER(subcategory), 'UNKNOWN') AS subcategory,
    COALESCE(UPPER(category), 'UNKNOWN') AS category,
    COALESCE(backgroundcolorformat, 'N/A') AS background_color,
    COALESCE(fontcolorformat, 'N/A') AS font_color
FROM {{ ref('staging_product') }}

