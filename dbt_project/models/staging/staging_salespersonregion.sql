SELECT 
    salespersonid,
    salesterritorykey
FROM {{ source('public', 'salespersonregion') }}