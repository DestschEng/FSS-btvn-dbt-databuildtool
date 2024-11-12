SELECT DISTINCT
    salesterritorykey,
    UPPER(territoryname) AS territory_name,
    UPPER(country) AS country,
    COALESCE(groupname, 'Unknown') AS group_name
FROM {{ ref('staging_region') }}