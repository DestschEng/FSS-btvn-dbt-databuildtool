WITH sales_data AS (
    SELECT
        s.salesordernumber,
        s.orderdate,
        s.quantity,
        -- Strip all non-numeric characters from these fields
        CASE WHEN s.unitprice::text LIKE '$%' THEN REPLACE(s.unitprice::text, '$', '')::NUMERIC ELSE s.unitprice END AS unitprice,
        CASE WHEN s.sales::text LIKE '$%' THEN REPLACE(s.sales::text, '$', '')::NUMERIC ELSE s.sales END AS sales,
        CASE WHEN s.cost::text LIKE '$%' THEN REPLACE(s.cost::text, '$', '')::NUMERIC ELSE s.cost END AS cost,
        p.product_name,
        p.category,
        r.territory_name,  
        sp.salesperson_name
    FROM {{ ref('fact_sales') }} AS s
    JOIN {{ ref('dim_product') }} AS p ON s.productkey = p.productkey
    JOIN {{ ref('dim_region') }} AS r ON s.salesterritorykey = r.salesterritorykey
    JOIN {{ ref('dim_salesperson') }} AS sp ON s.employeekey = sp.employeekey
)

SELECT
    salesordernumber,
    orderdate,
    product_name,
    category,
    territory_name,
    salesperson_name,
    SUM(quantity) AS total_quantity,
    SUM(sales) AS total_sales,
    SUM(cost) AS total_cost,
    (SUM(sales) - SUM(cost)) AS profit
FROM sales_data
GROUP BY
    salesordernumber,
    orderdate,
    product_name,
    category,
    territory_name,
    salesperson_name
