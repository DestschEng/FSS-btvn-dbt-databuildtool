SELECT 
    salesterritorykey,
    territoryname,
    country,
    groupname
FROM {{ source('public', 'region') }}