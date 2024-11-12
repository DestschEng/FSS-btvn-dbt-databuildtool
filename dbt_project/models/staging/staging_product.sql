SELECT 
    productkey,
    product,
    standardcost,
    color,
    subcategory,
    category,
    backgroundcolorformat,
    fontcolorformat 
FROM {{ source('public', 'product') }}