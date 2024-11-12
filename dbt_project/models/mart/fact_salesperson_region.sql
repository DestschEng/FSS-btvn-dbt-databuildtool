SELECT DISTINCT
    salespersonid,
    salesterritorykey
FROM {{ ref('staging_salespersonregion') }}
