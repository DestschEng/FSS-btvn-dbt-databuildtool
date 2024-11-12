SELECT
    salesordernumber,
    orderdate,
    productkey,
    resellerkey,
    employeekey,
    salesterritorykey,
    quantity,
    REPLACE(REPLACE(s.unitprice, '$', ''), ',', '')::NUMERIC AS unitprice,
    REPLACE(REPLACE(s.sales, '$', ''), ',', '')::NUMERIC AS sales,
    REPLACE(REPLACE(s.cost, '$', ''), ',', '')::NUMERIC AS cost
FROM {{ ref('staging_sales') }} AS s
