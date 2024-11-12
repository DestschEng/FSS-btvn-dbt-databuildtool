SELECT DISTINCT
    resellerid,
    UPPER(resellername) AS reseller_name,
    COALESCE(businesstype, 'Unknown') AS business_type,
    UPPER(city) AS city,
    UPPER(stateprovince) AS state_province,
    UPPER(countryregion) AS country_region
FROM {{ ref('staging_reseller') }}
