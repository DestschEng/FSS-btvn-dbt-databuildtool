SELECT 
    salesordernumber,
    orderdate,
    productkey,
    resellerkey,
    employeekey,
    salesterritorykey,
    quantity,
    unitprice,
    sales,
    cost
FROM {{ source('public', 'sales_staging') }}